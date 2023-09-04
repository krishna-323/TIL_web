import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/Master/vendors/view_vendors_details.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';
import 'package:new_project/widgets/motows_buttons/outlined_mbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'add_new_vendor.dart';

class ListVendors extends StatefulWidget {
  final ListVendorsArguments arg;
  const ListVendors({Key? key, required this. arg}) : super(key: key);

  @override
  State<ListVendors> createState() => _ListVendorsState();
}

class _ListVendorsState extends State<ListVendors> {

  List vendorList = [];
  List displayVendorList =[];
  int startVal =0;
  bool loading = false;
  String? authToken;

  Future fetchVendorsData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_all_new_vendor';
    try {
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vendorList = value;
            if(displayVendorList.length>15){
              for(int i=startVal;i<startVal + 15;i++){
                displayVendorList.add(vendorList[i]);
              }
            }
            else{
              for(int i=0;i<vendorList.length;i++){
                displayVendorList.add(vendorList[i]);
              }
            }
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getInitialData().whenComplete((){
      fetchVendorsData();
      // selectedId = widget.vendorList['new_vendor_id'];
    });
  }

  Future getInitialData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        appBar: const PreferredSize( preferredSize: Size.fromHeight(60),
            child: CustomAppBar()),
        body: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDrawer(widget.arg.drawerWidth,widget.arg.selectedDestination),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(
              child:
              CustomLoader(
                inAsyncCall: loading,
                child: Container(
                  color: Colors.grey[50],
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const  EdgeInsets.only(right: 40.0,left: 40,top: 10,bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0),)

                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                              ),
                              child: Column(children: [
                                const SizedBox(height: 18,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0,right: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      const Text(
                                        "Vendors List ",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold
                                        ),
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
                                            Navigator.of(context).push(PageRouteBuilder(
                                                pageBuilder: (context,animation1,animation2)=>const AddNewVendors(
                                                  selectedDestination: 3.3, drawerWidth: 190,)));
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
                                                      child: Text("COMPANY NAME")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text('NAME')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("EMAIL")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("PHONE")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("CITY")
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
                            const SizedBox(height: 4,),
                            for(int i=startVal;i<=displayVendorList.length;i++)
                              Column(
                                children: [
                                  if(i!=displayVendorList.length)
                                  MaterialButton(
                                    hoverColor: mHoverColor,

                                    onPressed: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1, animation2) => ViewVendors(vendorList: vendorList[i],
                                            drawerWidth: widget.arg.drawerWidth,
                                            selectedDestination: widget.arg.selectedDestination,),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:18.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayVendorList[i]['company_name']??"")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayVendorList[i]['contact_persons_name']??"")
                                                  // child: Text("name")
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayVendorList[i]['vendor_email']??"")
                                                  // child: Text("email")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayVendorList[i]['vendor_mobile_phone']??"")
                                                  // child: Text("mobile")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 28,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(" ${displayVendorList[i]['payto_city']??""}")
                                                  // child: Text("City"),
                                                ),
                                              )),
                                          const Center(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 8,),
                                              child: SizedBox(
                                                height: 28,
                                                child: Icon(size: 18,CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if(i!=displayVendorList.length)
                                    Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                  if(i==displayVendorList.length)
                                    Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Text("${startVal+15>vendorList.length?vendorList.length:startVal+1}-${startVal+15>vendorList.length?vendorList.length:startVal+15} of ${vendorList.length}",style: const TextStyle(color: Colors.grey)),
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
                                                displayVendorList=[];
                                                startVal = startVal-15;
                                                for(int i=startVal;i<startVal+15;i++){
                                                  try{
                                                    setState(() {
                                                      displayVendorList.add(vendorList[i]);
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
                                              if(vendorList.length>startVal+15){
                                                displayVendorList=[];
                                                startVal=startVal+15;
                                                for(int i=startVal;i<startVal+15;i++){
                                                  try{
                                                    setState(() {
                                                      displayVendorList.add(vendorList[i]);
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
