import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/static_data/motows_colors.dart';

class CustomTextFieldSearch extends StatefulWidget {
  /// A default list of values that can be used for an initial list of elements to select from
  final List? initialList;


  /// A controller for an editable text field
  final TextEditingController controller;

  /// An optional future or async function that should return a list of selectable elements
  final Function? future;

  /// The value selected on tap of an element within the list
  final Function? getSelectedValue;

  final FormFieldValidator<String>? validator;
  /// Used for customizing the display of the TextField
  final InputDecoration? decoration;

  /// Used for customizing the style of the text within the TextField
  final TextStyle? textStyle;

  /// Used for customizing the scrollbar for the scrollable results
  final ScrollbarDecoration? scrollbarDecoration;

  /// The minimum length of characters to be entered into the TextField before executing a search
  final int minStringLength;

  /// The number of matched items that are viewable in results
  final int itemsInView;

  final bool? showAdd;

  /// Creates a TextFieldSearch for displaying selected elements and retrieving a selected element
  const CustomTextFieldSearch(
      {Key? key,
        this.initialList,
        required this.controller,
        this.textStyle,
        this.showAdd,
        this.future,
        this.getSelectedValue,
        this.decoration,
        this.scrollbarDecoration,
        this.itemsInView = 3,
        this.minStringLength = 0,
        this.validator})
      : super(key: key);



  @override
  _CustomTextFieldSearchState createState() => _CustomTextFieldSearchState();
}

class _CustomTextFieldSearchState extends State<CustomTextFieldSearch> {
  final FocusNode _focusNode = FocusNode();
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List? filteredList = <dynamic>[];
  bool hasFuture = false;
  bool loading = false;
  final _debouncer = Debouncer(milliseconds: 1000);
  static const itemHeight = 55;
  bool? itemsFound;
  ScrollController _scrollController = ScrollController();

  void resetList() {
    List tempList = <dynamic>[];
    setState(() {
      // after loop is done, set the filteredList state from the tempList
      filteredList = tempList;
      loading = false;
    });
    // mark that the overlay widget needs to be rebuilt
    _overlayEntry.markNeedsBuild();
  }

  void setLoading() {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }
  }

  void resetState(List tempList) {
    setState(() {
      // after loop is done, set the filteredList state from the tempList
      filteredList = tempList;
      loading = false;
      // if no items are found, add message none found
      itemsFound = tempList.length == 0 && widget.controller.text.isNotEmpty
          ? false
          : true;
    });
    // mark that the overlay widget needs to be rebuilt so results can show
    _overlayEntry.markNeedsBuild();
  }

  void updateGetItems() {
    // mark that the overlay widget needs to be rebuilt
    // so loader can show
    _overlayEntry.markNeedsBuild();
    if (true) {
      setLoading();
      widget.future!().then((value) {
        filteredList = value;
        // create an empty temp list
        List tempList = <dynamic>[];
        // loop through each item in filtered items
        for (int i = 0; i < filteredList!.length; i++) {
          // lowercase the item and see if the item contains the string of text from the lowercase search
          if (widget.getSelectedValue != null) {
            if (filteredList![i]
                .label
                .toLowerCase()
                .contains(widget.controller.text.toLowerCase())) {
              // if there is a match, add to the temp list
              tempList.add(filteredList![i]);
            }
          } else {
            if (filteredList![i]
                .toLowerCase()
                .contains(widget.controller.text.toLowerCase())) {
              // if there is a match, add to the temp list
              tempList.add(filteredList![i]);
            }
          }
        }
        // helper function to set tempList and other state props
        resetState(tempList);
      });
    }
  }

  void updateList() {
    setLoading();
    // set the filtered list using the initial list
    filteredList = widget.initialList;

    // create an empty temp list
    List tempList = <dynamic>[];
    // loop through each item in filtered items
    for (int i = 0; i < filteredList!.length; i++) {
      // lowercase the item and see if the item contains the string of text from the lowercase search
      if (filteredList![i]
          .toLowerCase()
          .contains(widget.controller.text.toLowerCase())) {
        // if there is a match, add to the temp list
        tempList.add(filteredList![i]);
      }
    }
    // helper function to set tempList and other state props
    resetState(tempList);
  }

  void initState() {
    super.initState();

    if (widget.scrollbarDecoration?.controller != null) {
      _scrollController = widget.scrollbarDecoration!.controller;
    }

    // throw error if we don't have an initial list or a future
    if (widget.initialList == null && widget.future == null) {
      throw ('Error: Missing required initial list or future that returns list');
    }
    if (widget.future != null) {
      setState(() {
        hasFuture = true;
      });
    }
    // add event listener to the focus node and only give an overlay if an entry
    // has focus and insert the overlay into Overlay context otherwise remove it
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)!.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
        // check to see if itemsFound is false, if it is clear the input
        // check to see if we are currently loading items when keyboard exists, and clear the input
        if (itemsFound == false || loading == true) {
          // reset the list so it's empty and not visible
          resetList();
          widget.controller.clear();
        }
        // if we have a list of items, make sure the text input matches one of them
        // if not, clear the input
        if (filteredList!.length > 0) {
          bool textMatchesItem = false;
          if (widget.getSelectedValue != null) {
            // try to match the label against what is set on controller
            textMatchesItem = filteredList!
                .any((item) => item.label == widget.controller.text);
          } else {
            textMatchesItem = filteredList!.contains(widget.controller.text);
          }
          if (textMatchesItem == false) widget.controller.clear();
          resetList();
        }
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  ListView _listViewBuilder(context) {
    if (itemsFound == false) {
      return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: _scrollController,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // clear the text field controller to reset it
              widget.controller.clear();
              setState(() {
                itemsFound = false;
              });
              // reset the list so it's empty and not visible
              resetList();
              // remove the focus node so we aren't editing the text
              FocusScope.of(context).unfocus();
            },
            child: const ListTile(
              title: Text('No matching items.'),
              trailing: Icon(Icons.cancel,size: 14),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredList!.length,
      itemBuilder: (context, i) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(i==0 && widget.showAdd!=false)
              InkWell(hoverColor: mHoverColor,onTap: (){},child:  SizedBox(height: 40,child: Padding(
                padding: const EdgeInsets.only(left: 16.0,top: 8,bottom: 2),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("+ Add"),
                  ],
                ),
              ))),
            if(i==0&&widget.showAdd!=false)
            const Divider(height: 1,color: mSaveButton),
            if(widget.controller.text.isNotEmpty)
            InkWell(
              hoverColor: mHoverColor,
                onTap: () {
                  // set the controller value to what was selected
                  setState(() {
                    // if we have a label property, and getSelectedValue function
                    // send getSelectedValue to parent widget using the label property
                    if (widget.getSelectedValue != null) {
                      widget.controller.text = filteredList![i].label;
                      widget.getSelectedValue!(filteredList![i]);
                    } else {
                      widget.controller.text = filteredList![i];
                    }
                  });
                  // reset the list so it's empty and not visible
                  resetList();
                  // remove the focus node so we aren't editing the text
                  FocusScope.of(context).unfocus();
                },
                child: ListTile(
                    title: widget.getSelectedValue != null
                        ? Text(filteredList![i].label)
                        : Text(filteredList![i]))),
          ],
        );
      },
      padding: EdgeInsets.zero,
      shrinkWrap: true,
    );
  }

  /// A default loading indicator to display when executing a Future
  Widget _loadingIndicator() {
    return Container(
      width: 50,
      height: 50,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }

  Widget decoratedScrollbar(child) {
    if (widget.scrollbarDecoration is ScrollbarDecoration) {
      return Theme(
        data: Theme.of(context)
            .copyWith(scrollbarTheme: widget.scrollbarDecoration!.theme),
        child: Scrollbar(child: child, controller: _scrollController),
      );
    }

    return Scrollbar(child: child);
  }

  Widget? _listViewContainer(context) {
    if (itemsFound == true && filteredList!.length > 0 ||
        itemsFound == false && widget.controller.text.length > 0) {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: mSaveButton)),
          height: calculateHeight().toDouble(),
          child: decoratedScrollbar(_listViewBuilder(context)));
    }
    return null;
  }

  num heightByLength(int length) {
    return itemHeight * length;
  }

  num calculateHeight() {
    if(widget.controller.text.isEmpty){
      if (widget.itemsInView <= filteredList!.length) {
        return heightByLength(widget.itemsInView)/4;
      }
    }
    else if (filteredList!.length > 1) {
      if (widget.itemsInView <= filteredList!.length) {
        return heightByLength(widget.itemsInView);
      }

      return heightByLength(filteredList!.length);
    }

    return 105;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size overlaySize = renderBox.size;
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    return OverlayEntry(
        builder: (context) => Positioned(
          width: overlaySize.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, overlaySize.height + 5.0),
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: screenWidth,
                    maxWidth: screenWidth,
                    minHeight: 0,
                    maxHeight: calculateHeight().toDouble(),
                  ),
                  child: loading
                      ? _loadingIndicator()
                      : _listViewContainer(context)),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        onTap: (){
          print("++++++++++++++");
          print(widget.showAdd);
          if(widget.showAdd==false){

          }
          else
            {
              _debouncer.run(() {
                setState(() {
                  if (hasFuture) {
                    updateGetItems();
                  } else {
                    updateList();
                  }
                });
              });
            }
        },
        controller: widget.controller,
        focusNode: _focusNode,
        validator: widget.validator,
        decoration: widget.decoration ?? const InputDecoration(labelText: ''),
        style: widget.textStyle,
        onChanged: (String value) {
          // every time we make a change to the input, update the list
          _debouncer.run(() {
            setState(() {
              if (hasFuture) {
                updateGetItems();
              } else {
                updateList();
              }
            });
          });
        },
      ),
    );
  }
}

class Debouncer {
  /// A length of time in milliseconds used to delay a function call
  final int? milliseconds;

  /// A callback function to execute
  VoidCallback? action;

  /// A count-down timer that can be configured to fire once or repeatedly.
  Timer? _timer;

  /// Creates a Debouncer that executes a function after a certain length of time in milliseconds
  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

class ScrollbarDecoration {
  const ScrollbarDecoration({
    required this.controller,
    required this.theme,
  });

  /// {@macro flutter.widgets.Scrollbar.controller}
  final ScrollController controller;

  /// {@macro flutter.widgets.ScrollbarThemeData}
  final ScrollbarThemeData theme;
}
