import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:new_project/vehicle_part_order/parts_order_details2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';
import 'create_new_part_order.dart';
import 'package:new_project/classes/env.dart';

class PartsOrderByStatus extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final String type;
  const PartsOrderByStatus({super.key,
    required this.drawerWidth,
    required this.selectedDestination,
    required this.type});

  @override
  State<PartsOrderByStatus> createState() => _PartsOrderByStatusState();
}

class _PartsOrderByStatusState extends State<PartsOrderByStatus> {
  @override
  void  initState(){
    super.initState();
    getInitialData().whenComplete(() {
      //print("User Role : $role");
      getOrderList();

    });

    loading=true;
  }
  bool loading=false;
  List estimateItems=[];
  List displayListItems=[];
  Map kpiValues ={};
  int startVal=0;

  String role ='';
  String userId ='';
  String orgId ='';

  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role= prefs.getString("role")??"";
    userId= prefs.getString("userId")??"";
    orgId= prefs.getString("orgId")??"";
  }

  Future getOrderList()async{
    dynamic response;
    //String url='${StaticData.url}vehicleorder/search_by_status/${widget.type}';

    String url ="${StaticData.url}partsorder/search_by_status/${widget.type}";

    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            estimateItems=response;
            // print(estimateItems);
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
              else{
                for(int i=0;i<estimateItems.length;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
            }
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }

  Future getKPIValues()async{
    dynamic response;
    String url='${StaticData.url}vehicleorder/get_status_counts';

    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            kpiValues = response;
          }
          print(kpiValues);
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }

  Future searchByOrderID({ required String orderId})async{
    displayListItems =[];
    dynamic response;
    String url='${StaticData.url}vehicleorder/search_by_vehicleOrderId/$orderId';

    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            estimateItems=response;
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
              else{
                for(int i=0;i<estimateItems.length;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
            }
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }

  Future searchByStatus({ required String status})async{
    displayListItems =[];
    dynamic response;
    String url='${StaticData.url}vehicleorder/search_by_status/$status';

    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            estimateItems=response;
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
              else{
                for(int i=0;i<estimateItems.length;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
            }
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }

  // Search Controller Declaration.
  final searchByStatusController=TextEditingController();
  final searchByDate=TextEditingController();
  final searchByOrder=TextEditingController();
  formattedDate(int dateFromResp) {
    // Timestamp in milliseconds
    int timestamp = dateFromResp;
    // Convert to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // Format the date to 'dd-mm-yyyy'
    String formattedDate = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    //print(formattedDate); // Output: 24-09-2024
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize:Size.fromHeight(60) ,
        child: CustomAppBar(),),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(width: 1, thickness: 1,),
          Expanded(
            child:
            CustomLoader(
              inAsyncCall: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40,top: 30,bottom: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0),)

                      ),
                      child: Column(
                        children: [
                          PreferredSize(
                            preferredSize: const Size.fromHeight(60),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), // Apply corner radius here
                              child: AppBar(
                                title: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "List of Parts Order By (${widget.type})",
                                            style: const TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 18),
                                    child: SizedBox(
                                      width: 150,
                                      height: 30,
                                      child: OutlinedMButton(
                                        text: '+ Create Part Order',
                                        buttonColor: mSaveButton,
                                        textColor: Colors.white,
                                        borderColor: mSaveButton,
                                        onTap: () {
                                          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                              CreatePartOrder2(selectedDestination: widget.selectedDestination,
                                                drawerWidth: widget.drawerWidth,)
                                          ));

                                          // Navigator.of(context).push(PageRouteBuilder(
                                          //   pageBuilder: (context, animation1, animation2) => CreateRFQ(
                                          //     selectedDestination: widget.selectedDestination,
                                          //     drawerWidth: widget.drawerWidth,
                                          //   ),
                                          // )).then((value) async {
                                          //   setState(() {
                                          //     loading = true;
                                          //   });
                                          //   await getOrderList();
                                          //   setState(() {
                                          //     loading = false;
                                          //   });
                                          //   print("End");
                                          // });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            // height:100,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 18,),

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
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Order Id")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Vendor Name")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text('Date')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text('Total Amount')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Status")
                                                  ),
                                                )),
                                            // Expanded(
                                            //     child: Padding(
                                            //       padding: EdgeInsets.only(top: 4),
                                            //       child: SizedBox(height: 25,
                                            //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            //           child: Text("Status")
                                            //       ),
                                            //     )),
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
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: displayListItems.length + 1,
                            itemBuilder: (context, index) {
                              if (index < displayListItems.length) {
                                return Column(
                                  children: [
                                    MaterialButton(
                                      hoverColor: Colors.blue[50],
                                      onPressed: () {
                                        Navigator.of(context).push(PageRouteBuilder(
                                            pageBuilder: (context,animation1,animation2) => PartOrderDetails2(
                                              //customerList: displayList[i],
                                              drawerWidth: widget.drawerWidth,
                                              selectedDestination: widget.selectedDestination,
                                              partDetails: displayListItems[index],
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero,
                                              partsList: estimateItems,
                                            )
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 18.0, top: 4, bottom: 3),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(displayListItems[index]['partsOrderId']??"")
                                                    //Text(displayListItems[index]['estVehicleId']??"")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child:
                                                      Text(displayListItems[index]['invCustomerName']??"")
                                                    //Text(displayListItems[index]['billAddressName']??"")
                                                  ),
                                                )),
                                            // Expanded(
                                            //     child: Padding(
                                            //       padding: const EdgeInsets.only(top: 4),
                                            //       child: SizedBox(
                                            //           height: 25,
                                            //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            //           child:
                                            //           Text("")
                                            //           //Text(displayListItems[index]['shipAddressName']?? '')
                                            //       ),
                                            //     )
                                            // ),
                                            Expanded(
                                                child: Padding(
                                                  padding:const EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child:(displayListItems[index]['orderDate']== null || displayListItems[index]['orderDate']== '') ?const Text(''):
                                                      Text(formattedDate(displayListItems[index]['orderDate']??""))
                                                    //Text(displayListItems[index]['serviceInvoiceDate']?? '')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child:
                                                      Text(displayListItems[index]['totalAmount'].toString())
                                                    //Text(double.parse(displayListItems[index]['total'].toString()).toStringAsFixed(2))
                                                  ),
                                                )),
                                            if(displayListItems[index]['status']==null || displayListItems[index]['status']=='')...{
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      width: 100,
                                                      child: Text((displayListItems[index]['status']==null || displayListItems[index]['status']=="") ? "":
                                                      displayListItems[index]['status']),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            }
                                            else... {
                                              if (displayListItems[index]['status'] == "Delivered")
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 25,
                                                        width: 100,
                                                        child: OutlinedMButton(
                                                          text:
                                                          displayListItems[
                                                          index]
                                                          ['status'],
                                                          borderColor:
                                                          Colors.green,
                                                          textColor:
                                                          Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              if (displayListItems[index]
                                              ['status'] == "In-Progress")
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 25,
                                                        width: 100,
                                                        child: OutlinedMButton(
                                                          text:
                                                          displayListItems[
                                                          index]
                                                          ['status'],
                                                          borderColor:
                                                          Colors.blue,
                                                          textColor:
                                                          Colors.blue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              if (displayListItems[index]['status'] == "Returned Order")
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 25,
                                                        width: 100,
                                                        child: OutlinedMButton(
                                                          text:
                                                          displayListItems[index]['status'].substring(0,8),
                                                          borderColor:
                                                          Colors.red,
                                                          textColor: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                            }
                                          ],
                                        ),
                                      ),

                                    ),
                                    Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                  ],
                                );
                              }
                              else {
                                return Column(
                                  children: [
                                    Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${startVal + 15 > estimateItems.length ? estimateItems.length : startVal + 1}-${startVal + 15 > estimateItems.length ? estimateItems.length : startVal + 15} of ${estimateItems.length}",
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(width: 10),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            hoverColor: mHoverColor,
                                            child: const Padding(
                                              padding: EdgeInsets.all(18.0),
                                              child: Icon(Icons.arrow_back_ios_sharp, size: 12),
                                            ),
                                            onTap: () {
                                              if (startVal > 14) {
                                                displayListItems = [];
                                                startVal = startVal - 15;
                                                for (int i = startVal; i < startVal + 15; i++) {
                                                  setState(() {
                                                    displayListItems.add(estimateItems[i]);
                                                  });
                                                }
                                              } else {
                                                log('else');
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            hoverColor: mHoverColor,
                                            child: const Padding(
                                              padding: EdgeInsets.all(18.0),
                                              child: Icon(Icons.arrow_forward_ios, size: 12),
                                            ),
                                            onTap: () {
                                              if (startVal + 1 + 5 > estimateItems.length) {
                                                // print("Block");
                                              } else if (estimateItems.length > startVal + 15) {
                                                displayListItems = [];
                                                startVal = startVal + 15;
                                                for (int i = startVal; i < startVal + 15; i++) {
                                                  setState(() {
                                                    try {
                                                      displayListItems.add(estimateItems[i]);
                                                    } catch (e) {
                                                      log(e.toString());
                                                    }
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          )
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
  // Fetch Functions.
  fetchSearchByDate(String date)async{
    dynamic response;
    String url="";
    if(role=="Approver"){
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/search_by_serviceinvoicedate/$date";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/get_date_search_by_user_id/$userId/$date";
    }
    try {
      await getData(url:url ,context: context).then((date){
        setState(() {
          if(date!=null){
            response=date;
            estimateItems=response;
            displayListItems=[];
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
              else{
                for(int i=0;i<estimateItems.length;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
            }
          }
        });
      });
    }
    catch(e){
      log(e.toString());
    }
  }
  fetchOrderIDItems(String orderID)async{
    dynamic response;
    String url="";
    if(role=="Approver"){
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/search_by_estvehicleid/$orderID";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/get_estveh_id_search_by_user_id/$userId/$orderID";
    }
    try{
      await getData(context:context ,url: url).then((orderID){
        setState(() {
          if(orderID!=null){
            response=orderID;
            estimateItems=response;
            displayListItems=[];
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
              else{
                for(int i=0;i<estimateItems.length;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
            }
          }
        });
      });
    }
    catch(e){
      log(e.toString());
    }
  }
  fetchByStatus(String status)async{
    dynamic response;
    String url="";
    if(role=="Approver"){
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/search_by_status/$status";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/get_status_search_by_user_id/$userId/$status";
    }
    try{
      await getData(url:url ,context: context).then((searchByStatus){
        setState(() {
          if(searchByStatus!=null){
            response=searchByStatus;
            estimateItems=response;
            displayListItems=[];
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
              else{
                for(int i=0;i<estimateItems.length;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
            }
          }
        });
      });
    }
    catch(e){
      log(e.toString());
    }
  }
  // Search Text field Decoration.
  searchDateDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByDate.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayListItems=[];
              searchByDate.clear();
              getOrderList();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  searchByOrderIDDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByOrder.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayListItems=[];
              searchByOrder.clear();
              getOrderList();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  searchByStatusDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByStatusController.text.isEmpty? const Icon(Icons.search,size: 18,):InkWell(
          onTap: (){
            setState(() {
              setState(() {
                startVal=0;
                displayListItems=[];
                searchByStatusController.clear();
                getOrderList();
              });
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }


// Route _createRoute({required orderDetails, required double drawerWidth, required List<dynamic> orderList}) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => ViewOrderDetails(selectedDestination: 1.1, drawerWidth: drawerWidth , orderDetails:orderDetails,orderList: orderList),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(2.0, 0.0);
//       const end = Offset.zero;
//       const curve = Curves.bounceIn;
//
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
}
