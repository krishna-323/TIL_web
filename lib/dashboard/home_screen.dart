import 'package:flutter/material.dart';
import 'package:new_project/utils/customAppBar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../classes/arguments_classes/arguments_classes.dart';
import '../classes/motows_routes.dart';
import 'kpi_card.dart';
import '../utils/customDrawer.dart';


class MyHomePage extends StatefulWidget {


 const MyHomePage({Key? key}) : super(key: key);
  // static String homeRoute = "/home";

  @override
  State <MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double drawerWidth =190;

   getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getString('role')=="Admin") {

      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialData();
  }
  Map snap ={};

  @override
  Widget build(BuildContext context) {
    //return AddNewPurchaseOrder(drawerWidth: 180,selectedDestination: 4.2,);
    return Scaffold(
      appBar: const PreferredSize(    preferredSize: Size.fromHeight(60),
          child: CustomAppBar2()),
      body: Row(
        children: [
          CustomDrawer(drawerWidth,0),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          const Expanded(child: HomeScreen()),
        ],
      ),
    );
  }


}

class HomeScreen extends StatefulWidget {

  const HomeScreen( {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late double screenWidth;
  late double screenHeight;
  String imageUrl = "";


  @override
  void initState() {
    super.initState();

  }















  List displayList=[];

  // List grnList=[
  //   {
  //     "newvehi_grn_id": "GRN02525",
  //     "new_vendor_id": "NWVND_02479",
  //     "vendor_name": "Shobu",
  //     "purchase_order_number": "PO1912221003",
  //     "purchase_order_date": "19-12-2022",
  //     "grn_number": "grn",
  //     "grn_ref": "ok",
  //     "grn_date": "2022-12-19",
  //     "vehicle_name": "make",
  //     "updated_recieved_quantity": "0",
  //     "ordered_quantity": "16",
  //     "recieved_quantity": "2",
  //     "short_quantity": "14",
  //     "amount": "101010",
  //     "varient_color": "color",
  //     "tax_percent": "12",
  //     "freight_amount": 0.0,
  //     "terms_conditions": "ko",
  //     "customer_notes": "ok",
  //     "status": ""
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02537",
  //     "new_vendor_id": "NWVND_02534",
  //     "vendor_name": "Ganesh",
  //     "purchase_order_number": "PO1912221004",
  //     "purchase_order_date": "19-12-2022",
  //     "grn_number": "GRN123124",
  //     "grn_ref": "123123",
  //     "grn_date": "2022-12-19",
  //     "vehicle_name": "Ather",
  //     "updated_recieved_quantity": "0",
  //     "ordered_quantity": "8",
  //     "recieved_quantity": "2",
  //     "short_quantity": "6",
  //     "amount": "150",
  //     "varient_color": "Grey",
  //     "tax_percent": "7",
  //     "freight_amount": 0.0,
  //     "terms_conditions": "Terms and Conditions",
  //     "customer_notes": "Cust Notes",
  //     "status": "Invoiced"
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02544",
  //     "new_vendor_id": "NWVND_02534",
  //     "vendor_name": "Ganesh",
  //     "purchase_order_number": "PO2012221005",
  //     "purchase_order_date": "20-12-2022",
  //     "grn_number": "GRN123124",
  //     "grn_ref": "123123",
  //     "grn_date": "2022-12-21",
  //     "vehicle_name": "Mahindra",
  //     "updated_recieved_quantity": "0",
  //     "ordered_quantity": "2",
  //     "recieved_quantity": "2",
  //     "short_quantity": "0",
  //     "amount": "120000",
  //     "varient_color": "Blue",
  //     "tax_percent": "7",
  //     "freight_amount": 0.0,
  //     "terms_conditions": "Terms",
  //     "customer_notes": "Notes",
  //     "status": ""
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02545",
  //     "new_vendor_id": "NWVND_02534",
  //     "vendor_name": "Ganesh",
  //     "purchase_order_number": "PO2012221005",
  //     "purchase_order_date": "20-12-2022",
  //     "grn_number": "GRN123124",
  //     "grn_ref": "123123",
  //     "grn_date": "2022-12-21",
  //     "vehicle_name": "Mahindra",
  //     "updated_recieved_quantity": "0",
  //     "ordered_quantity": "2",
  //     "recieved_quantity": "2",
  //     "short_quantity": "0",
  //     "amount": "120000",
  //     "varient_color": "Blue",
  //     "tax_percent": "7",
  //     "freight_amount": 0.0,
  //     "terms_conditions": "Terms",
  //     "customer_notes": "Notes",
  //     "status": "Invoiced"
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02550",
  //     "new_vendor_id": "NWVND_02490",
  //     "vendor_name": "Nani",
  //     "purchase_order_number": "PO1912221005",
  //     "purchase_order_date": "19-12-2022",
  //     "grn_number": "Grn76576",
  //     "grn_ref": "babu",
  //     "grn_date": "2022-12-20",
  //     "vehicle_name": "Ather",
  //     "updated_recieved_quantity": "0",
  //     "ordered_quantity": "15",
  //     "recieved_quantity": "1",
  //     "short_quantity": "14",
  //     "amount": "150",
  //     "varient_color": "Grey",
  //     "tax_percent": "5",
  //     "freight_amount": 15.0,
  //     "terms_conditions": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws.",
  //     "customer_notes": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.",
  //     "status": ""
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02557",
  //     "new_vendor_id": "NWVND_02534",
  //     "vendor_name": "Ganesh",
  //     "purchase_order_number": "PO1912221004",
  //     "purchase_order_date": "19-12-2022",
  //     "grn_number": "GRN5454",
  //     "grn_ref": "dfdf",
  //     "grn_date": "2022-12-20",
  //     "vehicle_name": "Ather",
  //     "updated_recieved_quantity": "2",
  //     "ordered_quantity": "8",
  //     "recieved_quantity": "1",
  //     "short_quantity": "5",
  //     "amount": "150",
  //     "varient_color": "Grey",
  //     "tax_percent": "7",
  //     "freight_amount": 0.0,
  //     "terms_conditions": "Terms and Conditions",
  //     "customer_notes": "Cust Notes",
  //     "status": ""
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02569",
  //     "new_vendor_id": "NWVND_02479",
  //     "vendor_name": "Shobu",
  //     "purchase_order_number": "PO1912221003",
  //     "purchase_order_date": "19-12-2022",
  //     "grn_number": "GRN556",
  //     "grn_ref": "rahul",
  //     "grn_date": "2022-12-20",
  //     "vehicle_name": "make",
  //     "updated_recieved_quantity": "2",
  //     "ordered_quantity": "16",
  //     "recieved_quantity": "1",
  //     "short_quantity": "13",
  //     "amount": "101010",
  //     "varient_color": "color",
  //     "tax_percent": "12",
  //     "freight_amount": 0.0,
  //     "terms_conditions": "ko",
  //     "customer_notes": "ok",
  //     "status": ""
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02577",
  //     "new_vendor_id": "NWVND_02490",
  //     "vendor_name": "Nani",
  //     "purchase_order_number": "PO1912221005",
  //     "purchase_order_date": "19-12-2022",
  //     "grn_number": "GRN34534",
  //     "grn_ref": "babu",
  //     "grn_date": "2022-12-21",
  //     "vehicle_name": "Ather",
  //     "updated_recieved_quantity": "1",
  //     "ordered_quantity": "15",
  //     "recieved_quantity": "1",
  //     "short_quantity": "13",
  //     "amount": "150",
  //     "varient_color": "Grey",
  //     "tax_percent": "5",
  //     "freight_amount": 15.0,
  //     "terms_conditions": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws.",
  //     "customer_notes": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.",
  //     "status": ""
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02583",
  //     "new_vendor_id": "NWVND_02534",
  //     "vendor_name": "Ganesh",
  //     "purchase_order_number": "PO1912221004",
  //     "purchase_order_date": "19-12-2022",
  //     "grn_number": "GRN4545654",
  //     "grn_ref": "babu",
  //     "grn_date": "2022-12-07",
  //     "vehicle_name": "Ather",
  //     "updated_recieved_quantity": "3",
  //     "ordered_quantity": "8",
  //     "recieved_quantity": "1",
  //     "short_quantity": "4",
  //     "amount": "150",
  //     "varient_color": "Grey",
  //     "tax_percent": "7",
  //     "freight_amount": 0.0,
  //     "terms_conditions": "Terms and Conditions",
  //     "customer_notes": "Cust Notes",
  //     "status": ""
  //   },
  //   {
  //     "newvehi_grn_id": "GRN02611",
  //     "new_vendor_id": "NWVND_02490",
  //     "vendor_name": "Nani",
  //     "purchase_order_number": "PO1912221005",
  //     "purchase_order_date": "19-12-2022",
  //     "grn_number": "grn",
  //     "grn_ref": "babu",
  //     "grn_date": "2022-12-23",
  //     "vehicle_name": "Ather",
  //     "updated_recieved_quantity": "2",
  //     "ordered_quantity": "15",
  //     "recieved_quantity": "1",
  //     "short_quantity": "12",
  //     "amount": "150",
  //     "varient_color": "Grey",
  //     "tax_percent": "5",
  //     "freight_amount": 15.0,
  //     "terms_conditions": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws.",
  //     "customer_notes": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.",
  //     "status": ""
  //   }
  // ];
  List fiveGrnList=[];

  int endVal=0;
  int second=0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.only(left: 40,right: 40),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              const SizedBox(height: 30,),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Dashboard",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12,),
              Row(
                children:  [
                  Expanded(child: InkWell(
                    //mouseCursor: MouseCursor.,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: (){
                      Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 1.1,drawerWidth: 190));
                    },
                    child: const KpiCard(title: "Customers",subTitle:'300',subTitle2: "134",icon:Icons.account_balance_wallet_outlined)

                  )),
                  const SizedBox(width: 30),
                  Expanded(child: Card(
                      color: Colors.transparent,
                      elevation: 4,
                      child:  Container(
                        height: 130,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,top: 20),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 55,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: const Icon(Icons.account_balance_wallet_outlined,color: Colors.white,size: 30),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(child: Text(" Dockets",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Flexible(child: Text("1,300",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),
                                               const Flexible(
                                                child: Row(
                                                  children: [
                                                    Flexible(child: Icon(Icons.arrow_upward_sharp,color: Colors.green,size: 16)),
                                                    Flexible(child: Text("134",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.green,fontSize: 12,))),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            Container(
                              height: 40,decoration: BoxDecoration(
                              color: const Color(0xffF9FAFB),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border.all(
                                width: 3,
                                color: Colors.transparent,
                                style: BorderStyle.solid,
                              ),
                            ),
                              child:  const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                    child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))),
                  const SizedBox(width: 30),
                  Expanded(child: Card(
                      color: Colors.transparent,
                      elevation: 4,
                      child:  Container(
                        height: 130,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,top: 20),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 55,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: const Icon(IconData(0xef6f, fontFamily: 'MaterialIcons'),color: Colors.white,size: 30),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(child: Text("Vehicles Sold",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Flexible(child: Text("300",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),
                                               const Flexible(
                                                child: Row(
                                                  children: [
                                                    Flexible(child: Icon(Icons.arrow_upward_sharp,color: Colors.green,size: 16)),
                                                    Flexible(child: Text("134",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.green,fontSize: 12,))),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            Container(
                              height: 40,decoration: BoxDecoration(
                              color: const Color(0xffF9FAFB),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border.all(
                                width: 3,
                                color: Colors.transparent,
                                style: BorderStyle.solid,
                              ),
                            ),
                              child:  const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                    child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))),
                  const SizedBox(width: 30),
                  Expanded(child: InkWell(
                    //mouseCursor: MouseCursor.,
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: (){
                        Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 1.1,drawerWidth: 190));
                      },
                      child: const KpiCard(title: "Customers",subTitle:'300',subTitle2: "134",icon:Icons.account_balance_wallet_outlined)

                  )),
                ],
              ),
              const SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Card(elevation: 8,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                        height: 400,
                        child:
                         const Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14,),
                            Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text("Bar Chart"),
                            ),
                            SizedBox(height: 350,child: BarChartData()),
                          ],
                        ),
                      ),
                    ),
                  ),
                   const SizedBox(width: 20,),
                   Expanded(
                    child: Card(
                      elevation: 8,
                      child: Container(
                        height: 400,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                        child:  const Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14,),
                            Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text("Pie Chart"),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 300,
                              child: PirChartData()
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                   Expanded(
                    child: Card(elevation: 8,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                        height: 400,
                        child:  const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14,),
                            Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text("Line Chart"),
                            ),
                            SizedBox(height: 350,child: LineChartData()),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 30,),

              // Row(crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: Column(children: [
              //         Container(
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //               borderRadius: BorderRadius.circular(10),
              //               border: Border.all(color: const Color(0xFFE0E0E0),)
              //           ),
              //           child: Column(children: [
              //         const  Padding(
              //             padding:  EdgeInsets.all(15.0),
              //             child:   Align(alignment: Alignment.topLeft,child: Text("Customer List ", style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold))),
              //           ),
              //             Container(
              //                 height: 32,
              //                color: Colors.grey[100],
              //                 child:
              //                 IgnorePointer(ignoring: true,
              //                   child: MaterialButton(
              //                     hoverColor:mHoverColor,
              //                     hoverElevation: 0,
              //                     onPressed: () {  },
              //                     child: Padding(
              //                       padding: const EdgeInsets.only(left:15.0),
              //                       child: Row(
              //                         children: const [
              //                           Expanded(
              //                               child: Padding(
              //                                 padding: EdgeInsets.only(top: 4.0),
              //                                 child: SizedBox(height: 25,
              //                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //                                     child: Text("Name",style: TextStyle(color: Colors.black),)
              //                                 ),
              //                               )),
              //                           Expanded(
              //                               child: Padding(
              //                                 padding: EdgeInsets.only(top: 4.0),
              //                                 child: SizedBox(height: 25,
              //                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //                                     child: Text("Company Name",style: TextStyle(color: Colors.black),)
              //                                 ),
              //                               )),
              //                           Expanded(
              //                               child: Padding(
              //                                 padding: EdgeInsets.only(top: 4.0),
              //                                 child: SizedBox(height: 25,
              //                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //                                     child: Text("Phone No",style: TextStyle(color: Colors.black),)
              //                                 ),
              //                               )),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //             ),
              //             // for(int i=0;i<=displayList.length;i++)
              //             //   Column(children: [
              //             //     if(i!=displayList.length)
              //             //       MaterialButton(
              //             //         hoverColor: Colors.blue[50],
              //             //         onPressed: () {  },
              //             //         child: Padding(
              //             //           padding: const EdgeInsets.only(left:15.0),
              //             //           child: Row(
              //             //             children: [
              //             //               Expanded(
              //             //                   child: Padding(
              //             //                     padding: const EdgeInsets.only(top: 4.0),
              //             //                     child: SizedBox(height: 25,
              //             //                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //             //                         child:Text(displayList[i]['first_name'])
              //             //                     ),
              //             //                   )),
              //             //               Expanded(
              //             //                   child: Padding(
              //             //                     padding: const EdgeInsets.only(left:10,top: 4.0),
              //             //                     child: SizedBox(height: 25,
              //             //                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //             //                         child: Text(displayList[i]['company_name']??"")
              //             //                     ),
              //             //                   )),
              //             //               Expanded(
              //             //                   child: Padding(
              //             //                     padding: const EdgeInsets.only(left:10,top: 4.0),
              //             //                     child: SizedBox(height: 25,
              //             //                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //             //                         child: Text(displayList[i]['customer_phone']??"")
              //             //                     ),
              //             //                   )),
              //             //
              //             //
              //             //               const Center(child: Padding(
              //             //                 padding: EdgeInsets.only(right: 8),
              //             //                 child: Icon(size: 18,
              //             //                   Icons.more_vert,
              //             //                   color: Colors.black,
              //             //                 ),
              //             //               ),)
              //             //             ],
              //             //           ),
              //             //         ),
              //             //       ),
              //             //     if(i!=displayList.length)
              //             //       Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
              //             //     if(i==displayList.length)
              //             //       Row(mainAxisAlignment: MainAxisAlignment.end,
              //             //         children: [
              //             //
              //             //           Text("${endVal+5>customersList.length?customersList.length:endVal+1}-${endVal+5>customersList.length?customersList.length:endVal+5} of ${customersList.length}",style: const TextStyle(color: Colors.grey)),
              //             //           const SizedBox(width: 10,),
              //             //           //First backward arrow.
              //             //           InkWell(
              //             //             child: const Padding(
              //             //               padding: EdgeInsets.all(18.0),
              //             //               child: Icon(Icons.arrow_back_ios_sharp,size: 12),
              //             //             ),
              //             //             onTap: (){
              //             //               //endval initial 0.
              //             //               if(endVal>4){
              //             //                 displayList=[];
              //             //                 endVal = endVal-5;
              //             //                 for(int i=endVal;i<endVal+5;i++){
              //             //                   setState(() {
              //             //                     displayList.add(customersList[i]);
              //             //                   });
              //             //                 }
              //             //               }
              //             //               else{
              //             //                 print('else');
              //             //               }
              //             //
              //             //             },
              //             //           ),
              //             //           const SizedBox(width: 10,),
              //             //           //second forward arrow
              //             //           InkWell(
              //             //             child: const Padding(
              //             //               padding: EdgeInsets.all(18.0),
              //             //               child: Icon(Icons.arrow_forward_ios,size: 12),
              //             //             ),
              //             //             onTap: (){
              //             //               if(customersList.length>endVal+6){
              //             //                 displayList=[];
              //             //                 endVal=endVal+i;
              //             //                 for(int i=endVal;i<endVal+5;i++){
              //             //                   setState(() {
              //             //                     displayList.add(customersList[i]);
              //             //                   });
              //             //                 }
              //             //               }
              //             //               else{
              //             //                 displayList=[];
              //             //                 endVal=endVal+i;
              //             //                 for(int i=endVal;i<customersList.length;i++){
              //             //                   setState(() {
              //             //                     displayList.add(customersList[i]);
              //             //                   });
              //             //                 }
              //             //               }
              //             //             },
              //             //           ),
              //             //           const SizedBox(width: 20,)
              //             //         ],
              //             //       )
              //             //   ],)
              //
              //           ]),
              //         )
              //       ]),
              //     ),
              //     const SizedBox(width: 50,),
              //     Expanded(
              //       child: Column(children: [
              //         Container(
              //           decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(10),
              //               border: Border.all(color: const Color(0xFFE0E0E0),)
              //           ),
              //           child: Column(children: [
              //             const  Padding(
              //               padding:  EdgeInsets.all(15.0),
              //               child:   Align(alignment: Alignment.topLeft,child: Text("Grn List", style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold))),
              //             ),
              //             Container(
              //                 height: 32,
              //                 color: Colors.grey[100],
              //                 child:
              //                 IgnorePointer(ignoring: true,
              //                   child: MaterialButton(
              //                     hoverColor:mHoverColor,
              //                     hoverElevation: 0,
              //                     onPressed: () {  },
              //                     child: Padding(
              //                       padding: const EdgeInsets.only(left:15.0),
              //                       child: Row(
              //                         children: const [
              //                           Expanded(
              //                               child: Padding(
              //                                 padding: EdgeInsets.only(top: 4.0),
              //                                 child: SizedBox(height: 25,
              //                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //                                     child: Text("Vendor Name",style: TextStyle(color: Colors.black),)
              //                                 ),
              //                               )),
              //                           Expanded(
              //                               child: Padding(
              //                                 padding: EdgeInsets.only(top: 4.0),
              //                                 child: SizedBox(height: 25,
              //                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //                                     child: Text("Company Name",style: TextStyle(color: Colors.black),)
              //                                 ),
              //                               )),
              //                           Expanded(
              //                               child: Padding(
              //                                 padding: EdgeInsets.only(top: 4.0),
              //                                 child: SizedBox(height: 25,
              //                                     //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //                                     child: Text("Grn Number",style: TextStyle(color: Colors.black),)
              //                                 ),
              //                               )),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //             ),
              //
              //             // for(int i=0;i<=fiveGrnList.length;i++)
              //             //   Column(children: [
              //             //     if(i!=fiveGrnList.length)
              //             //       MaterialButton(
              //             //         hoverColor: Colors.blue[50],
              //             //         onPressed: () {  },
              //             //         child: Padding(
              //             //           padding: const EdgeInsets.only(left:15.0),
              //             //           child: Row(
              //             //             children: [
              //             //               Expanded(
              //             //                   child: Padding(
              //             //                     padding: const EdgeInsets.only(top: 4.0),
              //             //                     child: SizedBox(height: 25,
              //             //                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //             //                         child: Text(fiveGrnList[i]['vendor_name'])
              //             //                     ),
              //             //                   )),
              //             //               Expanded(
              //             //                   child: Padding(
              //             //                     padding: const EdgeInsets.only(left:10,top: 4.0),
              //             //                     child: SizedBox(height: 25,
              //             //                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //             //                         child:  Text(fiveGrnList[i]['vehicle_name'])
              //             //                     ),
              //             //                   )),
              //             //               Expanded(
              //             //                   child: Padding(
              //             //                     padding: const EdgeInsets.only(left:10,top: 4.0),
              //             //                     child: SizedBox(height: 25,
              //             //                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
              //             //                         child:Text(fiveGrnList[i]['grn_number'])
              //             //                     ),
              //             //                   )),
              //             //               const Center(child: Padding(
              //             //                 padding: EdgeInsets.only(right: 8),
              //             //                 child: Icon(size: 18,
              //             //                   Icons.more_vert,
              //             //                   color: Colors.black,
              //             //                 ),
              //             //               ),)
              //             //             ],
              //             //           ),
              //             //         ),
              //             //       ),
              //             //
              //             //     if(i!=fiveGrnList.length)
              //             //       Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
              //             //     if(i==fiveGrnList.length)
              //             //       Row(mainAxisAlignment: MainAxisAlignment.end,
              //             //         children: [
              //             //
              //             //           Text("${second+5>grnList.length?grnList.length:second+1}-${second+5>grnList.length?grnList.length:second+5} of ${grnList.length}",style: const TextStyle(color: Colors.grey)),
              //             //           const SizedBox(width: 10,),
              //             //           //First backward arrow.
              //             //           InkWell(
              //             //             child: const Padding(
              //             //               padding: EdgeInsets.all(18.0),
              //             //               child: Icon(Icons.arrow_back_ios_sharp,size: 12),
              //             //             ),
              //             //             onTap: (){
              //             //               //endval initial 0.
              //             //               if(second>4){
              //             //                 fiveGrnList=[];
              //             //                 second = second-5;
              //             //                 for(int i=second;i<second+5;i++){
              //             //                   setState(() {
              //             //                     fiveGrnList.add(grnList[i]);
              //             //                   });
              //             //                 }
              //             //               }
              //             //               else{
              //             //                 print('else');
              //             //               }
              //             //
              //             //             },
              //             //           ),
              //             //           const SizedBox(width: 10,),
              //             //           //second forward arrow
              //             //           InkWell(
              //             //             child: const Padding(
              //             //               padding: EdgeInsets.all(18.0),
              //             //               child: Icon(Icons.arrow_forward_ios,size: 12),
              //             //             ),
              //             //             onTap: (){
              //             //               if(grnList.length>second+6){
              //             //                 fiveGrnList=[];
              //             //                 second=second+i;
              //             //                 for(int i=second;i<second+5;i++){
              //             //                   setState(() {
              //             //                     fiveGrnList.add(grnList[i]);
              //             //                   });
              //             //                 }
              //             //               }
              //             //               else{
              //             //                 fiveGrnList=[];
              //             //                 second=second+i;
              //             //                 for(int i=second;i<grnList.length;i++){
              //             //                   setState(() {
              //             //                     fiveGrnList.add(grnList[i]);
              //             //                   });
              //             //                 }
              //             //               }
              //             //             },
              //             //           ),
              //             //           const SizedBox(width: 20,)
              //             //         ],
              //             //       )
              //             //   ],)
              //
              //           ]),
              //         )
              //       ]),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 30,),


              // Column(
              //   children: [
              //     const Padding(
              //       padding: EdgeInsets.only(top: 20, left: 40.0, right: 40.0),
              //       child: Align(alignment: Alignment.topLeft,
              //           child: Text("Brands", style: TextStyle(fontSize: 24,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.indigo))),
              //     ),
              //     // Padding(
              //     //   padding: const EdgeInsets.only(
              //     //       left: 40.0, right: 40.0, top: 10, bottom: 10),
              //     //   child: GridView.count(
              //     //     crossAxisCount: screenWidth > 1100 ? 5 : screenWidth > 700
              //     //         ? 3
              //     //         : screenWidth > 600 ? 2 : 1,
              //     //     physics: const NeverScrollableScrollPhysics(),
              //     //     shrinkWrap: true,
              //     //     crossAxisSpacing: 10,
              //     //     mainAxisSpacing: 10,
              //     //     children: List.generate(vehicleList.length, (index) {
              //     //       return Card(elevation: 4, color: Colors.grey[200],
              //     //         child: Material(
              //     //           color: Colors.transparent,
              //     //           child: InkWell(splashColor: Colors.red, key: const Key(
              //     //               "vehicleBtn"),
              //     //             onTap: () {
              //     //             Navigator.of(context).push(
              //     //                 PageRouteBuilder(
              //     //                   pageBuilder: (context, animation1, animation2) =>SelectColorVariant(vehicleList[index]["name"],vehicleList[index]['url']),
              //     //                   transitionDuration: Duration.zero,
              //     //                   reverseTransitionDuration: Duration.zero,
              //     //                 ),
              //     //             );
              //     //             },
              //     //             child: Column(
              //     //               mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     //               children: [
              //     //                 Expanded(flex: 8,
              //     //                   child: Image.asset(vehicleList[index]['url'],
              //     //                     height: screenHeight / 6,),
              //     //                 ),
              //     //                 Expanded(flex: 2,
              //     //                     child: Card(color: Colors.white,
              //     //                         child: Row(
              //     //                           mainAxisAlignment: MainAxisAlignment
              //     //                               .center,
              //     //                           children: [
              //     //                             Text(vehicleList[index]["name"],
              //     //                               style: const TextStyle(fontSize: 16,
              //     //                                   color: Color(0xff131d48)),),
              //     //                           ],
              //     //                         )))
              //     //               ],
              //     //             ),
              //     //           ),
              //     //         ),
              //     //       );
              //     //     }),
              //     //   ),
              //     // ),
              //     Padding(
              //       padding: const EdgeInsets.only(
              //           left: 40.0, right: 40.0, top: 10, bottom: 10),
              //       child: GridView.count(
              //         crossAxisCount: screenWidth > 1100 ? 5 : screenWidth > 700
              //             ? 3
              //             : screenWidth > 600 ? 2 : 1,
              //         physics: const NeverScrollableScrollPhysics(),
              //         shrinkWrap: true,
              //         crossAxisSpacing: 10,
              //         mainAxisSpacing: 10,
              //         children: List.generate(brands.length, (index) {
              //           return Card(elevation: 4, color: Colors.grey[200],
              //             child: Material(
              //               color: Colors.transparent,
              //               child: InkWell(splashColor: Colors.red,
              //                 onTap: () {
              //                 Navigator.of(context).push(
              //                     PageRouteBuilder(
              //                       pageBuilder: (context, animation1, animation2) => SelectModel(selectedDestination: 0,drawerWidth:190,brandName:brands[index]["name"] ),
              //                       transitionDuration: Duration.zero,
              //                       reverseTransitionDuration: Duration.zero,
              //                     ),
              //                   );
              //                 },
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                   children: [
              //
              //                     Expanded(flex: 2,
              //                         child: Card(color: Colors.white,
              //                             child: Row(
              //                               mainAxisAlignment: MainAxisAlignment
              //                                   .center,
              //                               children: [
              //                                 Text(brands[index]["name"],
              //                                   style: const TextStyle(fontSize: 16,
              //                                       color: Color(0xff131d48)),),
              //                               ],
              //                             )))
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           );
              //         }),
              //       ),
              //     )
              //
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }


}




class BarChartData extends StatefulWidget {
  const BarChartData({Key? key}) : super(key: key);

  @override
  State<BarChartData> createState() => _BarChartDataState();
}

class _BarChartDataState extends State<BarChartData> {

  final List<ChartData> chartData = [
    ChartData('Jan', 25, const Color.fromRGBO(9,0,136,1)),
    ChartData('Feb', 38, const Color.fromRGBO(147,0,119,1)),
    ChartData('Mar', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('April', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('May', 23, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 52, const Color.fromRGBO(255,189,57,1))
  ];

  final List<ChartData> chartData2 = [
    ChartData('Jan', 60, const Color.fromRGBO(9,0,136,1)),
    ChartData('Feb', 32, const Color.fromRGBO(147,0,119,1)),
    ChartData('Mar', 41, const Color.fromRGBO(228,0,124,1)),
    ChartData('April', 31, const Color.fromRGBO(228,0,124,1)),
    ChartData('May', 41, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 22, const Color.fromRGBO(255,189,57,1))
  ];

  @override
  Widget build(BuildContext context) {
    return  SfCartesianChart(
      isTransposed: true,
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        BarSeries<ChartData, String>(color: Colors.blue,
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        ),
        BarSeries<ChartData, String>(
          color:  const Color(0xffEF376E),
          dataSource: chartData2,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        ),
      ],
    );
  }
}


class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}


class LineChartData extends StatefulWidget {
  const LineChartData({Key? key}) : super(key: key);

  @override
  State<LineChartData> createState() => _LineChartDataState();
}

class _LineChartDataState extends State<LineChartData> {

  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 18),
    _SalesData('Mar', 32),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
    _SalesData('Jun', 29)
  ];

  List<_SalesData> data2 = [
    _SalesData('Jan', 30),
    _SalesData('Feb', 8),
    _SalesData('Mar', 34),
    _SalesData('Apr', 42),
    _SalesData('May', 45),
    _SalesData('Jun', 39)
  ];
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),

        // Chart title

        // Enable legend

        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<_SalesData, String>>[
          LineSeries<_SalesData, String>(
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.year,
              yValueMapper: (_SalesData sales, _) => sales.sales,
              name: 'Sales',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true)),
          LineSeries<_SalesData, String>(
              dataSource: data2,
              xValueMapper: (_SalesData sales, _) => sales.year,
              yValueMapper: (_SalesData sales, _) => sales.sales,
              name: 'Sales 2',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ]
    );
  }
}



class PirChartData extends StatefulWidget {
  const PirChartData({Key? key}) : super(key: key);

  @override
  State<PirChartData> createState() => _PirChartDataState();
}

class _PirChartDataState extends State<PirChartData> {

  late TooltipBehavior _tooltipBehavior;

  final List<ChartData> chartData = [
    ChartData('David', 25, const Color.fromRGBO(9,0,136,1)),
    ChartData('Steve', 38, const Color.fromRGBO(147,0,119,1)),
    ChartData('Jack', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 52, const Color.fromRGBO(255,189,57,1))
  ];

  final List<ChartData> chartData2 = [
    ChartData('David', 60, const Color.fromRGBO(9,0,136,1)),
    ChartData('Steve', 32, const Color.fromRGBO(147,0,119,1)),
    ChartData('Jack', 31, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 22, const Color.fromRGBO(255,189,57,1))
  ];

  @override
  void initState() {

    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.scroll),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
            enableTooltip: true,
            dataSource: chartData,
            pointColorMapper:(ChartData data,  _) => data.color,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelSettings: DataLabelSettings(isVisible: true,
              builder: (data, point, series, pointIndex, seriesIndex) {
                return Text("${data.x} ${data.y}",style: const TextStyle(color: Colors.white,fontSize: 12),);
              },
            )
        ),


      ],
    );
  }
}





