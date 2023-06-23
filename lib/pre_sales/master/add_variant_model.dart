import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../widgets/input_decoration_text_field.dart';

class AddVariantModel extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final String id;
  final List<String> color;
  final String make;
  final List transmissionList;
  const AddVariantModel({
    Key? key,

    required this.drawerWidth,
    required this.selectedDestination,
    required this.id,
    required this.color,
    required this.make,
    required this.transmissionList
  }) : super(key: key);

  @override
  State<AddVariantModel> createState() => _AddVariantModelState();
}

class _AddVariantModelState extends State<AddVariantModel> with SingleTickerProviderStateMixin{

  String? authToken;

  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }

  var makeController = TextEditingController();
  var modelCodeController = TextEditingController();
  var modelNameController = TextEditingController();
  var colorController = TextEditingController();
  var variantNameController = TextEditingController();
  var onRoadPriceController = TextEditingController();
  var orderedController = TextEditingController();
  var inventoryController = TextEditingController();
  var soldController = TextEditingController();
  var typeController = TextEditingController();
  var labourTypeController = TextEditingController();
  var vehicleCodeController = TextEditingController();
  var marketSegmentController = TextEditingController();
  var vehicleTypeCodeController = TextEditingController();
  var exShowRoomController = TextEditingController();

  bool makeError = false;
  bool modelCodeError = false;
  bool modelNameError = false;
  bool colorError = false;
  bool variantNameError = false;
  bool onRoadError = false;
  bool orderedError = false;
  bool inventoryError = false;
  bool soldError = false;
  bool typeError = false;
  bool labourTypeError = false;
  bool vehicleCodeError = false;
  bool marketSegmentError = false;
  bool vehicleTypeCodeError = false;
  bool transError = false;
  bool exShowError = false;

  final engineType=TextEditingController();
  final emission=TextEditingController();
  final emissionTest=TextEditingController();
  final transmission=TextEditingController();
  final powerKw=TextEditingController();
  final powerHp=TextEditingController();
  final topSpeed=TextEditingController();
  final acceleration=TextEditingController();
  final cylinderCapacity=TextEditingController();
  final noCylinder=TextEditingController();
  final door=TextEditingController();
  final tires=TextEditingController();
  final weight=TextEditingController();
  final roof=TextEditingController();
  final emptyWeight=TextEditingController();
  final rearAxle=TextEditingController();
  final frontAxle=TextEditingController();
  final trailerLoad=TextEditingController();
  final trailerTongue=TextEditingController();
  final axles=TextEditingController();
  final wheel=TextEditingController();
  bool emissionError=false;
  bool engineTypeError=false;
  bool emissionTestError=false;
  bool transmissionError=false;
  bool powerKwError=false;
  bool powerHpError=false;
  bool topSpeedError=false;
  bool accelerationError=false;
  bool cylinderError=false;
  bool numberCylinderError=false;
  bool doorError=false;
  bool tiresError=false;
  bool weightError=false;
  bool roofError=false;
  bool emptyWeightError=false;
  bool rearAxleError=false;
  bool frontAxleError=false;
  bool trailerError=false;
  bool trailerTongueError=false;
  bool axlesError=false;
  bool wheelError=false;

  var preferredVendorController = TextEditingController();
  var unitCostController = TextEditingController();
  var lastCostController = TextEditingController();
  var purchaseDateController = TextEditingController();
  var unitPriceController = TextEditingController();
  var priceListController = TextEditingController();

  bool preferredError = false;
  bool unitCostError = false;
  bool lastCostError = false;
  bool unitPriceError = false;
  bool priceListError = false;

  var price = "--Select--";
  final _priceList = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  void priceListDisplay(String? pl){
    setState(() {
      price = pl!;
    });
  }

  late TabController _tabController;
  int _tabIndex = 0;
  final List<Widget> myTabs = const [
    Tab(text: 'General',),
    Tab(text: 'Tech Info',),
    Tab(text: 'Inventory Data',),
  ];

  _handleTabSelection(){
    if(_tabController.indexIsChanging){
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }
  List<String> initialColor = [];
  List<String> colorList = [];
  List selectedColors = ["","","","",""];

  var transMission = "--Select--";
  dynamic transmissionList = [];
  void transListDisplay(String? t){
    setState(() {
      transMission = t!;
    });
  }

  @override
  void initState() {
    makeController.text = widget.make;
    _tabController = TabController(length: myTabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    getInitialData();
    colorList = widget.color;
    transmissionList = widget.transmissionList;
    // loading = true;
  }


  @override
  dispose(){
    super.dispose();
    _tabController.dispose();
  }

  final modelForm = GlobalKey<FormState>();
  var tabs = false;
  var firstId = "";
  bool loading = false;

  Map modelGeneral = {};
  Map techInfo = {};
  Map inventory = {};
  Future addModelGeneral(Map<dynamic, dynamic> mgData)async{
    String url="https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/add_mod_general";
    // print('--------addModel URL----------');
    // print(url);
    postData(context: context,url: url,requestBody: mgData).then((value) {
      setState(() {
        if(value!=null){
          Map tempMap = {};
          tempMap = value;
          addTechInfo(techInfo);
          // print('--------addModel value----------');
          // print(value);
          if(tempMap.containsKey('id')){
            firstId = tempMap["id"];
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ID is not called')));
          }
        }
      });
    });
  }
  Future addTechInfo(Map<dynamic, dynamic> tiData)async{
    String url="https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/model_tech_info/add_mod_mast_tech_info";
    postData(requestBody: tiData,url: url,context: context).then((value) {
      setState(() {
        if(value!=null){
          addInventory(inventory);
        }
      });
    });
  }
  Future addInventory(Map<dynamic, dynamic> iData)async{
    String url="https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/model_inventory/add_mod_inventory_details";
    postData(context: context,url: url,requestBody: iData).then((value) {
      setState(() {
        if(value!=null){
          // iData = value;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data Saved'),
              ));
          Navigator.of(context).pop();
        }
        loading = false;
      });
    });
  }

  var size, width, height;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60), child: CustomAppBar()),

      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(width: 1,thickness: 1,),
          Expanded(
            child: Scaffold(

              body: Container(
                color: const Color.fromRGBO(249,250,250,0.5),
                child: RawScrollbar(
                  thumbColor: Colors.black45,
                  radius: const Radius.circular(5.0),
                  thumbVisibility: true,
                  thickness: 10.0,
                  child: CustomLoader(
                    inAsyncCall: loading,
                    child: SingleChildScrollView(
                      primary:true,
                      child: DefaultTabController(
                        length: 3,
                        child: Form(
                          key: modelForm,
                          child: Column(
                            children: [
                              const SizedBox(height:40,
                                child: Align(alignment: Alignment.topLeft,
                                  child:  Padding(
                                    padding: EdgeInsets.only(left:50,top:20),
                                    child: Text(
                                      "Model",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 50,right: 50,top: 40,bottom: 40),
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
                                  child: Column(
                                    children: [
                                      //  -------header --------
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20,bottom: 20),
                                            child: Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Make',style: TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    SizedBox(
                                                      width: 280,
                                                      child: AnimatedContainer(
                                                        duration: const Duration(seconds: 0),
                                                        height: makeError ? 55 : 30,
                                                        child: TextFormField(
                                                          readOnly: true,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              setState(() {
                                                                makeError = true;
                                                              });
                                                              return "Required";
                                                            } else {
                                                              setState(() {
                                                                makeError = false;
                                                              });
                                                            }
                                                            return null;
                                                          },
                                                          style: const TextStyle(
                                                              fontSize: 14),
                                                          onChanged: (text) {
                                                            setState(() {});
                                                          },
                                                          controller: makeController,
                                                          decoration: decorationInput5('Make', makeController.text.isNotEmpty),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height:10),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Model Code',style: TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    SizedBox(
                                                      width: 280,
                                                      child: AnimatedContainer(
                                                        duration: const Duration(seconds: 0),
                                                        height: modelCodeError ? 55 : 30,
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              setState(() {
                                                                modelCodeError = true;
                                                              });
                                                              return "Required";
                                                            } else {
                                                              setState(() {
                                                                modelCodeError = false;
                                                              });
                                                            }
                                                            return null;
                                                          },
                                                          style: const TextStyle(
                                                              fontSize: 14),
                                                          onChanged: (text) {
                                                            setState(() {});
                                                          },
                                                          controller: modelCodeController,
                                                          decoration: decorationInput5('Model Code', modelCodeController.text.isNotEmpty),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height:10),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Transmission',style: TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    // SizedBox(
                                                    //   width: 280,
                                                    //   child:AnimatedContainer(
                                                    //     duration: const Duration(seconds: 0),
                                                    //     height: transError ? 55 : 30,
                                                    //     child: DropdownSearch<String>(
                                                    //       validator: (value) {
                                                    //         if (value == null ||
                                                    //             value=="--Select--") {
                                                    //           setState(() {
                                                    //             transError = true;
                                                    //           });
                                                    //           return "Required";
                                                    //         } else {
                                                    //           setState(() {
                                                    //             transError = false;
                                                    //           });
                                                    //         }
                                                    //         return null;
                                                    //       },
                                                    //       popupProps: PopupProps.menu(
                                                    //         constraints: const BoxConstraints(
                                                    //             maxHeight: 100),
                                                    //         showSearchBox: false,
                                                    //         showSelectedItems: true,
                                                    //         searchFieldProps: TextFieldProps(
                                                    //           decoration:
                                                    //           dropdownDecorationSearch(
                                                    //               transMission.isNotEmpty),
                                                    //           cursorColor: Colors.grey,
                                                    //           style: const TextStyle(
                                                    //             fontSize: 14,
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //       items: transmissionList,
                                                    //       selectedItem: transMission,
                                                    //       onChanged: transListDisplay,
                                                    //     ),
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20,bottom: 20),
                                            child: Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Model Name',style: TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    SizedBox(
                                                      width: 280,
                                                      child: AnimatedContainer(
                                                        duration: const Duration(seconds: 0),
                                                        height: modelNameError ? 55 : 30,
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              setState(() {
                                                                modelNameError = true;
                                                              });
                                                              return "Required";
                                                            } else {
                                                              setState(() {
                                                                modelNameError = false;
                                                              });
                                                            }
                                                            return null;
                                                          },
                                                          style: const TextStyle(
                                                              fontSize: 14),
                                                          onChanged: (text) {
                                                            setState(() {});
                                                          },
                                                          controller: modelNameController,
                                                          decoration: decorationInput5('Model Name', modelNameController.text.isNotEmpty),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height:10),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Variant Name',style: TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    SizedBox(
                                                      width: 280,
                                                      child: AnimatedContainer(
                                                        duration: const Duration(seconds: 0),
                                                        height: variantNameError ? 55 : 30,
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              setState(() {
                                                                variantNameError = true;
                                                              });
                                                              return "Required";
                                                            } else {
                                                              setState(() {
                                                                variantNameError = false;
                                                              });
                                                            }
                                                            return null;
                                                          },
                                                          style: const TextStyle(
                                                              fontSize: 14),
                                                          onChanged: (text) {
                                                            setState(() {});
                                                          },
                                                          controller: variantNameController,
                                                          decoration: decorationInput5('Variant Name', variantNameController.text.isNotEmpty),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height:10),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Ex-Showroom Price',style: TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    SizedBox(
                                                      width: 280,
                                                      child: AnimatedContainer(
                                                        duration: const Duration(seconds: 0),
                                                        height: exShowError ? 55 : 30,
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              setState(() {
                                                                exShowError = true;
                                                              });
                                                              return "Required";
                                                            } else {
                                                              setState(() {
                                                                exShowError = false;
                                                              });
                                                            }
                                                            return null;
                                                          },
                                                          style: const TextStyle(
                                                              fontSize: 14),
                                                          onChanged: (text) {
                                                            setState(() {});
                                                          },
                                                          controller: exShowRoomController,
                                                          decoration: decorationInput5('Ex-Showroom Price', exShowRoomController.text.isNotEmpty),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20,bottom: 20),
                                            child: Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Color',style: TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    // SizedBox(
                                                    //   width: 280,
                                                    //   child:AnimatedContainer(
                                                    //     duration: const Duration(seconds: 0),
                                                    //     height: colorError ? 55 : 30,
                                                    //     child: DropDownMultiSelect(
                                                    //       onChanged: (c){
                                                    //         setState(() {
                                                    //           selectedColors = ["","","","",""];
                                                    //           initialColor = c;
                                                    //           for(int i=0; i<initialColor.length; i++){
                                                    //             selectedColors[i] = initialColor[i];
                                                    //           }
                                                    //         });
                                                    //       },
                                                    //       options: colorList,
                                                    //       selectedValues: initialColor,
                                                    //       whenEmpty: "Select Color",
                                                    //     ),
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                                const SizedBox(height:10),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'On Road Price',style: TextStyle(fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    SizedBox(
                                                      width: 280,
                                                      child: AnimatedContainer(
                                                        duration: const Duration(seconds: 0),
                                                        height: onRoadError ? 55 : 30,
                                                        child: TextFormField(
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              setState(() {
                                                                onRoadError = true;
                                                              });
                                                              return "Required";
                                                            } else {
                                                              setState(() {
                                                                onRoadError = false;
                                                              });
                                                            }
                                                            return null;
                                                          },
                                                          style: const TextStyle(
                                                              fontSize: 14),
                                                          onChanged: (text) {
                                                            setState(() {});
                                                          },
                                                          controller: onRoadPriceController,
                                                          decoration: decorationInput5('On-Road Price', onRoadPriceController.text.isNotEmpty),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // ----------divider -------
                                      const Divider(),
                                      // ----------- tab bar ----------
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20,right: 50,top: 0,bottom: 40),
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              //  ----------tab bar--------
                                              Align(alignment: Alignment.topLeft,
                                                child: SizedBox(
                                                  width: 500,
                                                  child:  TabBar(
                                                    indicatorColor: Colors.blue,
                                                    labelColor: Colors.blue,
                                                    unselectedLabelColor: Colors.black,
                                                    tabs:myTabs,
                                                    controller:_tabController,
                                                  ),
                                                ),
                                              ),
                                              // --------- tab bar view ----------
                                              Container(
                                                child: [
                                                  //  ----------general tab ---------
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 20,left: 15),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width:200,
                                                                    child: Text(
                                                                      'Type',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: typeError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              typeError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              typeError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: typeController,
                                                                        decoration: decorationInput5('Enter Type', typeController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Labour Type',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: labourTypeError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              labourTypeError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              labourTypeError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: labourTypeController,
                                                                        decoration: decorationInput5('Enter Labour Type', labourTypeController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Vehicle Category Code',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: vehicleCodeError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              vehicleCodeError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              vehicleCodeError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: vehicleCodeController,
                                                                        decoration: decorationInput5('Vehicle Category Code', vehicleCodeController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Market Segment Code',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: marketSegmentError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              marketSegmentError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              marketSegmentError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: marketSegmentController,
                                                                        decoration: decorationInput5('Market Segment Code', marketSegmentController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Vehicle Type Code',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: vehicleTypeCodeError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              vehicleTypeCodeError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              vehicleTypeCodeError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: vehicleTypeCodeController,
                                                                        decoration: decorationInput5('Vehicle Type Code', vehicleTypeCodeController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // -------- tech info ------
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left:15,top:20),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                      width: 200,
                                                                      child: Text(
                                                                        'Engine Type Code',style: TextStyle(fontSize: 16),
                                                                      )),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 280,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: engineTypeError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              engineTypeError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              engineTypeError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: engineType,
                                                                        decoration: decorationInput5(
                                                                            'Engine Type Code',
                                                                            engineType
                                                                                .text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              //----------Emission--------
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                      width: 200,
                                                                      child: Text(
                                                                        'Emission Standard Code',style: TextStyle(fontSize: 16),
                                                                      )),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 280,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: emissionError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        // maxLength: 40,
                                                                        // keyboardType:
                                                                        // TextInputType.number,
                                                                        // inputFormatters: [
                                                                        //   FilteringTextInputFormatter
                                                                        //       .digitsOnly
                                                                        // ],
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              emissionError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              emissionError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: emission,
                                                                        decoration: decorationInput5(
                                                                            'Emission Standard Code',
                                                                            emission
                                                                                .text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              //-------Emission Test------
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    'Emission Test Category Code',style: TextStyle(fontSize: 16),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 280,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: emissionTestError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        // maxLength: 40,
                                                                        // keyboardType:
                                                                        // TextInputType.number,
                                                                        // inputFormatters: [
                                                                        //   FilteringTextInputFormatter
                                                                        //       .digitsOnly
                                                                        // ],
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              emissionTestError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              emissionTestError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: emissionTest,
                                                                        decoration: decorationInput5(
                                                                            'Emission Test Code',
                                                                            emissionTest
                                                                                .text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                      width: 200,
                                                                      child: Text(
                                                                        'Transmission Type Code',style: TextStyle(fontSize: 16),
                                                                      )),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 280,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: transmissionError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              transmissionError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              transmissionError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: transmission,
                                                                        decoration: decorationInput5(
                                                                            'Transmission Type Code',
                                                                            transmission
                                                                                .text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              //---------power-------
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                      width: 200,
                                                                      child: Text(
                                                                        'Power (KW)',style: TextStyle(fontSize: 16),
                                                                      )),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 280,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: powerKwError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        maxLength: 40,
                                                                        keyboardType:
                                                                        TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              powerKwError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              powerKwError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: powerKw,
                                                                        decoration: decorationInput5(
                                                                            'Power (KW)',
                                                                            powerKw
                                                                                .text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              //---------power (hp)--------
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                      width: 200,
                                                                      child: Text(
                                                                        'Power (HP)',style: TextStyle(fontSize: 16),
                                                                      )),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 280,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: powerHpError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        maxLength: 40,
                                                                        keyboardType:
                                                                        TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              powerHpError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              powerHpError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: powerHp,
                                                                        decoration: decorationInput5(
                                                                            'Power (HP)',
                                                                            powerHp
                                                                                .text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                      width: 200,
                                                                      child: Text(
                                                                        'Top Speed',style: TextStyle(fontSize: 16),
                                                                      )),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 280,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: topSpeedError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        maxLength: 40,
                                                                        keyboardType:
                                                                        TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              topSpeedError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              topSpeedError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: topSpeed,
                                                                        decoration: decorationInput5(
                                                                            'Top Speed',
                                                                            topSpeed
                                                                                .text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                              children:[
                                                                //----------acceleration--------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Acceleration',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: accelerationError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                accelerationError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                accelerationError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: acceleration,
                                                                          decoration: decorationInput5(
                                                                              'Accelaration',
                                                                              acceleration
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //--------cylinder typical.---------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Cylinder Capacity (Ccn)',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: cylinderError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                cylinderError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                cylinderError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: cylinderCapacity,
                                                                          decoration: decorationInput5(
                                                                              'Cylinder Capacity',
                                                                              cylinderCapacity
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'No .Of Cylinder',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: numberCylinderError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                numberCylinderError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                numberCylinderError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: noCylinder,
                                                                          decoration: decorationInput5(
                                                                              'No. Of Cylinder',
                                                                              noCylinder
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //--------no of door.---------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'No.Of Door',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width:280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: doorError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          // maxLength: 40,
                                                                          // keyboardType:
                                                                          // TextInputType.number,
                                                                          // inputFormatters: [
                                                                          //   FilteringTextInputFormatter
                                                                          //       .digitsOnly
                                                                          // ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                doorError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                doorError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: door,
                                                                          decoration: decorationInput5(
                                                                              'No.Of Door',
                                                                              door
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //--------tires.------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Tires',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: tiresError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          // maxLength: 40,
                                                                          // keyboardType:
                                                                          // TextInputType.number,
                                                                          // inputFormatters: [
                                                                          //   FilteringTextInputFormatter
                                                                          //       .digitsOnly
                                                                          // ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                tiresError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                tiresError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: tires,
                                                                          decoration: decorationInput5(
                                                                              'Tires',
                                                                              tires
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Total Weight(KG)',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: weightError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                weightError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                weightError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: weight,
                                                                          decoration: decorationInput5(
                                                                              'Total Weight ',
                                                                              weight
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //-------roof load-----
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'RoofLoad(Kg)',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: roofError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                roofError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                roofError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: roof,
                                                                          decoration: decorationInput5(
                                                                              'Roof Load',
                                                                              roof
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ]
                                                          ),
                                                          Column(
                                                              children:[
                                                                //-------Empty weight------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Empty Weight(Kg)',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: emptyWeightError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                emptyWeightError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                emptyWeightError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: emptyWeight,
                                                                          decoration: decorationInput5(
                                                                              'Empty Weight(Kg)',
                                                                              emptyWeight
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Rear Axle Load(Kg)',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: rearAxleError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                rearAxleError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                rearAxleError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: rearAxle,
                                                                          decoration: decorationInput5(
                                                                              'Rear Axle Load(kg)',
                                                                              rearAxle
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //--------front axle.--------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Front Axle Load(Kg)',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: frontAxleError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                frontAxleError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                frontAxleError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: frontAxle,
                                                                          decoration: decorationInput5(
                                                                              'Front Axle Load(Kg)',
                                                                              frontAxle
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //------trailer load.-----
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Trailer Load',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: trailerError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                trailerError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                trailerError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: trailerLoad,
                                                                          decoration: decorationInput5(
                                                                              'Trailer Load',
                                                                              trailerLoad
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Trailer Tongue Load',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: trailerTongueError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                trailerTongueError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                trailerTongueError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: trailerTongue,
                                                                          decoration: decorationInput5(
                                                                              'Trailer Tongue Load',
                                                                              trailerTongue
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //------axles.-------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'No.Of Axles',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: axlesError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                axlesError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                axlesError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: axles,
                                                                          decoration: decorationInput5(
                                                                              'No.Of Axles',
                                                                              axles
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //------wheel Base----
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(
                                                                        width: 200,
                                                                        child: Text(
                                                                          'Wheel Base',style: TextStyle(fontSize: 16),
                                                                        )),
                                                                    const SizedBox(height:5),
                                                                    SizedBox(
                                                                      width: 280,
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(seconds: 0),
                                                                        height: wheelError ? 55 : 30,
                                                                        child: TextFormField(
                                                                          maxLength: 40,
                                                                          keyboardType:
                                                                          TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly
                                                                          ],
                                                                          validator: (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                wheelError = true;
                                                                              });
                                                                              return "Required";
                                                                            } else {
                                                                              setState(() {
                                                                                wheelError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          style: const TextStyle(
                                                                              fontSize: 14),
                                                                          onChanged: (text) {
                                                                            setState(() {});
                                                                          },
                                                                          controller: wheel,
                                                                          decoration: decorationInput5(
                                                                              'Wheel Base',
                                                                              wheel
                                                                                  .text.isNotEmpty),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ]
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // -------- inventory data --------
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 20,left:15),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width:200,
                                                                    child: Text(
                                                                      'Preferred Vendor',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: preferredError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              preferredError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              preferredError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: preferredVendorController,
                                                                        decoration: decorationInput5('Enter Vendor', preferredVendorController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Unit Cost',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: unitCostError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        maxLength: 20,
                                                                        keyboardType:
                                                                        TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              unitCostError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              unitCostError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: unitCostController,
                                                                        decoration: decorationInput5('Enter Unit Cost', unitCostController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Last Direct Cost',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: lastCostError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        maxLength: 20,
                                                                        keyboardType:
                                                                        TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              lastCostError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              lastCostError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: lastCostController,
                                                                        decoration: decorationInput5('Enter Cost', lastCostController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Last Purchase Date',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  Container(
                                                                    width: 300,
                                                                    height: 30,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        border: Border.all(color: Colors.black,width: 0.6)),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 10,top: 5),
                                                                      child: TextField(
                                                                        controller: purchaseDateController, //editing controller of this TextField
                                                                        decoration: const InputDecoration(hintText: 'Enter Purchase Date',
                                                                          border: InputBorder.none,
                                                                          icon: Padding(
                                                                            padding: EdgeInsets.only(bottom:5),
                                                                            child: Icon(Icons.calendar_today,size: 15),
                                                                          ),  //icon of text field
                                                                          // labelText: "Enter Date" //label text of field
                                                                        ),
                                                                        //    readOnly: true,  //set it true, so that user will not able to edit text
                                                                        onTap: () async {
                                                                          DateTime? pickedDate = await showDatePicker(
                                                                              context: context, initialDate: DateTime.now(),
                                                                              firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                                                              lastDate: DateTime(2101)
                                                                          );

                                                                          if(pickedDate != null ){
                                                                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                                            setState(() {
                                                                              purchaseDateController.text = formattedDate; //set output date to TextField value.
                                                                            });
                                                                          }else{
                                                                            print("Date is not selected");
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Unit Price',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(seconds: 0),
                                                                      height: unitPriceError ? 55 : 30,
                                                                      child: TextFormField(
                                                                        maxLength: 20,
                                                                        keyboardType:
                                                                        TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
                                                                        validator: (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            setState(() {
                                                                              unitPriceError = true;
                                                                            });
                                                                            return "Required";
                                                                          } else {
                                                                            setState(() {
                                                                              unitPriceError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(
                                                                            fontSize: 14),
                                                                        onChanged: (text) {
                                                                          setState(() {});
                                                                        },
                                                                        controller: unitPriceController,
                                                                        decoration: decorationInput5('Enter Unit Price', unitPriceController.text.isNotEmpty),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10,),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  const SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      'Price List',style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height:5),
                                                                  // SizedBox(
                                                                  //   width: 300,
                                                                  //   child: AnimatedContainer(
                                                                  //     duration: const Duration(seconds: 0),
                                                                  //     height: priceListError ? 50 : 30,
                                                                  //     child: DropdownSearch<String>(
                                                                  //       validator: (value) {
                                                                  //         if (value == null ||
                                                                  //             value=="--Select--") {
                                                                  //           setState(() {
                                                                  //             priceListError = true;
                                                                  //           });
                                                                  //           return "Required";
                                                                  //         } else {
                                                                  //           setState(() {
                                                                  //             priceListError = false;
                                                                  //           });
                                                                  //         }
                                                                  //       },
                                                                  //       popupProps: PopupProps.menu(
                                                                  //         constraints: const BoxConstraints(
                                                                  //             maxHeight: 100),
                                                                  //         showSearchBox: false,
                                                                  //         showSelectedItems: true,
                                                                  //         searchFieldProps: TextFieldProps(
                                                                  //           decoration:
                                                                  //           dropdownDecorationSearch(
                                                                  //               price.isNotEmpty),
                                                                  //           cursorColor: Colors.grey,
                                                                  //           style: const TextStyle(
                                                                  //             fontSize: 14,
                                                                  //           ),
                                                                  //         ),
                                                                  //       ),
                                                                  //       items: _priceList,
                                                                  //       selectedItem: price,
                                                                  //       onChanged: priceListDisplay,
                                                                  //     ),
                                                                  //   ),
                                                                  // )
                                                                ],
                                                              ),
                                                              // const SizedBox(height: 10,),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ][_tabIndex],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar:
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: Colors.blue)
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:50,bottom:20,top:20),
                  child: Row(
                    children: [
                      if(_tabIndex == 0)
                        MaterialButton(onPressed: () {
                          if(modelForm.currentState!.validate()){
                            modelGeneral = {
                              "new_vehicle_id":widget.id,
                              "make":makeController.text,
                              "model_code":modelCodeController.text,
                              "model_name":modelNameController.text,
                              "onroad_price":onRoadPriceController.text,
                              "varient_name":variantNameController.text,
                              "varient_color1":selectedColors[0],
                              "varient_color2":selectedColors[1],
                              "varient_color3":selectedColors[2],
                              "varient_color4":selectedColors[3],
                              "varient_color5":selectedColors[4],
                              "type":typeController.text,
                              "labour_type":labourTypeController.text,
                              "vehicle_category_code":vehicleCodeController.text,
                              "market_segment_code":marketSegmentController.text,
                              "vehicle_type_code": vehicleTypeCodeController.text,
                              "transmission": transMission,
                              "ex_showroom_price":double.parse(exShowRoomController.text),
                            };
                            if(modelForm.currentState!.validate()){
                              _tabController.animateTo(_tabIndex+1);
                              tabs = true;
                            }
                            // print('-----------general save -----------');
                            // print(modelGeneral);
                          }
                        },
                          color: Colors.lightBlue,
                          child: const Text('Save',style: TextStyle(color:Colors.white),),
                        ),
                      if(_tabIndex == 1)
                        MaterialButton(onPressed: () {
                          if(modelForm.currentState!.validate()){
                            techInfo = {
                              "general_id":firstId,
                              "transmission_type_code": transmission.text,
                              "engine_type_code": engineType.text,
                              "emission_standard_code": emission.text,
                              "emission_test_category_code": emissionTest.text,
                              "power_kw": double.parse(powerKw.text),
                              "power_hp":double.parse(powerHp.text),
                              "top_speed": double.parse(topSpeed.text),
                              "accelaration": double.parse(acceleration.text),
                              "cylinder_capacity": double.parse(cylinderCapacity.text),
                              "no_of_cylinder": double.parse(noCylinder.text),
                              "no_of_door": door.text,
                              "tires": tires.text,
                              "total_weight": double.parse(weight.text),
                              "roof_load": double.parse(roof.text),
                              "empty_weight": double.parse(emptyWeight.text),
                              "rear_axle_load" : double.parse(rearAxle.text),
                              "front_axle_load": double.parse(frontAxle.text),
                              "trailer_load": double.parse(trailerLoad.text),
                              "trailer_tongue_load" : double.parse(trailerTongue.text),
                              "no_of_axles": double.parse(axles.text),
                              "wheel_base" : double.parse(wheel.text),
                            };
                            if(modelForm.currentState!.validate()){
                              _tabController.animateTo(_tabIndex+1);
                              tabs = true;
                            }
                            // print(techInfo);
                          }
                        },
                          color: Colors.lightBlue,
                          child: const Text('Save',style: TextStyle(color:Colors.white),),
                        ),
                      if(_tabIndex == 2)
                        MaterialButton(onPressed: () {
                          if(modelForm.currentState!.validate()){
                            inventory = {
                              "general_id":firstId,
                              "prefered_vendor":preferredVendorController.text,
                              "unit_cost":unitCostController.text,
                              "last_direct_cost":lastCostController.text,
                              "last_purchase_date":purchaseDateController.text,
                              "unit_price":unitPriceController.text,
                              "price_list":price
                            };
                            // print(inventory);
                            loading = true;
                            addModelGeneral(modelGeneral);
                          }
                        },
                          color: Colors.lightBlue,
                          child: const Text('Save',style: TextStyle(color:Colors.white),),
                        ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 80,
                        height: 30,
                        child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            color: Colors.white,
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
