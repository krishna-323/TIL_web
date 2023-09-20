import 'dart:developer';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/utils/customAppBar.dart';
import 'package:new_project/utils/customDrawer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../utils/static_data/motows_colors.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';


class AddNewTemplate extends StatefulWidget {
  final double selectedDestination;
  final double drawerWidth;
  const AddNewTemplate({super.key, required this.selectedDestination, required this.drawerWidth});

  @override
  State createState() => _AddNewTemplateState();
}

class _AddNewTemplateState extends State<AddNewTemplate> {
  final _formKey = GlobalKey<FormState>();
  final List fieldsList = [];
  DropListModel dropListModel = DropListModel([
    OptionItem(id: "1", title: "Option 1"),
    OptionItem(id: "2", title: "Option 2")
  ]);

  late   AutoScrollController controller=AutoScrollController();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  OptionItem optionItemSelected = OptionItem(id: '', title: "Drop-down select");
  List myFocusNode = <FocusNode>[];

  bool isHover =false;
  bool filePicker=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60),
      child: CustomAppBar(),
      ),
      body: Row(
        children: [
          CustomDrawer(widget.drawerWidth,widget. selectedDestination),
          const VerticalDivider(
            thickness: 1,
              width: 1,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: AppBar(
                        automaticallyImplyLeading: true,
                        elevation: 4,
                        title:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Dynamic Form',),
                             Padding(
                               padding: const EdgeInsets.all(20),
                               child: SizedBox(width: 100,
                                height: 30,
                                child: OutlinedMButton(text: 'Save',
                                  borderColor: mSaveButton,
                                  buttonColor: mSaveButton,
                                  onTap: (){
                                    if(_formKey.currentState!.validate()) {
                                      Map tempData = {
                                        "title":titleController.text,
                                        "description":descriptionController.text,
                                        'fieldsList':fieldsList
                                      };
                                      Navigator.pop(context, tempData);
                                    }
                                  },
                                  textColor: Colors.white,
                                ),
                            ),
                             ),
                          ],
                        )),
                  ),
                  Expanded(
                    child: ListView(
                      controller:controller ,
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 80,right: 80),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xfff1f9fa),
                                    Color(0xffA2D9E1),
                                  ],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(2, 0),
                                  stops: [0.51, 0.5,], tileMode: TileMode.decal),
                            ),
                            child:    Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    decoration: const InputDecoration(hintText: "Form Title"),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Please enter something';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 100,
                                    child: TextField(
                                      controller: descriptionController,
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
                        ReorderableListView.builder(
                          shrinkWrap: true,
                          onReorder: (oldIndex,newIndex){
                            if(newIndex>oldIndex)newIndex--;
                            dynamic fieldsLists = fieldsList.removeAt(oldIndex);
                            fieldsList.insert(newIndex, fieldsLists);
                          },
                          buildDefaultDragHandles: false,
                          itemCount: fieldsList.length,
                          padding: const EdgeInsets.only(right: 80,left: 80),
                          itemBuilder: (context, index) {
                            if(fieldsList[index]['type']=="fileType"){
                              filePicker=true;
                            }
                            return  AutoScrollTag(
                              key: ValueKey(fieldsList[index]),
                              controller: controller,
                              index: index,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0,bottom: 15),
                                child: Container(color: const Color(0xfff1f9fa),
                                  key: ValueKey(fieldsList[index]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: MouseRegion(
                                      onEnter: (v){
                                        setState(() {
                                          fieldsList[index]["isHover"]=true;
                                        });
                                      },
                                      onExit: (v){
                                        setState(() {
                                          fieldsList[index]["isHover"]=false;
                                        });
                                      },
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
                                                  const SizedBox(width: 8,),
                                                  _textfieldBtn(index),
                                                  const SizedBox(width: 8,),
                                                  if(fieldsList[index]["isHover"]!=null && fieldsList[index]["isHover"]==true)
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: ReorderableDragStartListener(
                                                        index: index,
                                                        child: const Icon(Icons.reorder_outlined),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
          activeBackgroundColor: Colors.transparent,
          //backgroundColor: Colors.transparent,
          //foregroundColor: Colors.transparent,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.3,
          children: [
            SpeedDialChild(
              label: 'Text',
              onTap: () async {
                setState(() {
                  fieldsList.add({"type":"textField","question": "", "answer": "","isHover":false});
                  myFocusNode.add(FocusNode());
                  myFocusNode[myFocusNode.length-1].requestFocus();
                });
                await controller.scrollToIndex(fieldsList.length-1,duration: const Duration(milliseconds: 500));


              },),

            SpeedDialChild(
              label: 'Choice',
              onTap: () async {
                setState(() {
                  fieldsList.add({"type": "radio", "question": "", "answer": "", "isHover": false});
                  myFocusNode.add(FocusNode());
                  myFocusNode[myFocusNode.length - 1].requestFocus();
                });
                await controller.scrollToIndex(fieldsList.length-1,duration: const Duration(milliseconds: 500));
              },),

            SpeedDialChild(
              label: 'Date',
              onTap: () async {
                setState(() {
                  fieldsList.add({"type":"date","question": "", "answer": "","isHover":false});
                  myFocusNode.add(FocusNode());
                  myFocusNode[myFocusNode.length - 1].requestFocus();
                });
                await controller.scrollToIndex(fieldsList.length-1,duration: const Duration(milliseconds: 500));
              },),

            /// Drop-Down
            // SpeedDialChild(
            //   label: 'Drop-Down',
            //   onTap: () async {
            //     setState(() {
            //       fieldsList.add({"type":"dropDown","question": "", "answer": "","isHover":false});
            //       myFocusNode.add(FocusNode());
            //       myFocusNode[myFocusNode.length - 1].requestFocus();
            //     });
            //     await controller.scrollToIndex(fieldsList.length-1,duration: const Duration(milliseconds: 1000));
            //   },
            // ),

            SpeedDialChild(
              label: 'Rating',
              onTap: () async {
                setState(() {
                  fieldsList.add({"type":"rating","question": "", "answer": "","isHover":false});
                  myFocusNode.add(FocusNode());
                  myFocusNode[myFocusNode.length - 1].requestFocus();
                });
                await controller.scrollToIndex(fieldsList.length-1,duration: const Duration(milliseconds: 500));
              },
            ),

            SpeedDialChild(
              label: 'Dropdown',
              onTap: () async {
                setState(() {
                  fieldsList.add({"type":"test","question": "", "answer": "","isHover":false,'length':1, 'dropdownAnswer':['']});
                  myFocusNode.add(FocusNode());
                  myFocusNode[myFocusNode.length - 1].requestFocus();
                });
                await controller.scrollToIndex(fieldsList.length-1,duration: const Duration(milliseconds: 500));
              },
            ),
            SpeedDialChild(
              label: 'fileType',
              onTap: () async {
                setState(() {
                  if(filePicker){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return SizedBox(
                                height: 220,
                                width: 300,
                                child: Stack(children: [
                                  Container(
                                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(5)),
                                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                    child: Padding(
                                      padding:  const EdgeInsets.only(left: 20.0,right: 25),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Icon(
                                            Icons.warning_rounded,
                                            color: Colors.red,
                                            size: 50,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Center(
                                              child: Text(
                                                'Already File Picker TextField Is Add',
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              )),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          MaterialButton(
                                              color: Colors.blue,
                                              child: const Text("Ok",style: TextStyle(color: Colors.white),),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              }),
                                          const SizedBox(height: 20,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(right: 0.0,

                                    child: InkWell(
                                      child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color:
                                                const Color.fromRGBO(204, 204, 204, 1),
                                              ),
                                              color: Colors.blue),
                                          child: const Icon(
                                            Icons.close_sharp,
                                            color: Colors.white,
                                          )),
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  else{
                    fieldsList.add({"type":"fileType","question": "", "answer": "","isHover":false,});
                    myFocusNode.add(FocusNode());
                    myFocusNode[myFocusNode.length - 1].requestFocus();
                  }

                });
                await controller.scrollToIndex(fieldsList.length-1,duration: const Duration(milliseconds: 500));
              },
            ),
          ],
          child: const Icon(Icons.add)
      ),
    );
  }

  Widget _textfieldBtn(int index) {
    return InkWell(
      onTap: () => setState(() {
        if(filePicker){
          filePicker=false;
        }
        fieldsList.removeAt(index);
      },
      ),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:  Colors.white,
        ),
        child: const Icon(size: 22,
          Icons.delete_forever,
          color: Colors.red,
        ),
      ),
    );
  }
}


enum YesOrNo { yes, no }
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
        optionItemSelected = OptionItem(id: '', title: widget.initialValue['answer'].toString());
        answerController.text = widget.initialValue['answer'].toString();
      }

      if(widget.initialValue['type']=='test') {
        dropdownOptions=[];

        for(int i=0;i<widget.initialValue['length'];i++) {
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

  DropListModel dropListModel = DropListModel([
    OptionItem(id: "1", title: "Option 1"),
    OptionItem(id: "2", title: "Option 2")
  ]);


  OptionItem optionItemSelected = OptionItem(id: '', title: "Drop-down select");

  List<TextEditingController> dropDownControllers  = <TextEditingController>[];

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getWidgets(type :widget.initialValue['type']),
        ],
      ),
    );
  }

  Widget getWidgets({required type}) {
    switch(type){
      case 'textField':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              focusNode: myFocusNode,
              controller: questionController,
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
      case 'radio':
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              focusNode: myFocusNode,
              controller: questionController,
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
      case 'date':
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: questionController,
              focusNode:myFocusNode,
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
      case 'rating':
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: questionController,
              focusNode: myFocusNode,
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
      case 'test':
        return Column(
          children: [
            TextFormField(
              focusNode: myFocusNode,
              controller: questionController,
              onChanged:(value){
                setState(() {

                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    'length':dropDownControllers.length,
                    "answer":answerController.text,
                    'dropdownAnswer':dropdownOptions
                  });
                });
              },
              decoration: const InputDecoration(hintText: "Enter your Question for drop-down"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  myFocusNode.requestFocus();
                  return 'Please enter something';
                }
                return null;
              },
            ),
            SizedBox(width: 130,
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: dropDownControllers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return  Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: dropDownControllers[index],
                              decoration: InputDecoration(hintText: "Option ${index+1}"),
                              onChanged: (v) {
                                setState(() {
                                  dropdownOptions[index]=v;
                                  widget.callback({
                                    'type':widget.initialValue['type'],
                                    "question":questionController.text,
                                    'length':dropDownControllers.length,
                                    "answer":answerController.text,
                                    'dropdownAnswer':dropdownOptions
                                  });
                                  //fieldLength = dropDownControllers.length;

                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                dropdownOptions.removeAt(index);
                                dropDownControllers.removeAt(index);
                                widget.callback({
                                  'type':widget.initialValue['type'],
                                  "question":questionController.text,
                                  'length':dropDownControllers.length,
                                  "answer":answerController.text,
                                  'dropdownAnswer':dropdownOptions
                                });
                              });
                            },
                          )
                        ],
                      );
                    },)
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(width: 120,decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: const Color(0xff6dd0ff)),child: TextButton(onPressed: (){
              setState(() {
                dropdownOptions.add('');
                dropDownControllers.add(TextEditingController(text: ''));
                widget.callback({
                  'type':widget.initialValue['type'],
                  "question":questionController.text,
                  'length':dropDownControllers.length,
                  "answer":answerController.text,
                  'dropdownAnswer':dropdownOptions
                });
              });

            }, child: const Wrap(
              children: [
                Icon(Icons.add,size: 18,color: Colors.white),

                Text("Add Options",style: TextStyle(color: Colors.white),)
              ],
            )))
          ],
        );
      case 'fileType':
        return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              focusNode: myFocusNode,
              controller: questionController,
              onChanged:(value){
                setState(() {
                  widget.callback({
                    'type':widget.initialValue['type'],
                    "question":questionController.text,
                    "answer":answerController.text
                  });
                });
              },
              decoration: const InputDecoration(hintText: "Files Types?"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  myFocusNode.requestFocus();
                  return 'Please enter something';
                }
                return null;
              },
            ),
            const SizedBox(height: 50,),
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

              decoration:  const InputDecoration(hintText: "Pick Files Here!",),
              // validator: (v) {
              //   if (v == null || v.trim().isEmpty) return 'Please enter something';
              //   return null;
              // },
            ),
          ],
        );
    }
    return Container();
  }
}

class DropListModel {
  DropListModel(this.listOptionItems);

  final List<OptionItem> listOptionItems;
}

class OptionItem {
  final String id;
  final String title;

  OptionItem({required this.id, required this.title});
}