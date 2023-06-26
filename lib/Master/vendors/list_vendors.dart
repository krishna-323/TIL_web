import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/Master/vendors/view_vendors_details.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'add_new_vendor.dart';

class ListVendors extends StatefulWidget {
  final ListVendorsArguments arg;
  const ListVendors({Key? key, required this. arg}) : super(key: key);

  @override
  State<ListVendors> createState() => _ListVendorsState();
}

class _ListVendorsState extends State<ListVendors> {

  List vendorList = [];
  bool loading = false;
  String? authToken;

  Future fetchVendorsData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_all_new_vendor';
    try {
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vendorList = value;
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getInitialData().whenComplete((){
      fetchVendorsData();
      // selectedId = widget.vendorList['new_vendor_id'];
    });
  }

  Future getInitialData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        appBar: const PreferredSize( preferredSize: Size.fromHeight(60),
            child: CustomAppBar()),
        body: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDrawer(widget.arg.drawerWidth,widget.arg.selectedDestination),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(
              child:
              CustomLoader(
                inAsyncCall: loading,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const  EdgeInsets.only(right: 50.0,left: 50,top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                const Text(
                                  "Vendors List ",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context, MaterialPageRoute(builder: (context)=>AddNewVendors(
                                    //   drawerWidth:widget.args.drawerWidth ,
                                    //   selectedDestination: widget.args.selectedDestination,
                                    // )
                                    // )
                                    // ).then((value) => fetchVendorsData());
                                    Navigator.of(context).push(PageRouteBuilder(
                                        pageBuilder: (context,animation1,animation2)=>const AddNewVendors(
                                          selectedDestination: 3.3, drawerWidth: 190,)));
                                  },color: Colors.blue,
                                  child: const Text(
                                      "+ New",
                                      style: TextStyle(color: Colors.white)),
                                )
                              ],
                            ),
                            const SizedBox(height: 20,),
                            //-------table header----
                            Container(
                                height: 40,
                                color: Colors.grey[200],
                                child:
                                const Row(
                                  children: [
                                    Expanded(child: Center(child: Text("COMPANY NAME"))),
                                    Expanded(child: Center(child: Text("NAME"))),
                                    Expanded(child: Center(child: Text("EMAIL"))),
                                    Expanded(child: Center(child: Text("PHONE"))),
                                    Expanded(child: Center(child: Text("CITY"))),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 20,
                                          child: Icon(CupertinoIcons.chevron_right_circle_fill,color: Colors.transparent,),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            const SizedBox(height: 10,),
                            for(int i=0;i<vendorList.length;i++)
                              Column(
                                children: [
                                  Card(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        splashColor:const Color(0xFFA2BFEC),
                                        onTap: (){
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) => ViewVendors(vendorList: vendorList[i],
                                                drawerWidth: widget.arg.drawerWidth,
                                                selectedDestination: widget.arg.selectedDestination,),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 8),
                                                      child: SizedBox(height: 28,
                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                          child: Text(vendorList[i]['company_name']??"")
                                                      ),
                                                    ))),
                                            Expanded(
                                                child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 8),
                                                      child: SizedBox(
                                                          height: 28,
                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                          child: Text(vendorList[i]['contact_persons_name']??"")
                                                        // child: Text("name")
                                                      ),
                                                    ))
                                            ),
                                            Expanded(
                                                child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 8),
                                                      child: SizedBox(height: 28,
                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                          child: Text(vendorList[i]['vendor_email']??"")
                                                        // child: Text("email")
                                                      ),
                                                    ))),
                                            Expanded(
                                                child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 8),
                                                      child: SizedBox(height: 28,
                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                          child: Text(vendorList[i]['vendor_mobile_phone']??"")
                                                        // child: Text("mobile")
                                                      ),
                                                    ))),
                                            Expanded(
                                                child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 8),
                                                      child: SizedBox(height: 28,
                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                          child: Text(" ${vendorList[i]['payto_city']??""}")
                                                        // child: Text("City"),
                                                      ),
                                                    ))),
                                            const Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 8,),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Icon(size: 18,CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4,),
                                ],
                              ),
                          ],
                        ),
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
