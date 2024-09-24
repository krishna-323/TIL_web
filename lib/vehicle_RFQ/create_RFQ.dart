
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

class CreateRFQ extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CreateRFQ({Key? key,  required this.selectedDestination, required this.drawerWidth }) : super(key: key);

  @override
  State<CreateRFQ> createState() => _CreateRFQState();
}

class _CreateRFQState extends State<CreateRFQ> {

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


  String selectedType1 ="Select Type";
  List selectType2List =[];
  String selectedType2 = "Select Type";

  get getBillTo {
    if(selectedType1 == "Dealer"){
      if(selectedType2 =="Floor plan"){
        return "(Bank)";
      }
    }
    return "";
  }

  get getDeliverTo {
    if(selectedType1 == "Dealer"){
      if(selectedType2 =="Floor plan"){
        return "Dealer";
      }
    }
    return "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salesInvoiceDate.text=DateFormat('dd-MM-yyyy').format(DateTime.now());
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
  int startVal=0;
  List vehicleList = [
    {
      "excel_id": "EXC_20869",
      "make": "CV-FML",
      "model": "T1 AMB",
      "varient": "T006860023434",
      "date": "16-7-34",
      "on_road_price": 7700000,
      "color": "Grey",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20870",
      "make": "CV-TDCV",
      "model": "KC3C1",
      "varient": "KC3C1",
      "date": "16-7-35",
      "on_road_price": 6800000,
      "color": "Red",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20871",
      "make": "CV-TDCV",
      "model": "F8C6F",
      "varient": "F8C6F",
      "date": "15-7-36",
      "on_road_price": 8651500,
      "color": "Black",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20872",
      "make": "CV-TML",
      "model": "LPO 1316",
      "varient": "27500855000R",
      "date": "16-8-6",
      "on_road_price": 7100000,
      "color": "White",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20873",
      "make": "CV-FML",
      "model": "T1 MB",
      "varient": "T006860016733",
      "date": "15-7-33",
      "on_road_price": 4200000,
      "color": "Grey",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20874",
      "make": "CV-TML",
      "model": "YODHA",
      "varient": "28985631ABFR",
      "date": "16-7-34",
      "on_road_price": 2725000,
      "color": "Red",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20875",
      "make": "CV-TML",
      "model": "XENON DC",
      "varient": "55025831ABFR",
      "date": "16-7-35",
      "on_road_price": 3800000,
      "color": "Red",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20876",
      "make": "CV-TML",
      "model": "INTRA V20",
      "varient": "55461223AKOR",
      "date": "15-7-36",
      "on_road_price": 2325000,
      "color": "Black",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20877",
      "make": "CV-TDCV",
      "model": "V3T6F",
      "varient": "V3T6F",
      "date": "16-8-6",
      "on_road_price": 11537240,
      "color": "White",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20878",
      "make": "CV-TML",
      "model": "LPK 2518",
      "varient": "41061262000RZK22",
      "date": "16-8-7",
      "on_road_price": 8875000,
      "color": "Grey",
      "year_of_manufacture": "2023"
    },
    {
      "excel_id": "EXC_20879",
      "make": "CV-TML",
      "model": "LPK 2516",
      "varient": "21715238000RBP20",
      "date": "15-7-32",
      "on_road_price": 7875000,
      "color": "Grey",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20880",
      "make": "CV-TML",
      "model": "SIGNA 1618",
      "varient": "21827336000RBH31",
      "date": "15-7-33",
      "on_road_price": 6075000,
      "color": "Red",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20881",
      "make": "CV-TML",
      "model": "SIGNA 2823",
      "varient": "50971038000R",
      "date": "16-7-34",
      "on_road_price": 10000000,
      "color": "Black",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20882",
      "make": "CV-TML",
      "model": "LPT 810",
      "varient": "26426438000R",
      "date": "16-7-35",
      "on_road_price": 3300000,
      "color": "White",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20883",
      "make": "CV-TML",
      "model": "SFC 407",
      "varient": "26522731000R",
      "date": "15-7-36",
      "on_road_price": 2750000,
      "color": "Grey",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20884",
      "make": "CV-TML",
      "model": "SIGNA 2518",
      "varient": "50302148000R",
      "date": "16-8-6",
      "on_road_price": 6580000,
      "color": "Red",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20885",
      "make": "CV-TML",
      "model": "LPT 809",
      "varient": "KB080938KENR",
      "date": "16-8-7",
      "on_road_price": 3225000,
      "color": "Red",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20886",
      "make": "CV-TML",
      "model": "LPT 1216",
      "varient": "KY111648KENR",
      "date": "15-7-36",
      "on_road_price": 4000000,
      "color": "Black",
      "year_of_manufacture": "2022"
    },
    {
      "excel_id": "EXC_20887",
      "make": "CV-TML",
      "model": "ULTRA T9",
      "varient": "55069139000R",
      "date": "16-8-6",
      "on_road_price": 3875000,
      "color": "White",
      "year_of_manufacture": "2022"
    }
  ];
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
  String managerId ='';
  String orgId ='';
  List taxCodes=[];
  List taxPercentage =[];
  // Future fetchTaxData() async {
  //   dynamic response;
  //   String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/tax/get_all_tax';
  //   try{
  //     await getData(context: context,url: url).then((value) {
  //       setState(() {
  //         if(value!=null){
  //           response = value;
  //           taxCodes = response;
  //           if(taxCodes.isNotEmpty){
  //             for(int i=0;i<taxCodes.length;i++){
  //               taxPercentage.add(taxCodes[i]['tax_total']);
  //             }
  //             // print('------taxCodes----');
  //             // print(taxPercentage);
  //           }
  //         }
  //         loading = false;
  //       });
  //     });
  //   }
  //   catch(e){
  //     logOutApi(context: context,response: response,exception: e.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }
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
                preferredSize: const Size.fromHeight(88.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: AppBar(
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Create Vehicle Order"),
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
                                funBool();
                                focusToController.requestFocus();
                                if(validationKey.currentState!.validate() &&  funBool()){
                                  double tempTotal =0;
                                  try{
                                    tempTotal = (double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text)+ double.parse(additionalCharges.text.isEmpty?"":additionalCharges.text));
                                  }
                                  catch(e){
                                    tempTotal= double.parse(subAmountTotal.text.isEmpty?"":subAmountTotal.text);
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
                                    "status":"In-review",
                                    "comment":"",
                                    "total": tempTotal.toString(),
                                    "totalTaxableAmount": subAmountTotal.text.isEmpty?0 :subAmountTotal.text,
                                    "manager_id": managerId,
                                    "userid": userId,
                                    "org_id": orgId,
                                    "items": [

                                    ]
                                  };
                                  for (int i = 0; i < selectedVehicles.length; i++) {
                                    postDetails['items'].add({
                                      "amount": lineAmount[i].text,
                                      "discount": discountPercentage[i].text,
                                      "estVehicleId": selectedVehicles[i]["new_vehicle_id"]??"",
                                      "itemsService": selectedVehicles[i]['model']??"",
                                      "priceItem": selectedVehicles[i]['on_road_price']??"",
                                      "quantity": units[i].text,
                                      "tax": tax[i].text,
                                    }
                                    );
                                  }
                                  // postEstimate(postDetails);
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
                      key:validationKey,
                      child: Column(
                        children: [
                          HeaderCard(width: width,),
                          const SizedBox(height: 20,),
                          buildInvoiceCard(),

                          const SizedBox(height: 20,),
                          buildLineCard(),

                          const SizedBox(height: 20,),
                          buildDealerNotes(),


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
                                decoration: customPopupDecoration(hintText:selectedType1,onTap: () {
                                  setState(() {
                                    selectedType1 = "Select Type";
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
                                    selectedType2="Select Type";
                                    selectedType1 = v.toString();
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
                                decoration: customPopupDecoration(hintText:selectedType2,onTap: (){
                                  selectedType2 = "Select Type";
                                }),
                                // hintText: "ss",
                                //textController: customerTypeController,
                                childWidth: constraints.maxWidth,
                                offset: const Offset(1, 40),
                                tooltip: '',
                                itemBuilder:  (BuildContext context) {
                                  return selectedType1 ==""?[]:selectType2List.map((value) {
                                    return CustomPopupMenuItem(
                                      value: value,
                                      text:value,
                                      child: Container(),
                                    );
                                  }).toList();
                                },
                                onSelected: (v){
                                  setState(() {
                                    selectedType2 = v.toString();
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
                    if(showCustomerDetails==false)
                      const SizedBox(height: 30,),
                    if(showCustomerDetails==false)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: CustomTextFieldSearch(
                            onTapAdd: (){

                            },
                            validator: (value){
                              if(value==null || value.trim().isEmpty){
                                setState(() {
                                  isBillToSelected=true;
                                });
                                return "Search $getBillTo Address";
                              }
                              return null;
                            },
                            showAdd: true,
                            decoration:textFieldVendorAndWarehouse(hintText: 'Search $getBillTo Address',error:isBillToSelected) ,
                            // decoration:textFieldWarehouseDecoration(hintText: 'Search Warehouse',error:searchWarehouse),
                            controller: wareHouseController,
                            future: fetchData,
                            getSelectedValue: (VendorModelAddress value) {
                              setState(() {
                                showCustomerDetails=true;
                                wareHouse ={
                                  'Name':value.label,
                                  'city': value.city,
                                  'state': value.state,
                                  'street': value.street,
                                  'zipcode': value.zipcode,
                                };
                                isBillToSelected=false;
                              });
                            },

                          ),
                        ),
                      ),
                    if(showCustomerDetails)
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
                    if(showCustomerDetails==false)
                      const SizedBox(height: 30,),
                    if(showCustomerDetails==false)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                          child: CustomTextFieldSearch(
                            onTapAdd: (){

                            },
                            validator: (value){
                              if(value==null || value.trim().isEmpty){
                                setState(() {
                                  isBillToSelected=true;
                                });
                                return "Search $getBillTo Address";
                              }
                              return null;
                            },
                            showAdd: true,
                            decoration:textFieldVendorAndWarehouse(hintText: 'Search $getBillTo Address',error:isBillToSelected) ,
                            // decoration:textFieldWarehouseDecoration(hintText: 'Search Warehouse',error:searchWarehouse),
                            controller: wareHouseController,
                            future: fetchData,
                            getSelectedValue: (VendorModelAddress value) {
                              setState(() {
                                showCustomerDetails=true;
                                wareHouse ={
                                  'Name':value.label,
                                  'city': value.city,
                                  'state': value.state,
                                  'street': value.street,
                                  'zipcode': value.zipcode,
                                };
                                isBillToSelected=false;
                              });
                            },

                          ),
                        ),
                      ),
                    if(showCustomerDetails)
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
                      child: const TextField(decoration: InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.only(right: 5,top: 10,left: 5)),style: TextStyle(fontSize: 12),maxLines: 10,),
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
              color: const Color(0xffffffff),
              height: 65,
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Text('Vehicle Details',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text('SL No'))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 4, child: Center(child: Text("Model"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Qty"))),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Text('Vehicle required DSLB or Chassis Cab',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            Expanded(child: Center(child: Text("Chassis Cab"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Body Build"))),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Text('Delivery',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            Expanded(flex: 3,child: Center(child: Text('Delivery Location'))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 3, child: Center(child: Text("Bodybuilder"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Edit"))),
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
                height: 45,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CustomVDivider(height: 44, width: 1, color: mTextFieldBorder),
                              Expanded(child: Center(child: Text('${index+1}'))),
                              const CustomVDivider(height: 44, width: 1, color: mTextFieldBorder),
                              Expanded(flex: 4, child: lineText(selectedVehiclesList[index]['model'])),
                              const CustomVDivider(height: 44, width: 1, color: mTextFieldBorder),
                              Expanded(child: Center(child: lineTextField(selectedVehiclesList[index]['qty'].toString(),index,
                                onChanged: (v){
                                setState(() {
                                  selectedVehiclesList[index]['qty'] =v;
                                });
                                }
                              ))),
                            ],
                          )
                        ],
                      ),
                    ),
                    const CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
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
                              const CustomVDivider(height: 44, width: 1, color: mTextFieldBorder),
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
                    const CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                     Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 3,child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
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
                              const CustomVDivider(height: 44, width: 1, color: mTextFieldBorder),
                              Expanded(flex: 3, child:  Padding(
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
                              ),),

                              const CustomVDivider(height: 44, width: 1, color: mTextFieldBorder),
                              Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Center(child: InkWell(onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditVehicleToForm(drawerWidth: widget.drawerWidth,selectedDestination: widget.selectedDestination,selectedVehicle: selectedVehiclesList[index]),)).then((value) {
                                      setState(() {
                                        selectedVehiclesList[index]=value;
                                      });
                                    });
                                  },child: const Icon(Icons.edit,color: Colors.blueAccent,size: 16,))),
                                  Center(child: InkWell(onTap: (){

                                    setState(() {
                                      selectedVehiclesList.removeAt(index);
                                    });

                                  },child: const Icon(Icons.delete,color: Colors.red,size: 16))),
                                ],
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },),


            const Divider(height: 1, color: mTextFieldBorder,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    width: 300,height: 28,
                    child: OutlinedMButton(
                      text: '+ Add Vehicle ',
                      buttonColor:mSaveButton ,
                      textColor: Colors.white,
                      borderColor: mSaveButton,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddVehicleToForm(selectedDestination: widget.selectedDestination, drawerWidth: widget.drawerWidth),
                            )).then((value) {
                              setState(() {
                                if(value!=null) {
                                  if(value['model']!="") {
                                    selectedVehiclesList.add(value);
                                  }
                                }
                              });
                            });
                      },
                    ),
                  ),
                ),
              ],
            )


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
                      child: const TextField(decoration: InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.only(right: 5,top: 10,left: 5)),style: TextStyle(fontSize: 14),maxLines: 10,),
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

  // Future fetchModelName(String modelName)async{
  //   dynamic response;
  //   String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_model_name/$modelName';
  //   try{
  //     await getData(url:url ,context:context ).then((value) {
  //       setState(() {
  //         if(value!=null){
  //           response=value;
  //           vehicleList=response;
  //           displayList=[];
  //           startVal=0;
  //           try{
  //             if(displayList.isEmpty){
  //               if(vehicleList.length>15){
  //                 for(int i=startVal;i<startVal+15;i++){
  //                   displayList.add(vehicleList[i]);
  //                 }
  //               }
  //               else{
  //                 for(int i=startVal;i<vehicleList.length;i++){
  //                   displayList.add(vehicleList[i]);
  //                 }
  //               }
  //             }
  //           }
  //           catch(e){
  //             log("Excepted Type $e");
  //           }
  //         }
  //       });
  //     }
  //     );
  //   }
  //   catch(e){
  //     logOutApi(context: context,response: response,exception: e.toString());
  //
  //   }
  // }
  //
  // Future fetchBrandName(String brandName)async{
  //   dynamic response;
  //   String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_brand_name/$brandName';
  //   try{
  //     await getData(context: context,url: url).then((value) {
  //       setState(() {
  //         if(value!=null){
  //           response=value;
  //           vehicleList=response;
  //           displayList=[];
  //           startVal=0;
  //           try{
  //             if(displayList.isEmpty){
  //               if(vehicleList.length>15){
  //                 for(int i=startVal;i<startVal+15;i++){
  //                   displayList.add(vehicleList[i]);
  //                 }
  //               }
  //               else{
  //                 for(int i=startVal;i<vehicleList.length;i++){
  //                   displayList.add(vehicleList[i]);
  //                 }
  //               }
  //             }
  //           }
  //           catch(e){
  //             log("Excepted Type $e");
  //           }
  //         }
  //       });
  //     });
  //   }
  //   catch(e){
  //     logOutApi(context: context,exception: e.toString(),response: response);
  //   }
  // }
  //
  // Future fetchVariantName(String variantName)async{
  //   dynamic response;
  //   String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_variant_name/$variantName';
  //   try{
  //     await getData(context:context ,url: url).then((value) {
  //       setState((){
  //         if(value!=null){
  //           response=value;
  //           vehicleList=response;
  //           displayList=[];
  //           startVal=0;
  //           try{
  //             if(displayList.isEmpty){
  //               if(vehicleList.length>15){
  //                 for(int i=startVal;i<startVal+15;i++){
  //                   displayList.add(vehicleList[i]);
  //                 }
  //               }
  //               else{
  //                 for(int i=startVal;i<vehicleList.length;i++){
  //                   displayList.add(vehicleList[i]);
  //                 }
  //               }
  //             }
  //           }
  //           catch(e){
  //             log("Excepted Type $e");
  //           }
  //         }
  //       });
  //     });
  //   }
  //   catch(e){
  //     logOutApi(context:context ,response: response,exception: e.toString());
  //   }
  // }

  // Future getAllVehicleVariant() async {
  //   dynamic response;
  //   String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_mod_general";
  //   try {
  //     await getData(context: context, url: url).then((value) {
  //       setState(() {
  //         if (value != null) {
  //           response = value;
  //           vehicleList = response;
  //           startVal=0;
  //           displayList=[];
  //           if(displayList.isEmpty){
  //             if(vehicleList.length>15){
  //               for(int i=startVal;i<startVal+15;i++){
  //                 displayList.add(vehicleList[i]);
  //               }
  //             }
  //             else{
  //               for(int i=startVal;i<vehicleList.length;i++){
  //                 displayList.add(vehicleList[i]);
  //               }
  //             }
  //           }
  //         }
  //         loading = false;
  //       });
  //     });
  //   } catch (e) {
  //     logOutApi(context: context, exception: e.toString(), response: response);
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }
  // postEstimate(estimate)async {
  //   String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/add_estimate_vehicle';
  //   postData(context: context,requestBody:estimate ,url:url ).then((value) {
  //     setState(() {
  //       if(value!=null){
  //
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Saved')));
  //         Navigator.of(context).pushNamed(MotowsRoutes.estimateRoutes);
  //       }
  //     });
  //   });
  //
  // }
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
    return Container(margin: const EdgeInsets.all(10),decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(2)),child: Center(child: Text(text,maxLines: 1,overflow:TextOverflow.ellipsis ,)));
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
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      constraints: const BoxConstraints(maxHeight: 30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
      counterText: '',
      contentPadding: const EdgeInsets.only(left: 8,top: 1,bottom: 16),

    );

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

  const HeaderCard({Key? key, required this.width}) : super(key: key);

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
                const Padding(
                  padding:  EdgeInsets.only(top: 8,left: 6),
                  child: Text("Dealer Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 250,height: 28,alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("ACsd XYZ",),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:  EdgeInsets.only(top: 8,left: 6),
                  child: Text("Dealer Code",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 150,height: 28,alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text("A13389",),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:  EdgeInsets.only(top: 8,left: 6),
                  child: Text("Order Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 150,height: 28,alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text("ORD123F45678",),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8,right: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:  EdgeInsets.only(top: 8,left: 6),
                  child: Text("Order Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                ),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 150,height: 28,alignment: Alignment.centerLeft,
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(formattedDate),
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

