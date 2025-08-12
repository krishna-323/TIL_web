import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/vehicle_part_order/parts_order_details2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';
import 'create_new_part_order.dart';
import 'parts_order_by_status.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:new_project/classes/env.dart';

class PartsOrderListArguments2 {
  final double drawerWidth;
  final double selectedDestination;
  PartsOrderListArguments2({required this.drawerWidth, required this.selectedDestination});
}

class PartsOrderList2 extends StatefulWidget {
  final PartsOrderListArguments2 args;

  const PartsOrderList2({Key? key, required this.args}) : super(key: key);

  @override
  State<PartsOrderList2> createState() => _PartsOrderList2State();
}

class _PartsOrderList2State extends State<PartsOrderList2> {
  @override
  void  initState(){
    super.initState();
    loading = true;
    getInitialData().whenComplete(() {
      //print('------Testing-------');
      //fetchEstimate();
      fetchOrderList();
    });
    // loading=true;
  }
  String role ='';
  String userId ='';
  String orgId ='';

  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role= prefs.getString("role")??"";
    userId= prefs.getString("userId")??"";
    orgId= prefs.getString("orgId")??"";
  }
  bool loading=false;
  List estimateItems=[];
  List displayListItems=[];
  Map kpiValues ={};
  int startVal=0;

  final salesInvoiceDataController = TextEditingController();
  final searchByOrderId=TextEditingController();
  final searchByStatusController=TextEditingController();
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();

  //Old Func Call Code.
  Future fetchEstimate()async{
    dynamic response;
    String url='';
    if(role=="Approver"){
      url="https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_all_by_company_id/$orgId";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_all_uesr_or_manager/User/$userId";
    }
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
  Future fetchOrderList()async{
    await getKPIValues();
    dynamic response;
    String url='${StaticData.url}partsorder/get_all_partsorder';

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
  Future getKPIValues()async{
    dynamic response;
    String url='${StaticData.url}partsorder/get_status_counts';

    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            kpiValues = response;
          }
          print(response);
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
          CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
          const VerticalDivider(width: 1,
            thickness: 1,),
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if(constraints.maxWidth >= 1140){
                    return CustomLoader(
                        inAsyncCall: loading,
                        child: buildMain(MediaQuery.of(context).size.width));

                    // return loading ? const Center(
                    //   child: SizedBox(
                    //       width: 50,
                    //       height: 50,
                    //       child: CircularProgressIndicator()),
                    // ):
                    // buildMain(MediaQuery.of(context).size.width);
                  }
                  else {
                    return CustomLoader(
                      inAsyncCall: loading,
                      child: AdaptiveScrollbar(
                        controller: _verticalScrollController,
                        underColor: Colors.blueGrey.withOpacity(0.3),
                        sliderDefaultColor: Colors.grey.withOpacity(0.7),
                        sliderActiveColor: Colors.grey,
                        position: ScrollbarPosition.right,
                        child: AdaptiveScrollbar(
                          position: ScrollbarPosition.bottom,
                          underColor: Colors.blueGrey.withOpacity(0.3),
                          sliderDefaultColor: Colors.grey.withOpacity(0.7),
                          sliderActiveColor: Colors.grey,
                          controller: _horizontalScrollController,
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 68, bottom: 30, right: 68),
                                child: buildMain(1140),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },),
          ),
        ],
      ),
    );
  }
  Widget buildMain(double screenWidth){
    return Container(
      width: screenWidth,
      color: Colors.grey[50],
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
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children:  [
                    Expanded(child: InkWell(
                      onTap:(){
                        // Navigator.pushReplacementNamed(context, MotowsRoutes.docketList,arguments: DocketListArgs(selectedDestination: 0,drawerWidth: 190));
                      },
                      child: Card(
                          color: Colors.transparent,
                          elevation: 4,
                          child:  Container(
                            height: 130,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0,top: 20),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 55,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                        child: const Icon(Icons.account_balance_wallet_outlined,color: Colors.white,size: 30),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(child: Text("Total Orders",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Flexible(child: Text("${kpiValues.isEmpty ?"":kpiValues['Total']}",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                              ],
                            ),
                          )),
                    )),
                    const SizedBox(width: 30),
                    Expanded(child: InkWell(
                      onTap:(){
                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                            PartsOrderByStatus(type: "In-Progress",selectedDestination: widget.args.selectedDestination,
                              drawerWidth: widget.args.drawerWidth,)
                        ));

                        // Navigator.pushReplacementNamed(context, MotowsRoutes.docketList,arguments: DocketListArgs(selectedDestination: 0,drawerWidth: 190));
                      },
                      child: Card(
                          color: Colors.transparent,
                          elevation: 4,
                          child:  Container(
                            height: 130,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0,top: 20),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 55,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                        child: const Icon(Icons.account_balance_wallet_outlined,color: Colors.white,size: 30),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(child: Text("In-progress",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Flexible(child: Text("${kpiValues.isEmpty ?"":kpiValues['In-Progress']}",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Container(
                                  height: 40,decoration: BoxDecoration(
                                  color: const Color(0xffF9FAFB),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.transparent,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                  child:  const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                        child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    )),
                    const SizedBox(width: 30),
                    Expanded(child: InkWell(
                      onTap: (){

                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                            PartsOrderByStatus(type: "Delivered",selectedDestination: widget.args.selectedDestination,
                              drawerWidth: widget.args.drawerWidth,)
                        ));

                      },
                      child: Card(
                          color: Colors.transparent,
                          elevation: 4,
                          child:  Container(
                            height: 130,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0,top: 20),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 55,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                        child: const Icon(IconData(0xef6f, fontFamily: 'MaterialIcons'),color: Colors.white,size: 30),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(child: Text("Delivered",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Flexible(child: Text("${kpiValues.isEmpty ?"":kpiValues['Delivered']}",
                                                      overflow:TextOverflow.ellipsis,maxLines: 1 ,
                                                      style: TextStyle(color: Colors.grey[800],
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold))),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Container(
                                  height: 40,decoration: BoxDecoration(
                                  color: const Color(0xffF9FAFB),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.transparent,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                  child:  const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                        child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    )),
                    const SizedBox(width: 30),
                    Expanded(child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                            PartsOrderByStatus(type: "Returned Order",selectedDestination: widget.args.selectedDestination,
                              drawerWidth: widget.args.drawerWidth,)
                        ));
                      },
                      child: Card(
                          color: Colors.transparent,
                          elevation: 4,
                          child:  Container(
                            height: 130,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0,top: 20),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 55,
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                          child:const Icon(Icons.check_box_rounded,color: Colors.white,size: 30)

                                        // const Icon(IconData(0xef6f, fontFamily: 'MaterialIcons'),color: Colors.white,size: 30),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(child: Text("Returned Order",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Flexible(child: Text("${kpiValues.isEmpty ?"":kpiValues['Returned Order']}",
                                                      overflow:TextOverflow.ellipsis,
                                                      maxLines: 1 ,style: TextStyle(color: Colors.grey[800],
                                                          fontSize: 20,fontWeight: FontWeight.bold))),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Container(
                                  height: 40,decoration: BoxDecoration(
                                  color: const Color(0xffF9FAFB),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.transparent,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                  child:  const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                        child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    )),
                  ],
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
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:   [
                          Text("Parts Order List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 50.0),
                          //   child: MaterialButton(onPressed: (){
                          //     Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                          //         CreatePartOrder(selectedDestination: widget.args.selectedDestination,
                          //           drawerWidth: widget.args.drawerWidth,)
                          //     )).then((value) => fetchEstimate());
                          //   },
                          //     color: Colors.blue,
                          //     child: const Text('+ Create Part Order',style: TextStyle(color: Colors.white),),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(height: 18,),
                    Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: SizedBox(height: 100,
                        child: Row(
                          children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(  width: 190,height: 30, child: TextFormField(
                                  controller:salesInvoiceDataController,
                                  onTap: ()async{
                                    DateTime? pickedDate=await showDatePicker(context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1999),
                                        lastDate: DateTime.now()

                                    );
                                    if(pickedDate!=null){
                                      String formattedDate=DateFormat('yyyy-MM-dd').format(pickedDate);
                                      setState(() {
                                        salesInvoiceDataController.text = formattedDate;
                                        // print('----------date---');
                                        // print(salesInvoiceDataController.text);
                                        displayListItems=[];
                                        fetchInvoiceDate(salesInvoiceDataController.text);
                                      });
                                    }
                                    else{
                                      log('Date not selected');
                                    }
                                  },

                                  onChanged: (value){
                                    if(value.isEmpty || value==""){
                                      startVal=0;
                                      displayListItems=[];
                                      fetchOrderList();
                                    }
                                    else if(searchByOrderId.text.isNotEmpty || searchByStatusController.text.isNotEmpty){
                                      searchByOrderId.clear();
                                      searchByStatusController.clear();
                                    }
                                    else{
                                      try{
                                        startVal=0;
                                        displayListItems=[];
                                        // print('-==========else condition========');
                                        // print(salesInvoiceDataController.text);
                                        fetchInvoiceDate(salesInvoiceDataController.text);
                                      }
                                      catch(e){
                                        log(e.toString());
                                      }
                                    }
                                  },
                                  style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchInvoiceDate(hintText: 'Search By Date'),  ),),
                                const SizedBox(height: 20),
                                Row(
                                  children: [

                                    SizedBox(  width: 190,height: 30, child: TextFormField(
                                      controller:searchByOrderId,
                                      onChanged: (value){
                                        if(value.isEmpty || value==""){
                                          startVal=0;
                                          displayListItems=[];
                                          fetchOrderList();
                                        }
                                        else if(searchByStatusController.text.isNotEmpty || salesInvoiceDataController.text.isNotEmpty){
                                          searchByStatusController.clear();
                                          salesInvoiceDataController.clear();
                                        }
                                        else{
                                          startVal=0;
                                          displayListItems=[];
                                          if(searchByOrderId.text.isNotEmpty){
                                            fetchByOrderId(searchByOrderId.text);
                                          }

                                        }
                                      },
                                      style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchOrderByIdDecoration(hintText: 'Search By Order #'),  ),),
                                    const SizedBox(width: 10,),

                                    SizedBox(  width: 190,height: 30, child: TextFormField(
                                      controller:searchByStatusController,
                                      onChanged: (value){
                                        if(value.isEmpty || value==""){
                                          startVal=0;
                                          displayListItems=[];
                                          //fetchEstimate();
                                          fetchOrderList();
                                        }
                                        else if(searchByOrderId.text.isNotEmpty || salesInvoiceDataController.text.isNotEmpty){
                                          searchByOrderId.clear();
                                          salesInvoiceDataController.clear();
                                        }
                                        else{
                                          try{
                                            startVal=0;
                                            displayListItems=[];
                                            fetchByStatusItems(searchByStatusController.text);
                                          }
                                          catch(e){
                                            log(e.toString());
                                          }
                                        }
                                      },
                                      style: const TextStyle(fontSize: 14),
                                      //  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      maxLength: 10,
                                      decoration: searchByStatusDecoration(hintText: 'Search By Status'),  ),),
                                    const SizedBox(width: 10,),
                                  ],
                                ),
                              ],
                            )),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 44),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:SizedBox(

                                        width: 150,
                                        height:30,
                                        child: OutlinedMButton(
                                          text: '+ Create Part Order',
                                          buttonColor:mSaveButton ,
                                          textColor: Colors.white,
                                          borderColor: mSaveButton,
                                          onTap:(){
                                            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                CreatePartOrder2(selectedDestination: widget.args.selectedDestination,
                                                  drawerWidth: widget.args.drawerWidth,)
                                            )).then((value) => fetchOrderList());
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),

                                  ],
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
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
                                          child: Text("Order ID")
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
                                // Expanded(
                                //     child: Padding(
                                //       padding: EdgeInsets.only(top: 4),
                                //       child: SizedBox(
                                //           height: 25,
                                //           //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                //           child: Text('Ship To Name')
                                //       ),
                                //     )
                                // ),
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
                                      child: SizedBox(height: 25,
                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: Text("Total Amount")
                                      ),
                                    )),
                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: SizedBox(height: 25,
                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: Text("Status")
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: displayListItems.length + 1,
                itemBuilder: ( context, index) {
                  if(index < displayListItems.length){
                    //print(displayListItems[index]['orderDate'].runtimeType);
                    return Column(
                      children: [
                        MaterialButton(
                          hoverColor: Colors.blue[50],
                          onPressed: (){
                            // print('-Item Line Data');
                            // print(displayListItems[i]);
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (context,animation1,animation2) => PartOrderDetails2(
                                  //customerList: displayList[i],
                                  drawerWidth: widget.args.drawerWidth,
                                  selectedDestination: widget.args.selectedDestination,
                                  partDetails: displayListItems[index],
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                  partsList: estimateItems,
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
                                      padding:  EdgeInsets.only(top: 4),
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
                                  if (displayListItems[index]['status'] == "Delivered" || displayListItems[index]['status'] == "Completed")
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
                                  if (displayListItems[index]['status'] == "In-Progress")
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

                                  // Expanded(
                                  //   child: Row(
                                  //     children: [
                                  //       SizedBox(
                                  //         height: 25,
                                  //         width: 100,
                                  //         child: OutlinedMButton(
                                  //           text:
                                  //           displayListItems[index]['status'],
                                  //           borderColor:
                                  //           Colors.red,
                                  //           textColor: Colors.red,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                }
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                      ],
                    );
                  }
                  else{
                    return Column(
                      children: [
                        Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Text("${startVal+15>estimateItems.length?estimateItems.length:startVal+1}-${startVal+15>estimateItems.length?estimateItems.length:startVal+15} of ${estimateItems.length}",style: const TextStyle(color: Colors.grey)),
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
                                        displayListItems.add(estimateItems[i]);
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
                                  if(startVal+1+5>estimateItems.length){
                                    // print("Block");
                                  }
                                  else
                                  if(estimateItems.length>startVal+15){
                                    displayListItems=[];
                                    startVal=startVal+15;
                                    for(int i=startVal;i<startVal+15;i++){
                                      setState(() {
                                        try{
                                          displayListItems.add(estimateItems[i]);
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
                        ),
                      ],
                    );
                  }
                },

              ),
            ],
          ),
        ),
      ),
    );
  }
  // Search Async Functions.
  Future fetchInvoiceDate(String orderDate)async{
    // print('-----orderDate-----');
    // print(orderDate);
    dynamic response;
    String url="${StaticData.url}partsorder/search_by_orderDate/$orderDate";
    // if(role=="Approver"){
    //   url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/search_by_serviceinvoicedate/$orderDate";
    // }
    // else{
    //   url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_date_search_by_user_id/$userId/$orderDate";
    // }
    try{
      await getData(url:url ,context: context).then((value){
        setState(() {
          if(value!=null){
            response=value;
            estimateItems=response;
            displayListItems=[];
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal +15;i++){
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
  Future fetchByOrderId(String orderID)async{
    dynamic response;
    String url="${StaticData.url}partsorder/search_by_partsorderId/$orderID";
    ///Old Cofig.
    // if(role=="Approver"){
    //   url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/search_by_estvehicleid/$orderID";
    // }
    // else{
    //   url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_estveh_id_search_by_user_id/$userId/$orderID";
    // }
    try{
      await getData(context:context ,url: url).then((value){
        setState(() {
          if(value!=null){
            response=value;
            estimateItems=response;
            displayListItems=[];
            if(displayListItems.isEmpty){
              if(estimateItems.length > 15){
                for(int i=startVal;i<startVal +15;i++){
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
  Future fetchByStatusItems(String status)async{
    dynamic response;
    String url="${StaticData.url}partsorder/search_by_status/$status";
    // if(role=="Approver"){
    //   url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/search_by_status/$status";
    // }
    // else{
    //   url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_status_search_by_user_id/USER_03268/$status";
    // }
    try{
      await getData(url:url ,context: context).then((statusItems){
        setState(() {
          if(statusItems!=null){
            response=statusItems;
            estimateItems=response;
            displayListItems=[];
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal +15;i++){
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

  searchInvoiceDate ({required String hintText,}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: salesInvoiceDataController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayListItems=[];
              salesInvoiceDataController.clear();
              //fetchEstimate();
              fetchOrderList();
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
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder:  const OutlineInputBorder(borderSide: BorderSide(color:mSaveButton)),
    );
  }
  searchOrderByIdDecoration ({required String hintText, }){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByOrderId.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayListItems=[];
              searchByOrderId.clear();
              fetchOrderList();
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
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder:  const OutlineInputBorder(borderSide: BorderSide(color:mSaveButton)),
    );
  }
  searchByStatusDecoration ({required String hintText,}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByStatusController.text.isEmpty? const Icon(Icons.search,size: 18,):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayListItems=[];
              searchByStatusController.clear();
              //fetchEstimate();
              fetchOrderList();
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
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder:  const OutlineInputBorder(borderSide: BorderSide(color:mSaveButton)),
    );
  }
}


