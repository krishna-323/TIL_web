
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../classes/models/search_models.dart';
import '../../utils/api/get_api.dart';
import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../widgets/input_decoration_text_field.dart';

class AddNewVehiclePurchaseOrder extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;

  const AddNewVehiclePurchaseOrder(
      {Key? key, required this.selectedDestination, required this.drawerWidth})
      : super(key: key);


  @override
  _AddNewPurchaseOrderState createState() => _AddNewPurchaseOrderState();
}

class _AddNewPurchaseOrderState extends State<AddNewVehiclePurchaseOrder> {
  final _addPurchaseForm = GlobalKey<FormState>();

  List taxList = [];
  bool loading = false;

  Future fetchTaxData() async {
    dynamic response;
    String url =
        "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/tax/get_all_tax";
    try {
      await getData(url: url, context: context).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            taxList = value;
            // print('--------fetch Tax Data--------');
            // print(taxList);
          }
          loading = false;
        });
      });
    } catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  Future<List> fetchModel() async {
    await Future.delayed(const Duration(milliseconds: 100));
    List list1 = [];
    // String _inputText = vendorName.text;
    for (int i = 0; i < modelList.length; i++) {
      list1.add(ModelData.fromJson(modelList[i]));
    }

    return list1;
  }

  Future<List> fetchVariant() async {
    await Future.delayed(const Duration(milliseconds: 100));
    List variant = [];
    // String _inputText = vendorName.text;
    for (int i = 0; i < variantList.length; i++) {
      variant.add(VariantData.fromJson(variantList[i]));
    }

    return variant;
  }

  Future<List> fetchBrand() async {
    await Future.delayed(const Duration(milliseconds: 100));
    List _list1 = [];
    // String _inputText = vendorName.text;
    for (int i = 0; i < brandList.length; i++) {
      _list1.add(ItemData.fromJson(brandList[i]));
    }

    return _list1;
  }

  Future fetchVendorsData() async {
    dynamic response;
    String url =
        "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_all_new_vendor";
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            vendorList = value;
            // print('----------fetchVendorData--------');
            // print(vendorList);
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

  String poNo = '';

  Future fetchBrandData() async {
    dynamic response;
    String url =
        "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/get_all_new_vehicle_brand";
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            poNumber.text =
            "PO-${DateTime.now().hour}${DateTime.now().microsecondsSinceEpoch}";
            brandList = value;
            // print('----------fetchBrandData-----------');
            // print(brandList);
          }
          loading = false;
        });
      });
    } catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  Future fetchModelData(name) async {
    dynamic response;
    String url =
        "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/get_new_vehicle_model_by_brand/$name";
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            modelList = value;
            // print('----------fetchModelData-----------');
            // print(modelList);
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

  Future fetchVariantData(name) async {
    dynamic response;
    String url =
        "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclevarient/get_new_vehicle_by_varient/$name";
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            variantList = value;
            print('--------fetchVariantData-----------');
            print(variantList);
          }
          loading = false;
        });
      });
    } catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  Future<List> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    List _list = [];
    // String _inputText = vendorName.text;
    for (int i = 0; i < vendorList.length; i++) {
      _list.add(VendorData.fromJson(vendorList[i]));
    }

    return _list;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1999, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        expDeliveryDate.text = (picked.toLocal()).toString().split(' ')[0];
      });
    }
  }

  List vvList = [];

  Future getAllVehicleVariant() async {
    dynamic response;
    String url =
        "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/get_all_mod_general";
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            vvList = value;
            // print('---------getAllVehicleVariant----------');
            // print(vvList);
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

  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }

  List warehouseList = [];

  //Warehouse details Api.
  Future fetchListWarehouseData() async {
    dynamic response;
    String url =
        'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/warehouse/get_all_warehouse';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            warehouseList = value;
            // print('--------warehouse List get all api---------');
            // print(warehouseList);
          }
          loading = false;
        });
      });
    } catch (e) {
      logOutApi(context: context, exception: toString(), response: response);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // loading = true;
    super.initState();
    getInitialData().whenComplete(() {
      //warehouse Details API Calling.
      fetchListWarehouseData();
      fetchBrandData();
      fetchVendorsData();
      fetchTaxData();
      // fetchItemData();
      getAllVehicleVariant();
    });
//This is For Tax Code.

    brandController.add(TextEditingController());
    colorController.add(TextEditingController());
    modelController.add(TextEditingController());
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
  }

  String? dropDownValue;
  String? orgVal;
  String? customerVal;
  double total = 0.0;
  double grandTotal = 0.0;
  double grandTotal1 = 0.0;

  List vendorList = [];

  List brandList = [];

  List modelList = [];
  List variantList = [];

  Map gstValues = {
    "cGst4": 0.0,
    "sGst4": 0.0,
    "cGst6": 0.0,
    "sGst6": 0.0,
    "cGst9": 0.0,
    "sGst9": 0.0,
    "cGst14": 0.0,
    "sGst14": 0.0,
  };

  List uiTableData = [];

  var itemSelected = [];

  List tableData = [0];
  final _quantity = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16"
  ];

  // final _color = ["Black", "Blue", "White", "Grey", "Silver"];
  //final _taxCode = ["10", "20", "30", "40", "50"];

  bool vendorNameError = false;
  bool purchaseOrderError = false;
  bool referenceError = false;
  bool expectedDeliveryError = false;
  bool shipmentPreError = false;
  bool customerNotesError = false;
  bool termsError = false;

  double discountValue = 0.0;

  var itemDetailsController = <TextEditingController>[];
  var brandController = <TextEditingController>[];
  var colorController = <TextEditingController>[];
  var modelController = <TextEditingController>[];
  var variantController = <TextEditingController>[];
  var unitController = <TextEditingController>[];
  var discountController = <TextEditingController>[];
  var taxController = <TextEditingController>[];

  var taxQuantity = <String>[];

  String? selectedItems;
  String? authToken;

  var rateController = <TextEditingController>[];
  var totalTaxValueController = <TextEditingController>[];
  var sGstController = <TextEditingController>[];
  var selectedQuantity = <String>[];
  var selectedColor = <String>[];
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
  final vendorPayToAddress = TextEditingController();
  final fetchingWarehouseAddress = TextEditingController();
  final customerNotes = TextEditingController();
  final termsAndConditions = TextEditingController();
  final referenceNo = TextEditingController();
  final expDeliveryDate = TextEditingController();
  final shipmentReferenceNo = TextEditingController();
  var freightController = TextEditingController();

  // final discountController = TextEditingController();

  // final _horizontalScrollController = ScrollController();
  double taxVal = 0.0;
  String poId = "";
  String vendorID = "";
  final taxCode = <TextEditingController>[];
  final reference = FocusNode();
  final date = FocusNode();
  final terms = FocusNode();
  final notes = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: CustomAppBar()),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: CustomLoader(
                inAsyncCall: loading,
                child: SingleChildScrollView(
                    child: Form(
                      key: _addPurchaseForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //--------header-------
                          Padding(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            child: Container(
                              color: const Color(0xffF4FAFF),
                              child: Column(
                                children: [
                                  Container(
                                      height: 60,
                                      color: Colors.white,
                                      child: const Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "New Purchase Order",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.indigo),
                                            ),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      'Vendor Name',
                                                      style: TextStyle(
                                                          color: Colors.red[900]),
                                                    )),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                      child: Container(
                                                        width: 290,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                              color: Colors.grey,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              bottom: 10),
                                                          child: TextFieldSearch(
                                                            textStyle:
                                                            const TextStyle(
                                                                fontSize: 16),
                                                            decoration:
                                                            const InputDecoration(
                                                              border:
                                                              InputBorder.none,
                                                            ),
                                                            controller: vendorName,
                                                            future: () {
                                                              return fetchData();
                                                            },
                                                            getSelectedValue:
                                                                (VendorData
                                                            newValue) {
                                                              vendorName.text =
                                                                  newValue
                                                                      .firstName;
                                                              vendorID =
                                                                  newValue.vendorID;
                                                              vendorPayToAddress
                                                                  .text =
                                                              '${newValue.payto_address1}, ${newValue.payto_address2}, ${newValue.payto_region}, ${newValue.payto_state}, ${newValue.payto_city}, ${newValue.payto_zip}';
                                                            },
                                                            label: '',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    if (vendorNameError)
                                                      const Padding(
                                                        padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 4, 0, 0),
                                                        child: Text(
                                                          'Required',
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
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      'Pay To Address',
                                                      style: TextStyle(
                                                          color: Colors.red[900]),
                                                    )),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(5),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  height: 80,
                                                  width: 290,
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    readOnly: true,
                                                    controller: vendorPayToAddress,
                                                    keyboardType:
                                                    TextInputType.multiline,
                                                    maxLines: 4,
                                                    minLines: 4,
                                                    decoration:
                                                    const InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                      InputBorder.none,
                                                      enabledBorder:
                                                      InputBorder.none,
                                                      errorBorder: InputBorder.none,
                                                      disabledBorder:
                                                      InputBorder.none,
                                                      contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15,
                                                          bottom: 10,
                                                          top: 11,
                                                          right: 15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      'Ship To Address',
                                                      style: TextStyle(
                                                          color: Colors.red[900]),
                                                    )),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(5),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  height: 80,
                                                  width: 290,
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    readOnly: true,
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) {
                                                            return Dialog(
                                                              backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                              child: SizedBox(
                                                                width: 600,
                                                                height: 400,
                                                                child: Stack(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          top: 13.0,
                                                                          right:
                                                                          8.0),
                                                                      child:
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                            35.0,
                                                                            right:
                                                                            35,
                                                                            top: 20,
                                                                            bottom:
                                                                            20),
                                                                        child:
                                                                        Column(
                                                                          children: [
                                                                            const Text(
                                                                              'Select Warehouse Details',
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.indigo),
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              15,
                                                                            ),
                                                                            Expanded(
                                                                              child:
                                                                              RawScrollbar(
                                                                                thumbColor:
                                                                                Colors.black45,
                                                                                radius:
                                                                                const Radius.circular(5.0),
                                                                                thumbVisibility:
                                                                                true,
                                                                                thickness:
                                                                                5.0,
                                                                                child:
                                                                                ListView(
                                                                                  shrinkWrap: true,
                                                                                  padding: const EdgeInsets.all(10.0),
                                                                                  children: [
                                                                                    Container(
                                                                                      height: 40,
                                                                                      color: Colors.grey[200],
                                                                                      child: const Row(
                                                                                        children: [
                                                                                          Expanded(child: Center(child: Text("WAREHOUSE NAME"))),
                                                                                          Expanded(child: Center(child: Text("WAREHOUSE CODE"))),
                                                                                          Expanded(child: Center(child: Text("ZIP-CODE"))),
                                                                                          Expanded(child: Center(child: Text("STATE"))),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    for (int i = 0; i < warehouseList.length; i++)
                                                                                      InkWell(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            fetchingWarehouseAddress.text = warehouseList[i]['warehouse_name'] + ', ' + warehouseList[i]['warehouse_code'].toString() + ', ' + warehouseList[i]['location'] + ', ' + warehouseList[i]['ship_to_name'] + ', ' + warehouseList[i]['branch'] + ', ' + warehouseList[i]['city'] + ', ' + warehouseList[i]['country'] + ', ' + warehouseList[i]['address_line1'] + ', ' + warehouseList[i]['address_line2'] + ', ' + warehouseList[i]['state'] + ', ' + warehouseList[i]['zip_code'].toString();
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
                                                                                                      padding: const EdgeInsets.only(right: 50.0),
                                                                                                      child: SizedBox(
                                                                                                        height: 30,
                                                                                                        child: Text(warehouseList[i]['warehouse_name']),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: Center(
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.only(right: 50.0),
                                                                                                      child: SizedBox(
                                                                                                        height: 30,
                                                                                                        child: Text(warehouseList[i]['warehouse_code'].toString()),
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
                                                                                                        child: Text(warehouseList[i]['zip_code'].toString()),
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
                                                                                                        child: Text(warehouseList[i]['state']),
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
                                                                    Positioned(
                                                                      right: 0.0,
                                                                      child:
                                                                      InkWell(
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
                                                                              Icons
                                                                                  .close_sharp,
                                                                              color:
                                                                              Colors.white,
                                                                            )),
                                                                        onTap: () {
                                                                          setState(
                                                                                  () {
                                                                                Navigator.of(context)
                                                                                    .pop();
                                                                              });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    controller:
                                                    fetchingWarehouseAddress,
                                                    keyboardType:
                                                    TextInputType.multiline,
                                                    maxLines: 4,
                                                    minLines: 4,
                                                    decoration:
                                                    const InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                      InputBorder.none,
                                                      enabledBorder:
                                                      InputBorder.none,
                                                      errorBorder: InputBorder.none,
                                                      disabledBorder:
                                                      InputBorder.none,
                                                      contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15,
                                                          bottom: 10,
                                                          top: 11,
                                                          right: 15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      'Purchase Order #',
                                                      style: TextStyle(
                                                          color: Colors.red[900]),
                                                    )),
                                                Container(
                                                  width: 290,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      )),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 8),
                                                    child: TextField(
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                      controller: poNumber,
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      decoration:
                                                      const InputDecoration(
                                                        border: InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      'Reference #',
                                                      style: TextStyle(),
                                                    )),
                                                Container(
                                                  color: Colors.white,
                                                  width: 290,
                                                  child: AnimatedContainer(
                                                    duration:
                                                    const Duration(seconds: 0),
                                                    height:
                                                    referenceError ? 50 : 35,
                                                    child: TextFormField(
                                                      onFieldSubmitted: (re) {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                            reference);
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            referenceError = true;
                                                          });
                                                          return "Required";
                                                        } else {
                                                          setState(() {
                                                            referenceError == false;
                                                          });
                                                        }
                                                        return null;
                                                      },
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                      onChanged: (text) {
                                                        setState(() {});
                                                      },
                                                      controller: referenceNo,
                                                      decoration: decorationInput5(
                                                          '',
                                                          referenceNo
                                                              .text.isNotEmpty),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      'Expected Delivery Date',
                                                      style: TextStyle(),
                                                    )),
                                                Container(
                                                  color: Colors.white,
                                                  width: 290,
                                                  child: AnimatedContainer(
                                                    duration:
                                                    const Duration(seconds: 0),
                                                    height: expectedDeliveryError
                                                        ? 50
                                                        : 35,
                                                    child: TextFormField(
                                                      focusNode: reference,
                                                      onFieldSubmitted: (re) {
                                                        FocusScope.of(context)
                                                            .requestFocus(date);
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            expectedDeliveryError =
                                                            true;
                                                          });
                                                          return "Required";
                                                        } else {
                                                          setState(() {
                                                            expectedDeliveryError ==
                                                                false;
                                                          });
                                                        }
                                                        return null;
                                                      },
                                                      onTap: () {
                                                        _selectDate(context);
                                                      },
                                                      readOnly: true,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                      onChanged: (text) {
                                                        setState(() {});
                                                      },
                                                      controller: expDeliveryDate,
                                                      decoration: decorationInput5(
                                                          '',
                                                          expDeliveryDate
                                                              .text.isNotEmpty),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      'Shipment Preference',
                                                      style: TextStyle(),
                                                    )),
                                                Container(
                                                  color: Colors.white,
                                                  width: 290,
                                                  child: AnimatedContainer(
                                                    duration:
                                                    const Duration(seconds: 0),
                                                    height:
                                                    shipmentPreError ? 50 : 35,
                                                    child: TextFormField(
                                                      focusNode: date,
                                                      onFieldSubmitted: (t) {
                                                        FocusScope.of(context)
                                                            .requestFocus(terms);
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            shipmentPreError = true;
                                                          });
                                                          return "Required";
                                                        } else {
                                                          setState(() {
                                                            shipmentPreError ==
                                                                false;
                                                          });
                                                        }
                                                        return null;
                                                      },
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                      onChanged: (text) {
                                                        setState(() {});
                                                      },
                                                      controller:
                                                      shipmentReferenceNo,
                                                      decoration: decorationInput5(
                                                          '',
                                                          shipmentReferenceNo
                                                              .text.isNotEmpty),
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //---------table-------
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, bottom: 20),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.blue,
                                  height: 25,
                                  child: const Padding(
                                    padding:
                                    EdgeInsets.only(left: 40, right: 40),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              'Variant',
                                              style: TextStyle(color: Colors.white),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              'Unit Price',
                                              style: TextStyle(color: Colors.white),
                                            )),
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Discount %',
                                              style: TextStyle(color: Colors.white),
                                            )),
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Qty',
                                              style: TextStyle(color: Colors.white),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              'Amount',
                                              style: TextStyle(color: Colors.white),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              'Tax Percentage',
                                              style: TextStyle(color: Colors.white),
                                            )),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              'Tax Amount',
                                              style: TextStyle(color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: SizedBox(
                                            // width: 100,
                                            height: 35,
                                            child: TextField(
                                              readOnly: true,
                                              controller: variantController[0],
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                      bottom: 10, left: 0),
                                                  hintText: "Select Variant"),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => showDialogBox(),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: SizedBox(
                                            // width: 100,
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: unitController[0],
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            // width: 50,
                                              child: TextFormField(
                                                controller: discountController[0],
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: (val) {
                                                  if (val.isEmpty ||
                                                      val == '' ||
                                                      variantController[0]
                                                          .text
                                                          .isEmpty) {
                                                    amountController[0].text =
                                                        unitController[0].text;
                                                    discountController[0].text = '';
                                                  } else {
                                                    setState(() {
                                                      var tempDis = 0.0;
                                                      discountValue = 0.0;
                                                      // for(int i=0; i<)
                                                      tempDis = (double.parse(val) /
                                                          100) *
                                                          double.parse(
                                                              unitController[0].text);
                                                      discountAmountController[0] =
                                                          tempDis;
                                                      discountUnitController[0] =
                                                          tempDis;
                                                      for (int i = 0;
                                                      i <
                                                          discountAmountController
                                                              .length;
                                                      i++) {
                                                        discountValue = discountValue +
                                                            discountAmountController[i];
                                                      }

                                                      // amountController[index].text = unitController[index].text;
                                                      amountController[0]
                                                          .text = (double.parse(
                                                          unitController[0]
                                                              .text) -
                                                          (double.parse(val) /
                                                              100) *
                                                              double.parse(
                                                                  unitController[0]
                                                                      .text))
                                                          .toString();
                                                      amountValueController[0]
                                                          .text = (double.parse(
                                                          unitController[0]
                                                              .text) -
                                                          (double.parse(val) /
                                                              100) *
                                                              double.parse(
                                                                  unitController[0]
                                                                      .text))
                                                          .toString();

                                                      // print(discountValue);
                                                    });
                                                  }
                                                },
                                              )),
                                        ),
                                        variantController[0].text.isNotEmpty ||
                                            variantController[0].text != ""
                                            ? Expanded(
                                          flex: 3,
                                          child: PopupMenuButton(
                                            itemBuilder: (context) {
                                              return _quantity
                                                  .map((String items) {
                                                return PopupMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  Text(selectedQuantity[0],
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                  const Icon(
                                                      Icons.arrow_drop_down)
                                                ],
                                              ),
                                            ),
                                            onSelected: (String? newValue) {
                                              setState(() {
                                                discountValue = 0.0;
                                                selectedQuantity[0] =
                                                newValue!;
                                                // amountController[index].text = (double.parse(newValue)*double.parse(amountValueController[index].text)).toString();
                                                amountController[0]
                                                    .text = (double.parse(
                                                    newValue) *
                                                    double.parse(
                                                        amountValueController[
                                                        0]
                                                            .text))
                                                    .toStringAsFixed(2);
                                                var tempValue =
                                                    discountUnitController[
                                                    0] *
                                                        double.parse(
                                                            selectedQuantity[
                                                            0]);
                                                discountAmountController[0] =
                                                    tempValue;
                                                totalTaxValueController[0]
                                                    .text = (taxVal *
                                                    double.parse(
                                                        selectedQuantity[
                                                        0]))
                                                    .toStringAsFixed(2);
                                                for (int i = 0;
                                                i <
                                                    discountAmountController
                                                        .length;
                                                i++) {
                                                  discountValue = discountValue +
                                                      discountAmountController[
                                                      0];
                                                }
                                                grandTotal1 = grandTotal;
                                              });
                                            },
                                          ),
                                        )
                                            : SizedBox(
                                            width: 40, child: Container()),
                                        Expanded(
                                          flex: 4,
                                          child: SizedBox(
                                            // width: 100,
                                              child: TextFormField(
                                                readOnly: true,
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
                                                child: TextField(
                                                  controller: taxCode[0],
                                                  readOnly: true,
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return Dialog(
                                                            backgroundColor:
                                                            Colors.transparent,
                                                            child: SizedBox(
                                                              height: 450,
                                                              width: 500,
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        top: 13.0,
                                                                        right: 8.0),
                                                                    child:
                                                                    SingleChildScrollView(
                                                                      child:
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            25.0),
                                                                        child:
                                                                        Column(
                                                                          children: [
                                                                            const Align(
                                                                              alignment:
                                                                              Alignment.center,
                                                                              child:
                                                                              Text(
                                                                                'Select Tax percentage',
                                                                                style: TextStyle(
                                                                                    color: Colors.indigo,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              15,
                                                                            ),
                                                                            Container(
                                                                                height:
                                                                                40,
                                                                                color:
                                                                                Colors.grey[350],
                                                                                child: const Row(
                                                                                  children: [
                                                                                    Expanded(child: Center(child: Text("Name"))),
                                                                                    Expanded(child: Center(child: Text("Tax code"))),
                                                                                    Expanded(child: Center(child: Text("Total tax percentage"))),
                                                                                  ],
                                                                                )),
                                                                            Card(
                                                                              child:
                                                                              Column(
                                                                                children: [
                                                                                  const SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  for (int i = 0; i < taxList.length; i++)
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          taxCode[0].text = taxList[i]['tax_total'];
                                                                                          Navigator.of(context).pop();
                                                                                          taxVal = (double.parse(taxList[i]['tax_total']) / 100) * double.parse(unitController[0].text);
                                                                                          // totalTaxValueController[index].text= (taxVal*double.parse(selectedQuantity[index])).toString();
                                                                                          totalTaxValueController[0].text = (taxVal * double.parse(selectedQuantity[0])).toStringAsFixed(2);
                                                                                          grandTotal = double.parse(totalTaxValueController[0].text) + double.parse(amountController[0].text) - discountValue;
                                                                                          grandTotal1 = grandTotal;
                                                                                          var tempAmount = 0.0;
                                                                                          for (int i = 0; i < amountController.length; i++) {
                                                                                            tempAmount = tempAmount + double.parse(amountController[i].text);
                                                                                          }
                                                                                          gTotal = tempAmount;
                                                                                          //-----------------------
                                                                                          var tempTaxAmount = 0.0;
                                                                                          for (int i = 0; i < totalTaxValueController.length; i++) {
                                                                                            tempTaxAmount = tempTaxAmount + double.parse(totalTaxValueController[i].text);
                                                                                          }
                                                                                          gTATotal = tempTaxAmount;
                                                                                          //---------------------------
                                                                                          var tempTotal = 0.0;
                                                                                          for (int i = 0; i < grandTotal1; i++) {
                                                                                            // tempTotal = tempTotal + double.parse(grandTotal1.toString());
                                                                                            tempTotal = gTotal + gTATotal;
                                                                                          }
                                                                                          gTotalTotal = tempTotal;
                                                                                        });
                                                                                      },
                                                                                      child: Row(
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
                                                                                ],
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
                                                                                color: const Color.fromRGBO(
                                                                                    204,
                                                                                    204,
                                                                                    204,
                                                                                    1),
                                                                              ),
                                                                              color: Colors.blue),
                                                                          child: const Icon(
                                                                            Icons
                                                                                .close_sharp,
                                                                            color: Colors
                                                                                .white,
                                                                          )),
                                                                      onTap: () {
                                                                        setState(
                                                                                () {
                                                                              Navigator.of(
                                                                                  context)
                                                                                  .pop();
                                                                            });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Select Tax",
                                                      contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 10,
                                                          left: 10)),
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: SizedBox(
                                            // width: 100,
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: totalTaxValueController[0],
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                keyboardType: const TextInputType
                                                    .numberWithOptions(decimal: true),

                                                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
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
                          //---------footer------
                          Padding(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            child: SizedBox(
                              // width: 1200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              focusNode: terms,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                                  '',
                                                  termsAndConditions
                                                      .text.isNotEmpty),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10, left: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                if (value == null ||
                                                    value.isEmpty) {
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
                                              decoration: decorationInput6('',
                                                  customerNotes.text.isNotEmpty),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 0, bottom: 0, left: 10),
                                      child: SizedBox(
                                        height: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    const Text("Base Price"),
                                                    Text(
                                                      gTotal.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    const Text("Discounted Price"),
                                                    Text(
                                                      discountValue
                                                          .toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    const Text("Tax"),
                                                    Text(
                                                      gTATotal.toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    const Text("Freight Amount"),
                                                    Container(
                                                        height: 25,
                                                        width: 100,
                                                        color: Colors.grey[100],
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                          child: TextFormField(
                                                            textAlign:
                                                            TextAlign.right,
                                                            style: const TextStyle(
                                                                fontSize: 16),
                                                            decoration:
                                                            const InputDecoration(
                                                                border:
                                                                InputBorder
                                                                    .none),
                                                            controller:
                                                            freightController,
                                                            // maxLength: 50,
                                                            keyboardType:
                                                            TextInputType
                                                                .number,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            onChanged: (v) {
                                                              double val = 0.0;
                                                              setState(() {
                                                                if (v.isNotEmpty ||
                                                                    v != "") {
                                                                  val = gTotal +
                                                                      discountValue +
                                                                      gTATotal +
                                                                      double.parse(
                                                                          v);
                                                                } else {
                                                                  val = gTotal +
                                                                      discountValue +
                                                                      gTATotal;
                                                                }
                                                              });
                                                              gTotalTotal = val;
                                                              // print(grandTotal1);
                                                              // print(gTotalTotal);
                                                              // print(freightController.text);
                                                            },
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Container(
                                                color: Colors.grey[300],
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      const Text("Total"),
                                                      // Text(grandTotal1.toString()),
                                                      Text(
                                                        gTotalTotal
                                                            .toStringAsFixed(2),
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
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
                    )),
              ),
              bottomNavigationBar: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                      child: MaterialButton(
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            vendorName.text.isEmpty
                                ? vendorNameError = true
                                : vendorNameError = false;
                          });

                          if (_addPurchaseForm.currentState!.validate() &&
                              vendorName.text.isNotEmpty) {
                            final dateNow = DateFormat('dd-MM-yyyy hh:mm:ss');
                            Map requestData = {
                              "shipping_address": fetchingWarehouseAddress.text,
                              "vendor_name": vendorName.text,
                              "new_vendor_id": vendorID,
                              "billing_address": vendorPayToAddress.text,
                              "reference": referenceNo.text,
                              "expected_delivery_date": expDeliveryDate.text,
                              "shipment_preference": shipmentReferenceNo.text,
                              "freight_amount": freightController.text,
                              "base_price": gTotal,
                              "discounted_price":
                              double.parse(discountValue.toString()),
                              "tax": gTATotal,
                              "freight_amount": freightController.text,
                              "grand_total": gTotalTotal,
                              "customer_notes": customerNotes.text,
                              "terms_conditions": termsAndConditions.text,
                              'date': dateNow.format(DateTime.now()),
                              'grn_status': 'no'
                            };

                            // print(requestData);
                            addPurchaseVehicleOrder(requestData);
                          }
                        },
                        child: const Text("Save",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
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

  Widget showDialogBox(){
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 650,
        height: 400,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.only(top: 13.0, right: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Select Vehicle',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                              child: const Row(
                                children: [
                                  Expanded(child: Center(child: Text("Brand"))),
                                  Expanded(child: Center(child: Text("Model"))),
                                  Expanded(child: Center(child: Text("Variant"))),
                                  Expanded(child: Center(child: Text("On road price"))),
                                  Expanded(child: Center(child: Text("Color"))),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            for (int i = 0; i < vvList.length; i++)
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      brandController[0].text = vvList[i]['make'];
                                      modelController[0].text = vvList[i]['model_name'];
                                      variantController[0].text = vvList[i]['varient_name'];
                                      discountController[0].text = '0';
                                      unitController[0].text = vvList[i]['onroad_price'].toString();
                                      amountController[0].text = vvList[i]['onroad_price'].toString();
                                      amountValueController[0].text = vvList[i]['onroad_price'].toString();
                                      colorController[0].text = vvList[i]['varient_color1'];
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
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 30,
                                                  child:
                                                  Text(vvList[i]['make']),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 30,
                                                  child: Text(
                                                      vvList[i]['model_name']),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 38,
                                                  child: Text(vvList[i]['varient_name']),
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
                                                  height: 38,
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
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
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
      ),
    );
  }


  Future addPurchaseVehicleOrder(Map<dynamic, dynamic> data) async {
    String url =
        "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/add_new_vehi_pur";
    // print('----------header url------------');
    // print(url);
    postData(context: context, url: url, requestBody: data).then((value) {
      // print('------------- add purchase value------------');
      // print(value);
      setState(() {
        if (value != null) {
          Map responseJson = {};
          responseJson = value;
          if (responseJson.containsKey('id')) {
            poId = responseJson['id'];
            List lineData = [];
            for (int i = 0; i < tableData.length; i++) {
              lineData.add({
                "brand": brandController[i].text,
                "model": modelController[i].text,
                "varient": variantController[i].text,
                "color": colorController[i].text,
                "unit_price": unitController[i].text,
                "discount": discountController[i].text,
                "quantity": selectedQuantity[i],
                "amount": amountController[i].text,
                "tax_code": taxCode[i].text,
                "tax_amount": totalTaxValueController[i].text,
                "new_pur_vehi_id": poId,
                "recieved_quantity": 0,
                "short_quantity": 0,
              });
              // print(lineData);
              log("Purchase Order Created, Waiting for Table Creation $poId");
              addTableApi(lineData, true);
              // print('----------addPurchaseVehicleOrder------------');
              // print(lineData);
            }
          }
          Navigator.of(context).pop();
        }
        loading = true;
      });
    });
  }

  Future addTableApi(List data, bool length) async {
    // print('---------tableData-----------');
    // print(data);
    // print('---------tableData-----------');
    for (int i = 0; i < tableData.length; i++) {
      String url =
          "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchaseline/add_new_vehi_pur_line";
      // print('------url--------');
      // print(url);
      postData(requestBody: data[i], url: url, context: context).then((value) {
        setState(() {
          if (value != null) {
            // data = value;
            // print('-------addTableAPI value---------');
            // print(value);
          }
        });
      });
    }
  }
}

class ItemData {
  final String label;
  final String name;

  final String brand;

  ItemData({
    required this.label,
    required this.name,
    required this.brand,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      label: json['brand'],
      name: json['name'],
      brand: json['brand'],
    );
  }
}

class ModelData {
  final String label;
  final String name;

  final String brand;

  ModelData({
    required this.label,
    required this.name,
    required this.brand,
  });

  factory ModelData.fromJson(Map<String, dynamic> json) {
    return ModelData(
      label: json['name'],
      name: json['name'],
      brand: json['brand'],
    );
  }
}

class VariantData {
  final String label;
  final double exShowroomPrice;

  final String model;

  VariantData({
    required this.label,
    required this.exShowroomPrice,
    required this.model,
  });

  factory VariantData.fromJson(Map<String, dynamic> json) {
    print('--------- variant data --------');
    print(json);
    return VariantData(
      label: json['varient'],
      exShowroomPrice: json['onroad_price'],
      model: json['model_name'],
    );
  }
}
