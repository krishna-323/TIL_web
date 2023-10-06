import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_project/utils/customAppBar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../classes/arguments_classes/arguments_classes.dart';
import '../classes/motows_routes.dart';
import '../docket/docket_list.dart';
import '../utils/api/get_api.dart';
import '../utils/static_data/motows_colors.dart';
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
          SelectionArea(child: CustomDrawer(drawerWidth,0)),
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

  @override
  void initState() {
    super.initState();
    fetchListCustomerData();
    fetchPoData();
  }
  List customersList=[];
  List displayList=[];
  List poList=[];
  Future fetchListCustomerData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/get_all_newcustomer';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            customersList = value;
            if(displayList.isEmpty){
              if(customersList.length>5){
                for(int i=endVal;i<endVal+5;i++){
                  displayList.add(customersList[i]);
                }

              }

              else{
                for(int i=endVal;i<customersList.length;i++){
                  displayList.add(customersList[i]);
                }
              }
            }

            // for(int i=0;i<customersList.length;i++){
            //   cityNames.add(
            //       customersList[i]['city']??""
            //   );
            // }

          }
         // loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        //loading = false;
      });
    }
  }
  Future fetchPoData() async{
    dynamic response;
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_mod_general";
    try {
      await getData(context: context, url: url).then((value) {
        // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["general_id"]}");
        // print(value);
        setState(() {
          if(value!=null){
            response = value;


            poList = value;

            if(displayPoList.isEmpty){
              if(poList.length>5){
                for(int i=second;i<5;i++){
                  displayPoList.add(poList[i]);
                }
              }
              else{
                for(int i=second;i<poList.length;i++){
                  displayPoList.add(poList[i]);
                }
              }
            }
            // print('------new get all docket data ----------');
            // print(docketData);
            // print(total);
          }
        });
      });
    }
    catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {

      });
    }
  }
  List displayPoList=[];
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
                      Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 0,drawerWidth: 190));
                    },
                    child: const KpiCard(title: "Customers",subTitle:'300',subTitle2: "134",icon:Icons.account_balance_wallet_outlined)

                  )),
                  const SizedBox(width: 30),
                  Expanded(child: InkWell(
                    onTap:(){
                      // Navigator.pushReplacementNamed(context, MotowsRoutes.docketList,arguments: DocketListArgs(selectedDestination: 0,drawerWidth: 190));
                   },
                    child: Card(
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
                        )),
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
                        // Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 1.1,drawerWidth: 190));
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
              Row(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0),)
                        ),
                        child: Column(children: [
                      const  Padding(
                          padding:  EdgeInsets.all(15.0),
                          child:   Align(alignment: Alignment.topLeft,child: Text("Customer List ", style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold))),
                        ),
                          Container(
                              height: 32,
                             color: Colors.grey[100],
                              child:
                              IgnorePointer(ignoring: true,
                                child: MaterialButton(
                                  hoverColor:mHoverColor,
                                  hoverElevation: 0,
                                  onPressed: () {  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left:15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Name",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Email",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),
                          const SizedBox(height: 4,),
                          ListView.builder(
                              shrinkWrap:true,
                              itemCount: displayList.length+1,
                              itemBuilder: (context,int i){
                            if(i<displayList.length){
                              return Column(children: [
                                MaterialButton(
                                  hoverColor: Colors.blue[50],
                                  onPressed: () {  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child:Text(displayList[i]['customer_name'])
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayList[i]['email_id']??"")
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                              ],);
                            }
                            else{
                              return Column(children: [
                                Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text("${endVal+5>customersList.length?customersList.length:endVal+1}-${endVal+5>customersList.length?customersList.length:endVal+5} of ${customersList.length}",style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(width: 10,),
                                    //First backward arrow.

                                    Material(color: Colors.transparent,
                                      child: InkWell(
                                        hoverColor: mHoverColor,
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                        ),
                                        onTap: (){
                                          if(endVal>4){
                                            displayList=[];
                                            endVal = endVal-5;
                                            for(int i=endVal;i<endVal+5;i++){
                                              try{
                                                setState(() {
                                                  displayList.add(customersList[i]);
                                                });
                                              }
                                              catch(e){
                                                log(e.toString());
                                              }
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    //second forward arrow
                                    Material(color: Colors.transparent,
                                      child: InkWell(
                                        hoverColor: mHoverColor,
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Icon(Icons.arrow_forward_ios,size: 12),
                                        ),
                                        onTap: (){
                                          if(endVal+1+5>customersList.length){
                                            log("Block");
                                          }
                                          else  if(customersList.length>endVal+5){
                                            displayList=[];
                                            endVal=endVal+5;
                                            for(int i=endVal;i<endVal+5;i++){
                                              try{
                                                setState(() {
                                                  displayList.add(customersList[i]);
                                                });
                                              }
                                              catch(e){
                                                log(e.toString());
                                              }
                                            }
                                          }

                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20,)
                                  ],
                                ),
                              ],);
                            }
                          })
                        ]),
                      )
                    ]),
                  ),
                  const SizedBox(width: 50,),
                  Expanded(
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0),)
                        ),
                        child: Column(children: [
                          const  Padding(
                            padding:  EdgeInsets.all(15.0),
                            child:   Align(alignment: Alignment.topLeft,child: Text("Po List", style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold))),
                          ),
                          Container(
                              height: 32,
                              color: Colors.grey[100],
                              child:
                              IgnorePointer(ignoring: true,
                                child: MaterialButton(
                                  hoverColor:mHoverColor,
                                  hoverElevation: 0,
                                  onPressed: () {  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left:15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Make Name",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Model Name",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("On Road Price",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),
                          const SizedBox(height: 4,),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: displayPoList.length+1,
                            itemBuilder: (BuildContext context, int i) {
                            if(i<displayPoList.length){
                              return Column(children: [
                                MaterialButton(
                                  hoverColor: Colors.blue[50],
                                  onPressed: () {  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayPoList[i]['make']??"")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child:  Text(displayPoList[i]['model']??"")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child:Text(displayPoList[i]['on_road_price'].toString())
                                              ),
                                            )),
                                        // const Center(child: Padding(
                                        //   padding: EdgeInsets.only(right: 8),
                                        //   child: Icon(size: 18,
                                        //     Icons.more_vert,
                                        //     color: Colors.black,
                                        //   ),
                                        // ),)
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                              ],);
                            }
                            else{
                              return Column(children: [
                                Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text("${second+5>poList.length?poList.length:second+1}-${second+5>poList.length?poList.length:second+5} of ${poList.length}",style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(width: 10,),
                                    Material(color: Colors.transparent,
                                      child: InkWell(
                                        hoverColor: mHoverColor,
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                        ),
                                        onTap: (){
                                          if(second>4){
                                            displayPoList=[];
                                            second = second-5;
                                            for(int i=second;i<second+5;i++){
                                              setState(() {
                                                displayPoList.add(poList[i]);
                                              });
                                            }
                                          }
                                          else{
                                            log('else');
                                          }

                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Material(color: Colors.transparent,
                                      child: InkWell(
                                        hoverColor: mHoverColor,
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Icon(Icons.arrow_forward_ios,size: 12),
                                        ),
                                        onTap: (){
                                          if(second+1+5>poList.length){
                                            log("Block");
                                          }
                                          else
                                          if(poList.length>second+5){
                                            displayPoList=[];
                                            second=second+5;
                                            for(int i=second;i<second+5;i++){
                                              setState(() {
                                                try{
                                                  displayPoList.add(poList[i]);
                                                }
                                                catch(e){
                                                  log(e.toString());
                                                }

                                              });
                                            }
                                          }

                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                  ],
                                ),

                              ],);
                            }
                          },)


                        ]),
                      )
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
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
  late TooltipBehavior _tooltipBehavior;


  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true,animationDuration: 1);
    super.initState();
  }
    final List<ChartData> chartData = [
    ChartData('Jan', 25, const Color.fromRGBO(9,0,136,1)),
    ChartData('Feb', 38, const Color.fromRGBO(147,0,119,1)),
    ChartData('Mar', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('April', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('May', 23, const Color.fromRGBO(228,0,124,1)),
      ChartData('Jun', 33, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 52, const Color.fromRGBO(255,189,57,1))
  ];

  final List<ChartData> chartData2 = [
    ChartData('Jan', 60, const Color.fromRGBO(9,0,136,1)),
    ChartData('Feb', 32, const Color.fromRGBO(147,0,119,1)),
    ChartData('Mar', 41, const Color.fromRGBO(228,0,124,1)),
    ChartData('April', 31, const Color.fromRGBO(228,0,124,1)),
    ChartData('May', 41, const Color.fromRGBO(228,0,124,1)),
    ChartData('Jun', 51, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 22, const Color.fromRGBO(255,189,57,1))
  ];

  @override
  Widget build(BuildContext context) {
    return  SfCartesianChart(
      tooltipBehavior: _tooltipBehavior,
      isTransposed: true,
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        BarSeries<ChartData, String>(color: const Color(0xff747AF2),
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
    ChartData('David', 25,  const Color.fromRGBO(0,37, 150, 190)),
    ChartData('Steve', 38, const Color.fromRGBO(147,0,119,1)),
    ChartData('Jack', 34, const Color.fromRGBO(228,0,124,1)),
    ChartData('Others', 52, const Color.fromRGBO(255,189,57,1))
  ];

  @override
  void initState() {

    _tooltipBehavior = TooltipBehavior(enable: true,animationDuration:1 );
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
                return Text("${data.x}",style: const TextStyle(color: Colors.white,fontSize: 12),);
              },
            )
        ),


      ],
    );
  }
}





