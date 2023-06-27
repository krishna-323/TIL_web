import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../widgets/input_decoration_text_field.dart';
import 'add_variant_model.dart';
import 'bloc/vehicle_details_bloc.dart';
import 'model/vehicle_details_model.dart';

class VehicleMasterDetails extends StatefulWidget {
  final int title;
  final double drawerWidth;
  final double selectedDestination;
  final Map vehicleList;
  const VehicleMasterDetails(
      {
        Key? key,
        required this.title,
        required this.drawerWidth,
        required this.selectedDestination,
        required this.vehicleList
      }
      ) : super(key: key);

  @override
  State<VehicleMasterDetails> createState() => _VehicleMasterDetailsState();
}

class _VehicleMasterDetailsState extends State<VehicleMasterDetails>with SingleTickerProviderStateMixin  {





  List variantList=[];
  List inventoryList = [];


  Future fetchVariantData(String vehicleId) async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/get_all_by_vehicle_id/$selectedId';
    // print( 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclevarient/get_varients_by_vehicle_id/$selectedId');
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            variantList = value;
            // print('----------variant list-----------');
            // print(variantList);
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString,response: response);
      setState(() {
        loading = false;
      });
    }
  }




  String selectedId = "";
  late int selectedIndex;
  String? authToken;

  late TabController _tabController;
  int _tabIndex = 0;
  final List<Widget> myTabs = const [
    Tab(text: 'Overview',),
    Tab(text: 'History'),
  ];
  _handleTabSelection(){
    if(_tabController.indexIsChanging){
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    loading=true;
    getInitialData().whenComplete(() {
      _tabController = TabController(length: myTabs.length, vsync: this);
      _tabController.addListener(_handleTabSelection);
      selectedId = widget.vehicleList['new_vehicle_id'];
      // vehicleId = widget.vehicleList['new_vehicle_id'];
      vehicleDetailsBloc.fetchVehicleNetwork(widget.vehicleList['new_vehicle_id']);
      fetchVehicleData().whenComplete(() {
        fetchVariantData(selectedId);
      });
    });
  }

  Future getInitialData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }
  String vehicleId='';
  late dynamic brand;
  List viewVehicleList = [];
  bool loading = false;
  String trans = "";
  String color = "";
  String engine = "";

  Future fetchVehicleData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/get_all_new_vehicle';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            viewVehicleList = value;
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  deleteVehicles() async{
    final deleteVehicleValue = await http.delete(
      Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/delete_new_vehicle_by_id/$selectedId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if(deleteVehicleValue.statusCode == 200){
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data Deleted'),)
        );
        fetchVehicleData();
        vehicleDetailsBloc.fetchVehicleNetwork(selectedId);
        Navigator.of(context).pop();
      });
    }
    else{
      setState(() {
        print(deleteVehicleValue.statusCode.toString());
      });
    }
  }

  final ScrollController controller = ScrollController();

  var size, width, height;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
              child: Scaffold(

                body: CustomLoader(
                  inAsyncCall: loading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //--------- left side table----------
                      Expanded(
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(color: Colors.grey[200],
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("All Vehicles"),
                                            Row(
                                              children: [
                                                SizedBox(width: 60,child: MaterialButton(onPressed: (){
                                                  // Navigator.push(context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context)=>AddNewVehicles(
                                                  //           title: 1,
                                                  //           drawerWidth: widget.drawerWidth,
                                                  //           selectedDestination: widget.selectedDestination,
                                                  //         )
                                                  //     )
                                                  // ).then((value) => fetchVehicleData());
                                                },child: const Text("+ New",style: TextStyle(color: Colors.white)),color: Colors.blue,))
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: viewVehicleList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color:  selectedId == viewVehicleList[index]["new_vehicle_id"]? Colors.grey[100]:Colors.white,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8.0, top: 10, bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          viewVehicleList[index]['brand'],
                                                          style: TextStyle(
                                                              color: Colors.blue[800]
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {


                                                  setState(() {
                                                    selectedId = viewVehicleList[index]["new_vehicle_id"];
                                                    fetchVariantData(selectedId);
                                                    vehicleId =viewVehicleList[index]["new_vehicle_id"];
                                                    selectedIndex = index;
                                                    vehicleDetailsBloc.fetchVehicleNetwork(viewVehicleList[index]['new_vehicle_id']);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                      ),
                      const VerticalDivider(width: 1),
                      // ----------tab bar----------
                      StreamBuilder(
                        stream: vehicleDetailsBloc.getVehicleDetails,
                        builder: (context, AsyncSnapshot<VehicleModel> snapshot) {
                          if(snapshot.hasData){
                            trans = "";
                            color = "";
                            engine = "";
                            vehicleId=snapshot.data!.vehicleDocketData[0].vehicleData['new_vehicle_id'];
                            brand = snapshot.data!.vehicleDocketData[0].vehicleData['brand'];

                            List<String> _color = [];
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['color1']!='') {
                              _color.add(snapshot.data!.vehicleDocketData[0].vehicleData['color1']);
                              color = color + snapshot.data!.vehicleDocketData[0].vehicleData['color1'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['color2']!='') {
                              _color.add(snapshot.data!.vehicleDocketData[0].vehicleData['color2']);
                              color = color + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['color2'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['color3']!='') {
                              _color.add(snapshot.data!.vehicleDocketData[0].vehicleData['color3']);
                              color = color + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['color3'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['color4']!='') {
                              _color.add(snapshot.data!.vehicleDocketData[0].vehicleData['color4']);
                              color = color + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['color4'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['color5']!='') {
                              _color.add(snapshot.data!.vehicleDocketData[0].vehicleData['color5']);
                              color = color + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['color5'];
                            }

                            List<String> transmissionList = [];
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['transmission_1']!='--Select--') {
                              transmissionList.add(snapshot.data!.vehicleDocketData[0].vehicleData['transmission_1']);
                              trans = trans + snapshot.data!.vehicleDocketData[0].vehicleData['transmission_1'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['transmission_2']!='--Select--') {
                              transmissionList.add(snapshot.data!.vehicleDocketData[0].vehicleData['transmission_2']);
                              trans = trans + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['transmission_2'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['transmission_3']!='--Select--') {
                              transmissionList.add(snapshot.data!.vehicleDocketData[0].vehicleData['transmission_3']);
                              trans = trans +", " + snapshot.data!.vehicleDocketData[0].vehicleData['transmission_3'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['transmission_4']!='--Select--') {
                              transmissionList.add(snapshot.data!.vehicleDocketData[0].vehicleData['transmission_4']);
                              trans = trans + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['transmission_4'];
                            }

                            if(snapshot.data!.vehicleDocketData[0].vehicleData['engine_1']!='--Select--'){
                              engine = engine + snapshot.data!.vehicleDocketData[0].vehicleData['engine_1'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['engine_2']!='--Select--'){
                              engine = engine + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['engine_2'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['engine_3']!='--Select--'){
                              engine = engine + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['engine_3'];
                            }
                            if(snapshot.data!.vehicleDocketData[0].vehicleData['engine_4']!='--Select--'){
                              engine = engine + ", " + snapshot.data!.vehicleDocketData[0].vehicleData['engine_4'];
                            }
                            // print('---------from view vendors---------');
                            return Expanded(
                                flex: 2,
                                child: DefaultTabController(
                                    length: 2,
                                    child: Scaffold(
                                      body: RawScrollbar(
                                        thumbColor: Colors.black45,
                                        radius: const Radius.circular(5.0),
                                        thumbVisibility: true,
                                        thickness: 10.0,
                                        child: SingleChildScrollView(
                                         // physics: const ScrollPhysics(),
                                           primary: true,
                                         //controller: ScrollController(),
                                          child: Column(
                                            children:  [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: SizedBox(
                                                  width: 400,
                                                  child: TabBar(
                                                    indicatorColor: Colors.blue,
                                                    labelColor: Colors.black,
                                                    unselectedLabelColor: Colors.lightBlue,
                                                    tabs: myTabs,
                                                    controller: _tabController,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: [
                                                  //------- overView --------
                                                  Column(
                                                    children: [
                                                      const SizedBox(height: 20,),
                                                      //-------------- top 3 containers -------------
                                                      // Row(
                                                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      //   children: [
                                                      //     Container(
                                                      //       height: 100,
                                                      //       width: 100,
                                                      //       decoration: BoxDecoration(
                                                      //         borderRadius: BorderRadius.circular(5.0),
                                                      //         color: Colors.blueGrey[50],
                                                      //         boxShadow: const [
                                                      //           BoxShadow(
                                                      //               color: Colors.grey,
                                                      //               blurRadius: 5,
                                                      //               blurStyle: BlurStyle.outer
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //       child: Column(
                                                      //         crossAxisAlignment: CrossAxisAlignment.center,
                                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                                      //         children: const [
                                                      //           Text('80',
                                                      //             style: TextStyle(
                                                      //               fontSize: 30,
                                                      //               fontWeight: FontWeight.bold,
                                                      //             ),
                                                      //           ),
                                                      //           Text('In Stock',
                                                      //             style: TextStyle(
                                                      //               fontWeight: FontWeight.bold,
                                                      //             ),
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //     Container(
                                                      //       height: 100,
                                                      //       width: 100,
                                                      //       decoration: BoxDecoration(
                                                      //         borderRadius: BorderRadius.circular(5.0),
                                                      //         color: Colors.blueGrey[50],
                                                      //         boxShadow: const [
                                                      //           BoxShadow(
                                                      //               color: Colors.grey,
                                                      //               blurRadius: 5,
                                                      //               blurStyle: BlurStyle.outer
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //       child: Column(
                                                      //         crossAxisAlignment: CrossAxisAlignment.center,
                                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                                      //         children: const [
                                                      //           Text('1254',
                                                      //             style: TextStyle(
                                                      //               color: Colors.blueAccent,
                                                      //               fontSize: 30,
                                                      //               fontWeight: FontWeight.bold,
                                                      //             ),
                                                      //           ),
                                                      //           Text('Sold',
                                                      //             style: TextStyle(
                                                      //               fontWeight: FontWeight.bold,
                                                      //             ),
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //     Container(
                                                      //       height: 100,
                                                      //       width: 100,
                                                      //       decoration: BoxDecoration(
                                                      //         borderRadius: BorderRadius.circular(5.0),
                                                      //         color: Colors.blueGrey[50],
                                                      //         boxShadow: const [
                                                      //           BoxShadow(
                                                      //               color: Colors.grey,
                                                      //               blurRadius: 5,
                                                      //               blurStyle: BlurStyle.outer
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //       child: Column(
                                                      //         crossAxisAlignment: CrossAxisAlignment.center,
                                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                                      //         children: const [
                                                      //           Text('10',
                                                      //             style: TextStyle(
                                                      //               color: Colors.red,
                                                      //               fontSize: 30,
                                                      //               fontWeight: FontWeight.bold,
                                                      //             ),
                                                      //           ),
                                                      //           Text('Minimum',
                                                      //             style: TextStyle(
                                                      //               fontWeight: FontWeight.bold,
                                                      //             ),
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      const SizedBox(height: 20,),
                                                      //------card-------------
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 10, right: 30, bottom: 10, left: 30),
                                                        child: Card(
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                              color: Colors.white,
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                    color: Colors.grey,
                                                                    blurRadius: 5,
                                                                    blurStyle: BlurStyle.outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: const [
                                                                      Text('Vehicle Details',
                                                                        style: TextStyle(
                                                                          color: Colors.blue,
                                                                          fontSize: 18,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                        width: 150,
                                                                        child: Text(
                                                                          'Name ',
                                                                          style:
                                                                          TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(snapshot.data!.vehicleDocketData[0].vehicleData['name'],style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                        width: 150,
                                                                        child: Text(
                                                                          'Brand ',
                                                                          style:
                                                                          TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Text(snapshot.data!.vehicleDocketData[0].vehicleData['brand'],style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      const SizedBox(
                                                                        width: 150,
                                                                        child: Text(
                                                                          'Color ',
                                                                          style:
                                                                          TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(color,style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      const SizedBox(
                                                                        width: 150,
                                                                        child: Text(
                                                                          'Engine ',
                                                                          style:
                                                                          TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Expanded(child: Text(engine, style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1)))),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      const SizedBox(
                                                                        width: 150,
                                                                        child: Text(
                                                                          'Transmission ',
                                                                          style:
                                                                          TextStyle(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Expanded(child: Text(trans,style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1)))),

                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      MaterialButton(onPressed: () {
                                                                        // Navigator.push(context,
                                                                        //     MaterialPageRoute(
                                                                        //       builder: (context) => EditVehicleMaster(drawerWidth: widget.drawerWidth,selectedDestination: widget.selectedDestination,vehicleData: snapshot.data!.vehicleDocketData[0].vehicleData),
                                                                        //     )
                                                                        // ).then((value){
                                                                        //   vehicleDetailsBloc.fetchVehicleNetwork(selectedId);
                                                                        //   fetchVehicleData();
                                                                        // });
                                                                      },
                                                                        color: Colors.blue,
                                                                        child: Row(
                                                                          children: const [
                                                                            Icon(Icons.edit,color: Colors.white,),
                                                                            Text('Edit',style: TextStyle(color: Colors.white)),
                                                                          ],
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
                                                      const SizedBox(height: 30,),
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 35,right: 35),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children:  [
                                                                  const Text(
                                                                    'Vehicle Variant',
                                                                    style: TextStyle(fontSize: 16),
                                                                  ),
                                                                  MaterialButton(onPressed: () {
                                                                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                                    AddVariantModel(
                                                                      drawerWidth: widget.drawerWidth,
                                                                        selectedDestination: widget.selectedDestination,
                                                                        id: snapshot.data!.vehicleDocketData[0].vehicleData['new_vehicle_id'],
                                                                        color: _color,
                                                                        make: brand,
                                                                        transmissionList: transmissionList,),
                                                                    ));
                                                                  },
                                                                    color: Colors.blue,
                                                                    child: const Text('Add',style: TextStyle(color: Colors.white)),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(height: 20,),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 30, right: 30),
                                                              child: SizedBox(
                                                                child:  getVariant(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //  ------- History -------
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 80,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  color: Colors.blueGrey,
                                                                  blurRadius: 5.0,
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey[200],
                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5))
                                                                ),
                                                                child: Row(
                                                                  children:  const [
                                                                    Expanded(child: Center(child: Text("GRN Number",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("GRN Date",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Order QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Received QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Total",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text(''),))
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration: const BoxDecoration(
                                                                    color: Colors.white70,
                                                                    borderRadius: BorderRadius.only(
                                                                      bottomLeft: Radius.circular(5),
                                                                      bottomRight: Radius.circular(5),
                                                                    )
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children:  const [
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('12345'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('28/10/2022'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('4'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('4'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('0'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Align(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: Icon(CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,)
                                                                                ),
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
                                                        const SizedBox(height: 20,),
                                                        Container(
                                                          height: 80,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  color: Colors.blueGrey,
                                                                  blurRadius: 5.0,
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey[200],
                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5))
                                                                ),
                                                                child: Row(
                                                                  children:  const [
                                                                    Expanded(child: Center(child: Text("PO Number",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("PO Date",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Order QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Pending QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Delivery Date",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Order Value",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text(''),))
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration: const BoxDecoration(
                                                                    color: Colors.white70,
                                                                    borderRadius: BorderRadius.only(
                                                                      bottomLeft: Radius.circular(5),
                                                                      bottomRight: Radius.circular(5),
                                                                    )
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children:  const [
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('12345'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('28/10/2022'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('4'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('4'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('28/10/2022'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('0'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Align(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: Icon(CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,)
                                                                                ),
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
                                                        const SizedBox(height: 20,),
                                                        Container(
                                                          height: 80,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  color: Colors.blueGrey,
                                                                  blurRadius: 5.0,
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey[200],
                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5))
                                                                ),
                                                                child: Row(
                                                                  children:  const [
                                                                    Expanded(child: Center(child: Text("Invoice Number",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Invoice Date",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    // Expanded(child: Center(child: Text("Customer Name",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text("Invoice Value",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                    Expanded(child: Center(child: Text(''),))
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration: const BoxDecoration(
                                                                    color: Colors.white70,
                                                                    borderRadius: BorderRadius.only(
                                                                      bottomLeft: Radius.circular(5),
                                                                      bottomRight: Radius.circular(5),
                                                                    )
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children:  const [
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('12345'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('28/10/2022'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('1'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Text('3'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.all(8.0),
                                                                              child: SizedBox(
                                                                                height: 20,
                                                                                child: Align(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: Icon(CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,)
                                                                                ),
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
                                                      ],
                                                    ),
                                                  ),
                                                ][_tabIndex],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                )
                            );
                          }
                          else{
                            print('----------SnapShot Error~~~~~~~~~~~~~');
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  getVariant() {
    return Column(
      children: [
        for(int i = 0; i < variantList.length; i++)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10,top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.blueGrey,
                          blurRadius: 5.0,
                          blurStyle: BlurStyle.outer
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5))
                        ),
                        child: Row(
                          children:    const [
                            Expanded(child: Center(child: Text("Variant",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                            Expanded(child: Center(child: Text("On-Road Price",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                            Expanded(child: Center(child: Text("Color",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                            Expanded(child: Center(child: Text("Model Name",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                            Expanded(child: Center(child: Text("Model Code",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                            Expanded(child: Center(child: Text(""),)),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            )
                        ),
                        child: Row(
                          children:   [
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 20,
                                    child: Text(variantList[i]['varient_name']),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 20,
                                    child: Text(variantList[i]['onroad_price'].toString()),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 20,
                                    child: Text(variantList[i]['varient_color1']),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 20,
                                    child: Text(variantList[i]['model_name']),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 20,
                                    child: Text(variantList[i]['model_code']),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 20,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return  Dialog(
                                              backgroundColor: Colors.transparent,
                                              child: SizedBox(
                                                width: 350,
                                                height: 250,
                                                child: Stack(children: [
                                                  Container(
                                                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Column(
                                                        children: [
                                                          const Text('Vehicle Variant',style: TextStyle(color: Colors.indigo,fontSize: 16,fontWeight: FontWeight.bold),),
                                                          const SizedBox(height: 10,),
                                                          Expanded(
                                                            child: ListView(
                                                              shrinkWrap: true,
                                                              padding: const EdgeInsets.all(10.0),
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width: 200,
                                                                          child: Text("TYPE",style: TextStyle(color: Colors.black,fontSize: 12)),
                                                                        ),
                                                                        Text(variantList[i]['type'],style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1),fontSize: 16)),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width: 200,
                                                                          child: Text("MODEL CODE",style: TextStyle(color: Colors.black,fontSize: 12)),
                                                                        ),
                                                                        Text(variantList[i]['model_code'],style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1),fontSize: 16)),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width: 200,
                                                                          child: Text("LABOUR TYPE",style: TextStyle(color: Colors.black,fontSize: 12)),
                                                                        ),
                                                                        Text(variantList[i]['labour_type'],style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1),fontSize: 16)),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width: 200,
                                                                          child: Text("VEHICLE CATEGORY CODE",style: TextStyle(color: Colors.black,fontSize: 12)),
                                                                        ),
                                                                        Text(variantList[i]['vehicle_category_code'],style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1),fontSize: 16)),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width: 200,
                                                                          child: Text("MARKET SEGMENT CODE",style: TextStyle(color: Colors.black,fontSize: 12)),
                                                                        ),
                                                                        Text(variantList[i]['market_segment_code'],style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1),fontSize: 16)),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const SizedBox(
                                                                          width: 200,
                                                                          child: Text("VEHICLE TYPE CODE",style: TextStyle(color: Colors.black,fontSize: 12)),
                                                                        ),
                                                                        Text(variantList[i]['vehicle_type_code'],style: const TextStyle(color: Color.fromRGBO(119, 119, 119, 1),fontSize: 16)),
                                                                      ],
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
                                                  Positioned(right: 0.0,

                                                    child: InkWell(
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15),
                                                              border: Border.all(
                                                                color:
                                                                const Color.fromRGBO(204, 204, 204, 1),
                                                              ),
                                                              color: Colors.blue),
                                                          child: const Icon(
                                                            Icons.close_sharp,
                                                            color: Colors.white,
                                                          )),
                                                      onTap: () {
                                                        setState(() {
                                                          Navigator.of(context).pop();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],

                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
      ],
    );
  }

  getInventory(){
    return Column(
      children: [
        for(int i = 0; i < inventoryList.length; i++)
          Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text('Item Code : ',style: TextStyle(color: Colors.black45)),
                                // Text(variantList[i]['model_name']),
                              ],
                            ),
                            Row(
                              children: const [
                                Text('Name : ',style: TextStyle(color: Colors.black45)),
                                // Text(variantList[i]['varient']),
                              ],
                            ),
                            Row(
                              children: const [
                                Text('Manufacturer : ',style: TextStyle(color: Colors.black45)),
                                // Text(variantList[i]['ex_showroom_price'].toString()),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text('Description : ',style: TextStyle(color: Colors.black45)),
                                // Text(variantList[i]['insurence'].toString()),
                              ],
                            ),
                            Row(
                              children: const [
                                Text('Cost Per Item : ',style: TextStyle(color: Colors.black45)),
                                // Text(variantList[i]['extended_warranty'].toString()),
                              ],
                            ),
                            Row(
                              children: const [
                                Text('Stock Quantity : ',style: TextStyle(color: Colors.black45)),
                                // Text(variantList[i]['fast_tag'].toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
      ],
    );
  }

  deleteVariant(selectedId) async{
    try{
      final response = await http.delete(
        Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclevarient/delete_new_veh_varient_by_id/$selectedId'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken'
        },
      );
      if(response.statusCode == 200){
        setState(() {
          // print('-----------variant delete --------');
          // print(selectedId);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Data Deleted')
              )
          );

          // vehicleDetailsBloc.fetchVehicleNetwork(selectedId);
          // Navigator.of(context).pop();
        });
      }
      else{
        setState(() {
          print(response.statusCode.toString());
        });
      }
    }
    catch(e){
      print(e.toString());
      print(e);
    }
  }
}

//--------------Variant------------

showConfirmationDialog(BuildContext context, List _color,String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(color: _color,id: id,);
    },);
}

class CustomDialog extends StatefulWidget {
  final List color;
  final String id;
  const CustomDialog({Key? key, required this.color,required this.id}) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  @override
  void initState() {
    super.initState();
    // print(widget.color);
  }
  final _popForm = GlobalKey<FormState>();

  var modelNameController = TextEditingController();
  var variantController = TextEditingController();
  var exShowRoomController = TextEditingController();
  var rtoController = TextEditingController();
  var insuranceController = TextEditingController();
  var extendWarrantyController = TextEditingController();
  var fastTagController = TextEditingController();
  var accessoryController = TextEditingController();
  var onRoadController = TextEditingController();
  var colorController = TextEditingController();
  var colorController2 = TextEditingController();
  var colorController3 = TextEditingController();
  var colorController4 = TextEditingController();
  var colorController5 = TextEditingController();
  var engineController = TextEditingController();
  var transmissionController = TextEditingController();
  var makeController = TextEditingController();
  var modelCodeController = TextEditingController();

  bool modelCodeError = false;
  bool makeError = false;
  bool modelError = false;
  bool variantError = false;
  bool exShowRoomError = false;
  bool rtoError = false;
  bool insuranceError = false;
  bool extendWarrantyError = false;
  bool fastTagError = false;
  bool accessoryError = false;
  bool onRoadError = false;
  bool colorError = false;
  bool colorError2 = false;
  bool colorError3 = false;
  bool colorError4 = false;
  bool colorError5 = false;
  bool engineError = false;
  bool transError = false;
  bool engineError1 = false;
  bool transmissionError1 = false;

  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;
  bool value5 = false;

  var engine = "--Select--";

  var trans = "--Select--";


  void engineDisplay(String? ed){
    setState(() {
      engine = ed!;
    });
  }
  void transDisplay(String? td){
    setState(() {
      trans = td!;
    });
  }

  String? authToken;



  Future addVehicleVariant(Map<dynamic,dynamic> vehicleVariant) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");

    try{
      final response = await http.post(
          Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclevarient/add_new_veh_varient'),
          // Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/model_varient/add_mod_mast_veh_varient'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(vehicleVariant)
      );
      if(response.statusCode == 200){

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Saved')));
        // print('------------vahicle data-----------');
        // print(response.body);
        Navigator.of(context).pop();
      }
      else{
        print('------vehicle variant post------');
        print(response.statusCode.toString());
      }
    }
    catch(e){
      print(e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          const Text('Add Vehicle Variant'),
          InkWell(
            child: const Icon(Icons.close_sharp,color: Colors.red),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Form(
                key: _popForm,
                child: RawScrollbar(
                  thumbColor: Colors.black45,
                  radius: const Radius.circular(5.0),
                  thumbVisibility: true,
                  thickness: 10.0,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10.0),
                    children: [
                      //-----make------
                      Row(
                        children:   [
                          const SizedBox(
                            width: 180,
                            child: Text('Make'),
                          ),
                          SizedBox(
                            width: 300,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 0),
                              height: makeError ? 55 : 30,
                              child: TextFormField(
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    setState(() {
                                      makeError = true;
                                    });
                                    return "Required";
                                  }
                                  else{
                                    setState(() {
                                      makeError = false;
                                    });
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 14),
                                controller: makeController,
                                decoration: decorationInput5('', makeController.text.isNotEmpty),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      //-------model code --------
                      Row(
                        children:   [
                          const SizedBox(
                            width: 180,
                            child: Text('Model Code'),
                          ),
                          SizedBox(
                            width: 300,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 0),
                              height: modelCodeError ? 55 : 30,
                              child: TextFormField(
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    setState(() {
                                      modelCodeError = true;
                                    });
                                    return "Required";
                                  }
                                  else{
                                    setState(() {
                                      modelCodeError = false;
                                    });
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 14),
                                controller: modelCodeController,
                                decoration: decorationInput5('Enter Model Code', modelCodeController.text.isNotEmpty),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      //------- model name----------
                      Row(
                        children:   [
                          const SizedBox(
                            width: 180,
                            child: Text('Model Name'),
                          ),
                          SizedBox(
                            width: 300,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 0),
                              height: modelError ? 55 : 30,
                              child: TextFormField(
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    setState(() {
                                      modelError = true;
                                    });
                                    return "Required";
                                  }
                                  else{
                                    setState(() {
                                      modelError = false;
                                    });
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 14),
                                controller: modelNameController,
                                decoration: decorationInput5('Enter Model Name', modelNameController.text.isNotEmpty),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      // --------color --------
                      Row(
                        children: [
                          const SizedBox(
                            width: 180,
                            child: Text('Color'),
                          ),
                          Checkbox(
                            value: value1,
                            onChanged: (value) {
                              setState(() {
                                value1 = value!;
                                value2 = false;
                                value3 = false;
                                value4 = false;
                                value5 = false;
                              });
                            },
                          ),
                          Text(widget.color[0]),
                          const SizedBox(width: 10,),
                          if(widget.color.length>1)
                            Row(
                              children: [
                                Checkbox(
                                  value: value2,
                                  onChanged: (value) {
                                    setState(() {
                                      value2 = value!;
                                      value1 = false;
                                      value3 = false;
                                      value4 = false;
                                      value5 = false;
                                    });
                                  },
                                ),
                                Text(widget.color[1]),
                              ],
                            ),
                          const SizedBox(width: 10,),
                          if(widget.color.length>2)
                            Row(
                              children: [
                                Checkbox(
                                  value: value3,
                                  onChanged: (value) {
                                    setState(() {
                                      value3 = value!;
                                      value1 = false;
                                      value2 = false;
                                      value4 = false;
                                      value5 = false;
                                    });
                                  },
                                ),
                                Text(widget.color[2]),
                              ],
                            ),
                          const SizedBox(width: 10,),
                          if(widget.color.length>3)
                            Row(
                              children: [
                                Checkbox(
                                  value: value4,
                                  onChanged: (value) {
                                    setState(() {
                                      value4 = value!;
                                      value1 = false;
                                      value2 = false;
                                      value3 = false;
                                      value5 = false;
                                    });
                                  },
                                ),
                                Text(widget.color[3]),
                              ],
                            ),
                          const SizedBox(width: 10,),
                          if(widget.color.length>4)
                            Row(
                              children: [
                                Checkbox(
                                  value: value5,
                                  onChanged: (value) {
                                    setState(() {
                                      value5 = value!;
                                      value1 = false;
                                      value2 = false;
                                      value3 = false;
                                      value4 = false;
                                    });
                                  },
                                ),
                                Text(widget.color[4]),
                              ],
                            ),
                          const SizedBox(width: 10,),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      //-----variant name------
                      Row(
                        children: [
                          const SizedBox(
                            width: 180,
                            child: Text('Variant Name'),
                          ),
                          SizedBox(
                            width: 300,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 0),
                              height: variantError ? 55:30,
                              child: TextFormField(
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    setState(() {
                                      variantError = true;
                                    });
                                    return 'Required';
                                  }
                                  else{
                                    setState(() {
                                      variantError = false;
                                    });
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 14),
                                controller: variantController,
                                decoration: decorationInput5('Enter Variant', variantController.text.isNotEmpty),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      //-----onRoadPrice------
                      Row(
                        children: [
                          const SizedBox(
                            width: 180,
                            child: Text('On-Road Price'),
                          ),
                          SizedBox(
                            width: 300,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 0),
                              height: variantError ? 55:30,
                              child: TextFormField(
                                maxLength: 40,
                                keyboardType:
                                TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly
                                ],
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    setState(() {
                                      onRoadError = true;
                                    });
                                    return 'Required';
                                  }
                                  else{
                                    setState(() {
                                      onRoadError = false;
                                    });
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 14),
                                controller: onRoadController,
                                decoration: decorationInput5('Enter Price', onRoadController.text.isNotEmpty),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  onPressed: () {
                    setState(() {
                    });
                    if(_popForm.currentState!.validate()){
                      setState(() {
                        if(value1 == true){
                          colorController.text= widget.color[0];
                        }else{
                          colorController.text='';
                        }
                        if(value2 == true){
                          colorController2.text= widget.color[1];
                        }else{
                          colorController2.text='';
                        }
                        if(value3 == true){
                          colorController3.text= widget.color[2];
                        }else{
                          colorController3.text='';
                        }
                        if(value4 == true){
                          colorController4.text= widget.color[3];
                        }else{
                          colorController4.text='';
                        }
                        if(value5 == true){
                          colorController5.text= widget.color[4];
                        }else{
                          colorController5.text='';
                        }
                      });
                      Map _addVehicleVariant = {
                        "new_vehicle_id":widget.id,
                        "varient":variantController.text,
                        "model_name":modelNameController.text,
                        "model_code":modelCodeController.text,
                        "make":makeController.text,
                        // "onroad_price":double.parse(onRoadController.text),
                        "onroad_price":onRoadController.text,
                        // "varient_color1":colorController.text,
                        if(value1==true)
                          "varient_color1":colorController.text,
                        if(value2==true)
                          "varient_color1":colorController2.text,
                        if(value3==true)
                          "varient_color1":colorController3.text,
                        if(value4==true)
                          "varient_color1":colorController4.text,
                        if(value5==true)
                          "varient_color1":colorController5.text,
                      };
                      print(_addVehicleVariant);
                      addVehicleVariant(_addVehicleVariant);
                    }
                  },
                  color: Colors.blue,
                  child: const Text('Save',style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//-------------edit variant ---------------
editVariantDialog(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const EditVariant();
    },);
}
class EditVariant extends StatefulWidget {
  const EditVariant({Key? key}) : super(key: key);


  @override
  State<EditVariant> createState() => _EditVariantState();
}

class _EditVariantState extends State<EditVariant> {

  final _editForm = GlobalKey<FormState>();

  var modelNameController = TextEditingController();
  var variantController = TextEditingController();
  var exShowRoomController = TextEditingController();
  var rtoController = TextEditingController();
  var insuranceController = TextEditingController();
  var extendWarrantyController = TextEditingController();
  var fastTagController = TextEditingController();
  var accessoryController = TextEditingController();
  var onRoadController = TextEditingController();
  var colorController = TextEditingController();
  var colorController2 = TextEditingController();
  var colorController3 = TextEditingController();
  var colorController4 = TextEditingController();
  var colorController5 = TextEditingController();
  var engineController = TextEditingController();
  var transmissionController = TextEditingController();

  bool modelError = false;
  bool variantError = false;
  bool exShowRoomError = false;
  bool rtoError = false;
  bool insuranceError = false;
  bool extendWarrantyError = false;
  bool fastTagError = false;
  bool accessoryError = false;
  bool onRoadError = false;
  bool colorError = false;
  bool colorError2 = false;
  bool colorError3 = false;
  bool colorError4 = false;
  bool colorError5 = false;
  bool engineError = false;
  bool transError = false;
  bool engineError1 = false;
  bool transmissionError1 = false;

  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;
  bool value5 = false;

  var engine = "--Select--";
  final _engineList = [
    'Petrol',
    'Diesel',
    'EV',
    'Hybrid',
  ];
  var trans = "--Select--";
  final _transList = [
    'Automatic Transmission (AT)',
    'Manual Transmission (MT)',
    'Automated Manual Transmission (AMT)',
    'Continuously Variable Transmission (CVT)',
  ];

  void engineDisplay(String? ed){
    setState(() {
      engine = ed!;
    });
  }
  void transDisplay(String? td){
    setState(() {
      trans = td!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          const Text('Edit Vehicle Variant'),
          InkWell(
            child: const Icon(Icons.close_sharp,color: Colors.red),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Form(
                key: _editForm,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    Row(
                      children:   [
                        const SizedBox(
                          width: 180,
                          child: Text('Model Name'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: modelError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    modelError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    modelError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: modelNameController,
                              decoration: decorationInput5('Enter Model Name', modelNameController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //-----variant------
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Variant'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: variantError ? 55:30,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    variantError = true;
                                  });
                                  return 'Required';
                                }
                                else{
                                  setState(() {
                                    variantError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: variantController,
                              decoration: decorationInput5('Enter Variant', variantController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //-------ex show room price----
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Ex-ShowRoom Price'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: variantError ? 55:30,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    exShowRoomError = true;
                                  });
                                  return 'Required';
                                }
                                else{
                                  setState(() {
                                    exShowRoomError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: exShowRoomController,
                              decoration: decorationInput5('Enter Price', exShowRoomController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //-----rto---
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('RTO'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: variantError ? 55:30,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    rtoError = true;
                                  });
                                  return 'Required';
                                }
                                else{
                                  setState(() {
                                    rtoError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: rtoController,
                              decoration: decorationInput5('Enter Price', rtoController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //-----insurance-------
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Insurance'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: variantError ? 55:30,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    insuranceError = true;
                                  });
                                  return 'Required';
                                }
                                else{
                                  setState(() {
                                    insuranceError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: insuranceController,
                              decoration: decorationInput5('Enter Insurance', insuranceController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //-----warranty-------
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Extended Warranty'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: variantError ? 55:30,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    extendWarrantyError = true;
                                  });
                                  return 'Required';
                                }
                                else{
                                  setState(() {
                                    extendWarrantyError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: extendWarrantyController,
                              decoration: decorationInput5('Enter Warranty', extendWarrantyController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //---fast tag---
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Fast Tag'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: variantError ? 55:30,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    fastTagError = true;
                                  });
                                  return 'Required';
                                }
                                else{
                                  setState(() {
                                    fastTagError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: fastTagController,
                              decoration: decorationInput5('Enter Price', fastTagController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //----accessory---
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Accessory Charges'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: variantError ? 55:30,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    accessoryError = true;
                                  });
                                  return 'Required';
                                }
                                else{
                                  setState(() {
                                    accessoryError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: accessoryController,
                              decoration: decorationInput5('Enter Charges', accessoryController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //-----on road----
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('On-Road Price'),
                        ),
                        SizedBox(
                          width: 300,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: variantError ? 55:30,
                            child: TextFormField(
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    onRoadError = true;
                                  });
                                  return 'Required';
                                }
                                else{
                                  setState(() {
                                    onRoadError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: onRoadController,
                              decoration: decorationInput5('Enter Price', onRoadController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    // ------color-----
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Color'),
                        ),
                        // Text(widget.color[0]),
                        Checkbox(
                          value: value1,
                          onChanged: (value) {
                            setState(() {
                              value1 = value!;
                            });
                          },
                        ),
                        const SizedBox(width: 10,),
                        // if(widget.color.length>1)
                        Row(
                          children: [
                            // Text(widget.color[1]),
                            Checkbox(
                              value: value2,
                              onChanged: (value) {
                                setState(() {
                                  value2 = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 10,),
                        // if(widget.color.length>2)
                        Row(
                          children: [
                            // Text(widget.color[2]),
                            Checkbox(
                              value: value3,
                              onChanged: (value) {
                                setState(() {
                                  value3 = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 10,),
                        // if(widget.color.length>3)
                        Row(
                          children: [
                            // Text(widget.color[3]),
                            Checkbox(
                              value: value4,
                              onChanged: (value) {
                                setState(() {
                                  value4 = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 10,),
                        // if(widget.color.length>4)
                        Row(
                          children: [
                            // Text(widget.color[4]),
                            Checkbox(
                              value: value5,
                              onChanged: (value) {
                                setState(() {
                                  value5 = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 10,),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //---------engine-----
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Engine'),
                        ),
                        // SizedBox(
                        //   width: 300,
                        //   child: AnimatedContainer(
                        //     duration: const Duration(seconds: 0),
                        //     height: engineError1 ? 50 : 30,
                        //     child: DropdownSearch<String>(
                        //       validator: (value) {
                        //         if (value == null ||
                        //             value=="--Select--") {
                        //           setState(() {
                        //             engineError1 = true;
                        //           });
                        //           return "Required";
                        //         } else {
                        //           setState(() {
                        //             engineError1 = false;
                        //           });
                        //         }
                        //       },
                        //       popupProps: PopupProps.menu(
                        //         constraints: const BoxConstraints(
                        //             maxHeight: 200),
                        //         showSearchBox: false,
                        //         showSelectedItems: true,
                        //         searchFieldProps: TextFieldProps(
                        //           decoration:
                        //           dropdownDecorationSearch(
                        //               engine.isNotEmpty),
                        //           cursorColor: Colors.grey,
                        //           style: const TextStyle(
                        //             fontSize: 14,
                        //           ),
                        //         ),
                        //       ),
                        //       items: _engineList,
                        //       selectedItem: engine,
                        //       onChanged: engineDisplay,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    //  -------transmission-----
                    Row(
                      children: [
                        const SizedBox(
                          width: 180,
                          child: Text('Transmission'),
                        ),
                        // SizedBox(
                        //   width: 300,
                        //   child: AnimatedContainer(
                        //     duration: const Duration(seconds: 0),
                        //     height: engineError1 ? 50 : 30,
                        //     child: DropdownSearch<String>(
                        //       validator: (value) {
                        //         if (value == null ||
                        //             value=="--Select--") {
                        //           setState(() {
                        //             transmissionError1 = true;
                        //           });
                        //           return "Required";
                        //         } else {
                        //           setState(() {
                        //             transmissionError1 = false;
                        //           });
                        //         }
                        //       },
                        //       popupProps: PopupProps.menu(
                        //         constraints: const BoxConstraints(
                        //             maxHeight: 200),
                        //         showSearchBox: false,
                        //         showSelectedItems: true,
                        //         searchFieldProps: TextFieldProps(
                        //           decoration:
                        //           dropdownDecorationSearch(
                        //               trans.isNotEmpty),
                        //           cursorColor: Colors.grey,
                        //           style: const TextStyle(
                        //             fontSize: 14,
                        //           ),
                        //         ),
                        //       ),
                        //       items: _transList,
                        //       selectedItem: trans,
                        //       onChanged: transDisplay,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(onPressed: () {

                },
                  color: Colors.blue,
                  child: const Text('Save',style: TextStyle(color: Colors.white)),
                ),
                MaterialButton(onPressed: () {

                },
                  color: Colors.red,
                  child: const Text('Delete',style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


//----------------------------Inventory --------------

showInventoryDialog(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return  InventoryDialog();
    },);
}
class InventoryDialog extends StatefulWidget {
  const InventoryDialog( {Key? key}) : super(key: key);

  @override
  State<InventoryDialog> createState() => _InventoryDialogState();
}

class _InventoryDialogState extends State<InventoryDialog> {

  final _inventoryForm = GlobalKey<FormState>();


  var itemCodeController = TextEditingController();
  var nameController = TextEditingController();
  var manufacturerController = TextEditingController();
  var descriptionController = TextEditingController();
  var costPerItemController = TextEditingController();
  var stockQuantityController = TextEditingController();

  bool itemCodeError = false;
  bool nameError = false;
  bool manufacturerError = false;
  bool descriptionError = false;
  bool costPerItemError = false;
  bool stockQuantityError = false;

  String? authToken;

  Future addNewInventory(Map<dynamic, dynamic> inventoryData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");

    try{
      final response = await http.post(
          Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicleinventory/add_newvehicleinventory'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(inventoryData)
      );
      if(response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data Saved'),
        ),);
        print(response.body);
        Navigator.of(context).pop();
      }
      else{
        print('--------- post Inventory ---------');
        print(response.statusCode.toString());
      }
    }
    catch(e){
      print(e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add Inventory'),
          InkWell(
            child: const Icon(Icons.close_sharp,color: Colors.red,),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      content: SizedBox(
        width: 400,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Form(
                key: _inventoryForm,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    //--------item code------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Item Code'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: itemCodeError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    itemCodeError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    itemCodeError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: itemCodeController,
                              decoration: decorationInput5('Enter Item Code', itemCodeController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------name-------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Name'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: nameError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    nameError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    nameError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: nameController,
                              decoration: decorationInput5('Enter Name', nameController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------manufacturer------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Manufacturer'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: manufacturerError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    manufacturerError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    manufacturerError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: manufacturerController,
                              decoration: decorationInput5('', manufacturerController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------description-------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Description'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            // height: descriptionError ? 55 : 30,
                            height: 80,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              // validator: (value) {
                              //   if(value == null || value.isEmpty){
                              //     setState(() {
                              //       descriptionError = true;
                              //     });
                              //     return "Required";
                              //   }
                              //   else{
                              //     setState(() {
                              //       descriptionError = false;
                              //     });
                              //   }
                              //   return null;
                              // },
                              style: const TextStyle(fontSize: 14),
                              controller: descriptionController,
                              decoration: decorationInput6('Enter Remarks', descriptionController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------cost per item-----
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Cost Per Item'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: costPerItemError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    costPerItemError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    costPerItemError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: costPerItemController,
                              decoration: decorationInput5('Enter Cost', costPerItemController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------stock quantity-----
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Stock Quantity'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: stockQuantityError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    stockQuantityError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    stockQuantityError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: stockQuantityController,
                              decoration: decorationInput5('Enter Quantity', stockQuantityController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(onPressed: () {
                  if(_inventoryForm.currentState!.validate()){
                    itemCodeController.text.isNotEmpty&&
                        nameController.text.isNotEmpty&&
                        manufacturerController.text.isNotEmpty&&
                        // descriptionController.text.isNotEmpty&&
                        costPerItemController.text.isNotEmpty&&
                        stockQuantityController.text.isNotEmpty;
                    print(nameController.text);
                  }
                },
                  color: Colors.blue,
                  child: const Text('Save',style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//----------------------Purchase ------------------------

showPurchaseDialog(BuildContext context){
  showDialog(context: context, builder: (BuildContext context) {
    return PurchaseDialog();
  },);
}
class PurchaseDialog extends StatefulWidget {
  const PurchaseDialog({Key? key}) : super(key: key);

  @override
  State<PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {

  final _grnForm = GlobalKey<FormState>();


  var grnIdController = TextEditingController();
  var grnQuantityController = TextEditingController();
  var vehicleCodeController = TextEditingController();
  var vehicleNameController = TextEditingController();
  var vehicleColorController = TextEditingController();
  var vehicleQuantityController = TextEditingController();
  var vehicleVinController = TextEditingController();

  bool grnIdError = false;
  bool grnQuantityError = false;
  bool vehicleCodeError = false;
  bool vehicleNameError = false;
  bool vehicleColorError = false;
  bool vehicleQuantityError = false;
  bool vehicleVinError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add Purchase'),
          InkWell(
            child: const Icon(Icons.close_sharp,color: Colors.red,),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      content: SizedBox(
        width: 400,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Form(
                key: _grnForm,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    //--------grn id------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('GRN ID'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: grnIdError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    grnIdError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    grnIdError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: grnIdController,
                              decoration: decorationInput5('Enter GRN Id', grnIdController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------grn quantity-------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('GRN Quantity'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: grnQuantityError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    grnQuantityError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    grnQuantityError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: grnQuantityController,
                              decoration: decorationInput5('Enter Quantity', grnQuantityController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------vehicle code------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Vehicle Code'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: vehicleCodeError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    vehicleCodeError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    vehicleCodeError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: vehicleCodeController,
                              decoration: decorationInput5('Enter Vehicle Code', vehicleCodeController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------vehicle name-------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Vehicle Name'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: vehicleNameError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    vehicleNameError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    vehicleNameError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: vehicleNameController,
                              decoration: decorationInput5('Enter Vehicle Name', vehicleNameController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------vehicle color-----
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Vehicle Color'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: vehicleColorError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    vehicleColorError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    vehicleColorError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: vehicleColorController,
                              decoration: decorationInput5('Enter Color', vehicleColorController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------vehicle quantity-----
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Vehicle Quantity'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: vehicleQuantityError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    vehicleQuantityError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    vehicleQuantityError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: vehicleQuantityController,
                              decoration: decorationInput5('Enter Quantity', vehicleQuantityController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------vehicle vin------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Vehicle VIN'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: vehicleVinError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    vehicleVinError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    vehicleVinError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: vehicleVinController,
                              decoration: decorationInput5('Enter VIN', vehicleVinController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(onPressed: () {
                  if(_grnForm.currentState!.validate()){

                  }
                },
                  color: Colors.blue,
                  child: const Text('Save',style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}







