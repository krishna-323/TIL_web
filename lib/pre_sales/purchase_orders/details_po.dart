import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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
class ViewEstimateItem extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map estimateItem;
  const ViewEstimateItem({Key? key, required this.drawerWidth, required this. selectedDestination, required Duration transitionDuration, required  Duration reverseTransitionDuration, required this.estimateItem}) : super(key: key);

  @override
  State<ViewEstimateItem> createState() => _ViewEstimateItemState();
}

class _ViewEstimateItemState extends State<ViewEstimateItem> {

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
  Map estimateItems={};
  List lineItems=[];
  Map updateEstimate={};
  bool vehicleLineTableData=false;
  final commentController=TextEditingController();
  //Tax Percentages.
  List taxPercentages=[];
  List taxCodes=[];
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
                taxPercentages.add(taxCodes[i]['tax_total']);
              }
              // print('------taxCodes----');
              // print(taxPercentages);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    estimateItems=widget.estimateItem;
    // print('-additional charges');
    // print(estimateItems);
    userId=estimateItems['userid'];
    commentController.text=estimateItems['comment']??"";
    billToName=estimateItems['billAddressName']??'';
    billToCity=estimateItems['billAddressCity']??"";
    billToStreet=estimateItems['billAddressStreet']??"";
    billToState=estimateItems['billAddressState']??"";
    billToZipcode=estimateItems['billAddressZipcode']??"";
    shipToName=estimateItems['shipAddressName']??"";
    shipToCity=estimateItems['shipAddressCity']??"";
    shipToStreet=estimateItems['shipAddressStreet']??"";
    shipToState=estimateItems['shipAddressState']??"";
    shipZipcode=estimateItems['shipAddressZipcode']??"";
    salesInvoiceDate.text=estimateItems['serviceInvoiceDate']??'';
    additionalCharges.text=estimateItems['additionalCharges'].toString();
    for(int i=0;i<estimateItems['items'].length;i++){
      units.add(TextEditingController());
      units[i].text=estimateItems['items'][i]['quantity'].toString();

      discountPercentage.add(TextEditingController());
      discountPercentage[i].text= estimateItems['items'][i]['discount'].toString();

      tax.add(TextEditingController());
      tax[i].text=estimateItems['items'][i]['tax'].toString();

      lineAmount.add(TextEditingController());
      lineAmount[i].text=estimateItems['items'][i]['amount'].toString();

      subDiscountTotal.text = lineAmount[i].text + discountPercentage[i].text;
    }
    subDiscountTotal.text=estimateItems['subTotalDiscount'].toString();
    subTaxTotal.text=estimateItems['subTotalTax'].toString();
    subAmountTotal.text=estimateItems['subTotalAmount'].toString();

    salesInvoice.text=estimateItems['serviceInvoice']??"";
    termsAndConditions.text=estimateItems['termsConditions']??"";
    getInitialData().whenComplete((){
      getAllVehicleVariant();
      fetchVendorsData();
      fetchTaxData();
    });

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

  List vehicleList = [];
  List displayList=[];
  List selectedVehicles=[];
  var units = <TextEditingController>[];
  var discountRupees = <TextEditingController>[];
  var discountPercentage = <TextEditingController>[];
  var tax = <TextEditingController>[];
  var lineAmount = <TextEditingController>[];
  List items=[];
  Map postDetails={};
  bool newAddress=false;
  bool newShipping=false;
  bool billing=true;
  Map selectedItems={};
  String ? authToken;

  String billToName='';
  String billToCity='';
  String billToStreet='';
  String billToState='';
  int billToZipcode=0;

  String shipToName='';
  String shipToCity='';
  String shipToStreet='';
  String shipToState='';
  int shipZipcode=0;
  String role ='';
  String userId ='';
  String managerId ='';
  String orgId ='';
  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
    role= prefs.getString("role")??"";
    managerId= prefs.getString("managerId")??"";
    orgId= prefs.getString("orgId")??"";
    // print('---------role----------');
    // print(role);
  }
  @override
  Widget build(BuildContext context) {
    width =MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar:  const PreferredSize(  preferredSize: Size.fromHeight(60),
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
                    title: const Text("Edit Vehicle Details"),
                    actions: [
                      if(role=="Manager")
                      Row(
                        children: [
                          SizedBox(
                            width: 120,height: 28,
                            child: OutlinedMButton(
                              text: 'Approve',
                              textColor: Colors.green,
                              borderColor: Colors.green,
                              onTap: (){
                                setState(() {
                                  if(estimateItems['items'].isEmpty){
                                    vehicleLineTableData=true;
                                  }
                                  else{
                                    double tempTotal =0;
                                    try{
                                      tempTotal = (double.parse(subAmountTotal.text)+ double.parse(additionalCharges.text));
                                    }
                                    catch(e){
                                      tempTotal = double.parse(subAmountTotal.text);
                                    }
                                    updateEstimate =    {
                                      "additionalCharges": additionalCharges.text,
                                      "address": "string",
                                      "billAddressCity": showVendorDetails==true?vendorData['city']??"":billToCity,
                                      "billAddressName":showVendorDetails==true?vendorData['Name']??"":billToName,
                                      "billAddressState": showVendorDetails==true?vendorData['state']??"":billToState,
                                      "billAddressStreet":showVendorDetails==true?vendorData['street']??"":billToStreet,
                                      "billAddressZipcode": showVendorDetails==true?vendorData['zipcode']??"":billToZipcode,
                                      "serviceDueDate": "",
                                      "estVehicleId": estimateItems['estVehicleId']??"",
                                      "serviceInvoice": salesInvoice.text,
                                      "serviceInvoiceDate": salesInvoiceDate.text,
                                      "shipAddressCity": showWareHouseDetails==true?wareHouse['city']??"":shipToCity,
                                      "shipAddressName": showWareHouseDetails==true?wareHouse['Name']??"":shipToName,
                                      "shipAddressState": showWareHouseDetails==true?wareHouse['state']??"":shipToState,
                                      "shipAddressStreet": showWareHouseDetails==true?wareHouse['street']??"":shipToStreet,
                                      "shipAddressZipcode": showWareHouseDetails==true?wareHouse['zipcode']??"":shipZipcode,
                                      "subTotalAmount": subAmountTotal.text,
                                      "subTotalDiscount": subDiscountTotal.text,
                                      "subTotalTax": subTaxTotal.text,
                                      "termsConditions": termsAndConditions.text,
                                      "total":tempTotal.toString(),
                                      "status":"Approved",
                                      "comment":estimateItems['comment']??"",
                                      "manager_id": managerId,
                                      "userid": userId,
                                      "org_id": orgId,
                                      "totalTaxableAmount": 0,
                                      "items": [],
                                    };


                                    for(int i=0;i<estimateItems['items'].length;i++){
                                      lineItems.add(
                                          {
                                            "amount": lineAmount[i].text,
                                            "discount":  discountPercentage[i].text,
                                            "estVehicleId": estimateItems['estVehicleId'],
                                            "itemsService": estimateItems['items'][i]['itemsService'],
                                            "priceItem": estimateItems['items'][i]['priceItem'].toString(),
                                            "quantity": units[i].text,
                                            "tax": tax[i].text,
                                          }
                                      );
                                    }
                                    putUpdatedEstimated(updateEstimate);
                                  }
                                });
                              },

                            ),
                          ),
                          const SizedBox(width: 10,),
                          SizedBox(
                            width: 120,height: 28,
                            child: OutlinedMButton(
                              text: 'Reject',
                              textColor:  Colors.red,
                              borderColor: Colors.red,
                              onTap: (){
                                rejectShowDialog();
                              },

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,height: 28,
                            child: OutlinedMButton(
                              text: 'Delete',
                              textColor: mSaveButton,
                              borderColor: mSaveButton,
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return SizedBox(
                                            height: 200,
                                            width: 300,
                                            child: Stack(children: [
                                              Container(
                                                decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                                margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 20.0,right: 25),
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
                                                      Column(
                                                        children:  [
                                                          const Center(
                                                              child: Text(
                                                                'Are You Sure, You Want To Delete ?',
                                                                style: TextStyle(
                                                                    color: Colors.indigo,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 15),
                                                              )),
                                                          const  SizedBox(height:5),
                                                          Center(
                                                              child: Text(estimateItems['estVehicleId']??"",
                                                                style: const TextStyle(
                                                                    color: Colors.indigo,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 15),
                                                              )),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          MaterialButton(
                                                            color: Colors.red,
                                                            onPressed: () {
                                                              // print(userId);
                                                              deleteEstimateItemData(estimateItems['estVehicleId']);
                                                            },
                                                            child: const Text(
                                                              'Ok',
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                          MaterialButton(
                                                            color: Colors.blue,
                                                            onPressed: () {
                                                              setState(() {
                                                                Navigator.of(context).pop();
                                                              });
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
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
                                    );
                                  },
                                );
                              },

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,height: 28,
                            child: OutlinedMButton(
                              text: 'Update',
                              buttonColor:mSaveButton ,
                              textColor: Colors.white,
                              borderColor: mSaveButton,
                              onTap: (){
                                setState(() {
                                  if(estimateItems['items'].isEmpty){
                                    vehicleLineTableData=true;
                                  }
                                  else{
                                    double tempTotal =0;
                                    try{
                                      tempTotal = (double.parse(subAmountTotal.text)+ double.parse(additionalCharges.text));
                                    }
                                    catch(e){
                                      tempTotal = double.parse(subAmountTotal.text);
                                    }
                                    updateEstimate =    {
                                      "additionalCharges": additionalCharges.text,
                                      "address": "string",
                                      "billAddressCity": showVendorDetails==true?vendorData['city']??"":billToCity,
                                      "billAddressName":showVendorDetails==true?vendorData['Name']??"":billToName,
                                      "billAddressState": showVendorDetails==true?vendorData['state']??"":billToState,
                                      "billAddressStreet":showVendorDetails==true?vendorData['street']??"":billToStreet,
                                      "billAddressZipcode": showVendorDetails==true?vendorData['zipcode']??"":billToZipcode,
                                      "serviceDueDate": "",
                                      "estVehicleId": estimateItems['estVehicleId']??"",
                                      "serviceInvoice": salesInvoice.text,
                                      "serviceInvoiceDate": salesInvoiceDate.text,
                                      "shipAddressCity": showWareHouseDetails==true?wareHouse['city']??"":shipToCity,
                                      "shipAddressName": showWareHouseDetails==true?wareHouse['Name']??"":shipToName,
                                      "shipAddressState": showWareHouseDetails==true?wareHouse['state']??"":shipToState,
                                      "shipAddressStreet": showWareHouseDetails==true?wareHouse['street']??"":shipToStreet,
                                      "shipAddressZipcode": showWareHouseDetails==true?wareHouse['zipcode']??"":shipZipcode,
                                      "subTotalAmount": subAmountTotal.text,
                                      "subTotalDiscount": subDiscountTotal.text,
                                      "subTotalTax": subTaxTotal.text,
                                      "termsConditions": termsAndConditions.text,
                                      "total":tempTotal.toString(),
                                      "status":estimateItems['status']??"In-review",
                                      "comment":estimateItems['comment']??"",
                                      "manager_id": managerId,
                                      "userid": userId,
                                      "org_id": orgId,
                                      "totalTaxableAmount": 0,
                                      "items": [],
                                    };


                                    for(int i=0;i<estimateItems['items'].length;i++){
                                      lineItems.add(
                                          {
                                            "amount": lineAmount[i].text,
                                            "discount":  discountPercentage[i].text,
                                            "estVehicleId": estimateItems['estVehicleId'],
                                            "itemsService": estimateItems['items'][i]['itemsService'],
                                            "priceItem": estimateItems['items'][i]['priceItem'].toString(),
                                            "quantity": units[i].text,
                                            "tax": tax[i].text,
                                          }
                                      );
                                    }
                                    putUpdatedEstimated(updateEstimate);
                                  }

                                });
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
                  child: const SelectableText("Ikyam Solutions Private Limited, 5, 80 Feet Rd, 4th Block, New Friends Colony, Koramangala, Bengaluru, Karnataka",style: TextStyle(fontSize: 14,color: Colors.grey)),
                ),
                const Row(
                  children: [
                    Icon(Icons.call,size: 16),
                    SizedBox(width: 5,),
                    SelectableText("081233 32485 / +917899726639",style: TextStyle(fontSize: 14,color: Colors.grey)),
                  ],
                )

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


  Widget buildContentCard(){
    return Card(color: Colors.white,
      surfaceTintColor: Colors.white,
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
                          if(estimateItems.isNotEmpty)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showVendorDetails=false;
                                    newAddress=true;
                                  });
                                },
                              ),
                            )

                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    const SizedBox(height: 10,),
                    if(newAddress)
                      Center(
                        child: SizedBox(height: 32,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 18),
                            child: CustomTextFieldSearch(
                              decoration:textFieldDecoration(hintText: 'Search Vendor') ,
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
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SelectionArea(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(showVendorDetails==true?vendorData['Name']??"":billToName,style: const TextStyle(fontWeight: FontWeight.bold)),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child:  Text("Street")),
                                const Text(": "),
                                Expanded(child: Text("${showVendorDetails==true?vendorData['street']??"":billToStreet}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("City")),
                                const Text(": "),
                                Expanded(child: Text("${showVendorDetails==true?vendorData['city']??"":billToCity}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("State")),
                                const Text(": "),
                                Expanded(child: Text("${showVendorDetails==true?vendorData['state']??"":billToState}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("ZipCode :")),
                                const Text(": "),
                                Expanded(child: Text("${showVendorDetails==true?vendorData['zipcode']??"":billToZipcode}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
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
                          if(estimateItems.isNotEmpty)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showWareHouseDetails=false;
                                    newShipping=true;
                                  });
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    const SizedBox(height: 10,),
                    if(newShipping)
                      Center(
                        child: SizedBox(height: 32,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 18),
                            child: CustomTextFieldSearch(
                              decoration:textFieldDecoration(hintText: 'Search warehouse'),
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
                                });


                                // print(value.value);
                                // print(value.city);
                                // print(value.street);// this prints the selected option which could be an object
                              },
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SelectionArea(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(showWareHouseDetails==true?wareHouse['Name']??"":shipToName,style: const TextStyle(fontWeight: FontWeight.bold)),
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child:  Text("Street")),
                                const Text(": "),
                                Expanded(child: Text("${showWareHouseDetails==true?wareHouse['street']??"":shipToStreet}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("City")),
                                const Text(": "),
                                Expanded(child: Text("${showWareHouseDetails==true?wareHouse['city']??"":shipToCity}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("State")),
                                const Text(": "),
                                Expanded(child: Text("${showWareHouseDetails==true?wareHouse['state']??"":shipToState}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),

                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 70,child: Text("ZipCode :")),
                                const Text(": "),
                                Expanded(child: Text("${showWareHouseDetails==true?wareHouse['zipcode']??"":shipZipcode}",maxLines: 2,overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
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
                                        const Text('Sales Invoice #'),
                                        const SizedBox(height: 10,),
                                        Container(
                                          width: 120,
                                          height: 32,
                                          color: Colors.grey[200],
                                          child: TextFormField(
                                            controller: salesInvoice,
                                            decoration:textFieldSalesInvoice(hintText: 'Sales Invoice') ,
                                          ),
                                        )
                                      ],),
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
                              const SizedBox(height: 25,),
                              Align(alignment: Alignment.topLeft,
                                child: SizedBox(
                                  width: 120,height: 28,
                                  child: OutlinedMButton(
                                    text: 'Add Due Date',
                                    textColor: mSaveButton,
                                    borderColor: mSaveButton,
                                    onTap: (){
                                      setState(() {

                                      });
                                    },

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              //Customer TextFields
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


          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: estimateItems['items'].length,
            itemBuilder: (BuildContext context, int index) {
              double tempDiscount=0;
              double tempLineData=0;
              double tempTax=0;
              try{
                lineAmount[index].text=(double.parse(estimateItems['items'][index]['priceItem'].toString())* (double.parse(units[index].text))).toString();
                if(discountPercentage[index].text!='0'||discountPercentage[index].text!=''||discountPercentage[index].text.isNotEmpty)
                {
                  tempDiscount =((double.parse(discountPercentage[index].text)/100 * double.parse(lineAmount[index].text)));
                  tempLineData =(double.parse(lineAmount[index].text)-tempDiscount);
                  tempTax = ((double.parse(tax[index].text)/100) *  double.parse( lineAmount[index].text));

                  lineAmount[index].text =(tempLineData+tempTax).toStringAsFixed(1);
                  // subDiscountTotal.text=tempDiscount.toString();
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
                subAmountTotal.text = (double.parse(subAmountTotal.text.toString())+ double.parse(lineAmount[index].text)).toStringAsFixed(1);
              }
              return  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0,right: 18),
                    child: SizedBox(height: 50,
                      child: Row(
                        children: [
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Text('${index+1}'))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(flex:4,child: Center(child: Text(estimateItems['items'][index]['itemsService']))),
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
                          Expanded(child: Center(child: Text(estimateItems['items'][index]['priceItem'].toString()))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child:  Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child: TextField(inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                  setState(() {

                                  });

                                  //discountRupees[index].clear();
                                  if(v.isNotEmpty||v!=''){
                                    //   double tempLineTotal =  double.parse(selectedVehicles[index]['onroad_price'])* double.parse(units[index].text);
                                    //   double tempVal =0;
                                    //   double tempVal =0;
                                    //   tempVal = (double.parse(v)/100) *  tempLineTotal;
                                    //   lineAmount[index].text=(tempLineTotal-tempVal).toString();
                                    //   setState(() {
                                    //     subAmountTotal.text=(double.parse(subAmountTotal.text)-tempVal).toString();
                                    //   });
                                    // }
                                    // else{
                                    //   lineAmount[index].text=(double.parse(selectedVehicles[index]['onroad_price'])* double.parse(units[index].text)).toString();
                                  }
                                },
                              ),
                            ),
                          ),),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(child: Center(child: Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
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
                                      return taxPercentages.map((value) {
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
                              if(estimateItems['items'][index]['estItemId']!=null){
                                deleteLineItem(estimateItems['items'][index]['estItemId']);
                              }
                              else{
                                 try{
                                   estimateItems['items'].removeAt(index);
                                   units.removeAt(index);
                                   discountRupees.removeAt(index);
                                   discountPercentage.removeAt(index);
                                   tax.removeAt(index);
                                   lineAmount.removeAt(index);
                                 }
                                 catch(e){
                                   log(e.toString());
                                 }
                              }

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
            },
          ),
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
                                borderColor: vehicleLineTableData==true?Colors.red:mSaveButton,
                                textColor: mSaveButton,
                                onTap: () {
                                  brandNameController.clear();
                                  modelNameController.clear();
                                  variantController.clear();
                                  displayList=vehicleList;
                                  showDialog(
                                      context: context,
                                      builder: (context) => showDialogBox()).then((value) {
                                    if(value!=null){
                                      setState(() {
                                        if(displayList.isNotEmpty){
                                          vehicleLineTableData=false;
                                        }
                                        isVehicleSelected=true;
                                        lineAmount.add(TextEditingController());
                                        units.add(TextEditingController(text: '1'));
                                        discountPercentage.add(TextEditingController(text:'0'));
                                        tax.add(TextEditingController());
                                        estimateItems['items'].add(value);
                                      });
                                    }
                                  });

                                },
                              ))),
                      const Expanded(flex: 5,child: Center(child: Text(""),))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              if(vehicleLineTableData==true)
                const Padding(
                  padding: EdgeInsets.only(left: 200),
                  child: Text('Please Add Vehicle Line Item',style: TextStyle(color: Colors.red),),
                ),
            ],
          ),
          const SizedBox(height: 40,),
          ///-----------------------------Table Ends-------------------------

          ///SUB TOTAL
          const Padding(
            padding: EdgeInsets.only(left:18.0,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder),
          ),
          Padding(
            padding: const EdgeInsets.only(left:18.0,right:18),
            child: Container(
              color: const Color(0xffF3F3F3),
              height: 34,
              child: Row(
                children:   [
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
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
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left:18.0,right:18),
            child: Divider(height: 1,color: mTextFieldBorder,),
          ),

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
          builder: (context, StateSetter setState,) {
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
                                          displayList=vehicleList;
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
                                          displayList=vehicleList;
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
                                          displayList=vehicleList;
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
                                    Expanded(child: Text("Brand")),
                                    Expanded(child: Text("Model")),
                                    Expanded(child: Text("Variant")),
                                    Expanded(child: Text("On road price")),
                                    Expanded(child: Text("Color")),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (int i = 0; i < displayList.length; i++)
                                      InkWell(
                                        hoverColor: mHoverColor,
                                        onTap: () {
                                          setState(() {
                                            // print('---------Table Line T------');
                                            // print(displayList[i]);
                                            selectedItems={
                                              "itemsService":displayList[i]['model_name']??"",
                                              "priceItem":displayList[i]['onroad_price'].toString(),
                                              "quantity":1,
                                              "discount":0,
                                              "tax":0,
                                              "amount":displayList[i]['onroad_price'].toString(),
                                            };
                                            Navigator.pop(context,selectedItems,);
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
                                                    child: Text(displayList[i]['make']),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: Text(
                                                        displayList[i]['model_name']),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: Text(displayList[i]['varient_name']),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: Text(displayList[i]['onroad_price'].toString()),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 20,
                                                    child: Text(displayList[i]['varient_color1']),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                  ],
                                ),
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
            padding: const EdgeInsets.all(28.0),
            child: Column(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    const Text("Terms and Conditions"),
                    const SizedBox(height: 10,),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.grey)),
                          height: 80,
                          child: TextFormField(
                            controller: termsAndConditions,
                            style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration:  const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:EdgeInsets.only(left: 15, bottom: 10, top: 18, right: 15),
                            ),
                          ),
                        )
                    )
                  ],
                ),
                if(commentController.text.isNotEmpty)
                  Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      const Text("Comments"),
                      const SizedBox(height: 10,),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.grey)),
                            height: 80,
                            child: TextFormField(readOnly: true,
                              controller: commentController,
                              style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration:  const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding:EdgeInsets.only(left: 15, bottom: 10, top: 18, right: 15),
                              ),
                            ),
                          )
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
        const CustomVDivider(height: 280, width: 1, color: mTextFieldBorder),
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
                  const Text("+ Add Additional Charges",style: TextStyle(color: mSaveButton)),
                  Container(
                      decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                      height: 32,width: 100,
                      child: TextField(
                        controller: additionalCharges,
                        inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
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
                        double tempValue=0;
                        try{
                          tempValue = (double.parse(subAmountTotal.text)+ double.parse(additionalCharges.text));
                        }
                        catch(e){
                          if(subAmountTotal.text.isEmpty){
                            tempValue=0;
                          }
                          else{
                            tempValue=double.parse(subAmountTotal.text);
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

  textFieldDecoration({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.search,size: 18),
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
        displayList=vehicleList;
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

  getAllVehicleVariant() async {
    dynamic response;
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/get_all_mod_general";
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            vehicleList = value;
            displayList=vehicleList;
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
  putUpdatedEstimated(updatedEstimated)async{
    try{
      final response=await http.put(Uri.parse('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/update_estimate_vehicle'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(updatedEstimated)
      );
      if(response.statusCode==200){
        if(lineItems.isNotEmpty){
          lineItemsData(lineItems);
        }


      }
      else{
        log(response.statusCode.toString());
      }
    }
    catch(e){
      log(e.toString());
    }
  }
  lineItemsData(lineItems)async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/add_estimate_item';
    postData(context:context ,url: url,requestBody: lineItems).then((value) => {
      setState((){
        if(value!=null){
          log(value.toString());
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Updated')));
            Navigator.of(context).pushNamed(MotowsRoutes.estimateRoutes);
          }
        }
      })
    });
  }
  deleteLineItem(estimateItemId)async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/delete_estimate_item_by_id/$estimateItemId';
    try{
      final response=await http.delete(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          }
      );
      if(response.statusCode==200){
        setState(() {
          estimateItems['items'].removeWhere((map)=>map['estItemId']==estimateItemId);
        });
      }
    }
    catch(e){
      log(e.toString());
    }
  }
  deleteEstimateItemData(estVehicleId)async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/delete_estimate_vehicle_by_id/$estVehicleId';
    try{
      final response=await http.delete(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          }
      );
      if(response.statusCode ==200){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("$estVehicleId Id Deleted" )));
          Navigator.of(context).pushNamed(MotowsRoutes.estimateRoutes);
        }
      }
    }
    catch(e){
      log(e.toString());
    }
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
  // Reject.
  rejectShowDialog(){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 200,
                width: 300,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 25),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children:  [
                              const Center(
                                  child: Text(
                                    'Comment',
                                    style: TextStyle(
                                        fontSize: 15),
                                  )),
                              const  SizedBox(height:10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(8)),
                                  child: TextFormField(
                                    controller: commentController,
                                    style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration:  const InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding:EdgeInsets.only(left: 15, bottom: 10, top: 18, right: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 120,height: 28,
                                child: OutlinedMButton(
                                  text: 'Reject',
                                  textColor: Colors.red,
                                  borderColor: Colors.red,
                                  onTap: (){
                                    setState(() {
                                      if(estimateItems['items'].isEmpty){
                                        vehicleLineTableData=true;
                                      }
                                      else{
                                        double tempTotal =0;
                                        try{
                                          tempTotal = (double.parse(subAmountTotal.text)+ double.parse(additionalCharges.text));
                                        }
                                        catch(e){
                                          tempTotal = double.parse(subAmountTotal.text);
                                        }
                                        updateEstimate =    {
                                          "additionalCharges": additionalCharges.text,
                                          "address": "string",
                                          "billAddressCity": showVendorDetails==true?vendorData['city']??"":billToCity,
                                          "billAddressName":showVendorDetails==true?vendorData['Name']??"":billToName,
                                          "billAddressState": showVendorDetails==true?vendorData['state']??"":billToState,
                                          "billAddressStreet":showVendorDetails==true?vendorData['street']??"":billToStreet,
                                          "billAddressZipcode": showVendorDetails==true?vendorData['zipcode']??"":billToZipcode,
                                          "serviceDueDate": "",
                                          "estVehicleId": estimateItems['estVehicleId']??"",
                                          "serviceInvoice": salesInvoice.text,
                                          "serviceInvoiceDate": salesInvoiceDate.text,
                                          "shipAddressCity": showWareHouseDetails==true?wareHouse['city']??"":shipToCity,
                                          "shipAddressName": showWareHouseDetails==true?wareHouse['Name']??"":shipToName,
                                          "shipAddressState": showWareHouseDetails==true?wareHouse['state']??"":shipToState,
                                          "shipAddressStreet": showWareHouseDetails==true?wareHouse['street']??"":shipToStreet,
                                          "shipAddressZipcode": showWareHouseDetails==true?wareHouse['zipcode']??"":shipZipcode,
                                          "subTotalAmount": subAmountTotal.text,
                                          "subTotalDiscount": subDiscountTotal.text,
                                          "subTotalTax": subTaxTotal.text,
                                          "termsConditions": termsAndConditions.text,
                                          "total":tempTotal.toString(),
                                          "status":"Rejected",
                                          "comment":commentController.text,
                                          "manager_id": managerId,
                                          "userid": userId,
                                          "org_id": orgId,
                                          "totalTaxableAmount": 0,
                                          "items": [],
                                        };


                                        for(int i=0;i<estimateItems['items'].length;i++){
                                          lineItems.add(
                                              {
                                                "amount": lineAmount[i].text,
                                                "discount":  discountPercentage[i].text,
                                                "estVehicleId": estimateItems['estVehicleId'],
                                                "itemsService": estimateItems['items'][i]['itemsService'],
                                                "priceItem": estimateItems['items'][i]['priceItem'].toString(),
                                                "quantity": units[i].text,
                                                "tax": tax[i].text,
                                              }
                                          );
                                        }
                                        putUpdatedEstimated(updateEstimate);
                                      }
                                    });
                                  },

                                ),
                              ),
                              SizedBox(
                                width: 120,height: 28,
                                child: OutlinedMButton(
                                  text: 'Cancel',
                                  textColor: Colors.green,
                                  borderColor: Colors.green,
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },

                                ),
                              ),
                            ],
                          )
                        ],
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
        );
      },
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