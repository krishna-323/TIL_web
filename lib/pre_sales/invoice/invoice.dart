// import 'dart:convert';
// import 'dart:math';
import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_project/widgets/motows_buttons/outlined_mbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';
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
  List displayDocketList =[];
  int startVal= 0;
  bool loading = false;
  String userId='';

  Future getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
  }


  Future fetchDocketData() async {
    dynamic response;
    String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocket/get_all_sales_dockets_wrapper';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            docketData = value;
            displayDocketList = docketData.where((item) => item['status'] == "Invoiced").toList();
            if(displayDocketList.isEmpty){
              if(docketData.length > 15){
                for(int i=startVal; i<startVal+15; i++){
                  displayDocketList.add(docketData[i]);
                }
              }else{
                for(int i=0; i<docketData.length; i++){
                  displayDocketList.add(docketData[i]);
                }
              }
            }
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
              child:CustomLoader(
                inAsyncCall: loading,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[50],
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:  const EdgeInsets.only(left: 40.0,right: 40,top:10,bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color:  Color(0xFFE0E0E0),)
                        ),
                        child: Column(
                          children: [
                            Container(
                              // height: 198,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),

                              ),
                              child: Column(children: [
                                const SizedBox(height: 18,),
                                const Padding(
                                  padding: EdgeInsets.only(left: 18.0,right: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      Text("Invoice List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18,),
                                Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                Container(
                                  color: Colors.grey[100],height: 32,
                                  child:  IgnorePointer(
                                    ignoring: true,
                                    child: MaterialButton(
                                      onPressed: (){},
                                      hoverColor: Colors.transparent,
                                      hoverElevation: 0,
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 18.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Vehicle")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text('Variant')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("On Road Price")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Customer Name")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Mobile")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Email ID")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Status")
                                                  ),
                                                )),
                                            Center(child: Padding(
                                              padding: EdgeInsets.only(right: 8),
                                              child: Icon(size: 18,
                                                Icons.more_vert,
                                                color: Colors.transparent,
                                              ),
                                            ),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                              ]),
                            ),
                            const SizedBox(height:4),
                            for(int i=0;i<=displayDocketList.length;i++)
                              // if(displayDocketList[i]['status']=="Invoiced")
                              Column(
                                children: [
                                  if(i!=displayDocketList.length)
                                    MaterialButton(
                                      hoverColor:mHoverColor,
                                      onPressed: (){
                                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=> InvoiceDetails(docketData[i]),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero
                                        )).then((value) {
                                          // fetchPurchaseData();
                                        });
                                      },
                                      child: Padding(padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                                        child: Row(children: [
                                          Expanded(flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayDocketList[i]['make']??"")
                                                ),
                                              )),
                                          Expanded(flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayDocketList[i]['variant']??"")
                                                ),
                                              )),
                                          Expanded(flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayDocketList[i]['onroad_price']??"")
                                                ),
                                              )),
                                          Expanded(flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:  Text(displayDocketList[i]['customer_name']??"")
                                                ),
                                              )),
                                          Expanded(flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayDocketList[i]['mobile']??"")
                                                ),
                                              )),
                                          Expanded(flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayDocketList[i]['email_id']??"")
                                                ),
                                              )),
                                          Expanded(flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        height: 25,
                                                        width: 100,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: OutlinedMButton(
                                                            text: displayDocketList[i]['status']??"",
                                                          textColor: Colors.green,
                                                          borderColor: Colors.green,
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          // const SizedBox(width: 20,),
                                          const Center(child: Padding(
                                            padding: EdgeInsets.only(right: 8,),
                                            child: Icon(size: 18,
                                              Icons.arrow_circle_right,
                                              color: Colors.blue,
                                            ),
                                          ),)
                                        ]),
                                      ),
                                    ),
                                  if(i!=displayDocketList.length)
                                    Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                  if(i==displayDocketList.length)
                                    Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Text("${startVal+15 > displayDocketList.length ? displayDocketList.length : startVal + 1} - ${startVal + 15 > displayDocketList.length ? displayDocketList.length : startVal + 15} of ${displayDocketList.length} ",style: const TextStyle(color: Colors.grey)),
                                        const SizedBox(width: 10,),
                                        Material(color: Colors.transparent,
                                          child: InkWell(
                                            hoverColor: mHoverColor,
                                            child: const Padding(
                                              padding: EdgeInsets.all(18.0),
                                              child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                            ),
                                            onTap: (){
                                              if(startVal > 14){
                                                displayDocketList = [];
                                                startVal = startVal - 15;
                                                for(int i=startVal; i<startVal+15; i++){
                                                  try{
                                                    setState(() {
                                                      displayDocketList.add(docketData[i]);
                                                    });
                                                  }catch(e){
                                                    log(e.toString());
                                                  }
                                                }
                                              }else{
                                                log("else");
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
                                              if(docketData.length > startVal + 15){
                                                displayDocketList = [];
                                                startVal = startVal + 15;
                                                for(int i=startVal; i<startVal+15; i++){
                                                  try{
                                                    setState(() {
                                                      displayDocketList.add(docketData[i]);
                                                    });
                                                  }catch(e){
                                                    log(e.toString());
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                      ],
                                    )
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );

  }
}


