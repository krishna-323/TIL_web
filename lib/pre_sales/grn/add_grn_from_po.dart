import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/api/get_api.dart';
import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/input_decoration_text_field.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';
class UpdatedGrn extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final String vendorName;
  final String vendorId;
  final String purchaseOrderNumber;
  final String dateInput;
  final String selectId;
  final String freightAmount;
  final String termsCondition;
  final String customerNotes;
  final double taxAmount;
  final double basePrice;
  final double grandTotal;

  const UpdatedGrn({
    Key? key,
    required this.taxAmount,
    required this.basePrice,
    required this.grandTotal,
    required this.drawerWidth,
    required this.selectedDestination,
    required this.vendorName,
    required this.vendorId,
    required this.dateInput,
    required this.purchaseOrderNumber,
    required this.selectId,
    required this.freightAmount,
    required this.termsCondition,
    required this.customerNotes,

  }) : super(key: key);

  @override
  State<UpdatedGrn> createState() => _UpdatedGrnState();
}

class _UpdatedGrnState extends State<UpdatedGrn> {
  String taxPercentage='';
  double unitPrice=0.0;

  @override
  initState() {
    print(widget.basePrice);
    print(widget.taxAmount);
    print(widget.grandTotal);
    print(widget.freightAmount);

    selectedId = widget.selectId;
    print(selectedId);
    vendorName.text = widget.vendorName;
    vendorID = widget.vendorId;
    freightAmountController.text = widget.freightAmount;
    termsConditionController.text = widget.termsCondition;
    customerNoteController.text = widget.customerNotes;
    orderNumber.text = widget.purchaseOrderNumber;
    dateInput.text = widget.dateInput.substring(0, 10);
    fetchGetVehiclePurchaseDetails();

    getInitialData();
    super.initState();
  }
  //Passing values One Class another Class For Storing Purpose Created Variables.
  int? receivedQtyValue;
  String lineAutoGenId="";
  String poLineId='';
  String shortQuantityValue='';
  int? updateValue;
  String model='';
  String brand='';
  String variant='';
  final grnNote = TextEditingController();
  final dateInput = TextEditingController();
  final vendorName = TextEditingController();
  final orderNumber = TextEditingController();
  final grnNumber = TextEditingController();
  final grnDate = TextEditingController();
  final freightAmountController = TextEditingController();
  final termsConditionController = TextEditingController();
  final customerNoteController = TextEditingController();
  bool freightError = false;
  bool poDateError = false;
  bool grnError = false;
  bool grnDateError = false;
  bool grnRefError = false;
  bool vendorError = false;
  bool orderError = false;
  String? authToken;
  List receivedQuantityList = <TextEditingController>[];
  List receivedQtyError = <bool>[];

  List shortQty = [];
  List updatedQty=[];

  // final vinSide = TextEditingController();
  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }

  Future addGrn(Map<dynamic,dynamic> ag) async{
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclegrn/add_newvehiclegrn";
    postData(requestBody: ag,url: url,context: context).then((value) {
      setState(() {
        if(value!=null){
          // print('------------');
          Map tempMap = {};
          tempMap= value;
          if(tempMap.containsKey("id")){
            for(int  i=0;i<receivedQtyValue!;i++){
              //Save Details Api().
              vinList[i]['newvehi_grn_id']=tempMap["id"];
              saveVinNumberDetails(vinList[i],receivedQtyValue==i+1);
              globalBool = true;
            }
          }
        }
      });
    });
  }

  Future updateLineData(Map<dynamic,dynamic> updateLine)async{
    //wait key word is valued inside async Function.
    //Put Means Update api.
    final response=await http.put(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchaseline/update_new_vehi_pur_line'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
      body: json.encode(updateLine),
    );
    if(response.statusCode==200){

    }
    else{


    }
  }

  Future saveVinNumberDetails(Map<dynamic,dynamic> mapVinData, bool navBack)async{
    final response = await http.post(Uri.parse(
        "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/recieved_quantity/add_recieved_quantity"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken'
        },
        body: json.encode(mapVinData));
    if (response.statusCode == 200) {
      if(navBack) {
        final response=await http.put(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/update_purchase_order/$poLineId/Yes'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          // body: json.encode(updatedSecondApi),
        );
        if(response.statusCode==200){
          // Navigator.pop(context);
          Navigator.pop(context);
        }
        else{

        }
      }
    }
    else {
      print("++++++ Status Code ++++++++");
      print(response.statusCode.toString());
    }
  }

  bool globalBool = false;
  List vinList = [];

  final vinForm=GlobalKey<FormState>();
  final mainForm=GlobalKey<FormState>();
  List<TextEditingController> vinControllersSideList = [];
  List<TextEditingController> notesSideControllersList = [];
  bool grnVinListErrors=false;
  Map updateLineDetails={};
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDrawer(widget.drawerWidth, widget.selectedDestination),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(88.0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: AppBar(
                        elevation: 1,
                        surfaceTintColor: Colors.white,
                        shadowColor: Colors.black,
                        title: const Text("Generate GRN"),
                      ),
                    )
                ),
                body: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Form(
                      key: mainForm,
                      child: Column(children: [
                        // Container(
                        //   height: 60,
                        //   decoration: BoxDecoration(
                        //       border: Border.all(
                        //         width: 0.1,
                        //       )),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 50, right: 50),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: const [
                        //         Text(
                        //           'Generate GRN',
                        //           style: TextStyle(
                        //               fontSize: 20,
                        //               color: Colors.indigo,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //first Row
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //vendor name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Vendor Name',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 335,
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: vendorError ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              vendorError = true;
                                            });
                                            return "Required";
                                          } else {
                                            setState(() {
                                              vendorError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (text) {
                                          setState(() {});
                                        },
                                        controller: vendorName,
                                        decoration: decorationInput5(
                                            'Vendor Name', vendorName.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //purchase order number
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Purchase Order Number',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 335,
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: orderError ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              orderError = true;
                                            });
                                            return "Required";
                                          } else {
                                            setState(() {
                                              orderError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (text) {
                                          setState(() {});
                                        },
                                        controller: orderNumber,
                                        decoration: decorationInput5('Order Number',
                                            orderNumber.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //purchase order date.
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Purchase Order Date'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 335,
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: poDateError ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              poDateError = true;
                                            });
                                            return "Required";
                                          } else {
                                            setState(() {
                                              poDateError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (text) {
                                          setState(() {});
                                        },
                                        controller: dateInput,
                                        decoration: decorationInput5(
                                            'Enter Date', dateInput.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        //second Row.
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //grn number
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'GRN Number',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 335,
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: grnError ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              grnError = true;
                                            });
                                            return "Required";
                                          } else {
                                            setState(() {
                                              grnError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (text) {
                                          setState(() {});
                                        },
                                        controller: grnNumber,
                                        decoration: decorationInput5(
                                            'GRN Number', grnNumber.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //grn date
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'GRN Date',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 335,
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: grnDateError ? 55 : 30,
                                      child: TextFormField(
                                        controller: grnDate,
                                        validator: (value) {
                                          if(value == null || value.isEmpty){
                                            setState(() {
                                              grnDateError = true;
                                            });
                                            return "Required";
                                          }else {
                                            setState(() {
                                              grnDateError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        //editing controller of this TextField
                                        decoration: decorationInput5("", grnDate.text.isNotEmpty),
                                        //    readOnly: true,  //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101));

                                          if (pickedDate != null) {
                                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                            setState(() {
                                              grnDate.text = formattedDate; //set output date to TextField value.
                                            });
                                          } else {
                                            log("Date is not selected");
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //grn note
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('GRN Reference'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 335,
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: grnRefError ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              grnRefError = true;
                                            });
                                            return "Required";
                                          } else {
                                            setState(() {
                                              grnRefError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (text) {
                                          setState(() {});
                                        },
                                        controller: grnNote,
                                        decoration: decorationInput5(
                                            'GRN Reference', grnNote.text.isNotEmpty),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 40,
                            color: Colors.grey[200],
                            child: Row(
                              children:  [
                                const Expanded(child: Center(child: Text("Vehicle Name"))),
                                const Expanded(child: Center(child: Text("Variant Color"))),
                                const Expanded(child: Center(child: Text('Ordered QTY'))),
                                Expanded(child: Center(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children:const [

                                    Text('Updated'),
                                    Text('Received QTY')
                                  ],
                                ),)),
                                const Expanded(child: Center(child: Text('Received QTY'))),
                                const Expanded(child: Center(child: Text('TAX PER'))),
                                const Expanded(child: Center(child: Text("Short QTY"))),
                                const Expanded(child: Center(child: Text("Unit Price"))),
                                const Expanded(child: Center(child: Text("GRN Details"))),
                              ],
                            )),
                        for (int i = 0; i < getVehicle.length; i++)
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  // var shortQty=getVehicle[i]['quantity'].toString();
                                  //var name;
                                  setState(() {

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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5),
                                                    child: Column(
                                                      children: [
                                                        Text(getVehicle[i]['brand']),
                                                      ],
                                                    ),
                                                  )),
                                            ))),
                                    Expanded(
                                        child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                  height: 38,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(getVehicle[i]['color'])),
                                            ))),
                                    Expanded(
                                        child: Center(
                                            child: SizedBox(
                                                height: 30,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child: Column(
                                                        children: [
                                                          Text(getVehicle[i]['quantity'].toString()),
                                                        ],
                                                      ),
                                                    ))))),
                                    Expanded(
                                        child: Center(
                                            child: SizedBox(
                                                height: 30,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child: Column(
                                                        children: [
                                                          Text(updatedQty[i].toString()),
                                                        ],
                                                      ),
                                                    ))))),
                                    Expanded(
                                        child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                // height: 30,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      color: Colors.grey.shade300,
                                                      child: Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 10, bottom: 5),
                                                          child: TextField(
                                                            keyboardType: TextInputType.number,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.digitsOnly
                                                            ],
                                                            onChanged: (value) {

                                                              setState(() {

                                                                //If This Condition Is True It Will Go Inside
                                                                if (receivedQuantityList[i].text.isNotEmpty) {
                                                                  //Entered Text LessThan or (Equal) To Ordered Quantity Condition True It Will Go Inside.
                                                                  if (double.parse(receivedQuantityList[i].text) <= getVehicle[i]['quantity']) {
                                                                    //Assigning Value And Calculating (Subtraction).
                                                                    shortQty[i] = (getVehicle[i]['quantity'] - double.parse(receivedQuantityList[i].text)).toString();
                                                                  }
                                                                  //Entered Received Quantity IsGrater Than Vehicle Ordered Quantity It Will Clear() The TextField.
                                                                  if (double.parse(receivedQuantityList[i].text) > getVehicle[i]['quantity']) {
                                                                    receivedQuantityList[i].clear();
                                                                  }

                                                                }
                                                                //Received Quantity TextField Is Empty This Condition Will Assign Ordered Quantity To Short Quantity.
                                                                if (receivedQuantityList[i].text.isEmpty) {
                                                                  shortQty[i] = getVehicle[i]['quantity'].toString();
                                                                }
                                                                if(receivedQuantityList[i].text.toString().isNotEmpty || receivedQuantityList[i].text.toString()==null){
                                                                  shortQty[i]=(int.parse(getVehicle[i]['quantity'].toString())-(updatedQty[i]+int.parse(receivedQuantityList[i].text.toString()))).toString();
                                                                  if(double.parse(receivedQuantityList[i].text)+ updatedQty[i] >getVehicle[i]['quantity']){
                                                                    shortQty[i]=0;
                                                                    print('--------------short quantity-------------');
                                                                    print(shortQty[i]);
                                                                  }
                                                                }

                                                              },
                                                              );

                                                            },
                                                            decoration: const InputDecoration(
                                                                border: InputBorder.none),
                                                            controller: receivedQuantityList[i],
                                                          )

                                                      ),
                                                    ),
                                                    if (receivedQtyError[i])
                                                      const Text(
                                                        'Required',
                                                        style: TextStyle(
                                                            color: Colors.red, fontSize: 10),
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ))),
                                    Expanded(
                                        child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                // height: 30,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Column(
                                                    children: [
                                                      Text(getVehicle[i]['tax_code']),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ))),
                                    Expanded(
                                        child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                // height: 30,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Column(
                                                    children: [
                                                      Text(shortQty[i].toString()),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ))),
                                    Expanded(
                                        child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                  height: 30,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 5),
                                                        child: Column(
                                                          children: [
                                                            Text(getVehicle[i]['unit_price'].toString()),
                                                          ],
                                                        ),
                                                      ))),
                                            ))),
                                    Expanded(
                                        child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 30,
                                                width: 60,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Center(
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: OutlinedMButton(
                                                            text: 'Add',
                                                            buttonColor:mSaveButton ,
                                                            textColor: Colors.white,
                                                            borderColor: mSaveButton,
                                                            onTap: () {
                                                              setState(() {
                                                                //This If Condition Is For Displaying Error Message.
                                                                if(receivedQuantityList[i].text.isEmpty? receivedQtyError[i] = true : receivedQtyError[i] = false) {}
                                                                //This Else If Condition For Small Pop up Message Box.
                                                                else if ((updatedQty[i]+int.parse(receivedQuantityList[i].text.toString()))>int.parse(getVehicle[i]['quantity'].toString())){
                                                                  showDialog(context: context,
                                                                      builder: (BuildContext context){
                                                                        return  AlertDialog(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                                                                          content:  SizedBox(
                                                                            height: 150,
                                                                            width: 250,
                                                                            child: Column(
                                                                              children:  [
                                                                                const SizedBox(height: 25,),
                                                                                const Text('Updated Received Quantity',style: TextStyle(fontSize: 20)),
                                                                                const Text('Not Exceed Order Quantity',style: TextStyle(fontSize: 20),),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 15),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      InkWell(
                                                                                        child: Container(width: 50,
                                                                                          color: Colors.green,
                                                                                          height:25,child: const Center(child: Text('OK',
                                                                                            style: TextStyle(color: Colors.white),)),
                                                                                        ),
                                                                                        onTap: (){
                                                                                          setState(() {
                                                                                            Navigator.of(context).pop();
                                                                                          });
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );}
                                                                  );
                                                                }
                                                                //This Else If Condition For Big formPop Message VinNumber and Notes Numbers.
                                                                else if(receivedQuantityList[i].text.isNotEmpty) {
                                                                  updateValue=updatedQty[i];
                                                                  shortQuantityValue=shortQty[i];
                                                                  poLineId=selectedId;
                                                                  lineAutoGenId=getVehicle[i]['new_purveh_line_id'];
                                                                  receivedQtyValue=int.parse(receivedQuantityList[i].text);
                                                                  model =getVehicle[i]['model'];
                                                                  brand=getVehicle[i]['brand'];
                                                                  variant=getVehicle[i]['varient'];
                                                                  unitPrice=getVehicle[i]['unit_price'];
                                                                  taxPercentage=getVehicle[i]['tax_code'];

                                                                  print(model);
                                                                  updateLineDetails={
                                                                    'new_purveh_line_id':lineAutoGenId,
                                                                    'brand':getVehicle[i]['brand'],
                                                                    'model':getVehicle[i]['model'],
                                                                    'varient':getVehicle[i]['varient'],
                                                                    'color':getVehicle[i]['color'],
                                                                    'unit_price':getVehicle[i]['unit_price'],
                                                                    'discount':getVehicle[i]['discount'],
                                                                    'quantity':getVehicle[i]['quantity'],
                                                                    'amount':getVehicle[i]['amount'],
                                                                    'tax_code':getVehicle[i]['tax_code'],
                                                                    'tax_amount':getVehicle[i]['tax_amount'],
                                                                    'new_pur_vehi_id':getVehicle[i]['new_pur_vehi_id'],
                                                                    "recieved_quantity":receivedQtyValue!+updatedQty[i],
                                                                    'short_quantity':shortQuantityValue,
                                                                  };
                                                                  //This IS a Method
                                                                  showGrnListDetails(context, receivedQtyValue,lineAutoGenId,poLineId,shortQuantityValue,updateValue!,

                                                                      updateLineDetails,authToken,model,brand,variant,unitPrice,taxPercentage);
                                                                }

                                                              });
                                                            },
                                                          ),
                                                          // Text('check'),
                                                          // MaterialButton(
                                                          //     color: Colors.blue,
                                                          //     child: const Text('Add',style: TextStyle(color: Colors.white),),
                                                          //     onPressed: () {
                                                          //       setState(() {
                                                          //         //This If Condition Is For Displaying Error Message.
                                                          //         if(receivedQuantityList[i].text.isEmpty? receivedQtyError[i] = true : receivedQtyError[i] = false) {}
                                                          //         //This Else If Condition For Small Pop up Message Box.
                                                          //         else if ((updatedQty[i]+int.parse(receivedQuantityList[i].text.toString()))>int.parse(getVehicle[i]['quantity'].toString())){
                                                          //           showDialog(context: context,
                                                          //               builder: (BuildContext context){
                                                          //                 return  AlertDialog(
                                                          //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                                                          //                   content:  SizedBox(
                                                          //                     height: 150,
                                                          //                     width: 250,
                                                          //                     child: Column(
                                                          //                       children:  [
                                                          //                         const SizedBox(height: 25,),
                                                          //                         const Text('Updated Received Quantity',style: TextStyle(fontSize: 20)),
                                                          //                         const Text('Not Exceed Order Quantity',style: TextStyle(fontSize: 20),),
                                                          //                         Padding(
                                                          //                           padding: const EdgeInsets.only(top: 15),
                                                          //                           child: Row(
                                                          //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //                             children: [
                                                          //                               InkWell(
                                                          //                                 child: Container(width: 50,
                                                          //                                   color: Colors.green,
                                                          //                                   height:25,child: const Center(child: Text('OK',
                                                          //                                     style: TextStyle(color: Colors.white),)),
                                                          //                                 ),
                                                          //                                 onTap: (){
                                                          //                                   setState(() {
                                                          //                                     Navigator.of(context).pop();
                                                          //                                   });
                                                          //                                 },
                                                          //                               ),
                                                          //                             ],
                                                          //                           ),
                                                          //                         ),
                                                          //                       ],
                                                          //                     ),
                                                          //                   ),
                                                          //                 );}
                                                          //           );
                                                          //         }
                                                          //         //This Else If Condition For Big formPop Message VinNumber and Notes Numbers.
                                                          //         else if(receivedQuantityList[i].text.isNotEmpty) {
                                                          //           updateValue=updatedQty[i];
                                                          //           shortQuantityValue=shortQty[i];
                                                          //           poLineId=selectedId;
                                                          //           lineAutoGenId=getVehicle[i]['new_purveh_line_id'];
                                                          //           receivedQtyValue=int.parse(receivedQuantityList[i].text);
                                                          //           model =getVehicle[i]['model'];
                                                          //           brand=getVehicle[i]['brand'];
                                                          //           variant=getVehicle[i]['varient'];
                                                          //           unitPrice=getVehicle[i]['unit_price'];
                                                          //           taxPercentage=getVehicle[i]['tax_code'];
                                                          //
                                                          //           print(model);
                                                          //           updateLineDetails={
                                                          //             'new_purveh_line_id':lineAutoGenId,
                                                          //             'brand':getVehicle[i]['brand'],
                                                          //             'model':getVehicle[i]['model'],
                                                          //             'varient':getVehicle[i]['varient'],
                                                          //             'color':getVehicle[i]['color'],
                                                          //             'unit_price':getVehicle[i]['unit_price'],
                                                          //             'discount':getVehicle[i]['discount'],
                                                          //             'quantity':getVehicle[i]['quantity'],
                                                          //             'amount':getVehicle[i]['amount'],
                                                          //             'tax_code':getVehicle[i]['tax_code'],
                                                          //             'tax_amount':getVehicle[i]['tax_amount'],
                                                          //             'new_pur_vehi_id':getVehicle[i]['new_pur_vehi_id'],
                                                          //             "recieved_quantity":receivedQtyValue!+updatedQty[i],
                                                          //             'short_quantity':shortQuantityValue,
                                                          //           };
                                                          //           //This IS a Method
                                                          //           showGrnListDetails(context, receivedQtyValue,lineAutoGenId,poLineId,shortQuantityValue,updateValue!,
                                                          //
                                                          //               updateLineDetails,authToken,model,brand,variant,unitPrice,taxPercentage);
                                                          //         }
                                                          //
                                                          //       });
                                                          //
                                                          //     }),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ))),
                                  ],
                                ),
                              ),

                              SizedBox(height: 30,),
                              Row(children: [
                                Expanded(child: Container()),
                                Expanded(child: Container()),
                                Padding(
                                  padding: const EdgeInsets.only(right: 50.0),
                                  child:
                                  SizedBox(
                                    width: 300,
                                    child: Column(children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          const Text('Tax Amount'),

                                          Text(widget.taxAmount.toString()),
                                        ],),
                                      const SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          const Text('Base Price'),

                                          Text(widget.basePrice.toString()),
                                        ],),
                                      const SizedBox(height: 10,),

                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          const Text('Feright Amount'),
                                          const SizedBox(width: 25,),
                                          Text(widget.freightAmount.toString()),
                                        ],),
                                      const SizedBox(height: 10,),
                                      Container(height: 1.5,color: Colors.blue,),
                                      const SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Grand Total'),

                                          Text(widget.grandTotal.toString()),
                                        ],)
                                    ],),
                                  ),
                                )
                              ],)
                            ],
                          ),

                      ]),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(204, 204, 204, 1))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Row(children: [
                      SizedBox(
                        height: 30,
                        width: 80,
                        child: OutlinedMButton(
                            text: "Save",
                          buttonColor:mSaveButton ,
                          textColor: Colors.white,
                          borderColor: mSaveButton,
                          onTap: () {
                            for (int i = 0; i < getVehicle.length; i++) {
                              // if(receivedQuantityList[i].text.isEmpty? receivedQtyError[i] = true : receivedQtyError[i] = false) {}
                              if(receivedQuantityList[i].text.isEmpty){
                                receivedQtyError[i] = true;
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter VIN Data")));
                              }else{
                                receivedQtyError[i] = false;
                              }
                              if(mainForm.currentState!.validate()){
                                Map addGrnPO = {
                                  "amount": getVehicle[i]['unit_price'].toString(),
                                  "grn_date": grnDate.text,
                                  "grn_number": grnNumber.text,
                                  "grn_ref": grnNote.text,
                                  "ordered_quantity": getVehicle[i]['quantity'],
                                  "purchase_order_date": dateInput.text,
                                  "purchase_order_number": orderNumber.text,
                                  "recieved_quantity": receivedQuantityList[i].text,
                                  "short_quantity": shortQty[i].toString(),
                                  "tax_percent": getVehicle[i]['tax_code'],
                                  "updated_recieved_quantity": updatedQty[i].toString(),
                                  "varient_color": getVehicle[i]['color'],
                                  "vehicle_name": getVehicle[i]['brand'],
                                  "vendor_name": vendorName.text,
                                  "new_vendor_id":vendorID,
                                  "freight_amount": freightAmountController.text,
                                  "terms_conditions": termsConditionController.text,
                                  "customer_notes": customerNoteController.text,
                                  "status":"",
                                };
                                // print('----------addGrnPo--------');
                                // print(addGrnPO);
                                addGrn(addGrnPO);
                                updateLineData(updateLineDetails);
                              }
                            }
                          },
                        ),
                      ),
                      // MaterialButton(
                      //     color: Colors.lightBlue,
                      //     child: const Text("Save",style: TextStyle(color: Colors.white),),
                      //     onPressed: () {
                      //       for (int i = 0; i < getVehicle.length; i++) {
                      //         // if(receivedQuantityList[i].text.isEmpty? receivedQtyError[i] = true : receivedQtyError[i] = false) {}
                      //         if(receivedQuantityList[i].text.isEmpty){
                      //           receivedQtyError[i] = true;
                      //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter VIN Data")));
                      //         }else{
                      //           receivedQtyError[i] = false;
                      //         }
                      //         if(mainForm.currentState!.validate()){
                      //           Map addGrnPO = {
                      //             "amount": getVehicle[i]['unit_price'].toString(),
                      //             "grn_date": grnDate.text,
                      //             "grn_number": grnNumber.text,
                      //             "grn_ref": grnNote.text,
                      //             "ordered_quantity": getVehicle[i]['quantity'],
                      //             "purchase_order_date": dateInput.text,
                      //             "purchase_order_number": orderNumber.text,
                      //             "recieved_quantity": receivedQuantityList[i].text,
                      //             "short_quantity": shortQty[i].toString(),
                      //             "tax_percent": getVehicle[i]['tax_code'],
                      //             "updated_recieved_quantity": updatedQty[i].toString(),
                      //             "varient_color": getVehicle[i]['color'],
                      //             "vehicle_name": getVehicle[i]['brand'],
                      //             "vendor_name": vendorName.text,
                      //             "new_vendor_id":vendorID,
                      //             "freight_amount": freightAmountController.text,
                      //             "terms_conditions": termsConditionController.text,
                      //             "customer_notes": customerNoteController.text,
                      //             "status":"",
                      //           };
                      //           // print('----------addGrnPo--------');
                      //           // print(addGrnPO);
                      //           addGrn(addGrnPO);
                      //           updateLineData(updateLineDetails);
                      //         }
                      //       }
                      //     }),
                      const SizedBox(
                        width: 20,
                      ),
                      // MaterialButton(
                      //     color: Colors.white,
                      //     child: const Text("Cancel"),
                      //     onPressed: () {
                      //       setState(() {
                      //         Navigator.of(context).pop();
                      //       });
                      //     })
                    ]),
                  ),
                ),
              ),
            )
          ]),
    );
  }
  List getVehicle = [];
  String  selectedId='';
  String vendorID = "";

  Future fetchGetVehiclePurchaseDetails() async {
    dynamic response;
    String url='https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchaseline/get_vehicle_purchase_details/$selectedId';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            getVehicle=value;

            for (int i = 0; i < getVehicle.length; i++) {


              shortQty.add(getVehicle[i]['quantity'].toString());
              shortQty[i]=getVehicle[i]['short_quantity'];
              //This IS For Displaying Error According To Index Position Message.
              receivedQtyError.add(false);
              //This Is For List Of Controllers.
              receivedQuantityList.add(TextEditingController());
              updatedQty.add(getVehicle[i]['recieved_quantity']);
              if(updatedQty[i]==0){
                shortQty[i]=shortQty[i];
              }
              if(updatedQty[i]>0){
                shortQty[i]=(getVehicle[i]['quantity']-updatedQty[i]).toString();
              }
              // print('-------caluculation-----------------');
              //print(int.parse(getVehicle[i]['tax_code']) / 100 * int.parse(getVehicle[i]['unit_price']));
              // taxAmount = int.parse(getVehicle[i]['tax_code']) / 100 * int.parse(getVehicle[i]['unit_price']);
              // print(taxAmount);
              // basePrice = int.parse(poId['recieved_quantity']) * int.parse(poId['amount']);
              // grandTotal = basePrice! + taxAmount! + poId['freight_amount'];
            }

          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context:context ,response:response ,exception: toString());
      setState(() {
        loading=false;
      });
    }
  }

  showGrnListDetails(BuildContext context,
      receivedQtyValue,
      String lineAutoGenId,
      String poLineId,
      String shortQuantityValue,
      int updateValue,
      Map<dynamic, dynamic> updateLineDetails,authT ,
      String model,
      String brand,
      String variant,
      double unitPrice,
      String taxPercentage,
      ){

    final vinForm=GlobalKey<FormState>();
    int? receivedQuantityVal;
    List<TextEditingController> vinControllersSideList = [];
    List<TextEditingController> notesSideControllersList = [];
    bool grnVinListErrors=false;
    // String purchaseLineId=poLineId;
    String lineAutoId=lineAutoGenId;
    Map mapVinData={};
    receivedQuantityVal=receivedQtyValue;
    int indexReceived =0;





    showDialog(context: context, builder: (BuildContext context){
      return StatefulBuilder(builder:(context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          content: SizedBox(
            height: 450,
            width: 450,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Received Quantity List',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 20),
                      ),
                      InkWell(
                        child: const Icon(Icons.close_sharp),
                        onTap: () {setState(() {Navigator.of(context).pop();});
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  color: Colors
                      .grey[200],
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("SN"),),
                      Expanded(
                          child: Center(child: Text("VIN"))),
                      Expanded(
                          child: Center(child: Text('Notes'))),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                //This Is For List Of Controllers.
                Expanded(
                  child: Form(key: vinForm,
                    child: ListView.builder(
                        itemCount:receivedQuantityVal,
                        // itemCount: int.parse(receivedQty.text),
                        itemBuilder: ((BuildContext context, int index) {
                          indexReceived = index +1;
                          //And Taking Each Every Controller Value Adding To List[].

                          vinControllersSideList.add(TextEditingController());
                          notesSideControllersList.add(TextEditingController());

                          return
                            Padding(
                              padding: const EdgeInsets.only(top: 5),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Sl no value.
                                  Text('$indexReceived'),
                                  const SizedBox(width: 50,),
                                  SizedBox(width:200,
                                    child: AnimatedContainer(
                                      height:grnVinListErrors?55:30,
                                      duration: const Duration(seconds: 0),
                                      child: TextFormField(
                                        validator: (value){
                                          if(value ==null || value.isEmpty){
                                            setState((){
                                              grnVinListErrors=true;
                                            });
                                            return 'Required';
                                          }
                                          else{
                                            setState((){
                                              grnVinListErrors=false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        controller: vinControllersSideList[index],
                                        decoration:decorationInput5('Enter Vin Number',vinControllersSideList[index].text.isNotEmpty) ,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  SizedBox(width:155,
                                    child: AnimatedContainer(height: grnVinListErrors?55:30,
                                      duration: const Duration(seconds: 0),
                                      child: TextFormField(
                                        validator: (value){
                                          if(value ==null || value.isEmpty){
                                            setState((){
                                              grnVinListErrors=true;
                                            });
                                            return 'Required';
                                          }
                                          else{
                                            setState((){
                                              grnVinListErrors=false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        controller: notesSideControllersList[index],
                                        decoration:decorationInput5('Enter Notes',notesSideControllersList[index].text.isNotEmpty) ,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                        })),
                  ),
                ),
                const SizedBox(height: 25,),
                Align(
                  alignment: Alignment.topLeft,
                  child:
                  //Save button Calling Two App's  Post Api and Updated Api.

                  MaterialButton(
                      color: Colors.lightBlue,
                      child: const Text('Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {

                        setState(() {
                          if(vinForm.currentState!.validate()){
                            //How To call Post Api Inside  For Loop.
                            for(int  i=0;i<receivedQuantityVal!;i++){
                              //Save Details Api().
                              mapVinData={
                                'new_purveh_line_id':lineAutoId,
                                'notes':notesSideControllersList[i].text,
                                'vin_number':vinControllersSideList[i].text,

                                'brand':brand,
                                'model':model,
                                'varient':variant,
                                'unit_price':unitPrice.toString(),
                                'tax_code':taxPercentage,
                              };
                              print('------new add fields----------');
                              print(mapVinData);
                              vinList.add(mapVinData);
                              //This Is a post API().
                              // print(indexReceived);
                              // saveVinNumberDetails(mapVinData,indexReceived==i+1);
                              globalBool = true;
                            }
                            Navigator.pop(context);
                          }


                        });
                      }),
                )
              ],
            ),
          ),
        );
      },);
    },);
  }
}


