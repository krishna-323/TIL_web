import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:new_project/master/parts/add_part.dart';
import 'package:new_project/master/parts/part_details.dart';
import 'package:new_project/widgets/motows_buttons/outlined_mbutton.dart';



import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';



class ListParts extends StatefulWidget {
  final ListAddItemsArguments arg;
  const ListParts({Key? key, required this.arg}) : super(key: key);

  @override
  State<ListParts> createState() => _ListPartsState();
}

class _ListPartsState extends State<ListParts> {
  List itemList = [];
  List displayItems =[];
  int startVal =0;
  String? authToken;
  bool loading = false;



  Future fetchItemData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/get_all_newitem';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            itemList = value;
            if(displayItems.isEmpty){
              if(itemList.length>15) {
                for (int i = startVal; i < startVal + 15; i++) {
                  displayItems.add(itemList[i]);
                }
              }
              else{
                for(int i=0;i<itemList.length;i++){
                  displayItems.add(itemList[i]);
                }
              }
            }
            // print('------- new get --------');
            // print(itemList);
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchItemData();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.arg.drawerWidth, widget.arg.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: CustomLoader(
              inAsyncCall: loading,
              child: Container(
                color: Colors.grey[50],
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40,top: 10,bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0),)

                      ),
                      child: Column(children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                          ),
                          child: Column(children: [
                            const SizedBox(height: 18,),
                            Padding(
                              padding: const EdgeInsets.only(left:18.0,right: 18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "All Items ",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    height: 30,
                                    child: OutlinedMButton(
                                      text: '+ New',
                                      buttonColor:mSaveButton ,
                                      textColor: Colors.white,
                                      borderColor: mSaveButton,
                                      onTap: () {
                                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                        const AddPart(drawerWidth: 190,
                                          selectedDestination: 2.4,),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero
                                        )).then((value) => fetchItemData());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18,),
                            Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                            Container(color: Colors.grey[100],height: 32,
                              child:  IgnorePointer(
                                ignoring: true,
                                child: MaterialButton(
                                  onPressed: (){},
                                  hoverColor: Colors.transparent,
                                  hoverElevation: 0,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 18.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("NAME")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: SizedBox(
                                                  height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text('DESCRIPTION')
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("RATE")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("HSN/SAC")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("USAGE UNIT")
                                              ),
                                            )),
                                        Center(child: Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(size: 18,
                                            Icons.more_vert,
                                            color: Colors.transparent,
                                          ),
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                          ]),
                        ),

                        //dynamic data code.
                        for(int i=startVal;i<=displayItems.length;i++)
                          Column(
                            children: [
                              if(i!=displayItems.length)
                              MaterialButton(hoverColor: mHoverColor,

                                onPressed: () {
                                  Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                      PartDetails(title: 1,itemList: itemList[i],drawerWidth: 190,selectedDestination: 2.4),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left:18.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(displayItems[i]['name'])
                                            ),
                                          )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text(displayItems[i]['description']??"")
                                        ),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Column(
                                              children: [
                                                Row(
                                                  //crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Text("Rs. "),
                                                    Text(displayItems[i]['selling_price'].toStringAsFixed(2)),
                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Row(
                                              children: [
                                                Text(displayItems[i]['tax_code']),
                                                Text(displayItems[i]['sac'].toString())
                                              ],
                                            )
                                        ),
                                      )),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text(displayItems[i]['unit'].toString())
                                        ),
                                      )),
                                      const Center(child: Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                          size: 18,
                                          color: Colors.blue,
                                        ),
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                              if(i!=displayItems.length)
                                Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                              if(i==displayItems.length)
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text("${startVal+15>itemList.length?itemList.length:startVal+1}-${startVal+15>itemList.length?itemList.length:startVal+15} of ${itemList.length}",style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(width: 10,),
                                    Material(color: Colors.transparent,
                                      child: InkWell(
                                        hoverColor: mHoverColor,
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                        ),
                                        onTap: (){
                                          if(startVal>14){
                                            displayItems=[];
                                            startVal = startVal-15;
                                            for(int i=startVal;i<startVal+15;i++){
                                              try{
                                                setState(() {
                                                  displayItems.add(itemList[i]);
                                                });
                                              }
                                              catch(e){
                                                log(e.toString());
                                              }
                                            }
                                          }
                                          else{
                                            log('else');
                                          }

                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Material(color: Colors.transparent,
                                      child: InkWell(
                                        hoverColor: mHoverColor,
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Icon(Icons.arrow_forward_ios,size: 12),
                                        ),
                                        onTap: (){
                                          if(itemList.length>startVal+15){
                                            displayItems=[];
                                            startVal=startVal+15;
                                            for(int i=startVal;i<startVal+15;i++){
                                              try{
                                                setState(() {
                                                  displayItems.add(itemList[i]);
                                                });
                                              }
                                              catch(e){
                                                log(e.toString());
                                              }

                                            }
                                          }

                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20,),

                                  ],
                                )
                            ],
                          ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
