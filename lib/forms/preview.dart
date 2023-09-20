import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:new_project/utils/customAppBar.dart';
import 'package:new_project/utils/customDrawer.dart';

import '../utils/static_data/motows_colors.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';

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
                            title: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Dynamic Form',),

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
                                                titleName: titleController.text,
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
        child: Row(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 100,
              height: 30,
              child: OutlinedMButton(text: 'Save',
                  borderColor: mSaveButton,
                  buttonColor: mSaveButton,
                  textColor: Colors.white,
                  onTap:(){
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                    }
                  }
              ),
            ),
            const SizedBox(width: 50,),
            SizedBox(width: 100,
              height: 30,
              child: OutlinedMButton(text: 'Cancel',
                  borderColor: mSaveButton,
                  buttonColor: mSaveButton,
                  textColor: Colors.white,
                  onTap:(){
                    if (_formKey.currentState!.validate()) {
                      if(fieldsList.isNotEmpty) {
                        Navigator.pop(context);
                        // Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => PreviewScreen(fieldsList: fieldsList),));
                      }
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DynamicFields extends StatefulWidget {
  final String titleName;
  final Map initialValue;
  final Function(Map) callback;
  final FocusNode focusNode;

  const DynamicFields({
    super.key,
    required this.initialValue,
    required this.callback, required this.focusNode,
    required this.titleName,
  });

  @override
  State<DynamicFields> createState() => _DynamicFieldsState();
}
enum YesOrNo { yes, no }
class _DynamicFieldsState extends State<DynamicFields> {
  late final TextEditingController questionController;
  late final TextEditingController answerController;
  late FocusNode myFocusNode;
  final storageRef= FirebaseStorage.instance.ref();
  var storeFileName= TextEditingController();
  List fullPathList=[];

 // File Picker Async Function.
  Future filePicker(questionName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      if(fileName.endsWith("xlsx") || fileName.endsWith("docx") || fileName.endsWith("pdf")){
        // Static Folder Name.
        // await storageRef.child("files/$fileName").putData(fileBytes!);

        //This Dynamic Folder Name Based On Form Name.
         await storageRef.child('${widget.titleName}/$fileName').putData(fileBytes!);


        //This Dynamic Folder based on Form Name and File Question Name.
       // await storageRef.child(widget.titleName).child("$questionName/$fileName").putData(fileBytes!);

      }
      else{
        selectFilesShouldBeXlsxAndDocx();
      }
    }
  }
  selectFilesShouldBeXlsxAndDocx(){
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
                                'Selected Files Must Be Xlsx Or Docx',
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
  //Displaying Uploaded Files UI.
  Future<void> displayingUploadedFilesInUI(questionIndex) async {
    //Getting based On Form name.
    ListResult store=await storageRef.child("${widget.titleName}/").listAll();
    //Form Name and Index Number.
    // final fileData1 =await storageRef.child("${widget.titleName}/$questionIndex/").listAll();
    for(int fullPath=0;fullPath<store.items.length;fullPath++){
      setState((){
        // File Names Adding To Empty List.
        fullPathList.add(store.items[fullPath].fullPath);
      });
    }
  }

  //Delete File.
  Future<void> deleteFile(String url) async {
    try {
      // Create a reference to the file to delete.
      await storageRef.child(url).delete();
      storeFileName.text="";
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File Deleted')));
      setState(() {
        displayingUploadedFilesInUI("");
        fullPathList=[];
      });
    } catch (e) {
      log("Error deleting db from cloud: $e");
    }
  }
  @override
  void initState() {
    super.initState();
    if(widget.titleName.isNotEmpty){
      displayingUploadedFilesInUI("");
    }
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
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter something';
                return null;
              },
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
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter something';
                return null;
              },
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
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                    color: Colors.blue,
                    child: const Text("Upload Files",style: TextStyle(color: Colors.white),),
                    onPressed: (){
                     filePicker(widget.initialValue['question']).whenComplete(() {
                        setState(() {
                          displayingUploadedFilesInUI(widget.initialValue['question']);
                          fullPathList=[];
                        });
                     });

                    }),
                const SizedBox(width: 50,),
                fullPathList.isNotEmpty?
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context,int index){
                        if(index<fullPathList.length){
                          return
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(fullPathList[index].replaceAll("${widget.titleName}/", "")),
                                ),
                                const SizedBox(width: 20,),
                                MaterialButton(
                                  color: Colors.blue,
                                  child: const Text('Delete',style: TextStyle(color: Colors.white),),
                                  onPressed: (){
                                    deleteFile(fullPathList[index]);
                                  },),
                                const SizedBox(width: 20,),

                                // MaterialButton(
                                //   color: Colors.blue,
                                //     child: Text("Download",style: TextStyle(color: Colors.white),),
                                //     onPressed: (){
                                //
                                // })
                              ],
                            );
                        }
                        return null;
                      }),
                ):
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "Upload Files"),
                    controller: storeFileName,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        myFocusNode.requestFocus();
                        return 'Upload  docx Or Xlsx Files';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 30,),

              ],
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
                        Flexible(
                          child: Center(
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