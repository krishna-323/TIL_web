import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_project/docket/docket_details.dart';
import 'package:new_project/utils/api/get_api.dart';
import 'package:new_project/utils/customAppBar.dart';
import 'package:new_project/utils/customDrawer.dart';
import 'package:new_project/utils/custom_loader.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';


class DocketListArgs{
  final double drawerWidth;
  final double selectedDestination;
  DocketListArgs({required this.drawerWidth,required this.selectedDestination});
}


class DocketList extends StatefulWidget {
  final DocketListArgs args;

  const DocketList({super.key,required this.args});

  @override
  State<DocketList> createState() => _DocketListState();
}

class _DocketListState extends State<DocketList> {

  bool loading=false;

  List docketList=[];
  List displayListItems=[];
  int startVal=0;

  @override
  void  initState(){
    super.initState();
    getAllDocket();
    loading=true;
  }

  Future getAllDocket()async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocket/get_all_sales_dockets_wrapper';
    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            docketList=response;
            if(displayListItems.isEmpty){
              if(docketList.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListItems.add(docketList[i]);
                }
              }
              else{
                for(int i=0;i<docketList.length;i++){
                  displayListItems.add(docketList[i]);
                }
              }
            }
          }
          loading=false;
        });
      });
    }
    catch(e){
      // logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize:Size.fromHeight(60) ,
        child: CustomAppBar(),),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
          const VerticalDivider(width: 1,
            thickness: 1,),
          Expanded(
            child:
            CustomLoader(
              inAsyncCall: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40,top: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0),)

                      ),
                      child: Column(
                        children: [
                          Container(
                            // height:100,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 18,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:   [
                                      const Text("Docket List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),

                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18,),
                                Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                Container(color: Colors.grey[100],
                                  //height: 32,
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
                                                      child: Text("Docket ID")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text('Customer Name')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Mobile")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Make")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Model")
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                const SizedBox(height: 4,)
                              ],
                            ),
                          ),
                          for(int i=0;i<=displayListItems.length;i++)
                            Column(
                              children: [
                                if(i!=displayListItems.length)
                                  MaterialButton(
                                    hoverColor: Colors.blue[50],
                                    onPressed: (){

                                      print('-------------inontap------------------');
                                      print(docketList[i]);

                                      Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (context,animation1,animation2) => DocketDetails(
                                            //customerList: displayList[i],
                                            docketData: docketList[i],
                                            drawerWidth: widget.args.drawerWidth,
                                            selectedDestination: widget.args.selectedDestination,
                                          )
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[i]['docket_id']??"")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[i]['customer_name']?? '')
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[i]['mobile']?? '')
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[i]['make']?? '')
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[i]['model']?? '')
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if(i!=displayListItems.length)
                                  Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                if(i==displayListItems.length)
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("${startVal+15>docketList.length?docketList.length:startVal+1}-${startVal+15>docketList.length?docketList.length:startVal+15} of ${docketList.length}",style: const TextStyle(color: Colors.grey)),
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
                                              displayListItems=[];
                                              startVal = startVal-15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                setState(() {
                                                  displayListItems.add(docketList[i]);
                                                });
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
                                            if(startVal+1+5>docketList.length){
                                              // print("Block");
                                            }
                                            else
                                            if(docketList.length>startVal+15){
                                              displayListItems=[];
                                              startVal=startVal+15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                setState(() {
                                                  try{
                                                    displayListItems.add(docketList[i]);
                                                  }
                                                  catch(e){
                                                    log(e.toString());
                                                  }

                                                });
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}