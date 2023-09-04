
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/pre_sales/parts_order/parts_order_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';

import '../../widgets/motows_buttons/outlined_mbutton.dart';
import 'add_new_parts_order.dart';



class PartsOrderListArguments {
  final double drawerWidth;
  final double selectedDestination;
  PartsOrderListArguments({required this.drawerWidth, required this.selectedDestination});
}

class PartsOrderList extends StatefulWidget {
  final PartsOrderListArguments args;

  const PartsOrderList({Key? key, required this.args}) : super(key: key);

  @override
  State<PartsOrderList> createState() => _PartsOrderListState();
}

class _PartsOrderListState extends State<PartsOrderList> {
  @override
  void  initState(){
    super.initState();
    getInitialData().whenComplete(() {
      fetchEstimate();
    });
    loading=true;
  }
  String role ='';
  String userId ='';

  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role= prefs.getString("role")??"";
    userId= prefs.getString("userId")??"";
  }
  bool loading=false;
  List estimateItems=[];
  List displayListItems=[];
  int startVal=0;

  final salesInvoiceDataController = TextEditingController();
  final searchByOrderId=TextEditingController();
  final searchByStatusController=TextEditingController();

  Future fetchEstimate()async{
    dynamic response;
    String url='';
    if(role=="Manager"){
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_all_uesr_or_manager/Manager/$userId";
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
                    padding: const EdgeInsets.only(left: 40,right: 40,top: 30,bottom: 30),
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
                                                  String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
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
                                                  fetchEstimate();
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
                                                      fetchEstimate();
                                                    }
                                                    else if(searchByStatusController.text.isNotEmpty || salesInvoiceDataController.text.isNotEmpty){
                                                      searchByStatusController.clear();
                                                      salesInvoiceDataController.clear();
                                                    }
                                                    else{
                                                      startVal=0;
                                                      displayListItems=[];
                                                      if(searchByOrderId.text.length>6){
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
                                                      fetchEstimate();
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
                                                              CreatePartOrder(selectedDestination: widget.args.selectedDestination,
                                                                drawerWidth: widget.args.drawerWidth,)
                                                          )).then((value) => fetchEstimate());
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
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text('Ship To Name')
                                                  ),
                                                )
                                            ),
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
                               return Column(
                                  children: [
                                    MaterialButton(
                                      hoverColor: Colors.blue[50],
                                      onPressed: (){
                                        // print('-Item Line Data');
                                        // print(displayListItems[i]);
                                        Navigator.of(context).push(PageRouteBuilder(
                                            pageBuilder: (context,animation1,animation2) => PartOrderDetails(
                                              //customerList: displayList[i],
                                              drawerWidth: widget.args.drawerWidth,
                                              selectedDestination: widget.args.selectedDestination,
                                              estimateItem: displayListItems[index],
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero,
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
                                                      child: Text(displayListItems[index]['estVehicleId']??"")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(displayListItems[index]['billAddressName']??"")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(displayListItems[index]['shipAddressName']?? '')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(displayListItems[index]['serviceInvoiceDate']?? '')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(double.parse(displayListItems[index]['total'].toString()).toStringAsFixed(2))
                                                  ),
                                                )),
                                            if(displayListItems[index]['status'] == "Approved")
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                    width: 100,
                                                    child: OutlinedMButton(
                                                      text: displayListItems[index]['status'],
                                                      borderColor: Colors.green,
                                                      textColor:Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if(displayListItems[index]['status']=="In-review")
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      width: 100,
                                                      child: OutlinedMButton(
                                                        text: displayListItems[index]['status'],
                                                        borderColor: Colors.blue,
                                                        textColor: Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if(displayListItems[index]['status'] == "Rejected")
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      width: 100,
                                                      child: OutlinedMButton(
                                                        text: displayListItems[index]['status'],
                                                        borderColor: Colors.red,
                                                        textColor:Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Search Async Functions.
  Future fetchInvoiceDate(String orderDate)async{
    dynamic response;
    String url="";
    if(role==""){
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/search_by_serviceinvoicedate/$orderDate";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_date_search_by_user_id/$userId/$orderDate";
    }
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
    String url="";
    if(role=="Manager"){
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/search_by_estvehicleid/$orderID";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_estveh_id_search_by_user_id/$userId/$orderID";
    }
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
    String url="";
    if(role=="Manager"){
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/search_by_status/$status";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/get_status_search_by_user_id/USER_03268/$status";
    }
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
               fetchEstimate();
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
               fetchEstimate();
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
              setState(() {
                startVal=0;
                 displayListItems=[];
                searchByStatusController.clear();
                 fetchEstimate();
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
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder:  const OutlineInputBorder(borderSide: BorderSide(color:mSaveButton)),
    );
  }


}


