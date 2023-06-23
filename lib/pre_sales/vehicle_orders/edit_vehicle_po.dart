import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../classes/models/search_models.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../widgets/input_decoration_text_field.dart';



class EditVehiclePurchaseOrder extends StatefulWidget {

  final double drawerWidth;
  final double selectedDestination;
  final Map poList;
  const EditVehiclePurchaseOrder({Key? key, required this.selectedDestination, required this.drawerWidth,required this.poList}) : super(key: key);

  @override
  _EditPurchaseOrderState createState() => _EditPurchaseOrderState();
}

class _EditPurchaseOrderState extends State<EditVehiclePurchaseOrder> {

  final _addPurchaseForm = GlobalKey<FormState>();




  Future<List> fetchModel()async{
    await Future.delayed(Duration(milliseconds: 100));
    List _list1 = [];
    // String _inputText = vendorName.text;
    for(int i=0;i<modelList.length;i++) {
      _list1.add( ModelData.fromJson(modelList[i]));
    }

    return _list1;
  }

  Future<List> fetchVariant()async{
    await Future.delayed(Duration(milliseconds: 100));
    List _list1 = [];
    // String _inputText = vendorName.text;
    for(int i=0;i<variantList.length;i++) {
      _list1.add( VariantData.fromJson(variantList[i]));
    }

    return _list1;
  }

  Future<List> fetchBrand()async{
    await Future.delayed(Duration(milliseconds: 100));
    List _list1 = [];
    // String _inputText = vendorName.text;
    for(int i=0;i<brandList.length;i++) {
      _list1.add( ItemData.fromJson(brandList[i]));
    }

    return _list1;
  }



  Future fetchVendorsData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_all_new_vendor';
    try {
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vendorList = value;
            // print('------fetchVendorsData-----');
            // print(vendorList);
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context: context, response: response,exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  String poNo='';
//This Is Fetch Tax Code Percentage.
  List taxList=[];


  Future fetchTaxData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/tax/get_all_tax';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            taxList = value;
            // print('-----------fetch Tax Data -----------');
            // print(taxList);
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



  Future fetchBrandData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/get_all_new_vehicle_brand';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            brandList = value;
            poNumber.text="PO-${DateTime.now().hour}${DateTime.now().microsecondsSinceEpoch}";
            // print('----------fetchBrandData---------');
            // print(brandList);
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }



  Future fetchModelData(name) async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/get_new_vehicle_model_by_brand/$name';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            modelList = value;
            // print('----------fetch model data-----');
            // print(modelList);
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




  Future fetchVariantData(name) async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclevarient/get_new_vehicle_by_varient/$name';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            variantList = value;
            // print('-----------fetchVariantData-----------');
            // print(variantList);
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }

  List vvList = [];
  String editVariantId = "";


  Future getAllVehicleVariant() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclevarient/get_new_veh_varient_by_id/$editVariantId';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vvList = value;
            // print('---------getAllVehicleVariant---------');
            // print(vvList);
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



  Future getAllPurchaseLine() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchaseline/get_vehicle_purchase_details/$editVariantId';
    // print('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchaseline/get_vehicle_purchase_details/$editVariantId');
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vvList = value;
            // print('-------getAllPurchaseLine------');
            // print(vvList);
            // vvList = jsonDecode(response.body);

            // print(vvList[0]['brand']);
            brandController[0].text =  vvList[0]['brand'];
            modelController[0].text = vvList[0]['model'];
            variantController[0].text = vvList[0]['varient'];
            colorController[0].text = vvList[0]['color'];
            unitController[0].text = vvList[0]['unit_price'].toString();
            discountController[0].text = vvList[0]['discount'].toString();
            selectedQuantity[0] = vvList[0]['quantity'].toString();
            amountController[0].text = vvList[0]['amount'].toString();
            taxCode[0].text = vvList[0]['tax_code'].toString();
            totalTaxValueController[0].text = vvList[0]['tax_amount'].toString();
            vvList[0]['recieved_quantity'] = '';
            vvList[0]['short_quantity'] = '';
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }

  Future<List> fetchData()async{

    await Future.delayed(Duration(milliseconds: 100));
    List _list = [];
    // String _inputText = vendorName.text;
    for(int i=0;i<vendorList.length;i++) {
      _list.add( VendorData.fromJson(vendorList[i]));
    }

    return _list;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1999, 8),
        lastDate: DateTime(2101));
    if (picked != null ) {
      setState(() {
        expDeliveryDate.text = (picked.toLocal()).toString().split(' ')[0];
      });
    }
  }



  Future getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("++++++++++++++++++++++");
    // print(widget.poList);
    editVariantId = widget.poList['new_pur_vehi_id'];
    // print(editVariantId);

    getInitialData().whenComplete(() {
      fetchBrandData();
      fetchVendorsData();
      fetchTaxData();
      getAllPurchaseLine();
      // fetchItemData();
    });

    brandController.add(TextEditingController());
    modelController.add(TextEditingController());
    colorController.add(TextEditingController());
    variantController.add(TextEditingController());
    uiTableData.add({});
    unitController.add(TextEditingController());
    discountController.add(TextEditingController());
    taxController.add(TextEditingController());
    taxCode.add(TextEditingController());

    itemDetailsController.add(TextEditingController());
    rateController.add(TextEditingController());
    totalTaxValueController.add(TextEditingController());
    sGstController.add(TextEditingController());

    amountController.add(TextEditingController());
    amountValueController.add(TextEditingController());
    discountAmountController.add(0.0);
    discountUnitController.add(0.0);
    itemVal.add(0);
    cGstVal.add(0);
    sGstVal.add(0);
    selectedQuantity.add("1");
    selectedColor.add("Black");
    taxQuantity.add('10');


    vendorName.text=widget.poList['vendor_name'];
    vendorBillingAddress.text=widget.poList['billing_address'];
    vendorShippingAddress.text=widget.poList['shipping_address'];
    referenceNo.text=widget.poList['reference'];
    expDeliveryDate.text=widget.poList['expected_delivery_date'];
    shipmentReferenceNo.text=widget.poList['shipment_preference'];
    gTotal=widget.poList['base_price'];
    gTATotal=widget.poList['tax'];
    gTotalTotal=widget.poList['grand_total'];
    discountValue=widget.poList['discounted_price'];
    customerNotes.text=widget.poList['customer_notes'];
    termsAndConditions.text= widget.poList['terms_conditions'];
    freightController.text = widget.poList['freight_amount'].toString();

  }
  //This IS For Tax Code.
  final taxCode=<TextEditingController>[];
  String? dropDownValue;
  String? orgVal;
  String? custVal;
  double total=0.0;
  double grandTotal=0.0;
  double grandTotal1=0.0;

  List vendorList = [

  ];
  bool loading = false;

  List brandList = [];

  List modelList =[];
  List variantList =[];

  Map gstValues={
    "cGst4":0.0,
    "sGst4":0.0,
    "cGst6":0.0,
    "sGst6":0.0,
    "cGst9":0.0,
    "sGst9":0.0,
    "cGst14":0.0,
    "sGst14":0.0,
  };

  List uiTableData=[];

  var itemSelected=[];

  List tableData =[0];
  final _quantity = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"];
  // final _color = ["Black","Blue","White","Grey","Silver"];
  // final _taxCode = ["10","20","30","40","50"];

  bool vendorNameError = false;
  bool purchaseOrderError = false;
  bool referenceError = false;
  bool expectedDeliveryError = false;
  bool shipmentPreError = false;
  bool customerNotesError = false;
  bool termsError = false;

  double discountValue=0.0;

  var itemDetailsController = <TextEditingController>[];
  var brandController = <TextEditingController>[];
  var colorController = <TextEditingController>[];
  var modelController = <TextEditingController>[];
  var variantController = <TextEditingController>[];
  var unitController = <TextEditingController>[];
  var discountController = <TextEditingController>[];
  var taxController = <TextEditingController>[];

  var taxQuantity= <String>[];

  String? selectedItems;
  String? authToken;

  var rateController = <TextEditingController>[];
  var totalTaxValueController = <TextEditingController>[];

  var sGstController = <TextEditingController>[];
  var selectedQuantity= <String>[];
  var selectedColor= <String>[];
  var cGstVal = <double>[];
  var sGstVal = <double>[];
  var itemVal = <double>[];

  var amountController = <TextEditingController>[];
  var amountValueController = <TextEditingController>[];
  var discountAmountController = <double>[];
  var discountUnitController = <double>[];
  double gTotal = 0.0;
  double gTATotal = 0.0;
  double gTotalTotal = 0.0;
  double gDiscount = 0.0;

  TextEditingController myController = TextEditingController();

  final poNumber = TextEditingController();
  final vendorName = TextEditingController();
  final vendorBillingAddress = TextEditingController();
  final vendorShippingAddress = TextEditingController();
  final customerNotes = TextEditingController();
  final termsAndConditions = TextEditingController();
  final referenceNo = TextEditingController();
  final expDeliveryDate = TextEditingController();
  final shipmentReferenceNo = TextEditingController();
  var freightController = TextEditingController();

  // final discountController = TextEditingController();

  // final _horizontalScrollController = ScrollController();

  String poId ="";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(backgroundColor: Colors.white,

              body: SingleChildScrollView(
                  child: Form(
                    key: _addPurchaseForm,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        //------header-----
                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: Container(
                            color: const Color(0xffF4FAFF),
                            child: Column(
                              children: [
                                Container(height: 60,color: Colors.white,child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Edit Purchase Order",style: TextStyle(color: Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                )),
                                const SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 160,
                                                  child:  Text('Vendor Name',style: TextStyle(color: Colors.red[900]),)),
                                              Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Container(
                                                      width: 290,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                          borderRadius: BorderRadius.circular(5.0)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15,bottom: 10),
                                                        child: TextFieldSearch(
                                                          textStyle: const TextStyle(fontSize: 16),
                                                          decoration: const InputDecoration(
                                                            border: InputBorder.none,
                                                          ),
                                                          controller: vendorName,
                                                          future: (){
                                                            return fetchData();
                                                          },
                                                          getSelectedValue: (VendorData newValue){
                                                            vendorName.text=newValue.firstName;

                                                            vendorBillingAddress.text=newValue.billing_address_address+", "+newValue.billing_address_city+", "+newValue.billing_address_state+", "+newValue.billing_address_country+", "+newValue.billing_address_zip_code;
                                                            vendorShippingAddress.text=newValue.shipping_address_street1+", "+newValue.shipping_address_street2+", "+newValue.shipping_address_city+", "+newValue.shipping_address_state+", "+newValue.shipping_address_country+", "+newValue.shipping_address_zip_code;
                                                          }, label: '',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if(vendorNameError)
                                                    const Padding(
                                                      padding: EdgeInsets.fromLTRB(15, 4, 0, 0),
                                                      child: Text('Required',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 160,
                                                  child:  Text('Pay To Address',style: TextStyle(color: Colors.red[900]),)),
                                              Container(
                                                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.grey)),
                                                height: 80,width: 290,
                                                child: TextFormField(
                                                  style: const TextStyle(fontSize: 16),
                                                  readOnly: true,
                                                  controller:vendorBillingAddress,
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: 4,minLines: 4,
                                                  decoration:  const InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    contentPadding:EdgeInsets.only(left: 15, bottom: 10, top: 11, right: 15),
                                                    // hintText: (verifyLabel.validateLabel("templesHistory"))),
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     setState(() {
                                                    //     });
                                                    //   }
                                                    //   return null;
                                                    // },
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 160,
                                                  child:  Text('Ship To Address',style: TextStyle(color: Colors.red[900]),)),
                                              Container(
                                                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.grey)),
                                                height: 80,width: 290,
                                                child: TextFormField(
                                                  style: const TextStyle(fontSize: 16),
                                                  readOnly: true,
                                                  controller: vendorShippingAddress,
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: 4,minLines: 4,
                                                  decoration:  const InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    contentPadding:EdgeInsets.only(left: 15, bottom: 10, top: 11, right: 15),
                                                    // hintText: (verifyLabel.validateLabel("templesHistory"))),
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     setState(() {
                                                    //     });
                                                    //   }
                                                    //   return null;
                                                    // },
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 160,
                                                  child:  Text('Purchase Order #',style: TextStyle(color: Colors.red[900]),)),
                                              Container(
                                                width: 290,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    border: Border.all(
                                                      color:  Colors.grey,
                                                    )
                                                ),
                                                child:   Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 8),
                                                  child: TextField(
                                                    style: const TextStyle(fontSize: 16),
                                                    controller: poNumber,
                                                    textAlignVertical: TextAlignVertical.center,
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 200,
                                                  child:  Text('Reference #',style: TextStyle(),)),
                                              Container(
                                                color: Colors.white,
                                                width: 290,
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: referenceError?50:35,
                                                  child: TextFormField(
                                                    validator: (value){
                                                      if(value == null || value.isEmpty){
                                                        setState(() {
                                                          referenceError = true;
                                                        });
                                                        return "Required";
                                                      }
                                                      else{
                                                        setState(() {
                                                          referenceError == false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(fontSize: 16),
                                                    onChanged: (text){
                                                      setState(() {

                                                      });
                                                    },
                                                    controller: referenceNo,
                                                    decoration: decorationInput5('', referenceNo.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 200,
                                                  child:  Text('Expected Delivery Date',style: TextStyle(),)),
                                              Container(
                                                color: Colors.white,
                                                width: 290,
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: expectedDeliveryError?50:35,
                                                  child: TextFormField(
                                                    validator: (value){
                                                      if(value == null || value.isEmpty){
                                                        setState(() {
                                                          expectedDeliveryError = true;
                                                        });
                                                        return "Required";
                                                      }
                                                      else{
                                                        setState(() {
                                                          expectedDeliveryError == false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onTap: (){
                                                      _selectDate(context);
                                                    },
                                                    readOnly: true,
                                                    style: const TextStyle(fontSize: 16),
                                                    onChanged: (text){
                                                      setState(() {

                                                      });
                                                    },
                                                    controller: expDeliveryDate,
                                                    decoration: decorationInput5('', expDeliveryDate.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 200,
                                                  child:  Text('Shipment Preference',style: TextStyle(),)),
                                              Container(
                                                color: Colors.white,
                                                width: 290,
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: shipmentPreError?50:35,
                                                  child: TextFormField(
                                                    validator: (value){
                                                      if(value == null || value.isEmpty){
                                                        setState(() {
                                                          shipmentPreError = true;
                                                        });
                                                        return "Required";
                                                      }
                                                      else{
                                                        setState(() {
                                                          shipmentPreError == false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(fontSize: 16),
                                                    onChanged: (text){
                                                      setState(() {

                                                      });
                                                    },
                                                    controller: shipmentReferenceNo,
                                                    decoration: decorationInput5('', shipmentReferenceNo.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ),
                        //------table------
                        // ListView(
                        //   scrollDirection: Axis.vertical,
                        //   shrinkWrap: true,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 50,right: 50,top: 20,bottom: 20),
                        //       child: DataTable(
                        //         headingRowHeight: 35,
                        //         headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState>states) {
                        //           return Colors.blue;
                        //         }),
                        //         columns: const [
                        //           DataColumn(
                        //             label:
                        //             SizedBox(width: 100, child: Text("Variant",style: TextStyle(color: Colors.white),)),
                        //           ),
                        //           DataColumn(
                        //             label: SizedBox(
                        //                 width: 70, child: Text('Unit Price',style: TextStyle(color: Colors.white),)),
                        //           ),
                        //           DataColumn(
                        //             label: SizedBox(
                        //                 width: 70, child: Text('Discount %',style: TextStyle(color: Colors.white),)),
                        //           ),
                        //           DataColumn(
                        //             label: SizedBox(width: 40, child: Text('Qty',style: TextStyle(color: Colors.white),)),
                        //           ),
                        //           DataColumn(
                        //             label:
                        //             SizedBox(width: 50, child: Text('Amount',style: TextStyle(color: Colors.white),)),
                        //           ),
                        //           DataColumn(
                        //             label: SizedBox(
                        //                 width: 100, child: Text('TaX Percentage',style: TextStyle(color: Colors.white),)),
                        //           ),
                        //           DataColumn(
                        //             label: SizedBox(
                        //                 width: 80, child: Text('Tax Amount',style: TextStyle(color: Colors.white),)),
                        //           ),
                        //         ],
                        //         rows: List<DataRow>.generate(
                        //           tableData.length,
                        //               (int index) => DataRow(
                        //
                        //             cells: <DataCell>[
                        //
                        //               //----- variant -------
                        //               DataCell(
                        //                 SizedBox(
                        //                   width: 100,
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.only(left: 5,bottom: 10),
                        //                     child:TextField(
                        //                       enabled: false,
                        //                       readOnly: true,
                        //                       controller: variantController[index],
                        //                       decoration: const InputDecoration(
                        //                         border: InputBorder.none,
                        //                       ),
                        //                       onTap: () {
                        //                         showDialog(
                        //                           context: context,
                        //                           builder: (context) =>
                        //                               AlertDialog(
                        //                                 title: Row(
                        //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                                   children: [
                        //                                     const Text('Select Vehicle'),
                        //                                     InkWell(
                        //                                       child: const Icon(Icons.close_sharp,color: Colors.red),
                        //                                       onTap: () {
                        //                                         Navigator.pop(context);
                        //                                       },
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                                 content: SizedBox(
                        //                                   width: 500,
                        //                                   height: 300,
                        //                                   child: Column(
                        //                                     children: [
                        //                                       Expanded(
                        //                                         child: RawScrollbar(
                        //                                           thumbColor: Colors.black45,
                        //                                           radius: const Radius.circular(5.0),
                        //                                           thumbVisibility: true,
                        //                                           thickness: 10.0,
                        //                                           child: ListView(
                        //                                             shrinkWrap: true,
                        //                                             padding: const EdgeInsets.all(10.0),
                        //                                             children: [
                        //                                               Container(
                        //                                                 height: 40,
                        //                                                 color: Colors.grey[200],
                        //                                                 child: Row(
                        //                                                   children:  const [
                        //                                                     Expanded(child: Center(child: Text("BRAND"))),
                        //                                                     Expanded(child: Center(child: Text("MODEL"))),
                        //                                                     Expanded(child: Center(child: Text("VARIANT"))),
                        //                                                     Expanded(child: Center(child: Text("ON ROAD PRICE"))),
                        //                                                     Expanded(child: Center(child: Text("COLOR"))),
                        //                                                   ],
                        //                                                 ),
                        //                                               ),
                        //                                               const SizedBox(height: 20,),
                        //                                               for(int i=0; i<vvList.length; i++)
                        //                                                 InkWell(
                        //                                                   onTap: () {
                        //                                                     setState(() {
                        //                                                       brandController[index].text=vvList[i]['make'];
                        //                                                       modelController[index].text=vvList[i]['model_name'];
                        //                                                       variantController[index].text=vvList[i]['varient'];
                        //                                                       discountController[index].text = '0';
                        //                                                       unitController[index].text=vvList[i]['onroad_price'].toString();
                        //                                                       amountController[index].text=vvList[i]['onroad_price'].toString();
                        //                                                       amountValueController[index].text=vvList[i]['onroad_price'].toString();
                        //                                                       colorController[index].text=vvList[i]['varient_color1'];
                        //                                                       Navigator.of(context).pop();
                        //                                                     });
                        //                                                   },
                        //                                                   child: Column(
                        //                                                     children: [
                        //                                                       Row(
                        //                                                         children: [
                        //                                                           Expanded(
                        //                                                             child: Center(
                        //                                                               child: Padding(
                        //                                                                 padding: const EdgeInsets.all(8.0),
                        //                                                                 child: SizedBox(
                        //                                                                   height: 30,
                        //                                                                   child: Text(vvList[i]['make']),
                        //                                                                 ),
                        //                                                               ),
                        //                                                             ),
                        //                                                           ),
                        //                                                           Expanded(
                        //                                                             child: Center(
                        //                                                               child: Padding(
                        //                                                                 padding: const EdgeInsets.all(8.0),
                        //                                                                 child: SizedBox(
                        //                                                                   height: 30,
                        //                                                                   child: Text(vvList[i]['model_name']),
                        //                                                                 ),
                        //                                                               ),
                        //                                                             ),
                        //                                                           ),
                        //                                                           Expanded(
                        //                                                             child: Center(
                        //                                                               child: Padding(
                        //                                                                 padding: const EdgeInsets.all(8.0),
                        //                                                                 child: SizedBox(
                        //                                                                   height: 30,
                        //                                                                   child: Text(vvList[i]['varient']),
                        //                                                                 ),
                        //                                                               ),
                        //                                                             ),
                        //                                                           ),
                        //                                                           Expanded(
                        //                                                             child: Center(
                        //                                                               child: Padding(
                        //                                                                 padding: const EdgeInsets.all(8.0),
                        //                                                                 child: SizedBox(
                        //                                                                   height: 30,
                        //                                                                   child: Text(vvList[i]['onroad_price'].toString()),
                        //                                                                 ),
                        //                                                               ),
                        //                                                             ),
                        //                                                           ),
                        //                                                           Expanded(
                        //                                                             child: Center(
                        //                                                               child: Padding(
                        //                                                                 padding: const EdgeInsets.all(8.0),
                        //                                                                 child: SizedBox(
                        //                                                                   height: 30,
                        //                                                                   child: Text(vvList[i]['varient_color1']),
                        //                                                                 ),
                        //                                                               ),
                        //                                                             ),
                        //                                                           ),
                        //                                                         ],
                        //                                                       )
                        //                                                     ],
                        //                                                   ),
                        //                                                 ),
                        //                                             ],
                        //                                           ),
                        //                                         ),
                        //                                       )
                        //                                     ],
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                         );
                        //                       },
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //               DataCell(
                        //                   SizedBox(
                        //                       width: 100,
                        //                       child: TextFormField(
                        //
                        //                         controller: unitController[index],
                        //                         decoration: const InputDecoration(
                        //                           border: InputBorder.none,
                        //                         ),
                        //                       ))
                        //               ),
                        //               //discount %
                        //               DataCell(
                        //                   SizedBox(
                        //                       width: 100,
                        //                       child: TextFormField(
                        //                         controller: discountController[index],
                        //                         decoration: const InputDecoration(
                        //                           border: InputBorder.none,
                        //                         ),
                        //                         onChanged: (val){
                        //                           if(val.isEmpty || val ==''||variantController[index].text.isEmpty){
                        //                             amountController[index].text =unitController[index].text;
                        //                             discountController[index].text='';
                        //                           }
                        //                           else{
                        //                             setState(() {
                        //                               var tempDis = 0.0;
                        //                               discountValue = 0.0;
                        //                               tempDis = (double.parse(val) / 100) * double.parse(unitController[index].text);
                        //
                        //                               discountAmountController[index] = tempDis;
                        //                               discountUnitController[index] = tempDis;
                        //                               for(int i=0; i<discountAmountController.length; i++){
                        //                                 discountValue = discountValue+discountAmountController[i];
                        //                               }
                        //                               // discountValue=(double.parse(val)/100)*double.parse(unitController[index].text);
                        //                               amountController[index].text=(double.parse(unitController[index].text) - (double.parse(val)/100)*double.parse(unitController[index].text)).toString();
                        //                               amountValueController[index].text=(double.parse(unitController[index].text) - (double.parse(val)/100)*double.parse(unitController[index].text)).toString();
                        //                             });
                        //                           }
                        //
                        //                         },
                        //                       ))
                        //               ),
                        //               DataCell(
                        //                   variantController[index].text.isNotEmpty || variantController[index].text!="" ?
                        //
                        //                   SizedBox(
                        //                     width: 45,
                        //                     child: DropdownButton(
                        //                         value: selectedQuantity[index],
                        //                         items: _quantity.map((String items) {
                        //                           return DropdownMenuItem(
                        //                               value: items,
                        //                               child: Text(items)
                        //                           );
                        //                         }
                        //                         ).toList(),
                        //                         onChanged: (String? newValue){
                        //                           setState(() {
                        //                             // print('-------------');
                        //                             // print(newValue);
                        //                             discountValue = 0.0;
                        //                             selectedQuantity[index] = newValue!;
                        //                             // print(selectedQuantity[index]);
                        //                             amountController[index].text = (double.parse(newValue)*double.parse(amountValueController[index].text)).toString();
                        //
                        //                             var tempValue= discountUnitController[index]*double.parse(selectedQuantity[index]);
                        //                             discountAmountController[index] =tempValue;
                        //
                        //                             for(int i=0; i<discountAmountController.length; i++){
                        //                               discountValue = discountValue + discountAmountController[index];
                        //                             }
                        //                             print(tempValue);
                        //
                        //                             // double taxVal = 0.0;
                        //                             // taxVal = (double.parse(taxQuantity[index])/100)*double.parse(unitController[index].text);
                        //                             // totalTaxValueController[index].text = taxVal.toString();
                        //                             // grandTotal = taxVal + double.parse(totalTaxValueController[0].text) + double.parse(amountController[0].text);
                        //                             grandTotal1 = grandTotal;
                        //                           });
                        //                         }
                        //                     ),
                        //                   ):
                        //                   SizedBox(
                        //                       width: 50,
                        //                       child: Container())
                        //               ),
                        //               //amount
                        //               DataCell(
                        //                   SizedBox(
                        //                       width: 120,
                        //                       child: TextFormField(readOnly: true,
                        //                         controller: amountController[index],
                        //                         decoration: const InputDecoration(
                        //                           border: InputBorder.none,
                        //                         ),
                        //                       ))
                        //               ),
                        //               DataCell(
                        //                   Container(
                        //                       height: 35,
                        //                       width: 150,
                        //
                        //                       color: Colors.white70,
                        //                       child: Padding(
                        //                         padding: const EdgeInsets.only(
                        //                             left: 7, bottom: 7),
                        //                         child:
                        //                         TextField(controller: taxCode[index],
                        //                           readOnly: true,
                        //                           onTap: (){
                        //
                        //                             showDialog(
                        //                                 context: context,
                        //                                 builder:
                        //                                     (BuildContext context) {
                        //                                   return AlertDialog(
                        //                                     shape:
                        //                                     RoundedRectangleBorder(
                        //                                         borderRadius:
                        //                                         BorderRadius
                        //                                             .circular(
                        //                                             5)),
                        //                                     content: Container(
                        //                                       height: 450,
                        //                                       width: 450,
                        //                                       child:
                        //                                       SingleChildScrollView(
                        //                                         child: Column(
                        //                                           children: [
                        //                                             Container(
                        //                                                 height: 40,
                        //                                                 color: Colors
                        //                                                     .grey[
                        //                                                 350],
                        //                                                 child: Row(
                        //                                                   children: const [
                        //                                                     Expanded(
                        //                                                         child:
                        //                                                         Center(child: Text("NAME"))),
                        //                                                     Expanded(
                        //                                                         child:
                        //                                                         Center(child: Text("TAX CODE"))),
                        //                                                     Expanded(
                        //                                                         child:
                        //                                                         Center(child: Text("TOTAL TAX PERCENTAGE"))),
                        //                                                   ],
                        //                                                 )),
                        //                                             Column(children: [
                        //                                               const SizedBox(height: 15,),
                        //                                               for (int i = 0; i < taxList.length; i++)
                        //                                                 InkWell(
                        //                                                   onTap:
                        //                                                       () {
                        //                                                     setState(() {
                        //                                                       taxCode[index].text=taxList[i]['tax_total'];
                        //                                                       Navigator.of(context).pop();
                        //                                                       // print(taxList);
                        //
                        //                                                       double taxVal =0.0;
                        //                                                       taxVal=  (double.parse(taxList[i]['tax_total'])/100)*double.parse(unitController[index].text);
                        //
                        //                                                       totalTaxValueController[index].text= (taxVal*double.parse(selectedQuantity[index])).toString();
                        //
                        //                                                       grandTotal = double.parse(totalTaxValueController[0].text)+double.parse(amountController[0].text)-discountValue;
                        //
                        //                                                       grandTotal1 = grandTotal;
                        //                                                       // print(taxList[i]['tax_code']);
                        //                                                       var tempAmount = 0.0;
                        //                                                       for(int i=0; i<amountController.length; i++) {
                        //                                                         tempAmount =
                        //                                                             tempAmount +
                        //                                                                 double
                        //                                                                     .parse(
                        //                                                                     amountController[i]
                        //                                                                         .text);
                        //                                                       }
                        //                                                       gTotal = tempAmount;
                        //                                                       //-----------------------
                        //                                                       var tempTaxAmount = 0.0;
                        //                                                       for(int i=0; i<totalTaxValueController.length; i++){
                        //                                                         tempTaxAmount = tempTaxAmount + double.parse(totalTaxValueController[i].text);
                        //                                                       }
                        //                                                       gTATotal = tempTaxAmount;
                        //                                                       //---------------------------
                        //                                                       var tempTotal = 0.0;
                        //                                                       for(int i=0; i<grandTotal1; i++){
                        //                                                         // tempTotal = tempTotal + double.parse(grandTotal1.toString());
                        //                                                         tempTotal = gTotal + gTATotal;
                        //                                                       }
                        //                                                       gTotalTotal = tempTotal;
                        //                                                     });
                        //                                                   },
                        //                                                   child:
                        //                                                   Row(
                        //                                                     children: [
                        //                                                       Expanded(
                        //                                                           child: Center(
                        //                                                               child: Padding(
                        //                                                                 padding: const EdgeInsets.all(8.0),
                        //                                                                 child: SizedBox(
                        //                                                                     height: 30,
                        //                                                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                        //                                                                     child: Text(taxList[i]['tax_name'] ?? '')),
                        //                                                               ))),
                        //                                                       Expanded(
                        //                                                           child: Center(
                        //                                                               child: Padding(
                        //                                                                 padding: const EdgeInsets.all(8.0),
                        //                                                                 child: SizedBox(
                        //                                                                     height: 30,
                        //                                                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                        //                                                                     child: Text(taxList[i]['tax_code'] ?? '')),
                        //                                                               ))),
                        //                                                       Expanded(
                        //                                                           child: Center(
                        //                                                               child: Padding(
                        //                                                                 padding: const EdgeInsets.all(8.0),
                        //                                                                 child: SizedBox(
                        //                                                                     height: 30,
                        //                                                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                        //                                                                     child: Text(taxList[i]['tax_total'] ?? '')),
                        //                                                               ))),
                        //                                                     ],
                        //                                                   ),
                        //                                                 ),
                        //                                             ],)
                        //                                           ],
                        //
                        //                                         ),
                        //                                       ),
                        //                                     ),
                        //                                   );
                        //                                 });
                        //                           },
                        //                           decoration: const InputDecoration(
                        //                               border: InputBorder.none),
                        //                         ),
                        //                       ))),
                        //               //Tax Amount
                        //               DataCell(SizedBox(
                        //                   width: 120,
                        //                   child: TextFormField(
                        //                     controller:
                        //                     totalTaxValueController[index],
                        //                     decoration: const InputDecoration(
                        //                       border: InputBorder.none,
                        //                     ),
                        //                   ))),
                        //             ],
                        //             // onSelectChanged: (bool? value) {
                        //             //
                        //             //   //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SelectedOrderBooking()));
                        //             // },
                        //           ),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 50,bottom: 20),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.blue,
                                height: 25,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40, right: 40),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Expanded(flex: 4,child: Text('Variant',style: TextStyle(color: Colors.white),)),
                                      Expanded(flex: 4,child: Text('Unit Price',style: TextStyle(color: Colors.white),)),
                                      Expanded(flex: 3,child: Text('Discount %',style: TextStyle(color: Colors.white),)),
                                      Expanded(flex: 3,child: Text('Qty',style: TextStyle(color: Colors.white),)),
                                      Expanded(flex: 4,child: Text('Amount',style: TextStyle(color: Colors.white),)),
                                      Expanded(flex: 4,child: Text('Tax Percentage',style: TextStyle(color: Colors.white),)),
                                      Expanded(flex: 4,child: Text('Tax Amount',style: TextStyle(color: Colors.white),)),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40,right: 40,top: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          // width: 100,
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0,bottom: 0),
                                            child:TextField(
                                              enabled: false,
                                              readOnly: true,
                                              controller: variantController[0],
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Select Vehicle'),
                                                            InkWell(
                                                              child: const Icon(Icons.close_sharp,color: Colors.red),
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        content: SizedBox(
                                                          width: 500,
                                                          height: 300,
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: RawScrollbar(
                                                                  thumbColor: Colors.black45,
                                                                  radius: const Radius.circular(5.0),
                                                                  thumbVisibility: true,
                                                                  thickness: 10.0,
                                                                  child: ListView(
                                                                    shrinkWrap: true,
                                                                    padding: const EdgeInsets.all(10.0),
                                                                    children: [
                                                                      Container(
                                                                        height: 40,
                                                                        color: Colors.grey[200],
                                                                        child: Row(
                                                                          children:  const [
                                                                            Expanded(child: Center(child: Text("BRAND"))),
                                                                            Expanded(child: Center(child: Text("MODEL"))),
                                                                            Expanded(child: Center(child: Text("VARIANT"))),
                                                                            Expanded(child: Center(child: Text("ON ROAD PRICE"))),
                                                                            Expanded(child: Center(child: Text("COLOR"))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(height: 20,),
                                                                      for(int i=0; i<vvList.length; i++)
                                                                        InkWell(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              brandController[0].text=vvList[i]['make'];
                                                                              modelController[0].text=vvList[i]['model_name'];
                                                                              variantController[0].text=vvList[i]['varient'];
                                                                              discountController[0].text = '0';
                                                                              unitController[0].text=vvList[i]['onroad_price'].toString();
                                                                              amountController[0].text=vvList[i]['onroad_price'].toString();
                                                                              amountValueController[0].text=vvList[i]['onroad_price'].toString();
                                                                              colorController[0].text=vvList[i]['varient_color1'];
                                                                              Navigator.of(context).pop();
                                                                            });
                                                                          },
                                                                          child: Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Center(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: SizedBox(
                                                                                          height: 30,
                                                                                          child: Text(vvList[i]['make']),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Center(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: SizedBox(
                                                                                          height: 30,
                                                                                          child: Text(vvList[i]['model_name']),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Center(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: SizedBox(
                                                                                          height: 30,
                                                                                          child: Text(vvList[i]['varient']),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Center(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: SizedBox(
                                                                                          height: 30,
                                                                                          child: Text(vvList[i]['onroad_price'].toString()),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Center(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: SizedBox(
                                                                                          height: 30,
                                                                                          child: Text(vvList[i]['varient_color1']),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
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
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          // width: 100,
                                            child: TextFormField(
                                              controller: unitController[0],
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: SizedBox(
                                          // width: 70,
                                            child: TextFormField(
                                              controller: discountController[0],
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (val){
                                                if(val.isEmpty || val ==''||variantController[0].text.isEmpty){
                                                  amountController[0].text =unitController[0].text;
                                                  discountController[0].text='';
                                                }
                                                else{
                                                  setState(() {
                                                    var tempDis = 0.0;
                                                    discountValue = 0.0;
                                                    tempDis = (double.parse(val) / 100) * double.parse(unitController[0].text);

                                                    discountAmountController[0] = tempDis;
                                                    discountUnitController[0] = tempDis;
                                                    for(int i=0; i<discountAmountController.length; i++){
                                                      discountValue = discountValue+discountAmountController[i];
                                                    }
                                                    // discountValue=(double.parse(val)/100)*double.parse(unitController[index].text);
                                                    amountController[0].text=(double.parse(unitController[0].text) - (double.parse(val)/100)*double.parse(unitController[0].text)).toString();
                                                    amountValueController[0].text=(double.parse(unitController[0].text) - (double.parse(val)/100)*double.parse(unitController[0].text)).toString();
                                                  });
                                                }

                                              },
                                            )),
                                      ),
                                      variantController[0].text.isNotEmpty || variantController[0].text!="" ?
                                      // SizedBox(
                                      //   width: 45,
                                      //   child: DropdownButtonHideUnderline(
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.only(top: 10),
                                      //       child: DropdownButton(
                                      //           value: selectedQuantity[0],
                                      //           items: _quantity.map((String items) {
                                      //             return DropdownMenuItem(
                                      //                 value: items,
                                      //                 child: Text(items)
                                      //             );
                                      //           }
                                      //           ).toList(),
                                      //           onChanged: (String? newValue){
                                      //             setState(() {
                                      //               // print('-------------');
                                      //               // print(newValue);
                                      //               discountValue = 0.0;
                                      //               selectedQuantity[0] = newValue!;
                                      //               // print(selectedQuantity[index]);
                                      //               amountController[0].text = (double.parse(newValue)*double.parse(amountValueController[0].text)).toString();
                                      //               var tempValue= discountUnitController[0]*double.parse(selectedQuantity[0]);
                                      //               discountAmountController[0] =tempValue;
                                      //               for(int i=0; i<discountAmountController.length; i++){
                                      //                 discountValue = discountValue + discountAmountController[0];
                                      //               }
                                      //               // print(tempValue);
                                      //               // double taxVal = 0.0;
                                      //               // taxVal = (double.parse(taxQuantity[index])/100)*double.parse(unitController[index].text);
                                      //               // totalTaxValueController[index].text = taxVal.toString();
                                      //               // grandTotal = taxVal + double.parse(totalTaxValueController[0].text) + double.parse(amountController[0].text);
                                      //               grandTotal1 = grandTotal;
                                      //             });
                                      //           }
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                      Expanded(
                                        flex: 3,
                                        child: PopupMenuButton(itemBuilder: (context) {
                                          return _quantity.map((String items) {
                                            return PopupMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList();
                                        },
                                          child:Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisSize:MainAxisSize.min,
                                              children:[
                                                Text(selectedQuantity[0],style: const TextStyle(fontSize: 16)),
                                                const Icon(Icons.arrow_drop_down)
                                              ],
                                            ),
                                          ),
                                          onSelected: (String? newValue){
                                            setState(() {
                                              discountValue = 0.0;
                                              selectedQuantity[0] = newValue!;
                                              // print(selectedQuantity[0]);
                                              // amountController[index].text = (double.parse(newValue)*double.parse(amountValueController[index].text)).toString();
                                              amountController[0].text = (double.parse(newValue)*double.parse(amountValueController[0].text)).toStringAsFixed(2);
                                              var tempValue= discountUnitController[0]*double.parse(selectedQuantity[0]);
                                              discountAmountController[0] =tempValue;

                                              for(int i=0; i<discountAmountController.length; i++){
                                                discountValue = discountValue + discountAmountController[0];
                                              }
                                              grandTotal1 = grandTotal;
                                            });
                                          },),
                                      )
                                          :
                                      SizedBox(
                                          width: 50,
                                          child: Container()),
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          // width: 120,
                                            child: TextFormField(readOnly: true,
                                              controller: amountController[0],
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                            height: 35,
                                            // width: 100,
                                            color: Colors.white70,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0, bottom: 0),
                                              child:
                                              TextField(controller: taxCode[0],
                                                readOnly: true,
                                                onTap: (){

                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext context) {
                                                        return AlertDialog(
                                                          shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  5)),
                                                          content: Container(
                                                            height: 450,
                                                            width: 450,
                                                            child:
                                                            SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                      height: 40,
                                                                      color: Colors
                                                                          .grey[
                                                                      350],
                                                                      child: Row(
                                                                        children: const [
                                                                          Expanded(
                                                                              child:
                                                                              Center(child: Text("NAME"))),
                                                                          Expanded(
                                                                              child:
                                                                              Center(child: Text("TAX CODE"))),
                                                                          Expanded(
                                                                              child:
                                                                              Center(child: Text("TOTAL TAX PERCENTAGE"))),
                                                                        ],
                                                                      )),
                                                                  Column(children: [
                                                                    const SizedBox(height: 15,),
                                                                    for (int i = 0; i < taxList.length; i++)
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(() {
                                                                            taxCode[0].text=taxList[i]['tax_total'];
                                                                            Navigator.of(context).pop();
                                                                            // print(taxList);

                                                                            double taxVal =0.0;
                                                                            taxVal=  (double.parse(taxList[i]['tax_total'])/100)*double.parse(unitController[0].text);

                                                                            totalTaxValueController[0].text= (taxVal*double.parse(selectedQuantity[0])).toString();

                                                                            grandTotal = double.parse(totalTaxValueController[0].text)+double.parse(amountController[0].text)-discountValue;

                                                                            grandTotal1 = grandTotal;
                                                                            // print(taxList[i]['tax_code']);
                                                                            var tempAmount = 0.0;
                                                                            for(int i=0; i<amountController.length; i++) {
                                                                              tempAmount =
                                                                                  tempAmount +
                                                                                      double
                                                                                          .parse(
                                                                                          amountController[i]
                                                                                              .text);
                                                                            }
                                                                            gTotal = tempAmount;
                                                                            //-----------------------
                                                                            var tempTaxAmount = 0.0;
                                                                            for(int i=0; i<totalTaxValueController.length; i++){
                                                                              tempTaxAmount = tempTaxAmount + double.parse(totalTaxValueController[i].text);
                                                                            }
                                                                            gTATotal = tempTaxAmount;
                                                                            //---------------------------
                                                                            var tempTotal = 0.0;
                                                                            for(int i=0; i<grandTotal1; i++){
                                                                              // tempTotal = tempTotal + double.parse(grandTotal1.toString());
                                                                              tempTotal = gTotal + gTATotal;
                                                                            }
                                                                            gTotalTotal = tempTotal;
                                                                          });
                                                                        },
                                                                        child:
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                                child: Center(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                          height: 30,
                                                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                                                          child: Text(taxList[i]['tax_name'] ?? '')),
                                                                                    ))),
                                                                            Expanded(
                                                                                child: Center(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                          height: 30,
                                                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                                                          child: Text(taxList[i]['tax_code'] ?? '')),
                                                                                    ))),
                                                                            Expanded(
                                                                                child: Center(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: SizedBox(
                                                                                          height: 30,
                                                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                                                          child: Text(taxList[i]['tax_total'] ?? '')),
                                                                                    ))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                  ],)
                                                                ],

                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                                decoration: const InputDecoration(
                                                    border: InputBorder.none),
                                              ),
                                            )),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: SizedBox(
                                          // width: 120,
                                            child: TextFormField(
                                              controller:
                                              totalTaxValueController[0],
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //------footer--------
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 50),
                          child: SizedBox(
                            // width: 1200,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20,bottom: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Terms and Conditions"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        AnimatedContainer(
                                          duration: const Duration(seconds: 0),
                                          height: termsError ? 100 : 80,
                                          width: 300,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                setState(() {
                                                  termsError = true;
                                                });
                                                return "Required";
                                              } else {
                                                setState(() {
                                                  termsError = false;
                                                });
                                              }
                                              return null;
                                            },
                                            controller: termsAndConditions,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 4,
                                            minLines: 4,
                                            decoration: decorationInput6(
                                                '', termsAndConditions.text.isNotEmpty),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10,left: 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Customer Notes"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        AnimatedContainer(
                                          duration: const Duration(seconds: 0),
                                          height: customerNotesError ? 100 : 80,
                                          width: 300,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                setState(() {
                                                  customerNotesError = true;
                                                });
                                                return "Required";
                                              } else {
                                                setState(() {
                                                  customerNotesError = false;
                                                });
                                              }
                                              return null;
                                            },
                                            controller: customerNotes,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 4,
                                            minLines: 4,
                                            decoration: decorationInput6(
                                                '', customerNotes.text.isNotEmpty),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 0,bottom: 0,left: 10),
                                    child: SizedBox(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text("Base Price"),
                                                  Text(gTotal.toStringAsFixed(2),style: const TextStyle(fontSize: 16),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text("Discounted Price"),
                                                  Text(discountValue.toStringAsFixed(2),style: const TextStyle(fontSize: 16),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text("Tax"),
                                                  // Text(totalTaxValueController[0].text),
                                                  Text(gTATotal.toStringAsFixed(2),style: const TextStyle(fontSize: 16),),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text("Freight Amount"),
                                                  Container(
                                                      height: 25,
                                                      width: 100,
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 5),
                                                        child: TextFormField(
                                                          textAlign: TextAlign.right,
                                                          style: const TextStyle(fontSize: 16),
                                                          decoration: const InputDecoration(
                                                              border: InputBorder.none),
                                                          controller: freightController,
                                                          keyboardType:
                                                          TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          onChanged: (v) {
                                                            double val = 0.0;
                                                            setState(() {
                                                              val = gTotalTotal +
                                                                  double.parse(v);
                                                            });
                                                            gTotalTotal = val;
                                                            // print(grandTotal1);
                                                            // print(gTotalTotal);
                                                          },
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 30,),
                                            Container(
                                              color: Colors.grey[300],
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text("Total"),
                                                    // Text(grandTotal1.toString()),
                                                    Text(gTotalTotal.toStringAsFixed(2),style: const TextStyle(fontSize: 16),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              bottomNavigationBar: SizedBox(height: 50,
                child: Row(
                  children: [
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 80,
                      height: 30,
                      child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          color: Colors.white,
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          )),
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

  Future addPurchaseVehicleOrder(Map<dynamic, dynamic> data) async{
    try {
      final response = await http.post(Uri.parse(
          "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/add_new_vehi_pur"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(data)
      );
      if (response.statusCode == 200) {
        Map responseJson={};

        print(response.body);
        responseJson=jsonDecode(response.body);
        if(responseJson.containsKey('new_id')){

          poId=responseJson['new_id'];
          Map lineData= {

            "brand": brandController[0].text,
            "model": modelController[0].text,
            "varient": variantController[0].text,
            "color": colorController[0].text,
            "unit_price": unitController[0].text,
            "discount": discountController[0].text,
            "quantity": selectedQuantity[0],
            "amount": amountController[0].text,
            "tax_code": taxQuantity[0] ,
            "tax_amount": totalTaxValueController[0].text,
            "new_pur_vehi_id": poId,
            "recieved_quantity": 0,
            "short_quantity": 0,
            "recieved_quantity": 0,
            "short_quantity": 0,
          };
          log("Purchase Order Created, Waiting for Table Creation $poId");
          print(lineData);
          addTableApi(lineData,true);
          // for(int i=0;i<uiTableData.length;i++) {
          //   uiTableData[i]["new_purchase_id"]=poId;
          //   if(i==uiTableData.length-1){
          //     addTableApi(uiTableData[i],true);
          //   }
          //   else{
          //     addTableApi(uiTableData[i],false);
          //   }
          //
          // }
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content: new Text("Error"),
          ));
        }

      }
      else {
        print("++++++ Status Code ++++++++");
        print(response.statusCode.toString());
      }
    }
    catch (e) {
      print(e.toString());
      print(e);
    }

  }


  Future addTableApi(Map<dynamic, dynamic> data, bool length) async{
    print(data);
    try {
      final response = await http.post(Uri.parse("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchaseline/add_new_vehi_pur_line"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(data)
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: new Text("Data Saved"),
        ));
        print(response.body);
        if(length)
          Navigator.of(context).pop();


      }
      else {
        print("++++++ Status Code ++++++++");
        print(response.statusCode.toString());
      }
    }
    catch (e) {
      print(e.toString());
      print(e);
    }

  }



}


class ItemData{
  final String label;
  final String name ;
  final String brand ;


  ItemData({
    required this.label,
    required this.name ,
    required this.brand ,


  });
  factory ItemData.fromJson(Map<String, dynamic> json) {

    return ItemData(
      label: json['brand'],
      name:json['name'],
      brand:json['brand'],


    );
  }
}

class ModelData{
  final String label;
  final String name ;
  final String brand ;


  ModelData({
    required this.label,
    required this.name ,
    required this.brand ,


  });
  factory ModelData.fromJson(Map<String, dynamic> json) {
    return ModelData(
      label: json['name'],
      name:json['name'],
      brand:json['brand'],


    );
  }
}

class VariantData{
  final String label;
  final double exShowroomPrice ;
  final String model ;


  VariantData({
    required this.label,
    required this.exShowroomPrice ,
    required this.model ,


  });
  factory VariantData.fromJson(Map<String, dynamic> json) {

    return VariantData(
      label: json['varient'],
      exShowroomPrice:json['ex_showroom_price'],
      model:json['model_name'],
    );
  }
}
