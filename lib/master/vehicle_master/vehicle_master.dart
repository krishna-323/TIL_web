import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:new_project/master/vehicle_master/vehicle_master_details.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';

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
  List displayVehicleList =[];
  int startVal=0;
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
            if(displayVehicleList.isEmpty){
              if(vehicleList.length>5){
                for(int i=startVal;i<startVal + 15;i++){
                  displayVehicleList.add(vehicleList[i]);
                }
              }

            }
            else{
              for(int i=startVal;i<vehicleList.length;i++){
                displayVehicleList.add(vehicleList[i]);
              }
            }
            // print('---------- new get ----------');
            // print(vehicleList);
          }
          loading = false;
        });
      });
    }
    catch (e) {
      //logOutApi(context: context, exception: e.toString(),response: response);
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
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  child: Column(
                    children:  [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40,top: 10,bottom: 10),

                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE0E0E0),)

                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                                ),
                                child: Column(children: [
                                  const SizedBox(height: 18,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0,right: 18),
                                    child: Row(
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
                                  ),
                                  const SizedBox(height: 18,),
                                  Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                  Container(color: Colors.grey[100],height: 32,
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
                                                        child: Text("BRAND")
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4),
                                                    child: SizedBox(
                                                        height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text('NAME')
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text("FUEL TYPE")
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text("TRANSMISSION")
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
                              const SizedBox(height: 4,),
                              for(int i=startVal;i<=displayVehicleList.length;i++)
                                Column(
                                  children: [
                                    if(i!=displayVehicleList.length)
                                    MaterialButton(
                                      hoverColor: mHoverColor,

                                      onPressed: () {
                                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2) => VehicleMasterDetails(
                                          title: 1, drawerWidth: 190, selectedDestination: 3.1, vehicleList: vehicleList[i]),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero
                                      )); },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:18.0,top: 4,bottom: 3),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child:Text(displayVehicleList[i]['brand']??""),
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayVehicleList[i]['name']??""),
                                                  ),
                                                )),
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
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayVehicleList[i]['engine_1']??""),
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayVehicleList[i]['transmission_1']??''),
                                                  ),
                                                )),

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
                                    if(i!=displayVehicleList.length)
                                      Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                    if(i==displayVehicleList.length)
                                      Row(mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          Text("${startVal+15>vehicleList.length?vehicleList.length:startVal+1}-${startVal+15>vehicleList.length?vehicleList.length:startVal+15} of ${vehicleList.length}",style: const TextStyle(color: Colors.grey)),
                                          const SizedBox(width: 10,),
                                          Material(color: Colors.transparent,
                                            child: InkWell(
                                              hoverColor: mHoverColor,
                                              child: const Padding(
                                                padding: EdgeInsets.all(18.0),
                                                child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                              ),
                                              onTap: (){
                                                if(startVal>14){
                                                  displayVehicleList=[];
                                                  startVal = startVal-15;
                                                  for(int i=startVal;i<startVal+15;i++){
                                                    try{
                                                      setState(() {
                                                        displayVehicleList.add(vehicleList[i]);
                                                      });
                                                    }
                                                    catch(e){
                                                      log(e.toString());
                                                    }
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
                                                if(vehicleList.length>startVal+15){
                                                  displayVehicleList=[];
                                                  startVal=startVal+15;
                                                  for(int i=startVal;i<startVal+15;i++){
                                                    try{
                                                      setState(() {
                                                        displayVehicleList.add(vehicleList[i]);
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
                                          const SizedBox(width: 20,),

                                        ],
                                      )
                                  ],
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),),
        ],
      ),
    );
  }
}
