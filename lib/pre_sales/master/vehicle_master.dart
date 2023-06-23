import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:new_project/pre_sales/master/vehicle_master_details.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'add_new_vehicle.dart';

class VehicleMaster extends StatefulWidget {
  final VehicleMasterArguments arg;
  const VehicleMaster({Key? key, required this. arg}) : super(key: key);

  @override
  State<VehicleMaster> createState() => _VehicleMasterState();
}

class _VehicleMasterState extends State<VehicleMaster> {

  List vehicleList = [];
  bool loading = false;
  String? authToken;

  Future fetchVehicleData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/get_all_new_vehicle';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vehicleList = value;
            // print('---------- new get ----------');
            // print(vehicleList);
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    fetchVehicleData();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.arg.drawerWidth, widget.arg.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child:  CustomLoader(
              inAsyncCall: loading,
              child: SingleChildScrollView(
                child: Column(
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0,right: 50,top: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              const Text(
                                "All Vehicles",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //     context, MaterialPageRoute(builder: (context)=>AddNewVehicles(
                                  //   title: 2,
                                  //   drawerWidth:widget.args.drawerWidth ,
                                  //   selectedDestination: widget.args.selectedDestination,
                                  // )
                                  // )
                                  // ).then((value) => fetchVehicleData());
                                  Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                  const AddNewVehicles( drawerWidth: 190, selectedDestination: 3.1,),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero
                                  ));
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
                            child: const Row(
                              children:  [
                                Expanded(child: Center(child: Text("BRAND"))),
                                Expanded(child: Center(child: Text("NAME"))),
                                // Expanded(child: Center(child: Text("COLOR"))),
                                Expanded(child: Center(child: Text("FUEL TYPE"))),
                                Expanded(child: Center(child: Text("TRANSMISSION"))),

                                // Expanded(child: Center(child: Text(''),))
                                Center(child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                  color: Colors.transparent,
                                ),)
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          for(int i=0;i<vehicleList.length;i++)
                            Column(
                              children: [
                                Card(
                                  child: Material(
                                    color: Colors.transparent,

                                    child: InkWell(splashColor: const Color(0xFFA2BFEC),
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2) => VehicleMasterDetails(
                                            title: 1, drawerWidth: 190, selectedDestination: 3.1, vehicleList: vehicleList[i]),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero
                                        ));
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 8),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleList[i]['brand']),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 8),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleList[i]['name']),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Expanded(
                                          //   child: Center(
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.all(8.0),
                                          //       child: SizedBox(
                                          //         height: 30,
                                          //         child:  SingleChildScrollView(
                                          //           scrollDirection: Axis.horizontal,
                                          //           child: Row(
                                          //             children: [
                                          //               Text(vehicleList[i]['color1']
                                          //                   +' '+ vehicleList[i]['color2']
                                          //                   +' '+ vehicleList[i]['color3']
                                          //                   +' '+ vehicleList[i]['color4']
                                          //                   +' '+ vehicleList[i]['color5']
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 8),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleList[i]['engine_1']),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 8),
                                                child: SizedBox(
                                                  height: 28,
                                                  child: Text(vehicleList[i]['transmission_1']),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Center(child: Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                              color: Colors.blue,
                                              size: 18,
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
                    )
                  ],
                ),
              ),
            ),),
        ],
      ),
    );
  }
}
