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
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';
class WarrantyDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map estimateItem;
  const WarrantyDetails({Key? key, required this.drawerWidth, required this. selectedDestination, required Duration transitionDuration, required  Duration reverseTransitionDuration, required this.estimateItem}) : super(key: key);

  @override
  State<WarrantyDetails> createState() => _WarrantyDetailsState();
}

class _WarrantyDetailsState extends State<WarrantyDetails> {

  bool loading = false;
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
  bool warrantyLineDataError=false;
  final commentController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    estimateItems=widget.estimateItem;

    userId=estimateItems['userid'];
    commentController.text=estimateItems['comment']??"";


    wareHouse['Name']=estimateItems['shipAddressName']??"";
    wareHouse['city']=estimateItems['shipAddressCity']??"";
    wareHouse['state']=estimateItems['shipAddressState']??"";
    wareHouse['street']=estimateItems['shipAddressStreet']??"";
    wareHouse['zipcode']=estimateItems['shipAddressZipcode']??"";

    vendorData['Name']=estimateItems['billAddressName']??"";
    vendorData['city']=estimateItems['billAddressCity']??"";
    vendorData['state']=estimateItems['billAddressState']??"";
    vendorData['street']=estimateItems['billAddressStreet']??"";
    vendorData['zipcode']=estimateItems['billAddressZipcode']??"";

    additionalCharges.text=estimateItems['additionalCharges'].toString();
    salesInvoiceDate.text=estimateItems['serviceInvoiceDate']??"";
    for(int i=0;i<estimateItems['items'].length;i++){
      selectedVehicles.add(
        {
          "name":estimateItems['items'][i]['itemsService'],
          "selling_price":estimateItems["items"][i]["priceItem"],

        }

      );
      units.add(TextEditingController());
      units[i].text=estimateItems['items'][i]['quantity'].toString();

      approvedPercentage.add(TextEditingController());
      approvedPercentage[i].text= estimateItems['items'][i]['discount'].toString();
      tax.add(TextEditingController());
      tax[i].text=estimateItems['items'][i]['tax'].toString();

      lineAmount.add(TextEditingController());
      lineApprovedAmount.add(TextEditingController());
      lineApprovedAmount[i].text=estimateItems['items'][i]['tax'].toString();
      lineAmount[i].text=estimateItems['items'][i]['amount'].toString();

      subDiscountTotal.text = lineAmount[i].text + approvedPercentage[i].text;
    }
    subDiscountTotal.text=estimateItems['subTotalDiscount'].toString();
    subTaxTotal.text=estimateItems['subTotalTax'].toString();
    subAmountTotal.text=estimateItems['subTotalAmount'].toString();
   // salesInvoiceDate.text=DateFormat('dd/MM/yyyy').format(DateTime.now());
    getAllVehicleVariant();
    fetchVendorsData();
    salesInvoice.text=estimateItems['serviceInvoice']??"";
    termsAndConditions.text=estimateItems['termsConditions']??"";
    getInitialData();
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
  var approvedPercentage = <TextEditingController>[];
  var tax = <TextEditingController>[];
  var lineAmount = <TextEditingController>[];
  var lineApprovedAmount = <TextEditingController>[];
  List items=[];
  Map postDetails={};
  bool newAddress=false;
  bool newShipping=false;
  bool billing=true;
  Map selectedItems={};
  String ?authToken;




  String role ='';
  String userId ='';
  String managerId ='';
  String orgId ='';
  bool quantity=false;
  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
    role= prefs.getString("role")??"";
    managerId= prefs.getString("managerId")??"";
    orgId= prefs.getString("orgId")??"";
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
                    title: const Text("Warranty Details"),
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
                                    if(selectedVehicles.isEmpty){
                                      warrantyLineDataError=true;
                                    }
                                    else{
                                      double tempTotal=0;
                                      try{
                                        tempTotal = (double.parse(subAmountTotal.text)+ double.parse(additionalCharges.text));
                                      }
                                      catch(e){
                                        tempTotal = double.parse(subAmountTotal.text);
                                      }
                                      updateEstimate =    {
                                        "additionalCharges": additionalCharges.text,
                                        "address": "string",
                                        "billAddressCity": vendorData['city']??"",
                                        "billAddressName":vendorData['Name']??"",
                                        "billAddressState": vendorData['state']??"",
                                        "billAddressStreet":vendorData['street']??"",
                                        "billAddressZipcode": vendorData['zipcode']??"",
                                        "serviceDueDate": "",
                                        "estVehicleId": estimateItems['estVehicleId']??"",
                                        "serviceInvoice": salesInvoice.text,
                                        "serviceInvoiceDate": salesInvoiceDate.text,
                                        "shipAddressCity":wareHouse['city']??"",
                                        "shipAddressName": wareHouse['Name']??"",
                                        "shipAddressState": wareHouse['state']??"",
                                        "shipAddressStreet": wareHouse['street']??"",
                                        "shipAddressZipcode": wareHouse['zipcode']??"",
                                        "subTotalAmount": subAmountTotal.text,
                                        "subTotalDiscount": subDiscountTotal.text,
                                        "subTotalTax": subTaxTotal.text,
                                        "status":"Approved",
                                        "comment":estimateItems['comment']??"",
                                        "termsConditions": termsAndConditions.text,
                                        "total": tempTotal.toString(),
                                        "totalTaxableAmount": 0,
                                        "manager_id": managerId,
                                        "userid": userId,
                                        "org_id": orgId,
                                        "items": [],
                                      };
                                      for(int i=0;i<selectedVehicles.length;i++){
                                        updateEstimate['items'].add(
                                            {
                                              "amount": lineAmount[i].text,
                                              "discount":  approvedPercentage[i].text,
                                              "estVehicleId": estimateItems['estVehicleId'],
                                              "itemsService":selectedVehicles[i]['name']??""+" - "+selectedVehicles[i]['description']??"",
                                              "priceItem": selectedVehicles[i]['selling_price'].toString(),
                                              "quantity": units[i].text,
                                              "tax": lineApprovedAmount[i].text,
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

                                  if(selectedVehicles.isEmpty){
                                    warrantyLineDataError=true;
                                  }
                                  else{
                                    double tempTotal=0;
                                    try{
                                      tempTotal = (double.parse(subAmountTotal.text)+ double.parse(additionalCharges.text));
                                    }
                                    catch(e){
                                      tempTotal = double.parse(subAmountTotal.text);
                                    }
                                    updateEstimate =    {
                                      "additionalCharges": additionalCharges.text,
                                      "address": "string",
                                      "billAddressCity": vendorData['city']??"",
                                      "billAddressName":vendorData['Name']??"",
                                      "billAddressState": vendorData['state']??"",
                                      "billAddressStreet":vendorData['street']??"",
                                      "billAddressZipcode": vendorData['zipcode']??"",
                                      "serviceDueDate": "",
                                      "estVehicleId": estimateItems['estVehicleId']??"",
                                      "serviceInvoice": salesInvoice.text,
                                      "serviceInvoiceDate": salesInvoiceDate.text,
                                      "shipAddressCity": wareHouse['city']??"",
                                      "shipAddressName": wareHouse['Name']??"",
                                      "shipAddressState": wareHouse['state']??"",
                                      "shipAddressStreet": wareHouse['street']??"",
                                      "shipAddressZipcode": wareHouse['zipcode']??"",
                                      "subTotalAmount": subAmountTotal.text,
                                      "subTotalDiscount": subDiscountTotal.text,
                                      "subTotalTax": subTaxTotal.text,
                                      "status":estimateItems['status']??"In-review",
                                      "comment":"",
                                      "termsConditions": termsAndConditions.text,
                                      "total": tempTotal.toString(),
                                      "totalTaxableAmount": 0,
                                      "manager_id": managerId,
                                      "userid": userId,
                                      "org_id": orgId,
                                      "items": [],
                                    };
                                    for(int i=0;i<selectedVehicles.length;i++){
                                      updateEstimate['items'].add(
                                          {
                                            "amount": lineAmount[i].text,
                                            "discount":  approvedPercentage[i].text,
                                            "estVehicleId": estimateItems['estVehicleId'],
                                            "itemsService": "${selectedVehicles[i]['name']}${selectedVehicles[i]['description']==null?"":" - ${selectedVehicles[i]['description']}"}",
                                            "priceItem": selectedVehicles[i]['selling_price'].toString(),
                                            "quantity": units[i].text,
                                            "tax": lineApprovedAmount[i].text,
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
                                   // showVendorDetails=false;
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
                                  //showVendorDetails=true;
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
                          if(estimateItems.isNotEmpty)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {

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

                                  wareHouse ={
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
                                                String formattedDate=DateFormat('dd/MM/yyyy').format(pickedDate);
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
                  Expanded(flex: 2,child: Center(child: Text("Price/Item"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Text("Approved %"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 3,child: Center(child: Text("Approved Amount"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Text("Amount"))),
                  SizedBox(width: 30,height: 30,),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder,),
          ),

          ///Row Items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedVehicles.length,
            itemBuilder: (context, index) {


              double tempTax =0;
              double tempLineData=0;
              double tempDiscount=0;
              lineAmount[index].text="0.0";

              if(approvedPercentage[index].text.isNotEmpty) {
                try{
                  tempDiscount = ((double.parse(approvedPercentage[index].text)/100) *  double.parse(selectedVehicles[index]['selling_price'].toString()));
                  tempLineData =(tempDiscount);
                  lineApprovedAmount[index].text =tempDiscount.toStringAsFixed(1);
                  tempTax = ((double.parse(tax[index].text)/100) *  double.parse( lineAmount[index].text));
                  lineAmount[index].text =(double.parse((tempLineData).toStringAsFixed(1))*double.parse(units[index].text)).toStringAsFixed(1);
                }
                catch(e){
                  log("Inside try block $e");
                }
              }
              else if (lineApprovedAmount[index].text.isNotEmpty) {
                try {
                  tempTax=double.parse(lineApprovedAmount[index].text)/double.parse(selectedVehicles[index]['selling_price'].toString())*100;
                  approvedPercentage[index].text = tempTax.toStringAsFixed(4);
                  lineAmount[index].text=(double.parse(lineApprovedAmount[index].text)*double.parse(units[index].text)).toStringAsFixed(1);
                  if(double.parse(approvedPercentage[index].text)>100){
                    approvedPercentage[index].text ="0.0";
                    lineApprovedAmount[index].text="0.0";
                    lineAmount[index].text="0.0";
                  }
                } catch (e) {
                  log(e.toString());
                }
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
                          Expanded(flex: 4,child: Center(child: Text("${selectedVehicles[index]['name']}"))),
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
                                      approvedPercentage[index].text='0';
                                    });
                                  },
                                )),
                          )),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(flex: 2,child: Center(child: Text("${selectedVehicles[index]['selling_price']}"))),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),

                          Expanded(flex: 2,child:  Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child: TextField(
                                controller: approvedPercentage[index],
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
                                  double tempValue =0.0;
                                  setState(() {
                                    lineApprovedAmount[index].clear();
                                    lineAmount[index].clear();
                                  });

                                  if(v.isNotEmpty||v!=''){
                                    try{
                                      tempValue = double.parse(v.toString());
                                      if(tempValue>100){
                                        approvedPercentage[index].clear();
                                      }
                                    }
                                    catch(e){
                                      approvedPercentage[index].clear();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),

                          Expanded(flex: 3,child:  Padding(
                            padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                            child: Container(
                              decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                              height: 32,
                              child: TextField(
                                controller: lineApprovedAmount[index],
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                    hintText: "Approved Amount",
                                    hintStyle: TextStyle(fontSize: 12),
                                    contentPadding: EdgeInsets.only(bottom: 12,right: 8,top: 2),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent))
                                ),
                                onChanged: (v) {
                                  setState(() {

                                    approvedPercentage[index].clear();
                                    lineAmount[index].clear();

                                  });

                                },
                              ),
                            ),
                          ),),
                          const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                          Expanded(flex: 2,child: Center(child: Padding(
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
                              selectedVehicles.removeAt(index);
                              units.removeAt(index);
                              approvedPercentage.removeAt(index);
                              tax.removeAt(index);
                              lineAmount.removeAt(index);
                              lineApprovedAmount.removeAt(index);

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
                                borderColor: warrantyLineDataError==true? Colors.red: mSaveButton,
                                textColor: mSaveButton,
                                onTap: () {
                                  if(selectedVehicles.isNotEmpty){
                                    warrantyLineDataError=false;
                                  }
                                  brandNameController.clear();
                                  modelNameController.clear();
                                  variantController.clear();
                                  displayList=vehicleList;
                                  showDialog(
                                      context: context,
                                      builder: (context) => showDialogBox()).then((value) {
                                    if(value!=null){
                                      setState(() {
                                        units.add(TextEditingController(text: '1'));
                                        approvedPercentage.add(TextEditingController(text:'0'));
                                        tax.add(TextEditingController(text:"0"));
                                        lineAmount.add(TextEditingController());
                                        lineApprovedAmount.add(TextEditingController());
                                        subAmountTotal.text="0";
                                        selectedVehicles.add(value);
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
              if(warrantyLineDataError==true)
                const Padding(
                  padding: EdgeInsets.only(left:200),
                  child: Text("Please Add Warranty Line Data",style: TextStyle(color: Colors.red),),
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
                  // Expanded(child: Center(child: Builder(
                  //     builder: (context) {
                  //       return Text("₹ ${subDiscountTotal.text.isEmpty?0:subDiscountTotal.text}");
                  //     }
                  // ))),
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
                                    Expanded(child: Text("Name")),
                                    Expanded(child: Text("Description")),
                                    Expanded(child: Text("Unit")),
                                    Expanded(child: Text("Price")),
                                    Expanded(child: Text("Type")),
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
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/get_all_newitem";
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
      final response=await http.put(Uri.parse('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/update_parts_warranty'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(updatedEstimated)
      );
      if(response.statusCode==200){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Updated')));
          Navigator.of(context).pushNamed(MotowsRoutes.warrantyRoutes);
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
  deleteLineItem(estimateItemId, int index)async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/delete_parts_warranty_line_item_by_id/$estimateItemId';
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
          tax.removeAt(index);
          lineApprovedAmount.removeAt(index);
          lineAmount.removeAt(index);
         // estimateItems['items']=[];
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content:  Text('Data Deleted'),)
          // );
        });
      }
    }
    catch(e){
      log(e.toString());
    }
  }
  deleteEstimateItemData(estVehicleId)async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/delete_parts_warranty_by_id/$estVehicleId';
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
          Navigator.of(context).pushNamed(MotowsRoutes.warrantyRoutes);
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
                                      if(selectedVehicles.isEmpty){
                                        warrantyLineDataError=true;
                                      }
                                      else{
                                        double tempTotal=0;
                                        try{
                                          tempTotal = (double.parse(subAmountTotal.text)+ double.parse(additionalCharges.text));
                                        }
                                        catch(e){
                                          tempTotal = double.parse(subAmountTotal.text);
                                        }
                                        updateEstimate =    {
                                          "additionalCharges": additionalCharges.text,
                                          "address": "string",
                                          "billAddressCity": vendorData['city']??"",
                                          "billAddressName":vendorData['Name']??"",
                                          "billAddressState": vendorData['state']??"",
                                          "billAddressStreet":vendorData['street']??"",
                                          "billAddressZipcode": vendorData['zipcode']??"",
                                          "serviceDueDate": "",
                                          "estVehicleId": estimateItems['estVehicleId']??"",
                                          "serviceInvoice": salesInvoice.text,
                                          "serviceInvoiceDate": salesInvoiceDate.text,
                                          "shipAddressCity": wareHouse['city']??"",
                                          "shipAddressName": wareHouse['Name']??"",
                                          "shipAddressState": wareHouse['state']??"",
                                          "shipAddressStreet":wareHouse['street']??"",
                                          "shipAddressZipcode": wareHouse['zipcode']??"",
                                          "subTotalAmount": subAmountTotal.text,
                                          "subTotalDiscount": subDiscountTotal.text,
                                          "subTotalTax": subTaxTotal.text,
                                          "status":"Rejected",
                                          "comment":commentController.text,
                                          "termsConditions": termsAndConditions.text,
                                          "total": tempTotal.toString(),
                                          "totalTaxableAmount": 0,
                                          "manager_id": managerId,
                                          "userid": userId,
                                          "org_id": orgId,
                                          "items": [],
                                        };
                                        for(int i=0;i<selectedVehicles.length;i++){
                                          updateEstimate['items'].add(
                                              {
                                                "amount": lineAmount[i].text,
                                                "discount":  approvedPercentage[i].text,
                                                "estVehicleId": estimateItems['estVehicleId'],
                                                "itemsService": selectedVehicles[i]['name']??"" +" - "+selectedVehicles[i]['description']??"",
                                                "priceItem": selectedVehicles[i]['selling_price'].toString(),
                                                "quantity": units[i].text,
                                                "tax": lineApprovedAmount[i].text,
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