


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

class CreatePartOrder extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CreatePartOrder({Key? key,  required this.selectedDestination, required this.drawerWidth }) : super(key: key);

  @override
  State<CreatePartOrder> createState() => _CreatePartOrderState();
}

class _CreatePartOrderState extends State<CreatePartOrder> {

  bool loading = false;
  bool showVendorDetails = false;
  bool showWareHouseDetails = false;
  bool isVehicleSelected = false;

  late double width ;



  var wareHouseController=TextEditingController();
  var vendorSearchController = TextEditingController();
  final brandNameController=TextEditingController();
  var modelNameController = TextEditingController();
  var variantController=TextEditingController();
  var salesInvoiceDate = TextEditingController();
  var subAmountTotal = TextEditingController();
  var subTaxTotal = TextEditingController();
  var subDiscountTotal = TextEditingController();
  final termsAndConditions=TextEditingController();
  final salesInvoice=TextEditingController();
  final additionalCharges=TextEditingController();
  bool notesFromDealerError=false;
  // Tax Codes.
  List taxCodes=[];
  List taxPercentage=[];
  Future fetchTaxData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/tax/get_all_tax';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            taxCodes = response;
            if(taxCodes.isNotEmpty){
              for(int i=0;i<taxCodes.length;i++){
                taxPercentage.add(taxCodes[i]['tax_total']);
              }
              // print('------taxCodes----');
              // print(taxPercentage);
            }
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }
  final focusDealerNotes=FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salesInvoiceDate.text=DateFormat('dd-MM-yyyy').format(DateTime.now());
    getInitialData().whenComplete(() {
      getPartsMaster();
      fetchVendorsData();
      fetchTaxData();
    });
  }
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
  List vendorList = [];

  Map vendorData ={
    'Name':'',
    'city': '',
    'state': '',
    'street': '',
    'zipcode': '',

  };

  Map wareHouse ={
    'Name':'',
    'city': '',
    'state': '',
    'street': '',
    'zipcode': '',

  };

  List partsList = [];
  List displayList=[];
  int startVal=0;
  List selectedVehicle=[];

  var units = <TextEditingController>[];
  var discountRupees = <TextEditingController>[];
  var discountPercentage = <TextEditingController>[];
  var tax = <TextEditingController>[];
  var lineAmount = <TextEditingController>[];
  List items=[];
  Map postDetails={};
  // Error Validation.
  int indexNumber=0;
  bool searchVendor=false;
  bool searchWarehouse=false;
  bool tableLineDataBool=false;
  final formValidation=GlobalKey<FormState>();
  List<String> generalId=[];
  String storeId="";
  bool matchVehicleId=false;

  bool checkLineItems(){
    if(selectedVehicle.isEmpty){
      setState(() {
        tableLineDataBool=true;
      });
      return false;
    }
    return true;
  }
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
                preferredSize: const Size.fromHeight(88.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: AppBar(
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Create New Parts Purchase Order"),
                    actions: [
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,height: 28,
                            child: OutlinedMButton(
                              text: 'Save',
                              buttonColor:mSaveButton ,
                              textColor: Colors.white,
                              borderColor: mSaveButton,
                              onTap: (){
                                checkLineItems();
                                focusDealerNotes.requestFocus();
                                if(formValidation.currentState!.validate() && checkLineItems()){
                                  double tempTotal =0;
                                  try{
                                    tempTotal = (double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text) + double.parse(additionalCharges.text.isEmpty?"":additionalCharges.text));
                                  }
                                  catch (e){
                                    tempTotal = double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text);
                                  }

                                  postDetails= {
                                    "additionalCharges": additionalCharges.text,
                                    "address": "string",
                                    "billAddressCity": vendorData['city']??"",
                                    "billAddressName": vendorData['Name']??"",
                                    "billAddressState": vendorData['state']??"",
                                    "billAddressStreet": vendorData['street']??"",
                                    "billAddressZipcode": vendorData['zipcode']??"",
                                    "serviceDueDate": "string",
                                    "serviceInvoice": salesInvoice.text,
                                    "serviceInvoiceDate": salesInvoiceDate.text,
                                    "shipAddressCity": wareHouse['city']??"",
                                    "shipAddressName": wareHouse['Name']??"",
                                    "shipAddressState": wareHouse['state']??"",
                                    "shipAddressStreet": wareHouse['street']??"",
                                    "shipAddressZipcode": wareHouse['zipcode']??"",
                                    "subTotalAmount": subAmountTotal.text.isEmpty?0 :subAmountTotal.text,
                                    "subTotalDiscount": subDiscountTotal.text.isEmpty?0:subDiscountTotal.text,
                                    "subTotalTax": subTaxTotal.text.isEmpty?0:subTaxTotal.text,
                                    "termsConditions": termsAndConditions.text,
                                    "total": tempTotal.toString(),
                                    "totalTaxableAmount": subAmountTotal.text.isEmpty?0 :subAmountTotal.text,
                                    "status": "In-review",
                                    "comment": "",
                                    "freight_amount":additionalCharges.text,
                                    "manager_id": managerId,
                                    "userid": userId,
                                    "org_id": orgId,
                                    "items": [

                                    ]
                                  };
                                  for (int i = 0; i < selectedVehicle.length; i++) {
                                    postDetails['items'].add(
                                        {
                                          "amount": lineAmount[i].text,
                                          "discount": discountPercentage[i].text,
                                          "itemsService": selectedVehicle[i]['name']+" "+selectedVehicle[i]['description'],
                                          "priceItem": selectedVehicle[i]['selling_price']??"",
                                          "quantity": units[i].text,
                                          "tax": tax[i].text,
                                          "newitem_id": selectedVehicle[i]['newitem_id']??"",
                                        }
                                    );

                                  }
                                  postEstimate(postDetails);
                                }

                              },

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ),
              body: CustomLoader(
                inAsyncCall: loading,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,left: 68,bottom: 30,right: 68),
                    child: Form(
                      key:formValidation,
                      child: Column(
                        children: [
                          buildHeaderCard(),
                          const SizedBox(height: 10,),
                          buildContentCard(),

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


  Widget buildHeaderCard(){
    return  Card(color: Colors.white,surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///Header Details
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Address",style: TextStyle(fontSize: 18)),
                const SizedBox(height: 5,),
                SizedBox(
                  width: width/2.8,
                  child: const Text("Ikyam Solutions Private Limited #742, RJ Villa, Cross, 8th A Main Rd, Koramangala 4th Block, Koramangala, Bengaluru, Karnataka 560034",maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.grey)),
                ),
                const Text("9087877767",style: TextStyle(fontSize: 14,color: Colors.grey))

              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 42,
                  child: Icon(Icons.car_rental,color: Color(0xffCCBA13),size: 90),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }




  Widget buildContentCard(){
    return Card(color: Colors.white,surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Bill to Details
              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,top: 8,right: 8,bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2,top: 2),
                            child: Text("Bill to Address"),
                          ),
                          if(showVendorDetails==true)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showVendorDetails=false;
                                    vendorSearchController.clear();
                                  });
                                },
                              ),
                            )

                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    if(showVendorDetails==false)
                      const SizedBox(height: 30,),
                    if(showVendorDetails==false)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: CustomTextFieldSearch(
                            validator: (value){
                              if(value==null || value.trim().isEmpty){
                                setState(() {
                                  searchVendor=true;
                                });
                                return "Search Vendor Address";
                              }
                              return null;

                            },
                            showAdd: false,
                            decoration:decorationVendorAndWarehouse(hintText: 'Search Vendor', error: searchVendor) ,
                            controller: vendorSearchController,
                            future: fetchData,
                            getSelectedValue: (VendorModelAddress value) {
                              setState(() {
                                showVendorDetails=true;
                                vendorData ={
                                  'Name':value.label,
                                  'city': value.city,
                                  'state': value.state,
                                  'street': value.street,
                                  'zipcode': value.zipcode,
                                };
                                searchVendor=false;
                              });
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height:5),
                    if(showVendorDetails)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vendorData['Name']??"",style: const TextStyle(fontWeight: FontWeight.bold)),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child:  Text("Street")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['street']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("City")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['city']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("State")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['state']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("ZipCode :")),
                                const Text(": "),
                                Expanded(child: Text("${vendorData['zipcode']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const CustomVDivider(height: 220, width: 1, color: mTextFieldBorder),

              ///Ship to Details
              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0,top: 8,right: 8,bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2,top: 2),
                            child: Text("Ship to Address"),
                          ),
                          if(showWareHouseDetails==true)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showWareHouseDetails=false;
                                    wareHouseController.clear();
                                  });
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    if(showWareHouseDetails==false)
                      const SizedBox(height: 30,),
                    if(showWareHouseDetails==false)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: CustomTextFieldSearch(
                            validator: (value){
                              if(value==null || value.trim().isEmpty){
                                setState(() {
                                  searchWarehouse=true;
                                });
                                return "Search Warehouse Address";
                              }
                              return null;
                            },
                            showAdd: false,
                            decoration:decorationVendorAndWarehouse(hintText: 'Search Warehouse', error: searchWarehouse),
                            controller: wareHouseController,
                            future: fetchData,
                            getSelectedValue: (VendorModelAddress value) {
                              setState(() {
                                showWareHouseDetails=true;
                                wareHouse ={
                                  'Name':value.label,
                                  'city': value.city,
                                  'state': value.state,
                                  'street': value.street,
                                  'zipcode': value.zipcode,
                                };
                                searchWarehouse=false;
                              });
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 5,),
                    if(showWareHouseDetails)
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(wareHouse['Name']??"",style: const TextStyle(fontWeight: FontWeight.bold)),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child:  Text("Street")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['street']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("City")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['city']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("State")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['state']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("ZipCode :")),
                                const Text(": "),
                                Expanded(child: Text("${wareHouse['zipcode']??""}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const CustomVDivider(height: 220, width: 1, color: mTextFieldBorder),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children:  [
                      Container(
                        height: 200,
                        width: 400,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Sales Invoice Date'),
                                        const SizedBox(height: 10,),
                                        Container(
                                          width: 140,
                                          height: 32,
                                          color: Colors.grey[200],
                                          child: TextFormField(showCursor: false,
                                            controller: salesInvoiceDate,
                                            onTap: ()async{
                                              DateTime? pickedDate=await showDatePicker(context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1999),
                                                  lastDate: DateTime.now()

                                              );
                                              if(pickedDate!=null){
                                                String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
                                                setState(() {
                                                  salesInvoiceDate.text=formattedDate;
                                                });
                                              }
                                              else{
                                                log('Date not selected');
                                              }
                                            },
                                            decoration: textFieldSalesInvoiceDate(hintText: 'Invoice Date'),
                                          ),
                                        )
                                      ],)
                                  ]),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: mTextFieldBorder,height: 1),
          const SizedBox(height: 18,),
          buildLineCard(),
        ],
      ),
    );
  }

  Widget buildLineCard(){
    return SizedBox(

      child: Column(
        children: [

          ///-----------------------------Table Starts-------------------------
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18,right: 18),
            child: Container(color: const Color(0xffF3F3F3),
              height: 34,
              child: const Row(
                children:  [
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text('SL No'))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 4,child: Center(child: Text("Items/Service"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Qty"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Price/Item"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Discount"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Tax %"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Amount"))),
                  SizedBox(width: 30,height: 30,),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                ],
              ),
            ),
          ),
          if(selectedVehicle.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 18,right: 18),
              child: Divider(height: 1,color: mTextFieldBorder,),
            ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedVehicle.length,
            itemBuilder: (context, index) {
              //print('----inside list view builder--------');
              //print(selectedVehicles);

              double tempTax =0;
              double tempLineData=0;
              double tempDiscount=0;

              try{indexNumber = index+1;

                lineAmount[index].text=(double.parse(selectedVehicle[index]['selling_price'].toString())* (double.parse(units[index].text))).toString();
                if(discountPercentage[index].text!='0'||discountPercentage[index].text!=''||discountPercentage[index].text.isNotEmpty)
                {
                  tempDiscount = ((double.parse(discountPercentage[index].text)/100) *  double.parse( lineAmount[index].text));
                  tempLineData =(double.parse(lineAmount[index].text)-tempDiscount);

                  tempTax = ((double.parse(tax[index].text)/100) *  double.parse( lineAmount[index].text));
                  lineAmount[index].text =(tempLineData+tempTax).toStringAsFixed(1);
                }
              }
              catch (e){
                log(e.toString());
              }
              if(index==0){
                subAmountTotal.text='0';
                subTaxTotal.text='0';
                subDiscountTotal.text='0';
                subTaxTotal.text= (double.parse(subTaxTotal.text.toString())+ tempTax).toStringAsFixed(1);
                subDiscountTotal.text= (double.parse(subDiscountTotal.text.toString())+ tempDiscount).toStringAsFixed(1);
                subAmountTotal.text = (double.parse(subAmountTotal.text.toString())+ double.parse( lineAmount[index].text)).toStringAsFixed(1);
              }else {
                subDiscountTotal.text= (double.parse(subDiscountTotal.text.toString())+ tempDiscount).toStringAsFixed(1);
                subTaxTotal.text= (double.parse(subTaxTotal.text.toString())+ tempTax).toStringAsFixed(1);
                subAmountTotal.text = (double.parse(subAmountTotal.text.toString())+ double.parse( lineAmount[index].text)).toStringAsFixed(1);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18,right: 18),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children:  [
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Text('${index+1}'))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(flex: 4,child: Center(child: Text("${selectedVehicle[index]['name']} - ${selectedVehicle[index]['description']} "))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                                decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                                height: 32,
                                child: TextField(
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  controller: units[index],
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: 12,right: 8,top: 2),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent))
                                  ),

                                  onChanged: (v) {
                                    setState(() {
                                      subAmountTotal.text=subAmountTotal.text;
                                      discountPercentage[index].text='0';
                                    });
                                  },
                                )),
                          )),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Text("${selectedVehicle[index]['selling_price']}"))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child:  Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child: TextField(
                                controller: discountPercentage[index],
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                    hintText: "%",
                                    contentPadding: EdgeInsets.only(bottom: 12,right: 8,top: 2),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent))
                                ),
                                onChanged: (v) {
                                  double tempValue=0.0;
                                  setState(() {

                                  });
                                  if(v.isNotEmpty || v!=""){
                                    try{
                                      tempValue=double.parse(v.toString());
                                      if(tempValue>100){
                                        discountPercentage[index].clear();
                                      }
                                    }
                                    catch(e){
                                      discountPercentage[index].clear();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child:
                            Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child:LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  return CustomPopupMenuButton(childHeight: 200,
                                    elevation: 4,
                                    decoration: InputDecoration(
                                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
                                      hintText: tax[index].text.isEmpty || tax[index].text == '' ? "Tax" : tax[index].text,
                                      contentPadding: const EdgeInsets.only(bottom: 15, right: 8),
                                      border: InputBorder.none,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                      ),
                                    ),
                                    hintText: '',
                                    childWidth: constraints.maxWidth,
                                    textAlign: TextAlign.right,
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide(color: mTextFieldBorder),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    offset: const Offset(1, 40),
                                    tooltip: '',
                                    itemBuilder: (BuildContext context) {
                                      return taxPercentage.map((value) {
                                        // print('-----values -----');
                                        // print(value);
                                        return CustomPopupMenuItem(
                                          textStyle: const TextStyle(color: Colors.black),
                                          textAlign: MainAxisAlignment.end,
                                          value: value.toString(),
                                          text: value.toString(),
                                          child: Container(),
                                        );
                                      }).toList();
                                    },
                                    onSelected: (String value) {
                                      // print('--------what it is getting ------------');
                                      // print(value);
                                      setState(() {
                                        tax[index].text = value;
                                        // print('-----assigned Value-----');
                                        // print(tax[index].text);
                                      });
                                    },
                                    onCanceled: () {},
                                    child: Container(),
                                  );
                                },
                              ),
                            ),
                          ),)),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child: TextField(
                                controller: lineAmount[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                    hintText: 'Total amount',
                                    contentPadding: EdgeInsets.only(bottom: 12,top: 2),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent))
                                ),
                                onChanged: (v) {},
                              ),
                            ),
                          ),)),
                          InkWell(onTap: (){
                            setState(() {
                              for(int i=0;i<indexNumber.bitLength;i++){
                                if(i==0){
                                  setState(() {
                                    tableLineDataBool=true;
                                  });
                                }
                                else{
                                  setState(() {
                                    tableLineDataBool=false;
                                  });
                                }
                              }
                              selectedVehicle.removeAt(index);
                              units.removeAt(index);
                              discountRupees.removeAt(index);
                              discountPercentage.removeAt(index);
                              tax.removeAt(index);
                              lineAmount.removeAt(index);

                            });
                          },hoverColor: mHoverColor,child: const SizedBox(width: 30,height: 30,child: Center(child: Icon(Icons.delete,color: Colors.red,size: 18,)))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18,right: 18),
                    child: Divider(height: 1,color: mTextFieldBorder,),
                  )
                ],
              );


            },),
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder,),
          ),

          const SizedBox(height: 40,),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: SizedBox(
                  height: 38,
                  child: Row(
                    children:  [
                      const Expanded(child: Center(child:Text(""))),
                      Expanded(
                          flex: 4,
                          child: Center(
                              child: OutlinedMButton(
                                text: "+ Add Item/ Service",
                                borderColor:tableLineDataBool?const Color(0xffB2261E): mSaveButton,
                               // borderColor: if(tableLineDataBool),
                                textColor: mSaveButton,
                                onTap: () {
                                  if(displayList.isNotEmpty){
                                    tableLineDataBool=false;
                                  }
                                  brandNameController.clear();
                                  modelNameController.clear();
                                  variantController.clear();
                                 // displayList=partsList;
                                  showDialog(
                                    context: context,
                                    builder: (context) => showDialogBox(),
                                  ).then((value) {
                                    if(value!=null){
                                      setState(() {
                                        if(matchVehicleId){
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              backgroundColor: Colors.transparent,
                                              child: StatefulBuilder(
                                                builder: (context, setState) {
                                                  return SizedBox(
                                                    width: 300,
                                                    height: 220,
                                                    child: Stack(children: [
                                                      Container(
                                                        decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(5)),
                                                        margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(15),
                                                          child: Container(
                                                            decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder,width: 1)),
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
                                                                const Column(
                                                                  children:  [
                                                                    Center(
                                                                        child: Text(
                                                                          'Part Already Added',
                                                                          style: TextStyle(
                                                                              color: Colors.indigo,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15),
                                                                        )),
                                                                    SizedBox(height:5),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 60,
                                                                      height: 30,
                                                                      child: OutlinedMButton(
                                                                        onTap: (){
                                                                          Navigator.of(context).pop();
                                                                          matchVehicleId=false;
                                                                        },
                                                                        text: 'Ok',
                                                                        borderColor: mSaveButton,
                                                                        textColor:mSaveButton,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
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
                                            ),
                                          );
                                        }
                                        else{
                                          isVehicleSelected=true;
                                          units.add(TextEditingController(text: '1'));
                                          discountRupees.add(TextEditingController(text: '0'));
                                          discountPercentage.add(TextEditingController(text: '0'));
                                          tax.add(TextEditingController(text: '0'));
                                          lineAmount.add(TextEditingController());
                                          subAmountTotal.text='0';
                                          selectedVehicle.add(value);
                                        }
                                      });
                                    }
                                  });


                                    for(int i=0;i<selectedVehicle.length;i++){
                                      generalId.add(selectedVehicle[i]["newitem_id"]);
                                    }


                                },
                              ))),
                      const Expanded(flex: 5,child: Center(child: Text(""),))
                    ],
                  ),
                ),
              ),
                const SizedBox(height: 5,),
              if(tableLineDataBool==true)
                const Padding(
                  padding: EdgeInsets.only(left:200.0),
                  child: Text('Please Add Part Line Item',style: TextStyle(color:Color(0xffB2261E)),),
                ),
            ],
          ),
          const SizedBox(height: 40,),
          ///-----------------------------Table Ends-------------------------

          ///SUB TOTAL
          const Divider(height: 1,color: mTextFieldBorder),
          Container(
            color: const Color(0xffF3F3F3),
            height: 34,
            child: Padding(
              padding: const EdgeInsets.only(left: 18,right: 18),
              child: Row(
                children:   [
                  const Expanded(child: Center(child: Text(''))),
                  const Expanded(flex: 4,child: Center(child: Text(""))),
                  const Expanded(child: Center(child: Text(""))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  const Expanded(child: Center(child: Text("Sub Total"))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Builder(
                      builder: (context) {
                        return Text("₹ ${subDiscountTotal.text.isEmpty?0:subDiscountTotal.text}");
                      }
                  ))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Builder(
                      builder: (context) {
                        return Text("₹ ${subTaxTotal.text.isEmpty?0:subTaxTotal.text}");
                      }
                  ))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Builder(
                      builder: (context) {
                        return Text("₹ ${subAmountTotal.text.isEmpty?0 :subAmountTotal.text}");
                      }
                  ))),
                  const SizedBox(width: 30,height: 30,),

                ],
              ),
            ),
          ),
          const Divider(height: 1,color: mTextFieldBorder,),
          ///------Foooter----------
          buildFooter(),
          const Divider(height: 1,color: mTextFieldBorder,),

        ],
      ),
    );
  }

  Widget showDialogBox(){
    return AlertDialog(
      backgroundColor:
      Colors.transparent,
      content:StatefulBuilder(
          builder: (context, StateSetter setState) {
            return SizedBox(
              width: MediaQuery.of(context).size.width/1.5,
              height: MediaQuery.of(context).size.height/1.1,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(top: 13.0, right: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(surfaceTintColor: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            ///search Fields
                            Row(
                              children: [
                                const SizedBox(width: 10,),
                                SizedBox(width: 250,
                                  child: TextFormField(
                                    controller: brandNameController,
                                    decoration: textFieldBrandNameField(hintText: 'Search Brand'),
                                    onChanged: (value) {
                                      setState(() {
                                        if(value.isEmpty || value==""){
                                          displayList=partsList;
                                        }
                                        else if(modelNameController.text.isNotEmpty || variantController.text.isNotEmpty){
                                          modelNameController.clear();
                                          variantController.clear();
                                        }
                                        else{
                                          fetchBrandName(brandNameController.text);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    decoration:  textFieldModelNameField(hintText: 'Search Model'),
                                    controller: modelNameController,
                                    onChanged: (value) {
                                      setState(() {
                                        if(value.isEmpty || value==""){
                                          displayList=partsList;
                                        }
                                        else if(brandNameController.text.isNotEmpty || variantController.text.isNotEmpty){
                                          brandNameController.clear();
                                          variantController.clear();

                                        }
                                        else{
                                          fetchModelName(modelNameController.text);
                                        }

                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(width: 250,
                                  child: TextFormField(
                                    controller: variantController,
                                    decoration: textFieldVariantNameField(hintText: 'Search Variant'),
                                    onChanged: (value) {
                                      setState(() {
                                        if(value.isEmpty || value==""){
                                          displayList=partsList;
                                        }
                                        else if(modelNameController.text.isNotEmpty || brandNameController.text.isNotEmpty){
                                          modelNameController.clear();
                                          brandNameController.clear();
                                        }
                                        else{
                                          fetchVariantName(variantController.text);
                                        }
                                      });
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
                                    Expanded(child: Text("Name")),
                                    Expanded(child: Text("Description")),
                                    Expanded(child: Text("Unit")),
                                    Expanded(child: Text("Price")),
                                    Expanded(child: Text("Type")),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4,),
                            Expanded(
                              child: SingleChildScrollView(
                                child:ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: displayList.length+1,
                                    itemBuilder: (context,int i){
                                  if(i<displayList.length){
                                    return Column(children: [
                                      MaterialButton(
                                        hoverColor: mHoverColor,
                                        onPressed: () {
                                          setState(() {
                                            storeId=displayList[i]["newitem_id"];
                                            for(var tempId in generalId){
                                              if(tempId == storeId){
                                                matchVehicleId=true;
                                              }
                                            }
                                            Navigator.pop(context,displayList[i]);
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
                                                    child: Text(displayList[i]['name']),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: Text(
                                                        displayList[i]['description']),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: Text(displayList[i]['unit']),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: Text(displayList[i]['selling_price'].toString()),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: Text(displayList[i]['type']),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                    ],);
                                  }
                                  else{
                                    return Column(children: [
                                      Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                      Row(mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("${startVal+15>partsList.length?partsList.length:startVal+1}-${startVal+15>partsList.length?partsList.length:startVal+15} of ${partsList.length}",style: const TextStyle(color: Colors.grey)),
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
                                                        displayList.add(partsList[i]);
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
                                                  if(partsList.length>startVal+15){
                                                    displayList=[];
                                                    startVal=startVal+15;
                                                    for(int i=startVal;i<startVal+15 && i< partsList.length;i++){
                                                      try{
                                                        setState(() {
                                                          displayList.add(partsList[i]);
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
                            )
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

  Widget buildFooter(){
    return Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.only(left:10.0),
                  child: Text("Notes From Dealer"),
                ),
                const SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(focusNode: focusDealerNotes,
                    validator: (value){
                      if(value==null || value.trim().isEmpty){
                        setState(() {
                          notesFromDealerError=true;
                        });
                        return "Enter Dealer Notes";
                      }
                      return null;
                    },
                    maxLines: 5,
                    controller: termsAndConditions,
                    decoration:textFieldDecoration(hintText: 'Enter Dealer Notes', error:notesFromDealerError ) ,
                  ),
                ),
                const SizedBox(height: 5,),

              ],
            ),
          ),
        ),
        const CustomVDivider(height: 250, width: 1, color: mTextFieldBorder),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Taxable Amount"),
                  Builder(
                      builder: (context) {
                        return Text("₹ ${subAmountTotal.text.isEmpty?0 :subAmountTotal.text}");
                      }
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Additional Charges",style: TextStyle(color: mSaveButton)),
                  Container(
                      decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                      height: 32,width: 100,
                      child: TextField(
                        controller: additionalCharges,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(

                            contentPadding: EdgeInsets.only(bottom: 12,right: 8,top: 2),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent))
                        ),
                        onChanged: (v) {
                          setState(() {
                            try{
                              double.parse(v.toString());
                            }
                            catch(e){
                              additionalCharges.clear();
                            }
                          });
                        },
                      )),
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(color: mTextFieldBorder),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total"),
                  Builder(
                      builder: (context) {
                        double tempValue= 0;
                        try {
                          tempValue= (double.parse(subAmountTotal.text) + double.parse(additionalCharges.text));
                        }
                        catch(e){
                          if(subAmountTotal.text.isEmpty){
                            tempValue =0;
                          }
                          else{
                            tempValue =double.parse(subAmountTotal.text);
                          }

                          log(e.toString());
                        }
                        return Text("₹ $tempValue");
                      }
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  decorationVendorAndWarehouse({required String hintText, required bool error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.search,size: 18),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error? Colors.red: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
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
  textFieldBrandNameField({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon:  brandNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          brandNameController.clear();
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
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldModelNameField({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon:  modelNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        modelNameController.clear();
        displayList=partsList;
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
  textFieldVariantNameField({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon:  variantController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        variantController.clear();
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

  fetchModelName(String modelName)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_model_name/$modelName';
    try{
      await getData(url:url ,context:context ).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            displayList=response;
          }
        });
      }
      );
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());

    }
  }

  fetchBrandName(String brandName)async{
    dynamic response;

    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_brand_name/$brandName';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            displayList=response;
          }
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
    }
  }

  fetchVariantName(String variantName)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_variant_name/$variantName';
    try{
      await getData(context:context ,url: url).then((value) {
        setState((){
          if(value!=null){
            response=value;
            displayList=response;

          }
        });
      });
    }
    catch(e){
      logOutApi(context:context ,response: response,exception: e.toString());
    }
  }

  getPartsMaster() async {
    dynamic response;
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/get_all_newitem";
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            partsList = value;
           try{
             if(displayList.isEmpty){
               if(partsList.length>15){
                 for(int i=startVal;i<startVal+15;i++){
                   displayList.add(partsList[i]);
                 }
               }
               else{
                 for(int i=0;i<partsList.length;i++){
                   displayList.add(partsList[i]);
                 }
               }
             }
           }
           catch(e){
             log(e.toString());
           }
           // displayList=partsList;
          }
          loading = false;
        });
      });
    } catch (e) {
      logOutApi(context: context, exception: e.toString(), response: response);
      setState(() {
        loading = false;
      });
    }
  }
  postEstimate(estimate)async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partspurchaseorder/add_parts_purchase_order';
    postData(context: context,requestBody:estimate ,url:url ).then((value) {
      setState(() {
        if(value!=null){

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Saved')));
          Navigator.of(context).pushNamed(MotowsRoutes.partsOrderListRoutes);
        }
      });
    });

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
    // create a list of 3 objects from a fake json response
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
