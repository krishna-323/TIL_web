import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';
import 'add_new_warranty.dart';
import 'warranty_details.dart';

class WarrantyArgs{
  final double drawerWidth;
  final double selectedDestination;
  WarrantyArgs({required this.drawerWidth,required this.selectedDestination});
}


class Warranty extends StatefulWidget {
  final WarrantyArgs args;

  const Warranty({Key? key, required this.args}) : super(key: key);

  @override
  State<Warranty> createState() => _WarrantyState();
}

class _WarrantyState extends State<Warranty> {
  @override
  void  initState(){
    super.initState();
    getInitialData().whenComplete(() {
      fetchWarrantyList();
    });
    loading=true;
  }
  bool loading=false;
  List estimateItems=[];
  List displayListItems=[];
  int startVal=0;

  final searchByDateController = TextEditingController();
  final searchByStatus = TextEditingController();
  final searchByOrderID = TextEditingController();
  String role ='';
  String userId ='';
  String managerId ='';
  String orgId ='';
  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role= prefs.getString("role")??"";
    userId= prefs.getString("userId")??"";
    managerId= prefs.getString("managerId")??"";
    orgId= prefs.getString("orgId")??"";
  }
  Future fetchWarrantyList()async{
    dynamic response;
    String url='';
    if(role=="Approver"){
      url ="https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/get_all_by_company_id/$orgId";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/get_all_uesr_or_manager/User/$userId";
    }
    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            estimateItems=response;
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal + 15;i++){
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
                                      Text("Warranty Orders List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
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
                                              onTap: ()async{
                                                DateTime? pickedDate=await showDatePicker(context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1999),
                                                    lastDate: DateTime.now()

                                                );
                                                if(pickedDate!=null){
                                                  String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
                                                  setState(() {
                                                    searchByDateController.text=formattedDate;
                                                    fetchDate(searchByDateController.text);
                                                  });
                                                }
                                                else{
                                                  log('Date not selected');
                                                }
                                              },
                                              controller:searchByDateController,
                                              onChanged: (value){
                                                if(value.isEmpty || value==""){
                                                  startVal=0;
                                                  displayListItems=[];
                                                  fetchWarrantyList();
                                                }
                                                else if(searchByOrderID.text.isNotEmpty || searchByStatus.text.isNotEmpty){
                                                  searchByOrderID.clear();
                                                  searchByStatus.clear();
                                                }
                                                else{
                                                  startVal=0;
                                                  displayListItems=[];
                                                  fetchDate(searchByDateController.text);
                                                }
                                              },
                                              style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchByDateDecoration(hintText: 'Search By Date'),  ),),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [

                                                SizedBox(  width: 190,height: 30, child: TextFormField(
                                                  controller:searchByOrderID,
                                                  onChanged: (value){
                                                    if(value.isEmpty || value==""){
                                                      startVal=0;
                                                      displayListItems=[];
                                                      fetchWarrantyList();
                                                    }
                                                    else if(searchByStatus.text.isNotEmpty || searchByDateController.text.isNotEmpty){
                                                      searchByStatus.clear();
                                                      searchByDateController.clear();
                                                    }
                                                    else{
                                                      startVal=0;
                                                      displayListItems=[];
                                                      if(searchByOrderID.text.length>6){
                                                        fetchByOrderID(searchByOrderID.text);
                                                      }

                                                    }
                                                  },
                                                  style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchByOrderIDDecoration(hintText: 'Search By Order #'),  ),),
                                                const SizedBox(width: 10,),

                                                SizedBox(  width: 190,height: 30, child: TextFormField(
                                                  controller:searchByStatus,
                                                  onChanged: (value){
                                                    if(value.isEmpty || value==""){
                                                      startVal=0;
                                                      displayListItems=[];
                                                      fetchWarrantyList();
                                                    }
                                                    else if(searchByOrderID.text.isNotEmpty || searchByDateController.text.isNotEmpty){
                                                      searchByOrderID.clear();
                                                      searchByDateController.clear();
                                                    }
                                                    else{
                                                        startVal=0;
                                                        displayListItems=[];
                                                        fetchByStatus(searchByStatus.text);
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
                                                    height: 30,
                                                    width: 180,
                                                    child: OutlinedMButton(
                                                      text: '+ Create Warranty Order',
                                                      buttonColor:mSaveButton ,
                                                      textColor: Colors.white,
                                                      borderColor: mSaveButton,
                                                      onTap:(){
                                                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                            AddNewWarranty(selectedDestination: widget.args.selectedDestination,
                                                              drawerWidth: widget.args.drawerWidth,)
                                                        )).then((value) => fetchWarrantyList());
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
                                                  padding: EdgeInsets.only(top: 4),
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
                                                  padding: EdgeInsets.only(top: 4.0),
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
                          ListView.builder(shrinkWrap: true,
                            itemCount: displayListItems.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                            if(index < displayListItems.length){
                            return  Column(
                              children: [
                                MaterialButton(
                                    hoverColor: Colors.blue[50],
                                    onPressed: (){

                                      Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (context,animation1,animation2) => WarrantyDetails(
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
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[index]['estVehicleId']?? '')
                                                ),
                                              )
                                          ),
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
                              return
                                Column(
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
  //Fetch By Names Apis.
  Future fetchDate(String searchByDate)async{
    dynamic response;
    String url="";
    if(role=="Approver"){
      url ="https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/search_by_serviceinvoicedate/$searchByDate";
      print(url);
    }
    else{
      url ="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/search_by_serviceinvoicedate/$userId/$searchByDate";
    }
    try{
     await getData(url:url ,context: context).then((date){
       setState(() {
         if(date!=null){
           response = date;
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
  Future fetchByOrderID(String orderID)async{
    dynamic response;
    String url="";
    if(role=="Approver"){
      url="https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/search_by_estvehicleid/$orderID";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/search_by_estvehicleid/$userId/$orderID";
    }
    try{
      await getData(context: context,url: url).then((orderID){
        setState(() {
        if(orderID!=null){
          response=orderID;
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
        });
      });
    }
    catch(e){
      log(e.toString());
    }
  }
  Future fetchByStatus(String status)async{
    dynamic response;
    String url='';
    if(role=="Approver"){
      url ="https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/search_by_status/$status";
    }
    else{
      url="https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/search_by_status/$userId/$status";
    }
    try{
      await getData(context: context,url: url).then((status){
        setState(() {
          if(status!=null){
            response =status;
            estimateItems=response;
            displayListItems=[];
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=0;i<startVal+15;i++){
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

  searchByDateDecoration ({required String hintText,}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByDateController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayListItems=[];
              searchByDateController.clear();
             fetchWarrantyList();
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
  searchByOrderIDDecoration ({required String hintText,}) {
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByOrderID.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayListItems=[];
              searchByOrderID.clear();
              fetchWarrantyList();
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
      focusedBorder:  const OutlineInputBorder(borderSide: BorderSide(color: mSaveButton)),
    );
  }
  searchByStatusDecoration ({required String hintText,}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByStatus.text.isEmpty? const Icon(Icons.search,size: 18,):InkWell(
          onTap: (){
            setState(() {
                startVal=0;
                displayListItems=[];
                searchByStatus.clear();
               fetchWarrantyList();
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
