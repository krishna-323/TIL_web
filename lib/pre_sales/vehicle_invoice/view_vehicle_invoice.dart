import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';

class ViewVehicleInvoice extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map vehicleList;
  const ViewVehicleInvoice({Key? key,
    required this.drawerWidth,
    required this.selectedDestination,
    required this.vehicleList}) : super(key: key);

  @override
  State<ViewVehicleInvoice> createState() => _ViewVehicleInvoiceState();
}
class _ViewVehicleInvoiceState extends State<ViewVehicleInvoice> {
  bool loading=false;
  String? authToken;
  Map vehicleList={};
  double taxAmount=0.0;
  double basePrice=0.0;
  double totalAmount=0.0;
  @override
  initState(){
    super.initState();
    loading=true;
    vehicleList=widget.vehicleList;
    // print('---------------------Map data-----------------------');
    // print(vehicleList);
    taxAmount=int.parse(vehicleList['tax_percentage'].toString())/100*int.parse(vehicleList['unit_price'].toString());
    basePrice=double.parse(vehicleList['received_quantiy'].toString())*int.parse(vehicleList['unit_price'].toString());
    totalAmount=taxAmount+basePrice+vehicleList['freight_amount'];
    getInitialData().whenComplete(() {
    });
  }
  Future getInitialData()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    authToken=prefs.getString("authToken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(width: 1,thickness: 1,),
          Expanded(child: Scaffold(

            body:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.grey[200],
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  left: 50, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Vehicle Invoice Details",
                                    style: TextStyle(fontSize: 20,color: Colors.indigo),),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50,),
                          Padding(
                            padding: const EdgeInsets.only(left: 65,right: 65),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //grn id.
                                  Row(children:  [
                                    const SizedBox(width:200,
                                        child: Text('GRN ID')),

                                    Text(vehicleList['newvehi_grn_id']??''),
                                  ],),
                                  const SizedBox(height: 10,),
                                  //vendor Name.
                                  Row(children:  [
                                    const SizedBox(width:200,
                                        child: Text('Vendor Name')),

                                    Text(vehicleList['vendor_name']??''),
                                  ],),
                                  //Shipping address.
                                  const SizedBox(height: 10,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      const SizedBox(width:200,
                                          child: Text('Shipping Address')),
                                      SizedBox(width: 300,child: Text(vehicleList['shipping_address']??'')),
                                    ],),
                                  const SizedBox(height: 10,),
                                  //Reference
                                  Row(children:  [
                                    const SizedBox(width:200,
                                        child: Text('Reference')),
                                    Text(vehicleList['reference']??""),
                                  ],),
                                  //Purchase date.
                                  const SizedBox(height: 10,),
                                  Row(children:  [
                                    const SizedBox(width:200,
                                        child: Text('Purchase Order Date')),
                                    Text(vehicleList['purchase_order_date']??""),
                                  ],),
                                  const SizedBox(height: 10,),
                                  //grn date.
                                  Row(children:  [
                                    const SizedBox(width:200,
                                        child: Text('GRN Date')),
                                    Text(vehicleList['grn_date']??""),
                                  ],),
                                  const SizedBox(height: 30,),

                                  Container(
                                      height: 40,
                                      color: Colors.blue.shade200,
                                      child:
                                      const Row(
                                        children: [
                                          Expanded(child: Center(child: Text("VEHICLE NAME"))),
                                          Expanded(child: Center(child: Text("VEHICLE COLOR"))),
                                          Expanded(child: Center(child: Text('RECEIVED QUANTITY'))),
                                          Expanded(child: Center(child:Text('TAX PERCENTAGE'))),
                                          Expanded(child: Center(child: Text('UNIT PRICE'),)),
                                          // Expanded(child: Center(child: Text("AMOUNT"))),
                                        ],
                                      )
                                  ),
                                  //Grn Status IS Success.
                                  //if(poId[''])
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(vehicleList['vehicle_name']??''),
                                            ),
                                          ))),
                                          Expanded(child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(vehicleList['varient_color']??''),
                                            ),
                                          ))),
                                          Expanded(child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child:Text(vehicleList['received_quantiy'].toString()),
                                            ),
                                          ))),
                                          Expanded(child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child:Text(vehicleList['tax_percentage'].toString()),
                                            ),
                                          ))),
                                          Expanded(child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(height: 30,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child:Text(vehicleList['unit_price'].toString()),
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
                                  const SizedBox(height: 10,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(

                                        child: Container(),
                                      ),
                                      Expanded(

                                        child: Container(),
                                      ),
                                      Expanded(

                                        child: Container(
                                          height: 150,
                                          color: Colors.grey[100],
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children:  [
                                                    const Text("Tax Amount"),
                                                    Text(taxAmount.toStringAsFixed(2)),
                                                  ],
                                                ),
                                                const SizedBox(height: 10,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children:  [
                                                    const Text("Base Amount"),
                                                    Text(basePrice.toStringAsFixed(2)),
                                                  ],
                                                ),
                                                const SizedBox(height: 10,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children:  [
                                                    const Text("Freight Amount"),
                                                    Text(vehicleList['freight_amount'].toStringAsFixed(2)),
                                                  ],
                                                ),
                                                const SizedBox(height: 10,),
                                                Container(height: 1.5,color: Colors.indigo,),
                                                const SizedBox(height: 10,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children:  [
                                                    const Text("Total Amount",style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(totalAmount.toStringAsFixed(2)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),


                                  vehicleList['terms_conditions']!=null?Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Terms And Conditions',style: TextStyle(color:Colors.indigo,fontSize: 18),),
                                      const SizedBox(height: 10,),
                                      SizedBox(width:300,child: Text(vehicleList['terms_conditions']??"")),
                                      const SizedBox(height: 50,),
                                    ],):Container(),
                                  vehicleList['customer_notes']!=null?Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Customer Notes',style:TextStyle(color:Colors.indigo,fontSize: 18)),
                                      const SizedBox(height: 10,),
                                      SizedBox(width:300,child: Text(vehicleList['customer_notes']??""))
                                    ],):Container(),
                                  const SizedBox(height: 50,)
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ))
                ]) ,))
        ],),
    );
  }
}
