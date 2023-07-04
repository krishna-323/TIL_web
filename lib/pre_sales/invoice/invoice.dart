// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'invoice.dart';
import 'invoice_details.dart';

class InvoiceArguments {
  final double drawerWidth;
  final double selectedDestination;
  InvoiceArguments({required this.drawerWidth, required this.selectedDestination});
}

class InvoiceList extends StatefulWidget {
  final InvoiceArguments args;
  const InvoiceList({Key? key,required this.args}) : super(key: key);

  @override
 State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {

  List docketData =[];
  bool loading = false;
  String userId='';

  Future getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
  }


  Future fetchDocketData() async {
    dynamic response;
    //String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_all_dock_customer_details';
    String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_all_by_userid/$userId';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            docketData = value;
            // print('------new get ----------');
            // print(docketData);
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
    // TODO: implement initState
    super.initState();
    getInitialData().whenComplete(() {fetchDocketData();});
    loading = true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.args.drawerWidth,widget.args.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
              child:Scaffold(
                body: CustomLoader(
                  inAsyncCall: loading,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding:  const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("Order Booking ",style: TextStyle(color: Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),

                                ],
                              ),
                              const SizedBox(height: 20,),
                              Container(height: 40,
                                  color: Colors.grey[200],
                                  child:
                                  Row(
                                    children: const [
                                      Expanded(child: Center(child: Text("Vehicle"))),
                                      Expanded(child: Center(child: Text("Variant"))),
                                      Expanded(child: Center(child: Text("On Road Price"))),
                                      Expanded(child: Center(child: Text("Customer Name"))),
                                      Expanded(child: Center(child: Text("Mobile"))),
                                      Expanded(flex: 2,child: Center(child: Text("Email ID"))),
                                      Expanded(child: Center(child: Text("Status"))),
                                      Center(child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                        color: Colors.transparent,
                                      ),)
                                    ],
                                  )
                              ),

                              // Align(alignment: Alignment.centerLeft,child: Text("OCT 11, Monday",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900],fontSize: 14),)),
                              // SizedBox(height: 10,),
                              const SizedBox(height: 10,),
                              for(int i=0;i<docketData.length;i++)
                                if(docketData[i]['status']=="Invoiced")
                                  Column(
                                    children: [
                                      Card(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(10),
                                            splashColor: const Color(0xFFA2BFEC),
                                            onTap: (){
                                              // print('---------- selected item ----------');
                                              // print(docketData[i]);
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => InvoiceDetails({

                                                    "custName": docketData[i]['customer_name'],
                                                    "mobileNo": docketData[i]['mobile'],
                                                    "address": "${docketData[i]['address_1']}, ${docketData[i]['address_2']}, ${docketData[i]['city']}, ${docketData[i]['state']}, ${docketData[i]['pincode']}",
                                                    "vehicleName": "${docketData[i]['make']}(${docketData[i]['varient_name']})",
                                                    "color": docketData[i]["color"],

                                                  }, docketData[i])));
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(child: Center(child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(docketData[i]['make'])
                                                  ),
                                                ))),
                                                Expanded(child: Center(child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(docketData[i]['varient_name']??"")
                                                  ),
                                                ))),
                                                Expanded(child: Center(child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Rs. ${docketData[i]['onroad_price'].toString()}")
                                                  ),
                                                ))),
                                                Expanded(child: Center(child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(docketData[i]['customer_name'])
                                                  ),
                                                ))),
                                                Expanded(child: Center(child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(docketData[i]['mobile'])
                                                  ),
                                                ))),
                                                Expanded(flex: 2,child: Center(child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(docketData[i]['email_id'])
                                                  ),
                                                ))),
                                                Expanded(child: Center(child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Center(child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(child: Padding(
                                                                  padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
                                                                  child: Container(
                                                                      decoration: const BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                          color: Colors.green),
                                                                      child:  Center(
                                                                          child: Text(
                                                                            docketData[i]['status'],
                                                                            style: const TextStyle(color: Colors.white),
                                                                          ))),
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  ),
                                                ))),
                                                const Center(child: Padding(
                                                  padding: EdgeInsets.only(top: 5.0,right: 5),
                                                  child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                                    size: 18,
                                                    color: Colors.blue,
                                                  ),
                                                ),)
                                              ],
                                            ),
                                          ),
                                        ),
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
              )
          ),
        ],
      ),
    );

  }
}


