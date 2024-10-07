
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/vehicle_RFQ/add_vehicle_to_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../classes/motows_routes.dart';
import '../../../widgets/custom_dividers/custom_vertical_divider.dart';
import '../../../widgets/custom_search_textfield/custom_search_field.dart';
import '../../../widgets/motows_buttons/outlined_icon_mbutton.dart';
import '../../../widgets/motows_buttons/outlined_mbutton.dart';
import '../../utils/api/get_api.dart';
import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../../utils/static_data/motows_colors.dart';
import 'edit_vehicle_to_form.dart';

class ViewOrderDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map orderDetails;
  final List orderList;
  const ViewOrderDetails({Key? key,  required this.selectedDestination, required this.drawerWidth, required this.orderDetails ,required this.orderList}) : super(key: key);

  @override
  State<ViewOrderDetails> createState() => _ViewOrderDetailsState();
}

class _ViewOrderDetailsState extends State<ViewOrderDetails> {

  bool loading = false;
  bool showCustomerDetails = false;
  bool isVehicleSelected = false;

  late double width ;



  var wareHouseController=TextEditingController();
  var vendorSearchController = TextEditingController();
  final brandNameController=TextEditingController();
  var modelNameController = TextEditingController();
  var checkingController=TextEditingController();
  var variantController=TextEditingController();
  var salesInvoiceDate = TextEditingController();
  var subAmountTotal = TextEditingController();
  var subTaxTotal = TextEditingController();
  var subDiscountTotal = TextEditingController();
  final termsAndConditions=TextEditingController();
  bool termsAndConditionError=false;
  final salesInvoice=TextEditingController();
  final additionalCharges=TextEditingController();
  final grandTotalAmount =TextEditingController();
  // Validation
  int indexNumber=0;
  bool searchVendor=false;
  bool isBillToSelected=false;
  bool tableLineDataBool =false;
  bool searchVendorError=false;


  String invoicingType1 ="Select Type";
  List selectType2List =[];
  String invoiceType2 = "Select Type";

  get getBillTo {
    if(invoicingType1 == "Dealer"){
      if(invoiceType2 =="Floor plan"){
        return "(Bank)";
      }
    }
    return "";
  }

  get getDeliverTo {
    if(invoicingType1 == "Dealer"){
      if(invoiceType2 =="Floor plan"){
        return "Dealer";
      }
    }
    return "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchList =widget.orderList;
    selectedID = widget.orderDetails['orderId'];
    salesInvoiceDate.text=DateFormat('dd-MM-yyyy').format(DateTime.now());
    mapData(widget.orderDetails);
    getInitialData().whenComplete(() {
      // getAllVehicleVariant();
      fetchVendorsData();
      // fetchTaxData();
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role= prefs.getString("role")??"";
    userId= prefs.getString("userId")??"";
    managerId= prefs.getString("managerId")??"";
    orgId= prefs.getString("orgId")??"";
  }
  List vendorList = [];

  Map shipToData ={
    'Name':'',
    'city': '',
    'state': '',
    'street': '',
    'zipcode': '',

  };

  Map billToData ={
    'Name':'',
    'city': '',
    'state': '',
    'street': '',
    'zipcode': '',

  };
  int startVal=0;
  List vehicleList = [];
  List displayList=[];
  List selectedVehicles=[];
  List selectedVehiclesList = [];
  var units = <TextEditingController>[];
  var discountRupees = <TextEditingController>[];
  var discountPercentage = <TextEditingController>[];
  var tax = <TextEditingController>[];
  var lineAmount = <TextEditingController>[];
  List items=[];
  Map postDetails={};
  String role ='';
  String userId ='';
  String selectedID ="";
  String managerId ='';
  String orgId ='';
  List taxCodes=[];
  List taxPercentage =[];

  List searchList =[];

  final validationKey=GlobalKey<FormState>();
  final focusToController=FocusNode();
  List<String> generalIdMatch = [];
  String storeGeneralId="";
  bool checkBool=false;

  @override
  Widget build(BuildContext context) {
    width =MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child:
            Scaffold(
              backgroundColor: const Color(0xffF0F4F8),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: AppBar(
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Vehicle Order Details"),
                    //centerTitle: true,
                    // actions: [
                    //   const SizedBox(width: 20),
                    //   Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 100,height: 28,
                    //         child: OutlinedMButton(
                    //           text: 'Save',
                    //           buttonColor:mSaveButton ,
                    //           textColor: Colors.white,
                    //           borderColor: mSaveButton,
                    //           onTap: (){
                    //             funBool();
                    //             focusToController.requestFocus();
                    //             if(validationKey.currentState!.validate()){
                    //               // double tempTotal =0;
                    //               // try{
                    //               //   tempTotal = (double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text)+ double.parse(additionalCharges.text.isEmpty?"":additionalCharges.text));
                    //               // }
                    //               // catch(e){
                    //               //   tempTotal= double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text);
                    //               // }
                    //
                    //
                    //               postDetails ={
                    //                 "dealerCode": "string",
                    //                 "invDealer": "string",
                    //                 "invNotes": "string",
                    //                 "invType1": invoicingType1,
                    //                 "invType2": invoiceType2,
                    //                 "orderDate": "2024-09-25",
                    //                 "searchBIllToAddress": vendorData['city'] + vendorData['street'] +vendorData['state'] +vendorData['zipcode'],
                    //                 "searchBIllToName":vendorData['Name']??"",
                    //                 "searchDeliverToAddress": wareHouse['city'] + wareHouse['street'] +wareHouse['state'] +wareHouse['zipcode'],
                    //                 "searchDeliverToName": wareHouse['Name']??"",
                    //                 "vehiclelist": []
                    //               };
                    //               for (int i = 0; i < selectedVehiclesList.length; i++) {
                    //
                    //                 postDetails['vehiclelist'].add({
                    //                   "chassisCab": selectedVehiclesList[i]=="Yes"?true:false,
                    //                   "loc1Address": selectedVehiclesList[i]['location1']['details'],
                    //                   "loc1Name": selectedVehiclesList[i]['location1']['name'],
                    //                   "loc1Type": selectedVehiclesList[i]['location1']['type'],
                    //                   "loc2Address": "string",
                    //                   "loc2Name": "string",
                    //                   "loc2Type": selectedVehiclesList[i]['location2']['type'],
                    //                   "loc3Address": "string",
                    //                   "loc3Name": "string",
                    //                   "loc3Type": "string",
                    //                   "orderId": "string",
                    //                   "vehBodyBuilder": true,
                    //                   "vehBodyType": "string",
                    //                   "vehDeliveryLoc": 0,
                    //                   "vehiclMasterID": "string",
                    //                   "vehicleDescription": "string",
                    //                   "vehicleLineId": "string",
                    //                   "vehicleModel": "string",
                    //                   "vehicleQty": 0
                    //                 }
                    //                 );
                    //               }
                    //
                    //               // postEstimate(postDetails);
                    //             }
                    //           },
                    //
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   const SizedBox(width: 30),
                    // ],
                  ),
                ),
              ),
              body: CustomLoader(
                inAsyncCall: loading,
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 240,color: Colors.white,child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(height: 32,child: TextField(
                            decoration: InputDecoration(
                                hintText: "Search by ID",
                                contentPadding: const EdgeInsets.fromLTRB(8, 4, 2, 2),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4),borderSide: const BorderSide(
                                  color: mSaveButtonBorder, // Set your desired border color here
                                  width: 2.0,        // You can adjust the width of the border as needed
                                ),),),
                            onChanged: (value){
                              if(value.isEmpty){
                              setState(() {
                                searchList = widget.orderList;
                              });
                              }
                              else {
                                getOrderList(value);
                              }
                            },
                          ),),
                        ),

                        Expanded(
                          child: ListView.builder(
                            itemCount: searchList.length,
                            itemBuilder: (context, index) {
                            return Column(
                              children: [
                                const Divider(thickness: 1,height: 1),
                                SizedBox(height:60,
                                  child: VehicleButton(
                                    buttonColor:selectedID==searchList[index]['orderId']? mSaveButton:Colors.white,
                                    data: searchList[index],
                                    onTap: (){
                                      setState(() {
                                        selectedID=searchList[index]['orderId'];
                                        mapData(searchList[index]);
                                      });
                                    }, borderColor: Colors.white, textColor: selectedID==searchList[index]['orderId']? Colors.white :Colors.black,
                                  ),
                                ),
                                if(index == searchList.length-1)
                                  const Divider(thickness: 1,height: 1),

                              ],
                            );
                          },
                            shrinkWrap: true,
                          ),
                        )


                      ],
                    ),
                    ),
                    Expanded(flex: 5,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10,left: 48,bottom: 30,right: 68),
                          child: Form(
                            key:validationKey,
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                HeaderCard(width: width,selectedID :selectedID,orderDate: widget.orderDetails['orderDate']),
                                const SizedBox(height: 50,),
                                buildInvoiceCard(),

                                const SizedBox(height: 50,),
                                buildLineCard()
                                ,
                                const SizedBox(height: 50,),
                                buildDocuments(),

                                const SizedBox(height: 50,),
                                buildDealerNotes(),


                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  bool funBool() {
    if(selectedVehicles.isEmpty){
      setState(() {
        tableLineDataBool=true;
      });
      return false;
    }
    return true;
  }



  fetchVendorsData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_all_new_vendor';
    try {
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vendorList = value;
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

  fetchData() async {

    List list = [];
    // create a list of 3 objects from a fake json responsef
    for(int i=0;i<vendorList.length;i++){
      list.add( VendorModelAddress.fromJson({
        "label":vendorList[i]['company_name'],
        "value":vendorList[i]['company_name'],
        "city":vendorList[i]['payto_city'],
        "state":vendorList[i]['payto_state'],
        "zipcode":vendorList[i]['payto_zip'],
        "street":vendorList[i]['payto_address1']+", "+vendorList[i]['payto_address2'],
      }));
    }

    return list;
  }


  Widget buildInvoiceCard(){
    return Card(color: Colors.white,surfaceTintColor: Colors.white,elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:  EdgeInsets.only(left: 18.0,bottom: 8,top: 8),
            child: Text("Invoicing Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
          ),
          const Divider(color: mTextFieldBorder,height: 1),
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Invoicing Type
              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(top:15.0,bottom: 5,left: 18,right: 18),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(4)),
                        child:   LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return CustomPopupMenuButton(
                                decoration: customPopupDecoration(hintText:invoicingType1,onTap: () {
                                  setState(() {
                                    invoicingType1 = "Select Type";
                                    selectType2List =[];
                                  });
                                },),
                                // hintText: "ss",
                                //textController: customerTypeController,
                                childWidth: constraints.maxWidth,
                                offset: const Offset(1, 40),
                                tooltip: '',
                                itemBuilder:  (BuildContext context) {
                                  return ['Customer', "Dealer"].map((value) {
                                    return CustomPopupMenuItem(

                                      value: value,
                                      text:value,
                                      child: Container(),
                                    );
                                  }).toList();
                                },
                                onSelected: (v){
                                  setState(() {
                                    invoiceType2="Select Type";
                                    invoicingType1 = v.toString();
                                    if(v=="Customer"){
                                      selectType2List =["Bank","Cash"];
                                    }
                                    if(v=="Dealer"){
                                      selectType2List =["Floor plan","Direct"];
                                    }

                                  });

                                },
                                onCanceled: () {
                                },
                                hintText: '',
                                child: Container(),
                              );
                            }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:15.0,bottom: 5,left: 18,right: 18),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(4)),
                        child:   LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {

                              return CustomPopupMenuButton(
                                decoration: customPopupDecoration(hintText:invoiceType2,onTap: (){
                                  invoiceType2 = "Select Type";
                                }),
                                // hintText: "ss",
                                //textController: customerTypeController,
                                childWidth: constraints.maxWidth,
                                offset: const Offset(1, 40),
                                tooltip: '',
                                itemBuilder:  (BuildContext context) {
                                  return invoicingType1 ==""?[]:selectType2List.map((value) {
                                    return CustomPopupMenuItem(
                                      value: value,
                                      text:value,
                                      child: Container(),
                                    );
                                  }).toList();
                                },
                                onSelected: (v){
                                  setState(() {
                                    invoiceType2 = v.toString();
                                  });

                                },
                                onCanceled: () {
                                },
                                hintText: '',
                                child: Container(),
                              );
                            }
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const CustomVDivider(height: 190, width: 1, color: mTextFieldBorder),

              ///Bill to details
              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,top: 8,right: 8,bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2,top: 2),
                            child: Text("Bill to Details $getBillTo",style: const TextStyle(fontSize: 16)),
                          ),
                          if(showCustomerDetails==true)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showCustomerDetails=false;
                                    wareHouseController.clear();
                                  });
                                },
                              ),
                            )

                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    // if(showCustomerDetails==false)
                    //   const SizedBox(height: 30,),
                    // if(showCustomerDetails==false)
                    //   Center(
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 18.0,right: 18),
                    //       child: CustomTextFieldSearch(
                    //         onTapAdd: (){
                    //
                    //         },
                    //         validator: (value){
                    //           if(value==null || value.trim().isEmpty){
                    //             setState(() {
                    //               isBillToSelected=true;
                    //             });
                    //             return "Search $getBillTo Address";
                    //           }
                    //           return null;
                    //         },
                    //         showAdd: true,
                    //         decoration:textFieldVendorAndWarehouse(hintText: 'Search $getBillTo Address',error:isBillToSelected) ,
                    //         // decoration:textFieldWarehouseDecoration(hintText: 'Search Warehouse',error:searchWarehouse),
                    //         controller: wareHouseController,
                    //         future: fetchData,
                    //         getSelectedValue: (VendorModelAddress value) {
                    //           setState(() {
                    //             showCustomerDetails=true;
                    //             wareHouse ={
                    //               'Name':value.label,
                    //               'city': value.city,
                    //               'state': value.state,
                    //               'street': value.street,
                    //               'zipcode': value.zipcode,
                    //             };
                    //             isBillToSelected=false;
                    //           });
                    //         },
                    //
                    //       ),
                    //     ),
                    //   ),
                   // if(showCustomerDetails)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(billToData['Name']??"",style: const TextStyle(fontWeight: FontWeight.bold)),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child:  Text("Street")),
                                const Text(": "),
                                Expanded(child: Text("${billToData['street']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("City")),
                                const Text(": "),
                                Expanded(child: Text("${billToData['city']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("State")),
                                const Text(": "),
                                Expanded(child: Text("${billToData['state']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("ZipCode :")),
                                const Text(": "),
                                Expanded(child: Text("${billToData['zipcode']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const CustomVDivider(height: 190, width: 1, color: mTextFieldBorder),

              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,top: 8,right: 8,bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2,top: 2),
                            child: Text("Ship to Details $getBillTo",style: const TextStyle(fontSize: 16)),
                          ),
                          if(showCustomerDetails==true)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showCustomerDetails=false;
                                    wareHouseController.clear();
                                  });
                                },
                              ),
                            )

                        ],
                      ),
                    ),
                     const Divider(color: mTextFieldBorder,height: 1),
                    // if(showCustomerDetails==false)
                    //   const SizedBox(height: 30,),
                    // if(showCustomerDetails==false)
                    //   Center(
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 18.0,right: 18),
                    //       child: CustomTextFieldSearch(
                    //         onTapAdd: (){
                    //
                    //         },
                    //         validator: (value){
                    //           if(value==null || value.trim().isEmpty){
                    //             setState(() {
                    //               isBillToSelected=true;
                    //             });
                    //             return "Search $getBillTo Address";
                    //           }
                    //           return null;
                    //         },
                    //         showAdd: true,
                    //         decoration:textFieldVendorAndWarehouse(hintText: 'Search $getBillTo Address',error:isBillToSelected) ,
                    //         // decoration:textFieldWarehouseDecoration(hintText: 'Search Warehouse',error:searchWarehouse),
                    //         controller: wareHouseController,
                    //         future: fetchData,
                    //         getSelectedValue: (VendorModelAddress value) {
                    //           setState(() {
                    //             showCustomerDetails=true;
                    //             wareHouse ={
                    //               'Name':value.label,
                    //               'city': value.city,
                    //               'state': value.state,
                    //               'street': value.street,
                    //               'zipcode': value.zipcode,
                    //             };
                    //             isBillToSelected=false;
                    //           });
                    //         },
                    //
                    //       ),
                    //     ),
                    //   ),
                    // if(showCustomerDetails)



                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(shipToData['Name']??"",style: const TextStyle(fontWeight: FontWeight.bold)),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child:  Text("Street")),
                                const Text(": "),
                                Expanded(child: Text("${shipToData['street']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("City")),
                                const Text(": "),
                                Expanded(child: Text("${shipToData['city']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("State")),
                                const Text(": "),
                                Expanded(child: Text("${shipToData['state']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("ZipCode :")),
                                const Text(": "),
                                Expanded(child: Text("${shipToData['zipcode']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: mTextFieldBorder,height: 1),
          const Padding(
            padding:  EdgeInsets.only(left: 20.0,top: 8),
            child: Text("Notes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
          ),
          Container(
            height: 100,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0,left: 18,right: 18),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xd5f8f7f7),border: Border.all(color: mTextFieldBorder),borderRadius:BorderRadius.circular(8) ),
                      child:  TextField(readOnly: true,controller: TextEditingController(text:widget.orderDetails['invNotes'] ),decoration: InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.only(right: 5,top: 10,left: 5)),style: TextStyle(fontSize: 12),maxLines: 10,),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget buildLineCard() {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.white,),

        child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
          children: [

            ///-----------------------------Table Starts-------------------------

            Container(
              color: Colors.grey[100],
              height: 90,
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 14,),
                        Text('Vehicle Details',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text('SL No'))),
                            CustomVDivider(height: 45, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 4, child: Center(child: Text("Model"))),
                            CustomVDivider(height: 45, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Qty"))),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomVDivider(height: 90, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 14,),
                        Text('Vehicle required DSLB or Chassis Cab',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            Expanded(child: Center(child: Text("Chassis Cab"))),
                            CustomVDivider(height: 45, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Body Build"))),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomVDivider(height: 90, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 14,),
                        Text('Delivery',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            Expanded(flex: 3,child: Center(child: Text('Delivery Location'))),
                            CustomVDivider(height: 45, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 3, child: Center(child: Text("Bodybuilder"))),

                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: mTextFieldBorder,height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedVehiclesList.length,
              itemBuilder: (context, index) {
                return Container(color: Colors.white,
                  height: 71,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                Expanded(child: Center(child: Text('${index+1}'))),
                                const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                Expanded(flex: 4, child: lineText(selectedVehiclesList[index]['model'])),
                                const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                Expanded(child: Center(child: lineTextField(selectedVehiclesList[index]['qty'].toString(),index,
                                    onChanged: (v){
                                      setState(() {
                                        selectedVehiclesList[index]['qty'] =v;
                                      });
                                    }
                                ))),
                              ],
                            ),
                          ),
                          const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded( child:  Padding(
                                      padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(height: 24,width: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: mTextFieldBorder),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: LayoutBuilder(
                                                builder: (BuildContext context, BoxConstraints constraints) {
                                                  return CustomPopupMenuButton<String>(
                                                    hintText: '',
                                                    decoration: lineCustomPopupDecoration(hintText:  selectedVehiclesList[index]['chassisCab']),
                                                    childWidth: constraints.maxWidth,
                                                    offset: const Offset(1, 40),
                                                    itemBuilder:  (BuildContext context) {
                                                      return ['Yes','No'].map((String choice) {
                                                        return CustomPopupMenuItem<String>(
                                                            value: choice,
                                                            text: choice,
                                                            child: Container()
                                                        );
                                                      }).toList();
                                                    },

                                                    onSelected: (String value)  {
                                                      setState(() {
                                                        selectedVehiclesList[index]['chassisCab'] = value;
                                                      });
                                                    },
                                                    onCanceled: () {

                                                    },
                                                    child: Container(),
                                                  );
                                                }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),),
                                    const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                    Expanded( child:  Padding(
                                      padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                      child: Container(height: 24,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: mTextFieldBorder),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: LayoutBuilder(
                                            builder: (BuildContext context, BoxConstraints constraints) {
                                              return CustomPopupMenuButton<String>(
                                                hintText: '',
                                                decoration: lineCustomPopupDecoration(hintText:  selectedVehiclesList[index]['bodyBuildType']),
                                                childWidth: constraints.maxWidth,
                                                offset: const Offset(1, 40),
                                                itemBuilder:  (BuildContext context) {
                                                  return ["Dropside", "VAN body", "Tipper", "Tautliner", "Flat deck"].map((String choice) {
                                                    return CustomPopupMenuItem<String>(
                                                        value: choice,
                                                        text: choice,
                                                        child: Container()
                                                    );
                                                  }).toList();
                                                },

                                                onSelected: (String value)  {
                                                  setState(() {
                                                    selectedVehiclesList[index]['bodyBuildType'] = value;
                                                  });
                                                },
                                                onCanceled: () {

                                                },
                                                child: Container(),
                                              );
                                            }
                                        ),
                                      ),
                                    ),),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(child: SizedBox(width: 100,
                                          child: lineTextField(selectedVehiclesList[index]['noOfDeliveryLoc'].toString(),index,
                                              onChanged: (v){
                                                setState(() {
                                                  selectedVehiclesList[index]['noOfDeliveryLoc'] =v;
                                                });
                                              }
                                          ),
                                        )),
                                      ],
                                    )),
                                    const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                    Expanded( child:  Padding(
                                      padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(height: 24,width: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: mTextFieldBorder),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: LayoutBuilder(
                                                builder: (BuildContext context, BoxConstraints constraints) {
                                                  return CustomPopupMenuButton<String>(
                                                    hintText: '',
                                                    decoration: lineCustomPopupDecoration(hintText:  selectedVehiclesList[index]['bodybuilder']),
                                                    childWidth: constraints.maxWidth,
                                                    offset: const Offset(1, 40),
                                                    itemBuilder:  (BuildContext context) {
                                                      return ["Yes","No"].map((String choice) {
                                                        return CustomPopupMenuItem<String>(
                                                            value: choice,
                                                            text: choice,
                                                            child: Container()
                                                        );
                                                      }).toList();
                                                    },

                                                    onSelected: (String value)  {
                                                      setState(() {
                                                        selectedVehiclesList[index]['bodybuilder'] = value;
                                                      });
                                                    },
                                                    onCanceled: () {

                                                    },
                                                    child: Container(),
                                                  );
                                                }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: mTextFieldBorder,height: 1),
                    ],
                  ),
                );
              },),


            const Divider(height: 1, color: mTextFieldBorder,),


          ],
        ),
      ),
    );
  }

  Widget buildDealerNotes(){
    return Card(color: Colors.white,surfaceTintColor: Colors.white,elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
        children: [

          const Padding(
            padding:  EdgeInsets.only(left: 18.0,bottom: 8,top: 8),
            child: Text("Dealer Notes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
          ),
          const Divider(color: mTextFieldBorder,height: 1),
          const SizedBox(height: 20,),
          SizedBox(
            height: 140,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0,left: 15,right: 15),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(8),color: const Color(0xd5f8f7f7),),
                      child:  TextField(readOnly: true,controller: TextEditingController(text: widget.orderDetails['dealerNotes']),decoration: InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.only(right: 5,top: 10,left: 5)),style: TextStyle(fontSize: 14),maxLines: 10,),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }



  Widget showDialogBox(){
    return Dialog(
      backgroundColor: Colors.transparent,
      child:StatefulBuilder(
          builder: (context,  setState) {
            return SizedBox(
              // width: MediaQuery.of(context).size.width/1.5,
              //height: MediaQuery.of(context).size.height/1.1,
              child: Stack(
                children: [
                  Container(
                    width: 950,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(top: 13.0, right: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0,right:20,bottom: 10,top:10),
                      child: Card(surfaceTintColor: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            ///search Fields
                            Row(
                              children: [
                                const SizedBox(width: 10,),
                                SizedBox(width: 250,height: 35,
                                  child: TextFormField(
                                    controller: brandNameController,
                                    decoration: textFieldBrandNameField(hintText: 'Search Brand',
                                        onTap:()async{
                                          // if(brandNameController.text.isEmpty || brandNameController.text==""){
                                          //   await getAllVehicleVariant().whenComplete(() => setState((){}));
                                          // }
                                        }
                                    ),
                                    onChanged: (value) async{
                                      if(value.isNotEmpty || value!=""){
                                        // await fetchBrandName(brandNameController.text).whenComplete(()=>setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        // await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    decoration:  textFieldModelNameField(hintText: 'Search Model',onTap: ()async{
                                      if(modelNameController.text.isEmpty || modelNameController.text==""){
                                        // await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    }),
                                    controller: modelNameController,
                                    onChanged: (value)async {
                                      if(value.isNotEmpty || value!=""){
                                        // await  fetchModelName(modelNameController.text).whenComplete(() =>setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        // await getAllVehicleVariant().whenComplete(()=> setState((){}));
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(width: 10,),
                                SizedBox(width: 250,
                                  child: TextFormField(
                                    controller: variantController,
                                    decoration: textFieldVariantNameField(hintText: 'Search Variant',onTap:()async{
                                      if(variantController.text.isEmpty || variantController.text==""){
                                        // await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    }),
                                    onChanged: (value) async{
                                      if(value.isNotEmpty || value!=""){
                                        // await fetchVariantName(variantController.text).whenComplete(() => setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        // await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            ///Table Header
                            Container(
                              height: 40,
                              color: Colors.grey[200],
                              child: const Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text("Brand")),
                                    Expanded(child: Text("Model")),
                                    Expanded(child: Text("Variant")),
                                    Expanded(child: Text("On road price")),
                                    Expanded(child: Text("Year of Manufacture")),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4,),
                            Expanded(
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: displayList.length+1,
                                    itemBuilder: (context,int i){
                                      if(i<displayList.length){
                                        return   Column(
                                          children: [
                                            MaterialButton(
                                              hoverColor: mHoverColor,
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context,displayList[i]);
                                                  storeGeneralId=displayList[i]["excel_id"];
                                                  for(var tempValue in generalIdMatch){
                                                    if(tempValue == storeGeneralId){
                                                      setState((){
                                                        checkBool=true;
                                                      });
                                                    }
                                                  }
                                                });

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 18.0),
                                                child: SizedBox(height: 30,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['make']??""),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(
                                                              displayList[i]['model']??""),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['varient']??''),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['on_road_price'].toString()),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['year_of_manufacture']??""),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                          ],
                                        );
                                      }
                                      else{
                                        return Column(children: [
                                          Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                          Row(mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("${startVal+15>vehicleList.length?vehicleList.length:startVal+1}-${startVal+15>vehicleList.length?vehicleList.length:startVal+15} of ${vehicleList.length}",style: const TextStyle(color: Colors.grey)),
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
                                                      displayList=[];
                                                      startVal = startVal-15;
                                                      for(int i=startVal;i<startVal+15;i++){
                                                        try{
                                                          setState(() {
                                                            displayList.add(vehicleList[i]);
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
                                                    setState(() {
                                                      if(vehicleList.length>startVal+15){
                                                        displayList=[];
                                                        startVal=startVal+15;
                                                        for(int i=startVal;i<startVal+15;i++){
                                                          try{
                                                            setState(() {
                                                              displayList.add(vehicleList[i]);
                                                            });
                                                          }
                                                          catch(e){
                                                            log("Expected Type Error $e ");
                                                            log(e.toString());
                                                          }

                                                        }
                                                      }
                                                    });


                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                            ],
                                          ),
                                          Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                        ],);
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: InkWell(
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromRGBO(204, 204, 204, 1),
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
          }
      ),
    );
  }


  textFieldDecoration({required String hintText, required bool error}) {
    return  InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldVendorAndWarehouse({required String hintText, required bool error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.search,size: 18),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:  OutlineInputBorder(borderSide: BorderSide(color:error? Colors.red:mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldBrandNameField( {required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      suffixIcon:  brandNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          brandNameController.clear();
          onTap!();
        });
      },
          child: const Icon(Icons.close,size: 18,)
      ),

      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldModelNameField({required String hintText, bool? error,Function ? onTap}) {
    return  InputDecoration(
      suffixIcon:  modelNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          modelNameController.clear();
          onTap!();
        });
      },
          child: const Icon(Icons.close,size: 18,)
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldVariantNameField({required String hintText, bool? error,Function ? onTap}) {
    return  InputDecoration(
      suffixIcon:  variantController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        variantController.clear();
        onTap!();
      },
          child: const Icon(Icons.close,size: 18,)
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }

  textFieldSalesInvoice({required String hintText, bool? error}) {
    return  InputDecoration(border: InputBorder.none,
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(10, 00, 0, 15),
    );
  }
  textFieldSalesInvoiceDate({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.calendar_month_rounded,size: 12,color: Colors.grey,),
      border: InputBorder.none,
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(10, 00, 0, 0),
    );
  }

  Widget lineText(String text) {
    return Container(
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            border: Border.all(color: mTextFieldBorder),
            borderRadius: BorderRadius.circular(4)),
        child: Center(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Text(style: const TextStyle(fontSize: 12),
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
            )));
  }

  Widget lineTextField(text, int index, {required ValueChanged onChanged}) {
    var t1 = TextEditingController(text: '$text');
    t1.selection = TextSelection.fromPosition(TextPosition(offset: t1.text.length));
    return Container(
      height: 24,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child:  Center(
        child: TextField(
            textAlign: TextAlign.center,controller: t1,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 2,top: 4,bottom: 8,right: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
            ),
            style: const TextStyle(fontSize: 13, overflow: TextOverflow.visible),
            onChanged:onChanged
        ),
      ),
    );
  }

  customPopupDecoration({required String hintText , GestureTapCallback? onTap}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      enabledBorder:  const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      suffixIcon: InkWell(onTap: onTap,child:  Icon(hintText=="Select Type" ? Icons.arrow_drop_down_circle_sharp : Icons.clear, color: mSaveButton, size: 14)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black,),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 0, 0, 10),

    );

  }
  lineCustomPopupDecoration({required String hintText}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      enabledBorder:  const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 12),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 12, color: Colors.black,),
      contentPadding: const EdgeInsets.only(left: 18,top: 10,bottom: 20),

    );

  }

 Widget buildDocuments() {
    return Card(elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.white,),
        child: Column(
          children: [
            Container(
              color: Colors.grey[100],
              height: 45,
              child: const Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text('SN',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text('Vehicle Details',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 3,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text('Vehicle',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text('VIN Number',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text('Amount',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text('Status',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text('Documnets',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: mTextFieldBorder,height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedVehiclesList.length,
              itemBuilder: (context, index) {
                return Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(color: Colors.white,
                      height: 45,
                      child:  Row(
                        children: [
                          Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 5,),
                                Text('${index+1}'),
                                const SizedBox(height: 5,),
                              ],
                            ),
                          ),
                          const CustomVDivider(height: 90, width: 1, color: mTextFieldBorder),
                          Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 5,),
                                Text('PRIMA 4856$index',style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 5,),
                              ],
                            ),
                          ),
                          const CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                          const Expanded(flex: 3,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10,0,4,0),
                                  child: Text('VEHICLE',style: TextStyle(fontSize: 12)),
                                ),
                                SizedBox(height: 5,),
                              ],
                            ),
                          ),
                          const CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                          const Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),
                                Text('VIN Number',style: TextStyle(fontSize: 12)),
                                SizedBox(height: 5,),
                              ],
                            ),
                          ),
                          const CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                          const Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),
                                Text('285677',style: TextStyle(fontSize: 12)),
                                SizedBox(height: 5,),
                              ],
                            ),
                          ),
                          const CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                          const Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),
                                Text('-',style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5,),
                              ],
                            ),
                          ),
                          const CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                          const Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),
                                Icon(Icons.file_present,color: Colors.blue),
                                SizedBox(height: 5,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                  ],
                );
              },),


            const Divider(height: 1, color: mTextFieldBorder,),
          ],
        ),
      ),
    );
 }

  void mapData(Map<dynamic, dynamic> orderDetails) {
    selectedVehiclesList =[];
    invoicingType1 =orderDetails['invType1'];
    invoiceType2 =orderDetails['invType2'];
    billToData['Name'] = orderDetails['searchBIllToName'];
    billToData['city'] = orderDetails['billTOCity'];
    billToData['state'] = orderDetails['billToState'];
    billToData['street'] = orderDetails['billToStreet'];
    billToData['zipcode'] = orderDetails['billToZipcode'].toString();

    shipToData['Name'] = orderDetails['searchDeliverToName'];
    shipToData['city'] = orderDetails['shipToCity'];
    shipToData['state'] = orderDetails['shipToState'];
    shipToData['street'] = orderDetails['shipToStreet'];
    shipToData['zipcode'] = orderDetails['shipToZipCode'].toString();

    for(int i=0;i<orderDetails['vehiclelist'].length;i++){
      selectedVehiclesList.add({
        "model":orderDetails['vehiclelist'][i]['vehicleModel'],
        "qty": orderDetails['vehiclelist'][i]['vehicleQty'],
        "chassisCab":orderDetails['vehiclelist'][i]['chassisCab']==true? "Yes":"No",
        "bodyBuildType": orderDetails['vehiclelist'][i]['vehBodyType'],
        "noOfDeliveryLoc": orderDetails['vehiclelist'][i]['vehDeliveryLoc'],
        "bodybuilder": orderDetails['vehiclelist'][i]['vehBodyBuilder']==true? "Yes":"No",
        "location1": {"type":  orderDetails['vehiclelist'][i]['loc1Type'], "name": orderDetails['vehiclelist'][i]['loc1Name'], "details": orderDetails['vehiclelist'][i]['loc1Address']},
        "location2": {"type":  orderDetails['vehiclelist'][i]['loc2Type'], "name": orderDetails['vehiclelist'][i]['loc2Name'], "details": orderDetails['vehiclelist'][i]['loc2Address']},
        "location3": {"type":  orderDetails['vehiclelist'][i]['loc3Type'], "name": orderDetails['vehiclelist'][i]['loc3Name'], "details": orderDetails['vehiclelist'][i]['loc3Address']},
        "vehicleMasterId": "EXC_20879"
      });
    }


  }
  Future getOrderList(String value)async{

    dynamic response;
    String url='https://hiqbfxz5ug.execute-api.ap-south-1.amazonaws.com/stage1/api/vehicleorder/search_by_vehicleOrderId/$value';

    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            searchList=response;
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
}

class VendorModelAddress {
  String label;
  String city;
  String state;
  String zipcode;
  String street;
  dynamic value;
  VendorModelAddress({
    required this.label,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.street,
    this.value
  });

  factory VendorModelAddress.fromJson(Map<String, dynamic> json) {
    return VendorModelAddress(
      label: json['label'],
      value: json['value'],
      city: json['city'],
      state: json['state'],
      street: json['street'],
      zipcode: json['zipcode'],

    );
  }
}



class HeaderCard extends StatefulWidget {
  final double width;
  final String selectedID;
  final String? orderDate;
  const HeaderCard({Key? key, required this.width, required this.selectedID, this.orderDate}) : super(key: key);

  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {

  DateTime date = DateTime.now(); // Example: current date
  String formattedDate = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate = DateFormat('dd-MMM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.white,surfaceTintColor: Colors.white,elevation:4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0,bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                const Padding(
                  padding:  EdgeInsets.only(top: 8,left: 6),
                  child: Text("Dealer Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
                const SizedBox(height: 5,),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 250,height: 28,alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("ACsd XYZ",),
                  ),
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                const Padding(
                  padding:  EdgeInsets.only(top: 8,left: 6),
                  child: Text("Dealer Code",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
                const SizedBox(height: 5,),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 150,height: 28,alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text("A13389",),
                  ),
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                const Padding(
                  padding:  EdgeInsets.only(top: 8,left: 6),
                  child: Text("Order Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
                const SizedBox(height: 5,),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 150,height: 28,alignment: Alignment.centerLeft,
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(widget.selectedID,),
                  ),
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8,right: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                const Padding(
                  padding:  EdgeInsets.only(top: 8,left: 6),
                  child: Text("Order Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
                const SizedBox(height: 5,),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 150,height: 28,alignment: Alignment.centerLeft,
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(widget.orderDate ??formattedDate),
                  ),
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

