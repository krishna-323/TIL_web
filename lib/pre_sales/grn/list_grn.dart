import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'display_grn_details.dart';
import 'display_vehicle_po.dart';

class ListGrnItems extends StatefulWidget {
  final   ListGrnArguments  arg;
  const ListGrnItems({Key? key, required this. arg}) : super(key: key);

  @override
  State<ListGrnItems> createState() => _ListGrnItemsState();
}

class _ListGrnItemsState extends State<ListGrnItems> {

  List grnList =[];
  bool loading = false;


  Future fetchPurchaseData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclegrn/get_all_newvehigrn';
    try {
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            grnList = value;
            // print('-------GrnList-------');
            // print(grnList);
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    fetchPurchaseData();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body:
      Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.arg.drawerWidth,widget.arg.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: CustomLoader(
              inAsyncCall: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50,right: 50.0,top: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            const Text("All Items",style: TextStyle(color: Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),

                            MaterialButton(
                              onPressed: () {

                                Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>const ViewGrn(
                                  drawerWidth: 190,
                                  selectedDestination: 2.2,),
                                transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero
                                )).then((value) => fetchPurchaseData());
                              },color: Colors.blue,
                              child: const Text(
                                  "+ New",
                                  style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Container(
                            height: 40,
                            color: Colors.grey[200],
                            child:
                            Row(
                              children:  [
                                const Expanded(child: Center(child: Text('VEHICLE ID'),)),
                                const Expanded(child: Center(child: Text('VEHICLE NAME'))),
                                const Expanded(child: Center(child: Text("PURCHASE ORDER"))),
                                const Expanded(child: Center(child: Text("VENDOR NAME"))),
                                const Expanded(child: Center(child: Text("TOTAL"))),
                                const Expanded(child: Center(child: Text("STATUS"))),
                                const Center(child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                  color: Colors.transparent,
                                ),),
                                Container(width: 15,),
                              ],
                            )
                        ),
                        // Align(alignment: Alignment.centerLeft,child: Text("OCT 11, Monday",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900],fontSize: 14),)),
                        // SizedBox(height: 10,),
                        const SizedBox(height: 10,),

                        for(int i=0;i<grnList.length;i++)
                        // if(grnList[i]['grn_status']=='Yes')
                          Column(
                            children: [
                              Card(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    splashColor: const Color(0xFFA2BFEC),
                                    onTap: (){
                                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                          DisplayGrnDetails(drawerWidth:190,
                                            selectedDestination:2.2,
                                            purchaseOrderMapDetails: grnList[i],),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero
                                      ));
                                    },
                                    child: Row(
                                      children: [
                                        //Vehicle ID.
                                        Expanded(child: Center(child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(height: 28,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(grnList[i]['newvehi_grn_id'])
                                          ),
                                        ))),
                                        //Vehicle Name.
                                        Expanded(child: Center(child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(height: 28,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text(grnList[i]['vehicle_name']??""),
                                          ),
                                        ))),
                                        //Purchase Order Id.
                                        Expanded(child: Center(child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(height: 28,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(grnList[i]['purchase_order_number']??"")
                                          ),
                                        ))),
                                        //Vehicle Name
                                        Expanded(child: Center(child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(height: 28,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(grnList[i]['vendor_name']??"")
                                          ),
                                        ))),
                                        Expanded(child: Center(child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(height: 28,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text(double.parse(grnList[i]['amount'].toString()).toStringAsFixed(2)),
                                          ),
                                        ))),
                                        grnList[i]['status'] == "Invoiced" ?
                                        Expanded(child: Center(child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                            height: 28,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child:
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                    color: grnList[i]['status'] == "Invoiced" ? Colors.green : Colors.blue,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5,right: 5),
                                                    child: Text(grnList[i]['status'].toString(),style: const TextStyle(color: Colors.white)),
                                                  )
                                              ),
                                            ),
                                          ),
                                        ))):
                                        const Expanded(child: Center(child: Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child:
                                          SizedBox(height: 28,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text('--')
                                          ),
                                        ))),
                                        const Center(child: Padding(
                                          padding: EdgeInsets.all( 8.0),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
