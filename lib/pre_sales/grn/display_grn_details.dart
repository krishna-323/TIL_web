import 'package:flutter/material.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
class DisplayGrnDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map purchaseOrderMapDetails;

  const DisplayGrnDetails(
      {Key? key,
        required this.drawerWidth,
        required this.selectedDestination,
        required this.purchaseOrderMapDetails})
      : super(key: key);

  @override
  State<DisplayGrnDetails> createState() => _DisplayGrnDetailsState();
}

class _DisplayGrnDetailsState extends State<DisplayGrnDetails> {
  Map purchaseLineItemsData = {};
  bool loading = false;
  Map poId = {};
  int? basePrice;
  double? taxAmount;
  double? grandTotal;
  String? newVendorId;
  String totalAddress = '';

  @override
  initState() {
    poId = widget.purchaseOrderMapDetails;
    // print('------------Map details---------');
    // print(poId);
    newVendorId = poId['new_vendor_id'];
    fetchPurchaseLineData();
    totalAddress;
    //  print('---------------Map details-------------------------');
    //  print(poId);
    //  print('--------NEW VENDOR ID----');
    // print(newVendorId);
    taxAmount =
        int.parse(poId['tax_percent']) / 100 * int.parse(poId['amount']);
    basePrice =
        int.parse(poId['recieved_quantity']) * int.parse(poId['amount']);
    grandTotal = basePrice! + taxAmount! + poId['freight_amount'];

    super.initState();
  }

//This Api Is For Line Data Getting After Passing 'new_purveh_line_id':
//  Future fetchPurchaseLineData(String newPur) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? authToken = prefs.getString("authToken");
//
//     final response = await http.get(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchaseline/get_vehicle_purchase_details/$newPur'),
//       headers: {
//         "Content-Type": "application/json",
//         'Authorization': 'Bearer $authToken'
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       // print(response.body);
//       setState(() {
//         purchaseLineItemsData=jsonDecode(response.body);
//         print(purchaseLineItemsData);
//       });
//       //return Album.fromJson(jsonDecode(response.body));
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       print("++++++++++Status Code +++++++++++++++");
//       print(response.statusCode.toString());
//     }
//   }

  Future fetchPurchaseLineData() async {
    dynamic response;
    // print('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_new_vendor_by_id/$newVendorId');
    String url =
        'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_new_vendor_by_id/$newVendorId';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            purchaseLineItemsData = value;
            totalAddress = purchaseLineItemsData['shipto_region'] +
                ', ' +
                purchaseLineItemsData['shipto_state'] +
                ', ' +
                purchaseLineItemsData['shipto_address1'] +
                ',' +
                purchaseLineItemsData['shipto_address2'] +
                ', ' +
                purchaseLineItemsData['shipto_zip'];
          }
          // loading = false;
        });
      });
    } catch (e) {
      logOutApi(context: context, exception: e.toString(), response: response);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //This Is For Left CustomDrawer Items.
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          //This Is Line.
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          // Top AppBar Search Bar.
          Expanded(
              child: Scaffold(

                  body:
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Billed To',
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(poId['vendor_name'] ?? ''),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    width: 200,
                                  ),
                                  SizedBox(
                                      width: 150, child: Text(totalAddress)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Purchase Order Date',
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 18),
                                  ),
                                  Text(poId['purchase_order_date'] ?? ""),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  const Text(
                                    'GRN Date',
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 18),
                                  ),
                                  Text(poId['grn_date'] ?? ""),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Purchase Order Number',
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 18),
                                  ),
                                  Text(poId['purchase_order_number'] ?? ""),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                              height: 40,
                              color: Colors.blue.shade200,
                              child: const Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                            "VEHICLE NAME",

                                          ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                            "VEHICLE COLOR",
                                          ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                            'RECEIVED QUANTITY',

                                          ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                            'TAX PERCENTAGE',

                                          ))),
                                  Expanded(
                                      child: Center(
                                        child: Text(
                                          'UNIT PRICE',

                                        ),
                                      )),
                                  // Expanded(child: Center(child: Text("AMOUNT"))),
                                ],
                              )),
                          Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(poId['vehicle_name'] ?? ''),
                                            ),
                                          ))),
                                  Expanded(
                                      child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                height: 30,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(poId['varient_color'] ?? '')),
                                          ))),
                                  Expanded(
                                      child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(poId['recieved_quantity'] ?? ''),
                                            ),
                                          ))),
                                  Expanded(
                                      child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(poId['tax_percent'] ?? ''),
                                            ),
                                          ))),
                                  Expanded(
                                      child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(poId['amount'] ?? ''),
                                            ),
                                          ))),
                                  // Expanded(child: Center(child: Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: SizedBox(height: 30,
                                  //       //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  //       child: Text(purchaseLineItemsData[line]['amount'].toString())
                                  //   ),
                                  // ))),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 50,),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              Expanded(child: Container()),
                              Expanded(
                                child: SizedBox(width: 500,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 35,
                                      ),

                                      //Tax amount
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('TAX AMOUNT'),
                                          const SizedBox(
                                            width: 80,
                                          ),
                                          Text(taxAmount!.toStringAsFixed(2)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //base price.
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Base Price'),
                                          const SizedBox(
                                            width: 100,
                                          ),
                                          Text(basePrice!.toStringAsFixed(2)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //Freight amount.
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Freight Amount'),
                                          const SizedBox(
                                            width: 100,
                                          ),
                                          Text(poId['freight_amount'].toStringAsFixed(2)),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(height: 1.5,color: Colors.indigo,),
                                      const SizedBox(height: 25,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Grand Total',style: TextStyle(fontWeight: FontWeight.bold),),
                                          const SizedBox(
                                            width: 100,
                                          ),
                                          Text(grandTotal!.toStringAsFixed(2)),
                                        ],
                                      ),
                                      const SizedBox(height: 25,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Notes',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.indigo),
                                ),
                                SizedBox(width: 300,child: Text(poId['customer_notes'])),
                                const SizedBox(
                                  height: 25,
                                ),
                                const Text(
                                  'Terms And Conditions',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.indigo),
                                ),
                                SizedBox(width: 300,child: Text(poId['terms_conditions'])),
                              ],
                            ),
                          ),
                          const SizedBox(height:50),
                        ],
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }
}
