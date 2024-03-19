import 'package:flutter/material.dart';

class CustomDropListModel {
  CustomDropListModel(this.listOptionItems);
  final List<CustomOptionItem> listOptionItems;
}

class CustomOptionItem {
  final String id;
  final String title;
  CustomOptionItem({required this.id, required this.title});
}


class CustomDropList extends StatefulWidget {
  final CustomOptionItem itemSelected;
  final CustomDropListModel dropListModel;
  final Function(CustomOptionItem) onOptionSelected;

  const CustomDropList(  {super.key, required this.itemSelected,required this.dropListModel, required this.onOptionSelected});

  @override
  State<CustomDropList> createState() => _CustomDropListState();
}

class _CustomDropListState extends State<CustomDropList> with SingleTickerProviderStateMixin {

  late CustomOptionItem optionItemSelected;
  late final CustomDropListModel dropListModel;

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;


  @override
  void initState() {
    optionItemSelected= widget.itemSelected;
    dropListModel= widget.dropListModel;
    super.initState();
    expandController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350)
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if(isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              isShow = !isShow;
              _runExpandCheck();
              setState(() {

              });
            },
            child: Container(

              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: const Radius.circular(10), topRight: const Radius.circular(10),bottomLeft:isShow?const Radius.circular(0):const Radius.circular(10),bottomRight:isShow?const Radius.circular(0):const Radius.circular(10) ),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: const Alignment(1, 0),
                    child: Icon(
                      isShow ? Icons.arrow_drop_down : Icons.arrow_right,
                      color: const Color(0xFF307DF1),
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4,),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Container(

                  decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    border: Border.all(color: Colors.grey),
                    // boxShadow: [
                    //   BoxShadow(
                    //       blurRadius: 4,
                    //       color: Colors.black26,
                    //       offset: Offset(0, 4))
                    // ],
                  ),
                  child: _buildDropListOptions(dropListModel.listOptionItems, context)
              )
          ),
//          Divider(color: Colors.grey.shade300, height: 1,)
        ],
      ),
    );
  }

  Column _buildDropListOptions(List<CustomOptionItem> items, BuildContext context) {
    return Column(
        children: [
          for(int i=0;i<items.length;i++)
            InkWell(
              onTap: () {
                optionItemSelected = items[i];
                isShow = false;
                expandController.reverse();
                widget.onOptionSelected(items[i]);
              },
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 16.0,right: 10,top: 10,bottom: 10),
                        child: Text(items[i].title,
                            style: const TextStyle(
                                color: Color(0xFF307DF1),
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  if(i+1!=items.length)
                    const Divider(thickness: 1,height: 1,)
                ],
              ),
            )
        ]
      // children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }


}



