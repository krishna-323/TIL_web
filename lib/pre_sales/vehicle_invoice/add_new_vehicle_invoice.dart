import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;

import '../../utils/api/get_api.dart';
import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';


class AddNewVehicleInvoice extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const AddNewVehicleInvoice(
      {Key? key, required this.drawerWidth, required this.selectedDestination}) : super(key: key);

  @override
  State<AddNewVehicleInvoice> createState() => _AddNewVehicleInvoiceState();
}

class _AddNewVehicleInvoiceState extends State<AddNewVehicleInvoice> {

  final addVehicleInvoiceForm = GlobalKey<FormState>();
  bool loading = false;
  String? authToken;
  String poNo = "";
  String grnId = "";
  double totalTax = 0.0;
  double freightAmount = 0.0;
  double amount = 0.0;
  double totalAmount = 0.0;
  List invoiceList = [];
  List tableData = [0];

  Future fetchInvoiceData() async{
    dynamic response;
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclegrn/get_all_newvehigrn";
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            invoiceList = value;
          }
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
    }
  }
  Future fetchShipAddData(poNo)async{
    dynamic response;
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_new_vehi_poid_wrapper/$poNo";
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            shipAddressController.text=response['shipping_address'];
          }
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
    }
  }
  Future<List> fetchData()async{
    await Future.delayed(const Duration(milliseconds: 100));
    List list = [];
    for(int i=0; i<invoiceList.length; i++){
      if(invoiceList[i]['status'] == "") {
        list.add(InvoiceData.fromJson(invoiceList[i]));
      }

    }
    return list;
  }
  Future addVehicleInvoice(Map<dynamic,dynamic> data) async{
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicleinvoice/add_invoice";
    postData(context: context,url: url,requestBody: data).then((value) {
      setState(() {
        if(value!=null){
          editGrnStatus();
        }
      });
    });
  }
  Future editGrnStatus()async{
    try{
      final response = await http.put(
        Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclegrn/update_vehicle_grn_status/$grnId/Invoiced'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
      );
      if(response.statusCode == 200){
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Saved')));
        Navigator.of(context).pop();
      }
      else {
        print('-------status code-------');
        print(response.statusCode.toString());
      }
    }
    catch(e){
      print(e.toString());
      print(e);
    }
  }

  final grnNumberController = TextEditingController();
  final grnIdController = TextEditingController();
  final vendorNameController = TextEditingController();
  final poNumController = TextEditingController();
  final poDateController = TextEditingController();
  final grnReferenceController = TextEditingController();
  final grnDateController = TextEditingController();
  final vehicleNameController = TextEditingController();
  final variantColorController = TextEditingController();
  final updateReceivedQtyController = TextEditingController();
  final orderQtyController = TextEditingController();
  final receivedQtyController = TextEditingController();
  final shortQtyController = TextEditingController();
  final unitPriceController = TextEditingController();
  final taxPerController = TextEditingController();
  final freightAmountController = TextEditingController();
  final shipAddressController = TextEditingController();
  final statusController = TextEditingController();
  final termsConditionController = TextEditingController();
  final customerNotesController = TextEditingController();

  bool vendorNameError = false;
  bool grnIdError = false;



  Future getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }

  @override
  void initState(){
    super.initState();
    getInitialData().whenComplete(() {
      fetchInvoiceData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(width: 1,thickness: 1,),
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.white,

              body: SingleChildScrollView(
                child: Form(
                  key: addVehicleInvoiceForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60,right: 60),
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
                                          "New Vehicle Invoice",
                                          style: TextStyle(fontSize: 18,color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 180,
                                                child: Text(
                                                  'GRN ID',
                                                  style:
                                                  TextStyle(color: Colors.red[900]),
                                                )),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 250,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius.circular(5.0)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 15,bottom: 10),
                                                    child: TextFieldSearch(
                                                      label: '',
                                                      controller: grnIdController,
                                                      decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                      ),
                                                      future: (){
                                                        return fetchData();
                                                      },
                                                      getSelectedValue: (InvoiceData newValue){
                                                        grnIdController.text = newValue.grnId;
                                                        grnId = newValue.grnId;
                                                        grnNumberController.text = newValue.grnNumber;
                                                        vendorNameController.text = newValue.vendorName;
                                                        poNumController.text = newValue.purchaseOrderNumber;
                                                        grnReferenceController.text = newValue.grnReference;
                                                        poDateController.text = newValue.purchaseOrderDate;
                                                        grnDateController.text = newValue.grnDate;
                                                        poNo= newValue.purchaseOrderNumber;
                                                        unitPriceController.text = newValue.unitPrice;
                                                        taxPerController.text = newValue.taxPercent;
                                                        variantColorController.text = newValue.variantColor;
                                                        shortQtyController.text = newValue.shortQuantity;
                                                        orderQtyController.text = newValue.orderedQuantity;
                                                        updateReceivedQtyController.text = newValue.updatedReceivedQuantity;
                                                        vehicleNameController.text = newValue.vehicleName;
                                                        receivedQtyController.text = newValue.receivedQuantity;
                                                        freightAmountController.text = newValue.freightAmount;
                                                        termsConditionController.text = newValue.termsCondition;
                                                        customerNotesController.text = newValue.customerNotes;
                                                        fetchShipAddData(poNo);

                                                        setState(() {
                                                          totalTax = int.parse(newValue.taxPercent)/100*int.parse(newValue.unitPrice);
                                                          freightAmount = double.parse(newValue.freightAmount);
                                                          amount = double.parse(unitPriceController.text)*double.parse(receivedQtyController.text);
                                                          totalAmount = totalTax + amount+ double.parse(freightAmountController.text.toString());
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                if(grnIdError)
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(
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
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text('Vendor Name',
                                                style: TextStyle(color: Colors.red[900]),
                                              ),
                                            ),
                                            Container(
                                              width: 250,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(5.0)),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: vendorNameController,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                      left: 15,
                                                      bottom: 15,
                                                      right: 5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text('Purchase Order #',
                                                style: TextStyle(color: Colors.red[900]),
                                              ),
                                            ),
                                            Container(
                                              width: 250,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(5.0)),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: poNumController,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                      left: 15,
                                                      bottom: 15,
                                                      right: 5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text('Shipping Address',
                                                style: TextStyle(color: Colors.red[900]),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                  border:
                                                  Border.all(color: Colors.grey)),
                                              height: 80,
                                              width: 250,
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: shipAddressController,
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 4,
                                                minLines: 4,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                      left: 15,
                                                      bottom: 10,
                                                      top: 11,
                                                      right: 15),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20,),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 180,
                                              child: Text('Reference #',
                                                // style: TextStyle(color: Colors.red[900]),
                                              ),
                                            ),
                                            Container(
                                              width: 250,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(5.0)),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: grnReferenceController,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                      left: 15,
                                                      bottom: 15,
                                                      right: 5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 180,
                                              child: Text('Purchase Order Date',
                                                // style: TextStyle(color: Colors.red[900]),
                                              ),
                                            ),
                                            Container(
                                              width: 250,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(5.0)),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: poDateController,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                      left: 15,
                                                      bottom: 15,
                                                      right: 5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 180,
                                              child: Text('GRN Date',
                                                // style: TextStyle(color: Colors.red[900]),
                                              ),
                                            ),
                                            Container(
                                              width: 250,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(5.0)),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: grnDateController,
                                                decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                      left: 15,
                                                      bottom: 15,
                                                      right: 5),
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
                            ],
                          ),
                        ),
                      ),
                      //--------table--------
                      Padding(
                        padding: const EdgeInsets.only(left: 60,right: 60,top: 20,bottom: 30),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.blue,
                              height: 25,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 40,right: 40),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    Text('Vehicle Name',style: TextStyle(color: Colors.white),),
                                    Text('Variant Color',style: TextStyle(color: Colors.white),),
                                    Text('Received Qty',style: TextStyle(color: Colors.white),),
                                    Text('Tax Percentage',style: TextStyle(color: Colors.white),),
                                    Text('Unit Price',style: TextStyle(color: Colors.white),)
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
                                  children:  [
                                    Text(vehicleNameController.text,style: const TextStyle(fontSize: 16),),
                                    Text(variantColorController.text,style: const TextStyle(fontSize: 16),),
                                    Text(receivedQtyController.text,style: const TextStyle(fontSize: 16),),
                                    Text(taxPerController.text,style: const TextStyle(fontSize: 16),),
                                    Text(unitPriceController.text,style: const TextStyle(fontSize: 16),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //---------footer--------
                      Padding(
                        padding: const EdgeInsets.only(left: 60,right: 60),
                        child: SizedBox(
                          // width: 800,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                flex:1,
                                child: Container(),
                              ),
                              Expanded(
                                flex:1,
                                child: Container(),
                              ),
                              Expanded(
                                flex:1,
                                child: SizedBox(
                                  height: 170,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children:  [
                                              const Text("Total Tax"),
                                              Text(totalTax.toStringAsFixed(2),style: const TextStyle(fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children:  [
                                              const Text("Freight Amount"),
                                              Text(freightAmount.toStringAsFixed(2),style: const TextStyle(fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children:  [
                                              const Text("Amount"),
                                              Text(amount.toStringAsFixed(2),style: const TextStyle(fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          color: Colors.grey[300],
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:  [
                                                const Text("Total Amount",style: TextStyle(fontSize: 18)),
                                                Text(totalAmount.toStringAsFixed(2),style: const TextStyle(fontSize: 16),),
                                              ],
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            grnIdController.text.isEmpty ? grnIdError = true : grnIdError = false;
                            if(addVehicleInvoiceForm.currentState!.validate() && grnIdController.text.isNotEmpty){
                              Map requestData = {
                                "newvehi_grn_id": grnIdController.text,
                                "grn_number": grnNumberController.text,
                                "vendor_name": vendorNameController.text,
                                "purchase_order_no": poNumController.text,
                                "reference": grnReferenceController.text,
                                "purchase_order_date": poDateController.text,
                                "grn_date": grnDateController.text,
                                "vehicle_name": vehicleNameController.text,
                                "updated_recieved_quantity": updateReceivedQtyController.text,
                                "ordered_quantity": orderQtyController.text,
                                "received_quantiy": receivedQtyController.text,
                                "short_quantity": shortQtyController.text,
                                "unit_price":unitPriceController.text,
                                "varient_color": variantColorController.text,
                                "tax_percentage": taxPerController.text,
                                "shipping_address": shipAddressController.text,
                                "status": "Invoiced",
                                "total_tax": totalTax,
                                "amount": amount,
                                "total_amount": totalAmount,
                                "freight_amount": freightAmount,
                                "terms_conditions": termsConditionController.text,
                                "customer_notes": customerNotesController.text,
                              };
                              addVehicleInvoice(requestData);
                            }
                          });
                        },
                        color: Colors.blue,
                        child: const Text("Save",style: TextStyle(color: Colors.white)),
                      ),
                    ),
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
}


class InvoiceData {
  final String label;
  final String grnId;
  final String vendorName;
  final String purchaseOrderNumber;
  final String purchaseOrderDate;
  final String grnNumber;
  final String grnReference;
  final String grnDate;
  final String vehicleName;
  final String updatedReceivedQuantity;
  final String orderedQuantity;
  final String receivedQuantity;
  final String shortQuantity;
  final String unitPrice;
  final String variantColor;
  final String taxPercent;
  final String freightAmount;
  final String termsCondition;
  final String customerNotes;
  final String status;
  InvoiceData({
    required this.label,
    required this.grnId,
    required this.vendorName,
    required this.purchaseOrderNumber,
    required this.purchaseOrderDate,
    required this.grnNumber,
    required this.grnReference,
    required this.grnDate,
    required this.vehicleName,
    required this.updatedReceivedQuantity,
    required this.orderedQuantity,
    required this.receivedQuantity,
    required this.shortQuantity,
    required this.unitPrice,
    required this.variantColor,
    required this.taxPercent,
    required this.freightAmount,
    required this.termsCondition,
    required this.customerNotes,
    required this.status
  });
  factory InvoiceData.fromJson(Map<String, dynamic> json){
    return InvoiceData(
      label: json['newvehi_grn_id'],
      grnId: json['newvehi_grn_id'],
      vendorName: json['vendor_name'],
      purchaseOrderNumber: json['purchase_order_number'],
      purchaseOrderDate: json['purchase_order_date'],
      grnNumber: json['grn_number'],
      grnReference: json['grn_ref'],
      grnDate: json['grn_date'],
      vehicleName: json['vehicle_name'],
      updatedReceivedQuantity: json['updated_recieved_quantity'],
      orderedQuantity: json['ordered_quantity'],
      receivedQuantity: json['recieved_quantity'],
      shortQuantity: json['short_quantity'],
      unitPrice: json['amount'],
      variantColor: json['varient_color'],
      taxPercent: json['tax_percent'],
      freightAmount: json['freight_amount'].toString(),
      termsCondition: json['terms_conditions'],
      customerNotes: json['customer_notes'],
      status: json['status'],
    );
  }
}