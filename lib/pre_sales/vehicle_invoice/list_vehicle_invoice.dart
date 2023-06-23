import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:new_project/pre_sales/vehicle_invoice/view_vehicle_invoice.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'add_new_vehicle_invoice.dart';

class ListVehicleInvoice extends StatefulWidget {
  final ListVehicleInvoiceArguments arg;
  const ListVehicleInvoice({Key? key, required this.arg}) : super(key: key);

  @override
  State<ListVehicleInvoice> createState() => _ListVehicleInvoiceState();
}

class _ListVehicleInvoiceState extends State<ListVehicleInvoice> {
  bool loading = false;
  List vehicleInList = [];

  Future fetchInvoiceData()async{
    dynamic response;
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicleinvoice/get_all_invoice";
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vehicleInList = value;
            // print('----------fetch invoice getAll API-------');
            //  print(vehicleInList['vehi_invoice_id']);
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        loading=false;
      });
    }
  }
  @override
  void initState(){
    super.initState();
    fetchInvoiceData();
    loading = true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(
        children: [
          CustomDrawer(widget.arg.drawerWidth, widget.arg.selectedDestination),
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
                    padding: const EdgeInsets.only(left: 50.0,right: 50,top: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            const Text("All Vehicles",style: TextStyle(color: Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),
                            MaterialButton(onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewVehicleInvoice(
                              //     drawerWidth: widget.args.drawerWidth,
                              //     selectedDestination: widget.args.selectedDestination)
                              // )).then((value) => fetchInvoiceData());
                              Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                  const AddNewVehicleInvoice(
                                    drawerWidth: 190,
                                    selectedDestination: 2.3,),
                              transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero
                              ));
                            },color: Colors.blue,
                              child: const Text("+ New",style: TextStyle(color: Colors.white)),)
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Container(
                            height: 40,
                            color: Colors.grey[200],
                            child:
                            const Row(
                              children: [
                                Expanded(child: Center(child: Text("VEHICLE INVOICE ID"))),
                                Expanded(child: Center(child: Text("VENDOR NAME"))),
                                Expanded(child: Center(child: Text("VEHICLE NAME"))),
                                Expanded(child: Center(child: Text("PURCHASE ORDER NUMBER"))),
                                Expanded(child: Center(child: Text("TOTAL AMOUNT"))),
                                // Expanded(child: Center(child: Text("TOTAL"))),
                                Center(child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                  color: Colors.transparent,
                                ),)
                              ],
                            )
                        ),
                        const SizedBox(height: 10,),
                        for(int i=0; i<vehicleInList.length; i++)
                          Column(
                            children: [
                              Card(
                                child: Material(color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    splashColor: const Color(0xFFA2BFEC),
                                    onTap: () {
                                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                          ViewVehicleInvoice(drawerWidth: 190,
                                          selectedDestination: 2.3,
                                          vehicleList:vehicleInList[i]),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero
                                      ));

                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Center(
                                              child: Padding(padding: const EdgeInsets.only(top: 8.0),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleInList[i]['vehi_invoice_id']??""),
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: Center(
                                              child: Padding(padding: const EdgeInsets.only(top: 8.0),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleInList[i]['vendor_name']??""),
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: Center(
                                              child: Padding(padding: const EdgeInsets.only(top: 8.0),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleInList[i]['vehicle_name']??""),
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: Center(
                                              child: Padding(padding: const EdgeInsets.only(top: 8.0),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleInList[i]['purchase_order_no']??""),
                                                ),
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: Center(
                                              child: Padding(padding: const EdgeInsets.only(top:8.0),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleInList[i]['total_amount'].toStringAsFixed(2)),
                                                ),
                                              ),
                                            )
                                        ),
                                        const Center(child: Padding(
                                          padding: EdgeInsets.only(right: 8.0),
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
