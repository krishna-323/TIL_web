import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:new_project/utils/customAppBar.dart';
import 'package:new_project/utils/customDrawer.dart';

class PreviewScreen extends StatefulWidget {
  final double selectedDestination;
  final double drawerWidth;
  final List fieldsList;
  final String title;
  final String description;
  const PreviewScreen({super.key , required this.fieldsList, required this.title, required this.description, required this.selectedDestination, required this.drawerWidth});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {

  final _formKey = GlobalKey<FormState>();
  List fieldsList =[];
  List<FocusNode> myFocusNode = <FocusNode>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fieldsList=widget.fieldsList;
    titleController.text=widget.title;
    desController.text=widget.description;
    for(int i=0;i<fieldsList.length;i++){
      myFocusNode.add(FocusNode());
    }
  }

  final titleController = TextEditingController();
  final desController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60),
      child: CustomAppBar(),
      ),
      body: Row(
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(
            thickness: 1,
              width: 1,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: AppBar(
                            elevation: 4,
                            automaticallyImplyLeading: true,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Dynamic Form',),
                                Padding(
                                  padding:  const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blue)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {}
                                    },
                                    child: const Text('Save',style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0,bottom: 8,left: 50,right: 50),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color(0xfff1f9fa),
                                Color(0xffA2D9E1),
                              ],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(2, 0),
                              stops: [
                                0.51,
                                0.5,
                              ],
                              tileMode: TileMode.decal
                          ),
                        ),
                        child:    Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(hintText: "Form Title"),
                                controller: titleController,
                              ),
                              SizedBox(
                                height: 100,
                                child: TextField(
                                  controller: desController,
                                  maxLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(hintText: "Description",hintStyle: TextStyle(decoration: TextDecoration.none)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: fieldsList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(right: 50,left: 50,),
                      itemBuilder: (context, index) {
                        return  Container(
                          key: ValueKey(fieldsList[index]),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0,top: 15),
                            child: Container(
                              color: const Color(0xfff1f9fa),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 22.0,left: 8),
                                    child: Text("${index+1}. ",style: const TextStyle(fontSize: 18)),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0,bottom: 18),
                                      child: Padding(
                                        padding: const EdgeInsets.only(),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: DynamicFields(
                                                key: UniqueKey(),
                                                initialValue: fieldsList[index],
                                                callback: (v) {
                                                  fieldsList[index]=v;
                                                  if (v['type'] == "date" && v.containsKey("refresh")) {
                                                    setState(() {});
                                                  }
                                                },
                                                focusNode: myFocusNode[index],
                                                //callback: fieldsList[index] ,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.blue)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              print(fieldsList);
              if(fieldsList.isNotEmpty) {
                Navigator.pop(context);
                // Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => PreviewScreen(fieldsList: fieldsList),));
              }
            }
          },
          child: const Text('Cancel',style: TextStyle(color: Colors.white)),
        ),
      ),

    );
  }
}


class DynamicFields extends StatefulWidget {
  final Map initialValue;
  final Function(Map) callback;
  final FocusNode focusNode;

  const DynamicFields({
    super.key,
    required this.initialValue,
    required this.callback, required this.focusNode,
  });

  @override
  State<DynamicFields> createState() => _DynamicFieldsState();
}
enum YesOrNo { yes, no }
class _DynamicFieldsState extends State<DynamicFields> {
  late final TextEditingController questionController;
  late final TextEditingController answerController;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = widget.focusNode;
    try{
      questionController = TextEditingController();
      answerController = TextEditingController();
      questionController.text = widget.initialValue['question'] ?? '';
      if(widget.initialValue['type']=='textField' ||widget.initialValue['type']=='date'||widget.initialValue['type']=='rating') {
        answerController.text = widget.initialValue['answer'].toString();
      }
      if(widget.initialValue['type']=='dropDown') {
        optionItemSelected = OptionItem2(id: '', title: widget.initialValue['answer'].toString());
        answerController.text = widget.initialValue['answer'].toString() ;
      }

      if(widget.initialValue['type']=='test') {
        dropdownOptions=[];
        optionItemSelected = OptionItem2(id: '', title: widget.initialValue['answer'].toString());
        answerController.text = widget.initialValue['answer'].toString();
        for(int i=0;i<widget.initialValue['length'];i++) {
          dropListModel.add(OptionItem2(id: "$i", title: widget.initialValue['dropdownAnswer'][i]));
          dropDownControllers.add(TextEditingController(text: widget.initialValue['dropdownAnswer'][i]));
          dropdownOptions.add(widget.initialValue['dropdownAnswer'][i]);
          // dropdownOptions.add(widget.initialValue['dropdownAnswer'][i]);
        }
      }


      if(widget.initialValue['type']=='radio'){
        if(widget.initialValue['answer'].toString()=="YesOrNo.yes") {
          _character =YesOrNo.yes;
        }
        else{
          _character =YesOrNo.no;
        }
      }
    }
    catch(e){
      log(e.toString());
    }
  }

  @override
  void dispose() {
    //questionController.dispose();
    //answerController.dispose();
    super.dispose();
  }
  YesOrNo? _character ;


  List dropdownOptions =[];

  List dropListModel = [];


  OptionItem2 optionItemSelected = OptionItem2(id: '', title: "Drop-down select");

  List<TextEditingController> dropDownControllers  = <TextEditingController>[];

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 8.0,bottom: 10),
      child:getWidgets(type:widget.initialValue['type']),
    );
  }

  Widget getWidgets({required type}) {
    switch(type){
      case 'textField':
        return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              focusNode: myFocusNode,
              controller: questionController,
              readOnly: true,
              onChanged:(value){
                setState(() {
                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    "answer":answerController.text
                  });
                });
              },
              decoration: const InputDecoration(hintText: "Enter your Question"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  myFocusNode.requestFocus();
                  return 'Please enter something';
                }
                return null;
              },
            ),
            const SizedBox(width: 100,),
            TextFormField(
              controller: answerController,
              onChanged:  (value){
                setState(() {
                  widget.callback({
                    'type': widget.initialValue['type'],
                    "question": questionController.text,
                    "answer": answerController.text
                  });
                });
              },

              decoration: const InputDecoration(hintText: "Answer"),
              // validator: (v) {
              //   if (v == null || v.trim().isEmpty) return 'Please enter something';
              //   return null;
              // },
            ),
          ],
        );
      case 'radio' :
        return  Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              focusNode: myFocusNode,
              controller: questionController,
              readOnly: true,
              onChanged:(value){
                widget.callback({
                  'type':widget.initialValue['type'],
                  "question":questionController.text,
                  "answer":_character
                });
              },
              decoration: const InputDecoration(hintText: "Enter your Question for Radio button"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  myFocusNode.requestFocus();
                  return 'Please enter something';
                }
                return null;
              },
            ),
            Wrap(
              children: [

                ListTile(
                  title: const Text('Yes'),
                  leading: Radio<YesOrNo>(
                    value: YesOrNo.yes,
                    groupValue: _character,
                    onChanged: (YesOrNo? value) {
                      setState(() {
                        _character = value;
                        widget.callback({
                          'type':widget.initialValue['type'],
                          "question":questionController.text,
                          "answer":value.toString(),
                        });
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('No'),
                  leading: Radio<YesOrNo>(
                    value: YesOrNo.no,
                    groupValue: _character,
                    onChanged: (YesOrNo? value) {
                      setState(() {
                        _character = value;
                        widget.callback({
                          'type':widget.initialValue['type'],
                          "question":questionController.text,
                          "answer":value.toString()
                        });
                      });
                    },
                  ),
                ),

              ],
            ),
          ],
        );
      case 'date' :
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: questionController,
              focusNode:myFocusNode,
              readOnly: true,
              onChanged:(value){
                setState(() {
                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    "answer":answerController.text
                  });
                });
              },

              decoration: const InputDecoration(hintText: "Enter your Question (Date)"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  myFocusNode.requestFocus();
                  return 'Please enter something';
                }
                return null;
              },
            ),
            const SizedBox(width: 100,),
            TextFormField(
              controller: answerController,
              readOnly: true,
              onTap: ()async{
                DateTime? pickedDate=await showDatePicker(context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1999),
                    lastDate: DateTime.now()

                );
                if(pickedDate!=null){
                  String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);

                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    "answer":formattedDate,
                    "refresh":true
                  });

                  answerController.text=formattedDate;


                }
                else{
                  log('Date not selected');
                }
              },
              onChanged:  (value){

              },

              decoration: const InputDecoration(hintText: "Answer"),
              // validator: (v) {
              //   if (v == null || v.trim().isEmpty) return 'Please enter something';
              //   return null;
              // },
            ),
          ],
        );
      case 'test':
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: questionController,
              focusNode: myFocusNode,
              readOnly: true,
              onChanged:(value){
                setState(() {
                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    "answer":answerController.text
                  });
                });
              },

              decoration: const InputDecoration(hintText: "Enter your Question (Drop Down)"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  myFocusNode.requestFocus();
                  return 'Please enter something';
                }
                return null;
              },
            ),
            const SizedBox(width: 100,),
            SizedBox(width: 200,
              child: SelectDropList(
                optionItemSelected,
                dropListModel,
                    (optionItem){
                  optionItemSelected = optionItem;
                  answerController.text =optionItem.title;
                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    "answer":optionItem.title,
                    'dropdownAnswer':widget.initialValue['dropdownAnswer'],
                    'length':widget.initialValue['length']
                  });
                  setState(() {});
                },
              ),
            ),
          ],
        );
      case 'rating':
        return  Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: questionController,
              focusNode: myFocusNode,
              readOnly: true,
              onChanged:(value){
                setState(() {
                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    "answer":answerController.text
                  });
                });
              },

              decoration: const InputDecoration(hintText: "Enter your Question (Rating)"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  myFocusNode.requestFocus();
                  return 'Please enter something';
                }
                return null;
              },
            ),
            const SizedBox(width: 100,),
            SizedBox(width: 500,height: 60,
              child: RatingBar.builder(itemSize: 28,
                initialRating: double.parse(answerController.text.isNotEmpty?answerController.text:"0"),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 8),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,size: 10,
                ),
                onRatingUpdate: (rating) {
                  answerController.text =rating.toString();
                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    "answer":rating.toString()
                  });
                  setState(() {

                  });
                },
              ),
            ),
          ],
        );
    }
    return Container();

  }
}


class SelectDropList extends StatefulWidget {
  final OptionItem2 itemSelected;
  final List dropListModel;
  final Function(OptionItem2 optionItem) onOptionSelected;

  const SelectDropList(this.itemSelected, this.dropListModel, this.onOptionSelected, {super.key});

  @override
  State<SelectDropList> createState() => _SelectDropListState();
}

class _SelectDropListState extends State<SelectDropList> with SingleTickerProviderStateMixin {

  late OptionItem2 optionItemSelected;
  late final List dropListModel;

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
      child: Column(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(optionItemSelected.title, style: const TextStyle(
                          color: Color(0xFF307DF1),
                          fontSize: 16),)
                  ),
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
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    border: Border.all(color: Colors.grey),),
                  child: _buildDropListOptions(dropListModel, context)
              )
          ),
//          Divider(color: Colors.grey.shade300, height: 1,)
        ],
      ),
    );
  }

  Column _buildDropListOptions(List items, BuildContext context) {
    return Column(
        children: [
          for(int i=0;i<items.length;i++)
            Material(
              borderRadius: BorderRadius.only(bottomRight:i+1!=items.length? const Radius.circular(0):const Radius.circular(20),bottomLeft:i+1!=items.length? const Radius.circular(0):const Radius.circular(20)  ),
              child: InkWell(
                borderRadius: BorderRadius.only(bottomRight:i+1!=items.length? const Radius.circular(0):const Radius.circular(20),bottomLeft:i+1!=items.length? const Radius.circular(0):const Radius.circular(20)  ),
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
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16.0,right: 10,top: 10,bottom: 0),
                            child: Text(items[i].title,
                                style: const TextStyle(
                                    color: Color(0xFF000000),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    if(i+1!=items.length)
                      const Divider(thickness: 1,height: 1,)
                  ],
                ),
              ),
            )
        ]
      // children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }
}


class OptionItem2 {
  final String id;
  final String title;

  OptionItem2({required this.id, required this.title});
}