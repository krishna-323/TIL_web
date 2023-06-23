


import 'package:flutter/material.dart';

import '../../utils/api/get_api.dart';



class InvoiceDetails extends StatefulWidget {
  final Map<dynamic, dynamic> invoiceData;
  final Map<dynamic, dynamic> docketDetails;
  const InvoiceDetails(this.invoiceData,this.docketDetails, {Key? key}) : super(key: key);

  @override
  _InvoiceDetailsState createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  Map docketData ={};
  bool loading = false;
  double total = 0.0;
  String address = "";
  Future fetchAllDocketDetails() async{
    dynamic response;
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["dock_customer_id"]}";
    try {
      await getData(context: context, url: url).then((value) {
        // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["general_id"]}");
        // print(value);
        setState(() {
          if(value!=null){
            response = value;
            docketData = value;
            // print('------new get all docket data ----------');
            // print(docketData);
            total = docketData['onroad_price'] + docketData['ex_showroom_price'] + docketData['accessories_actual']-docketData['ex_showroom_discounted'];
            if(docketData['address_1'].isNotEmpty){
              address += docketData['address_1'];
            }
            if(docketData['address_2'].isNotEmpty){
              address +=", "  "${docketData['address_2']}";
            }
            if(docketData['city'].isNotEmpty){
              address += ", "  "${docketData['city']}";
            }
            if(docketData['state'].isNotEmpty){
              address += ", " "${docketData['state']}";
            }
            // print(total);
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }
  @override
  void initState() {
    fetchAllDocketDetails();
    // print('------new get all docket data ----------');
    // print(docketData);
    // print("_______________________________________________________________");
    // print(widget.docketDetails);
    // print('------- invoice ---------');
    // print(widget.invoiceData);
    super.initState();
  }

  List invoiceData =["Discount","Accessible Value", "VAT @ 14.5%", "Sub Total Amount(Accessible Value + Tax)"];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 100,right: 100,top: 20),
          child: Card(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(flex: 1,child: Container(height: 70,color: Colors.black,child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Image(alignment: Alignment.topLeft,image: AssetImage("assets/logo/IkyamWhite.png"))),
                    ))),
                    Expanded(flex:2,child: Container()),
                    const Expanded(flex: 1,child: SizedBox(height: 70,child: Padding(
                      padding: EdgeInsets.only(right: 28,left: 8),
                      child: Image(alignment: Alignment.topLeft,image: AssetImage("assets/cars/maruthi_suzuki_logo.png")),
                    ))),
                  ],
                ),
                const SizedBox(height: 20,),
                const Divider(thickness: 2,color: Colors.black),

                Padding(
                  padding: const EdgeInsets.only(left: 50,top: 18,right: 50,bottom: 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const   Expanded(flex: 1,child: Text("Sold To")),
                                Expanded(flex: 2,child: Text(": ${docketData['customer_name']}"))
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                const  Expanded(flex: 1,child: Text("Mobile Number")),
                                Expanded(flex: 2,child: Text(": ${docketData['mobile']} "))
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                const Expanded(flex: 1,child: Text("Address")),
                                Expanded(flex: 2,child: Text(": $address"))
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children:  [
                                const Expanded(flex: 1,child: Text("Financed by sales Executive")),
                                Expanded(flex: 2,child: Text(": ${docketData['finance_company']}"))
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children:  [
                                const Expanded(flex: 1,child: Text("Vehicle ID")),
                                Expanded(flex: 2,child: Text(": ${docketData['preg_no']}"))
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Expanded(flex: 3,
                      //     child: Column(
                      //   children: [
                      //     Row(
                      //       children: [
                      //         const   Expanded(flex: 1,child: Text("Sold To")),
                      //         Expanded(flex: 2,child: Text(": ${docketData['customer_name']}"))
                      //       ],
                      //     ),
                      //     const SizedBox(height: 10,),
                      //     Row(
                      //       children: [
                      //         const  Expanded(flex: 1,child: Text("Mobile Number")),
                      //         Expanded(flex: 2,child: Text(": ${docketData['mobile']} "))
                      //       ],
                      //     ),
                      //     const SizedBox(height: 10,),
                      //     Row(
                      //       children: [
                      //         const Expanded(flex: 1,child: Text("Address")),
                      //         Expanded(flex: 2,child: Text(": $address"))
                      //       ],
                      //     ),
                      //     const SizedBox(height: 10,),
                      //     Row(
                      //       children:  [
                      //         const Expanded(flex: 1,child: Text("Financed by sales Executive")),
                      //         Expanded(flex: 2,child: Text(": ${docketData['finance_company']}"))
                      //       ],
                      //     ),
                      //     const SizedBox(height: 10,),
                      //     Row(
                      //       children:  [
                      //         const Expanded(flex: 1,child: Text("Vehicle ID")),
                      //         Expanded(flex: 2,child: Text(": ${docketData['preg_no']}"))
                      //       ],
                      //     ),
                      //   ],
                      // )),
                      Expanded(child: const SizedBox(width: 10,)),
                      Expanded(flex: 2,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Expanded(flex: 1,child: Text("Invoice No.")),
                                  Expanded(flex: 2,child: Text(": ${docketData['invoice_no']}"))
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  const Expanded(flex: 1,child: Text("Invoice Date")),
                                  Expanded(flex: 2,child: Text(": ${docketData['invoice_date']}"))
                                ],
                              ),
                              const SizedBox(height: 140,),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                const Divider(),
                const SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Expanded(flex: 3,child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(width:120,child: Text("Name")),
                            Expanded(child: Text(": ${docketData['make']}(${docketData['varient_name']})")),
                          ],
                        ),
                      )),
                      const Expanded(flex: 1,child: Text("Dr Amount")),
                      const Expanded(flex: 1,child: Text("Cr Amount")),
                    ],
                  ),
                ),
                const SizedBox(height: 8,),
                const Divider(),

                ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return  Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          Expanded(flex: 3,child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    const SizedBox(width: 120,child: Text("CHASSIS NO")),
                                    Expanded(flex: 2,child: Text(": ${docketData['chassis_no']}"))
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children:  [
                                    const SizedBox(width: 120,child: Text("ENGINE NO")),
                                    Expanded(flex: 2,child: Text(": ${docketData['engine_no']}"))
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children:  [
                                    const SizedBox(width: 120,child: Text("COLOR")),
                                    Expanded(flex: 2,child: Text(": ${docketData['color']}"))
                                  ],
                                ),
                                // const SizedBox(height: 10,),
                              ],
                            ),
                          )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: const [
                                      Expanded(flex: 1,child: Text("Ex-ShowRoom Price")),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: const [
                                      Expanded(flex: 1,child: Text("On-Road Price")),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: const [
                                      Expanded(flex: 1,child: Text("Discount")),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: const [
                                      Expanded(flex: 1,child: Text("Accessory Value")),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                ],
                              )),
                          Expanded(flex: 1,child:
                          Column(
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(flex: 1,child: Text("Rs ${docketData['ex_showroom_price']}")),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(flex: 1,child: Text("Rs ${docketData['onroad_price']}")),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(flex: 1,child: Text("Rs ${docketData['ex_showroom_discounted']}")),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(flex: 1,child: Text("Rs ${docketData['accessories_actual']}")),
                                ],
                              ),
                              const SizedBox(height: 10,),
                            ],
                          )
                          ),
                        ],
                      ),
                    );

                  },),
                const Divider(),
                ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 10),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Expanded(flex: 3,child: Container()),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Total"),
                                    ],
                                  ),
                                ],
                              )),
                          Expanded(child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(flex: 1,child: Text("Rs $total")),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                    );
                  },),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
