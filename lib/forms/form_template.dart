import 'package:flutter/material.dart';
import 'package:new_project/forms/preview.dart';
import 'package:new_project/utils/customAppBar.dart';

import '../classes/arguments_classes/arguments_classes.dart';
import '../utils/customDrawer.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';
import 'add_new_template.dart';

class TemplateScreen extends StatefulWidget {
  final FormTemplatesArguments args;
  const TemplateScreen({super.key, required this.args});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {

  List titleDes = [
    {
      "title": 'Template Title 1',
      'description': 'Template description 1',
    },
  ];

  List templateData =[
    [
      {
        "type": "textField",
        "question": " Enter your Name",
        "answer": "",
        "isHover": false
      },
      {
        "type": "textField",
        "question": "Enter Age",
        "answer": "",
        "isHover": false
      },
      {
        "type": "date",
        "question": "Enter Date of birth",
        "answer": "",
        "isHover": false
      },
      {
        "type": "test",
        "question": "Select applicable choice",
        "length": 2,
        "answer": "",
        "dropdownAnswer": [
          "Choice 1",
          "Choice 2"
        ],
        "isHover": false
      }
    ],
  ];



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60),
    child: CustomAppBar(),
    ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.args.drawerWidth,widget.args.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: AppBar(
                      elevation: 4,
                      automaticallyImplyLeading: false,
                      title:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Dynamic Form',),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(width: 150,
                              height: 30,
                              child: OutlinedMButton(text: '+ New Template',
                                borderColor: mSaveButton,
                                buttonColor: mSaveButton,
                                textColor: Colors.white,
                                onTap: (){
                                  Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                            AddNewTemplate(selectedDestination: widget.args.selectedDestination,
                                              drawerWidth: widget.args.drawerWidth,)
                                        )).then((value){
                                          if(value==null){

                                          }
                                          else{
                                            setState(() {
                                              if(value['fieldsList'].isNotEmpty){
                                                titleDes.add(  {
                                                  "title": value['title'],
                                                  'description': value['description'],
                                                },);
                                                templateData.add(value['fieldsList']);
                                              }
                                            });
                                          }
                                        });

                                        // Navigator.push(context,
                                        //     PageRouteBuilder(
                                        //       maintainState: false,
                                        //       pageBuilder: (context, animation, secondaryAnimation) => const AddNewTemplate(),
                                        //     )).then((value) {
                                        //   if(value==null){
                                        //
                                        //   }
                                        //   else{
                                        //     setState(() {
                                        //       if(value['fieldsList'].isNotEmpty){
                                        //         titleDes.add(  {
                                        //           "title": value['title'],
                                        //           'description': value['description'],
                                        //         },);
                                        //         templateData.add(value['fieldsList']);
                                        //       }
                                        //     });
                                        //   }
                                        // });

                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Wrap(
                      children: [
                        for(int i=0;i<templateData.length;i++)
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: ElevatedButton(
                                style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    )
                                )),
                                onPressed: () {
                                  Navigator.push(context, PageRouteBuilder(maintainState: false,pageBuilder: (context, animation1, animation2) => PreviewScreen(
                                      selectedDestination: widget.args.selectedDestination,
                                      drawerWidth: widget.args.drawerWidth,
                                      title:titleDes[i]['title'],description:titleDes[i]['description'],fieldsList: templateData[i]),));

                                },
                                child:  SizedBox(height: 150,width: 140,child: Center(child: Text("Template ${i+1}")))),
                          ),

                        // Padding(
                        //   padding: const EdgeInsets.all(24.0),
                        //   child: ElevatedButton(
                        //       style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           const RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.zero,
                        //           )
                        //       )),
                        //       onPressed: () {
                        //         List tempData =[
                        //           {
                        //             "type": "textField",
                        //             "question": "Enter Your Restaurants Name",
                        //             "answer": "",
                        //             "isHover": false
                        //           },
                        //           {
                        //             "type": "rating",
                        //             "question": "Enter Rating",
                        //             "answer": "",
                        //             "isHover": false
                        //           },
                        //           {
                        //             "type": "date",
                        //             "question": "Select Date of Visit",
                        //             "answer": "",
                        //             "isHover": false
                        //           },
                        //           {
                        //             "type": "radio",
                        //             "question": " Select Yes or No",
                        //             "answer": "YesOrNo.no",
                        //             "isHover": false
                        //           }
                        //         ];
                        //         Navigator.push(context, PageRouteBuilder(maintainState: false,pageBuilder: (context, animation, secondaryAnimation) => PreviewScreen(fieldsList: tempData, title: '',description: '',),));
                        //
                        //       },
                        //       child: const SizedBox(height: 150,width: 140,child: Center(child: Text("Template 2")))),
                        // ),
                        //
                        // Padding(
                        //   padding: const EdgeInsets.all(24.0),
                        //   child: ElevatedButton(
                        //       style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           const RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.zero,
                        //           )
                        //       )),
                        //       onPressed: () {  },
                        //       child: const SizedBox(height: 150,width: 140,child: Center(child: Text("Template 3")))),
                        // ),
                        //
                        // Padding(
                        //   padding: const EdgeInsets.all(24.0),
                        //   child: ElevatedButton(
                        //       style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           const RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.zero,
                        //           )
                        //       )),
                        //       onPressed: () {  },
                        //       child: const SizedBox(height: 150,width: 140,child: Center(child: Text("Template 4")))),
                        // ),
                        //
                        // Padding(
                        //   padding: const EdgeInsets.all(24.0),
                        //   child: ElevatedButton(
                        //       style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           const RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.zero,
                        //           )
                        //       )),
                        //       onPressed: () {  },
                        //       child: const SizedBox(height: 150,width: 140,child: Center(child: Text("Template 5")))),
                        // ),
                        //
                        // Padding(
                        //   padding: const EdgeInsets.all(24.0),
                        //   child: ElevatedButton(
                        //       style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //           const RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.zero,
                        //           )
                        //       )),
                        //       onPressed: () {  },
                        //       child: const SizedBox(height: 150,width: 140,child: Center(child: Text("Template 6")))),
                        // ),


                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}