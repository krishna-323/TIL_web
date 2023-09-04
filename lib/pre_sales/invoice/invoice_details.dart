


import 'package:flutter/material.dart';

import '../../utils/api/get_api.dart';



class InvoiceDetails extends StatefulWidget {
  Map<dynamic, dynamic> invoiceData;
   InvoiceDetails( this.invoiceData, {Key? key}) : super(key: key);

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  Map docketData ={};
  bool loading = false;
  String total = "0.0";
  String address = "";
  Future fetchAllDocketDetails() async{
    dynamic response;
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocket/get_all_sales_dockets_wrapper";
    try {
      await getData(context: context, url: url).then((value) {
        print('------ invoice list --------');
        print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocket/get_all_sales_dockets_wrapper");
        print(value);
        setState(() {
          if(value!=null){
            response = value;
            print('------ invoice details response ----------');
            // print(response);
            print(response['customer_name']);
            docketData = value;
            // total = docketData['onroad_price'] + docketData['ex_showroom_price'] + docketData['accessories_actual']-docketData['ex_showroom_discounted'];
            total = docketData['onroad_price'] + docketData['ex_showroom_price'];
            if(docketData['street_address'].isNotEmpty){
              address += docketData['street_address'];
            }
            if(docketData['city'].isNotEmpty){
              address +=", "  "${docketData['city']}";
            }
            if(docketData['location'].isNotEmpty){
              address += ", "  "${docketData['location']}";
            }
            if(docketData['pin_code'].isNotEmpty){
              address += ", " "${docketData['pin_code']}";
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
    // fetchAllDocketDetails();
    double onroadPrice = double.parse(widget.invoiceData['onroad_price']);
    double exShowroomPrice = widget.invoiceData['ex_showroom_price'];
    double totalPrice = onroadPrice + exShowroomPrice;
    total = totalPrice.toStringAsFixed(2);
    super.initState();
  }

  List invoiceData =["Discount","Accessible Value", "VAT @ 14.5%", "Sub Total Amount(Accessible Value + Tax)"];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 100,right: 100,top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                      color: Colors.blueAccent),
                ),
                // width: 80,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: 80,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_sharp,
                              color: Colors.blue,
                              size: 20),
                          Expanded(child: Text("Go Back",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight
                                    .bold,
                                fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow
                                .ellipsis,)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            // flex: 1,
                            child: Container(
                                height: 120,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14)
                                  ),
                                  color: Color(0xFF4C6971),
                                ),
                                child: const Center(
                                    child: Image(
                                        alignment: Alignment.center,
                                        height: 70,
                                        image: AssetImage("assets/logo/img_1.png")
                                    )
                                )
                            )
                        ),
                      ],
                    ),
                    // const Divider(thickness: 2,color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(left: 50,top: 18,right: 50,bottom: 20),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const   Expanded(flex: 1,child: Text("Sold To")),
                                    Expanded(flex: 2,child: Text(": ${widget.invoiceData['customer_name']}"))
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const  Expanded(flex: 1,child: Text("Mobile Number")),
                                    Expanded(flex: 2,child: Text(": ${widget.invoiceData['mobile']} "))
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(flex: 1,child: Text("Address")),
                                    Expanded(flex: 2,child: Text(": ${[widget.invoiceData['street_address'], widget.invoiceData['city'] ,widget.invoiceData['location'] ,widget.invoiceData['pin_code']].join(', ')}"))
                                  ],
                                ),
                                // const SizedBox(height: 10,),
                                // Row(
                                //   children:  [
                                //     const Expanded(flex: 1,child: Text("Financed by sales Executive")),
                                //     Expanded(flex: 2,child: Text(": ${widget.invoiceData['finance_company']}"))
                                //   ],
                                // ),
                                // const SizedBox(height: 10,),
                                // Row(
                                //   children:  [
                                //     const Expanded(flex: 1,child: Text("Vehicle ID")),
                                //     Expanded(flex: 2,child: Text(": ${widget.invoiceData['new_vehicle_id']}"))
                                //   ],
                                // ),
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
                          const Expanded(child: SizedBox(width: 10,)),
                          Expanded(flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      const Expanded(flex: 1,child: Text("Financed by sales Executive")),
                                      Expanded(flex: 2,child: Text(": ${widget.invoiceData['finance_company']}"))
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      const Expanded(flex: 1,child: Text("Vehicle ID")),
                                      Expanded(flex: 2,child: Text(": ${widget.invoiceData['new_vehicle_id']}"))
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const Expanded(flex: 1,child: Text("Invoice No.")),
                                  //     Expanded(flex: 2,child: Text(": ${docketData['invoice_no']??""}"))
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10,),
                                  // Row(
                                  //   children: [
                                  //     const Expanded(flex: 1,child: Text("Invoice Date")),
                                  //     Expanded(flex: 2,child: Text(": ${docketData['invoice_date']??""}"))
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 140,),
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Divider(),
                    const SizedBox(height: 8,),
                    Padding(
                      padding: const EdgeInsets.only(left: 50,top: 0,right: 50,bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Expanded(flex: 3,child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              children: [
                                const SizedBox(width:120,child: Text("Name")),
                                Expanded(child: Text(": ${widget.invoiceData['make']}(${widget.invoiceData['model']})")),
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
                          padding: const EdgeInsets.only(left: 50,top: 0,right: 50,bottom: 0),
                          child: Row(
                            children: [
                              Expanded(flex: 3,child: Padding(
                                padding: const EdgeInsets.only(left: 0,top: 0,right: 0,bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // const SizedBox(height: 10,),
                                    // Row(
                                    //   children: [
                                    //     const SizedBox(width: 120,child: Text("CHASSIS NO")),
                                    //     Expanded(flex: 2,child: Text(": ${docketData['chassis_no']??""}"))
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 10,),
                                    // Row(
                                    //   children:  [
                                    //     const SizedBox(width: 120,child: Text("ENGINE NO")),
                                    //     Expanded(flex: 2,child: Text(": ${docketData['engine_no']??""}"))
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 10,),
                                    Row(
                                      children:  [
                                        const SizedBox(width: 120,child: Text("COLOR")),
                                        Expanded(flex: 2,child: Text(": ${widget.invoiceData['color']}"))
                                      ],
                                    ),
                                    // const SizedBox(height: 10,),
                                  ],
                                ),
                              )),
                              const Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(flex: 1,child: Text("Ex-ShowRoom Price")),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(flex: 1,child: Text("On-Road Price")),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      // Row(
                                      //   children: [
                                      //     Expanded(flex: 1,child: Text("Discount")),
                                      //   ],
                                      // ),
                                      // SizedBox(height: 10,),
                                      // Row(
                                      //   children: [
                                      //     Expanded(flex: 1,child: Text("Accessory Value")),
                                      //   ],
                                      // ),
                                      // SizedBox(height: 10,),
                                    ],
                                  )),
                              Expanded(flex: 1,child:
                              Column(
                                children: [
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(flex: 1,child: Text("Rs ${widget.invoiceData['ex_showroom_price']}")),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(flex: 1,child: Text("Rs ${widget.invoiceData['onroad_price']}")),
                                    ],
                                  ),
                                  // const SizedBox(height: 10,),
                                  // Row(
                                  //   children: [
                                  //     Expanded(flex: 1,child: Text("Rs ${docketData['ex_showroom_discounted']??""}")),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10,),
                                  // Row(
                                  //   children: [
                                  //     Expanded(flex: 1,child: Text("Rs ${docketData['accessories_actual']??""}")),
                                  //   ],
                                  // ),
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
                          padding: const EdgeInsets.only(left: 50,top: 10,right: 50,bottom: 10),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Expanded(flex: 3,child: Container()),
                              const Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}
