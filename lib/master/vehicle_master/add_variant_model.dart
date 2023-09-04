import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/input_decoration_text_field.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';

class AddVariantModel extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final String id;
  final List<String> color;
  final String make;
  final List<String> transmissionList;
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
  var transmissionController = TextEditingController();
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
  bool isColorFocused = false;
  bool isTransmissionFocused = false;
  bool isPriceListFocused = false;
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
  List<String> priceList = [
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
  var selectColor = "Select Color";
  var transMission = "--Select--";
  List<String> transmissionList = [];
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
              // backgroundColor: const Color(0xffF0F4F8),
              backgroundColor: const Color.fromRGBO(249,250,250,0.5),
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(88.0),
               child: Padding(
                 padding: const EdgeInsets.only(bottom: 30),
                 child: AppBar(
                   elevation: 1,
                   surfaceTintColor: Colors.white,
                   shadowColor: Colors.black,
                   title: const Text("Model"),
                   actions: [
                     if(_tabIndex == 0)
                     Padding(
                       padding: const EdgeInsets.only(right: 20),
                       child: SizedBox(
                         width: 100,
                         height: 28,
                         child: OutlinedMButton(
                           text: 'Save',
                           textColor: mSaveButton,
                           borderColor: mSaveButton,
                           onTap: () {
                             if(modelForm.currentState!.validate()){
                               modelGeneral = {
                                 "new_vehicle_id":widget.id,
                                 "make":makeController.text,
                                 "model_code":modelCodeController.text,
                                 "model_name":modelNameController.text,
                                 "onroad_price":onRoadPriceController.text,
                                 "varient_name":variantNameController.text,
                                 "varient_color1":selectColor,
                                 "varient_color2":"",
                                 "varient_color3":"",
                                 "varient_color4":"",
                                 "varient_color5":"",
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
                         ),
                       ),
                     ),
                     if(_tabIndex == 1)
                     Padding(
                       padding: const EdgeInsets.only(right: 20),
                       child: SizedBox(
                         width: 100,
                         height: 28,
                         child: OutlinedMButton(
                           text: 'Save',
                           textColor: mSaveButton,
                           borderColor: mSaveButton,
                           onTap: () {
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
                         ),
                       ),
                     ),
                     if(_tabIndex == 2)
                     Padding(
                       padding: const EdgeInsets.only(right: 20),
                       child: SizedBox(
                         width: 100,
                         height: 28,
                         child: OutlinedMButton(
                           text: 'Save',
                           textColor: mSaveButton,
                           borderColor: mSaveButton,
                           onTap: () {
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
                         ),
                       ),
                     ),
                   ],
                 ),
               )
              ),
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
                        child: FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: Form(
                            key: modelForm,
                            child: Column(
                              children: [
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
                                                        width: 300,
                                                        child: TextFormField(
                                                          controller: makeController,
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
                                                          decoration: textFieldDecoration(hintText: "Make", error: makeError),
                                                        ),
                                                      ),
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
                                                        width: 300,
                                                        child: TextFormField(
                                                          controller: modelCodeController,
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
                                                          decoration: textFieldDecoration(hintText: "Model Code", error: modelCodeError),
                                                        ),
                                                      ),
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
                                                      SizedBox(
                                                        width: 300,
                                                        child: Focus(
                                                          onFocusChange: (value) {
                                                            setState(() {
                                                              isTransmissionFocused = value;
                                                            });
                                                          },
                                                          child: LayoutBuilder(
                                                            builder: (BuildContext context, BoxConstraints constraints) {
                                                              return CustomPopupMenuButton(
                                                                elevation: 4,
                                                                validator: (value) {
                                                                  if(value == null || value.isEmpty){
                                                                    setState(() {
                                                                      transError = true;
                                                                    });
                                                                    return null;
                                                                  }
                                                                  return null;
                                                                },
                                                                textController: transmissionController,
                                                                childWidth: constraints.maxWidth,
                                                                hintText: transMission,
                                                                shape: const RoundedRectangleBorder(
                                                                    side: BorderSide(color: mTextFieldBorder),
                                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                                ),
                                                                offset: const Offset(1, 40),
                                                                decoration: customPopupDecoration(hintText:"Select Transmission", error: transError,isFocused: isTransmissionFocused),
                                                                itemBuilder: (BuildContext context) {
                                                                  return transmissionList.map<CustomPopupMenuItem<String>>((value) {
                                                                    return CustomPopupMenuItem(
                                                                      value: value,
                                                                      text: value,
                                                                      child: Container(),
                                                                    );
                                                                  }).toList();
                                                                },
                                                                onSelected: (String value) {
                                                                  setState(() {
                                                                    transmissionController.text = value;
                                                                    transMission = value;
                                                                    transError = false;
                                                                  });
                                                                },
                                                                onCanceled: () {

                                                                },
                                                                child: Container(),
                                                              );
                                                            },),
                                                        ),
                                                      ),
                                                      if(transError)
                                                        const Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 6,),
                                                              Text("Required",style: TextStyle(color:mErrorColor,fontSize: 12)),
                                                              SizedBox(height: 6,),
                                                            ],
                                                          ),
                                                        ),
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
                                                        width: 300,
                                                        child: TextFormField(
                                                          controller: modelNameController,
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
                                                          decoration: textFieldDecoration(hintText: "Model Name", error: modelNameError),
                                                        ),
                                                      ),
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
                                                        width: 300,
                                                        child: TextFormField(
                                                          controller: variantNameController,
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
                                                          decoration: textFieldDecoration(hintText: "Variant Name", error: variantNameError),
                                                        ),
                                                      ),
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
                                                        width: 300,
                                                        child: TextFormField(
                                                          controller: exShowRoomController,
                                                          keyboardType: TextInputType.number,
                                                          maxLength: 10,
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
                                                          decoration: textFieldDecoration(hintText: "Ex-Showroom Price", error: exShowError),
                                                        ),
                                                      ),
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
                                                      SizedBox(
                                                          width: 300,
                                                        child: Focus(
                                                          onFocusChange: (value) {
                                                            setState(() {
                                                              isColorFocused = value;
                                                            });
                                                          },
                                                          child: LayoutBuilder(
                                                          builder: (BuildContext context, BoxConstraints constraints) {
                                                            return CustomPopupMenuButton(
                                                              elevation: 4,
                                                              validator: (value) {
                                                                if(value == null || value.isEmpty){
                                                                  setState(() {
                                                                    colorError = true;
                                                                  });
                                                                  return null;
                                                                }
                                                                return null;
                                                              },
                                                              textController: colorController,
                                                              childWidth: constraints.maxWidth,
                                                              hintText: selectColor,
                                                              shape: const RoundedRectangleBorder(
                                                                side: BorderSide(color: mTextFieldBorder),
                                                                borderRadius: BorderRadius.all(Radius.circular(5))
                                                              ),
                                                              offset: const Offset(1, 40),
                                                              decoration: customPopupDecoration(hintText:"Select Color", error: colorError,isFocused: isColorFocused),
                                                              itemBuilder: (BuildContext context) {
                                                                return colorList.map<CustomPopupMenuItem<String>>((value) {
                                                                  return CustomPopupMenuItem(
                                                                    value: value,
                                                                    text: value,
                                                                    child: Container(),
                                                                  );
                                                                }).toList();
                                                              },
                                                              onSelected: (String value) {
                                                                setState(() {
                                                                  colorController.text = value;
                                                                  selectColor = value;
                                                                  colorError = false;
                                                                });
                                                              },
                                                              onCanceled: () {

                                                              },
                                                              child: Container(),
                                                            );
                                                          },),
                                                        ),
                                                      ),
                                                      if(colorError)
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(height: 6,),
                                                            Text("Required",style: TextStyle(color:mErrorColor,fontSize: 12)),
                                                            SizedBox(height: 6,),
                                                          ],
                                                        ),
                                                      ),
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
                                                        width: 300,
                                                        child: TextFormField(
                                                          controller: onRoadPriceController,
                                                          keyboardType: TextInputType.number,
                                                          maxLength: 10,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
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
                                                          decoration: textFieldDecoration(hintText: "Ex-Showroom Price", error: onRoadError),
                                                        ),
                                                      ),
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
                                          padding: const EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 40),
                                          child: Container(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                //  ----------tab bar--------
                                                Align(alignment: Alignment.topLeft,
                                                  child: SizedBox(
                                                    // width: 500,
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
                                                        padding: const EdgeInsets.only(top: 20,left: 10),
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        const Text("Type"),
                                                                        const SizedBox(height: 6,),
                                                                        SizedBox(
                                                                          width: 300,
                                                                          child: TextFormField(
                                                                            autofocus: true,
                                                                            validator: (value){
                                                                              if(value == null || value.isEmpty){
                                                                                setState(() {
                                                                                  typeError = true;
                                                                                });
                                                                                return 'Required';
                                                                              }
                                                                              else{
                                                                                setState(() {
                                                                                  typeError = false;
                                                                                });
                                                                              }
                                                                              return null;
                                                                            },
                                                                            controller: typeController,
                                                                            decoration: textFieldDecoration(hintText: "Type", error: typeError),
                                                                            onChanged: (value) {
                                                                              typeController.value = TextEditingValue(
                                                                                text: capitalizeFirstWord(value),
                                                                                selection: typeController.selection,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(width: 55,),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        const Text("Labour Type"),
                                                                        const SizedBox(height: 6,),
                                                                        SizedBox(
                                                                          width: 300,
                                                                          child: TextFormField(
                                                                            autofocus: true,
                                                                            validator: (value){
                                                                              if(value == null || value.isEmpty){
                                                                                setState(() {
                                                                                  labourTypeError = true;
                                                                                });
                                                                                return 'Required';
                                                                              }
                                                                              else{
                                                                                setState(() {
                                                                                  labourTypeError = false;
                                                                                });
                                                                              }
                                                                              return null;
                                                                            },
                                                                            controller: labourTypeController,
                                                                            decoration: textFieldDecoration(hintText: "Labour Type", error: labourTypeError),
                                                                            onChanged: (value) {
                                                                              labourTypeController.value = TextEditingValue(
                                                                                text: capitalizeFirstWord(value),
                                                                                selection: labourTypeController.selection,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(width: 55,),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        const Text("Vehicle Category Code"),
                                                                        const SizedBox(height: 6,),
                                                                        SizedBox(
                                                                          width: 300,
                                                                          child: TextFormField(
                                                                            autofocus: true,
                                                                            validator: (value){
                                                                              if(value == null || value.isEmpty){
                                                                                setState(() {
                                                                                  vehicleCodeError = true;
                                                                                });
                                                                                return 'Required';
                                                                              }
                                                                              else{
                                                                                setState(() {
                                                                                  vehicleCodeError = false;
                                                                                });
                                                                              }
                                                                              return null;
                                                                            },
                                                                            controller: vehicleCodeController,
                                                                            decoration: textFieldDecoration(hintText: "Vehicle Category Code", error: vehicleCodeError),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        const Text("Market Segment Code"),
                                                                        const SizedBox(height: 6,),
                                                                        SizedBox(
                                                                          width: 300,
                                                                          child: TextFormField(
                                                                            autofocus: true,
                                                                            validator: (value){
                                                                              if(value == null || value.isEmpty){
                                                                                setState(() {
                                                                                  marketSegmentError = true;
                                                                                });
                                                                                return 'Required';
                                                                              }
                                                                              else{
                                                                                setState(() {
                                                                                  marketSegmentError = false;
                                                                                });
                                                                              }
                                                                              return null;
                                                                            },
                                                                            controller: marketSegmentController,
                                                                            decoration: textFieldDecoration(hintText: "Market Segment Code", error: marketSegmentError),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(width: 55,),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        const Text("Vehicle Type Code"),
                                                                        const SizedBox(height: 6,),
                                                                        SizedBox(
                                                                          width: 300,
                                                                          child: TextFormField(
                                                                            autofocus: true,
                                                                            validator: (value){
                                                                              if(value == null || value.isEmpty){
                                                                                setState(() {
                                                                                  vehicleTypeCodeError = true;
                                                                                });
                                                                                return 'Required';
                                                                              }
                                                                              else{
                                                                                setState(() {
                                                                                  vehicleTypeCodeError = false;
                                                                                });
                                                                              }
                                                                              return null;
                                                                            },
                                                                            controller: vehicleTypeCodeController,
                                                                            decoration: textFieldDecoration(hintText: "Vehicle Type Code", error: vehicleTypeCodeError),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
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
                                                                    const Text("Engine Type Code"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              engineTypeError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              engineTypeError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: engineType,
                                                                        decoration: textFieldDecoration(hintText: "Engine Type Code", error: engineTypeError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //----------Emission--------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Emission Standard Code"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              emissionError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              emissionError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: emission,
                                                                        decoration: textFieldDecoration(hintText: "Emission Standard Code", error: emissionError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //-------Emission Test------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Emission Test Category Code"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              emissionTestError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              emissionTestError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: emissionTest,
                                                                        decoration: textFieldDecoration(hintText: "Emission Test Category Code", error: emissionTestError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Transmission Type Code"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              transmissionError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              transmissionError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: transmission,
                                                                        decoration: textFieldDecoration(hintText: "Transmission Type Code", error: transmissionError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //---------power-------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Power (KW)"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.digitsOnly
                                                                        ],
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              powerKwError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              powerKwError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: powerKw,
                                                                        decoration: textFieldDecoration(hintText: "Power (KW)", error: powerKwError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //---------power (hp)--------
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Power (HP)"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.digitsOnly
                                                                        ],
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              powerHpError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              powerHpError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: powerHp,
                                                                        decoration: textFieldDecoration(hintText: "Power (HP)", error: powerHpError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Top Speed"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.digitsOnly
                                                                        ],
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              topSpeedError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              topSpeedError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: topSpeed,
                                                                        decoration: textFieldDecoration(hintText: "Top Speed", error: topSpeedError),
                                                                      ),
                                                                    ),
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
                                                                      const Text("Acceleration"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                accelerationError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                accelerationError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: acceleration,
                                                                          decoration: textFieldDecoration(hintText: "Acceleration", error: accelerationError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  //--------cylinder typical.---------
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Cylinder Capacity (Ccn)"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                cylinderError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                cylinderError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: cylinderCapacity,
                                                                          decoration: textFieldDecoration(hintText: "Cylinder Capacity (Ccn)", error: cylinderError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("No.Of Cylinder"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                numberCylinderError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                numberCylinderError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: noCylinder,
                                                                          decoration: textFieldDecoration(hintText: "No.Of Cylinder", error: numberCylinderError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  //--------no of door.---------
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("No.Of Door"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                doorError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                doorError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: door,
                                                                          decoration: textFieldDecoration(hintText: "No.Of Door", error: doorError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  //--------tires.------
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Tires"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                tiresError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                tiresError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: tires,
                                                                          decoration: textFieldDecoration(hintText: "Tires", error: tiresError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Total Weight(KG)"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                weightError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                weightError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: weight,
                                                                          decoration: textFieldDecoration(hintText: "Total Weight(KG)", error: weightError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  //-------roof load-----
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("RoofLoad(Kg)"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                roofError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                roofError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: roof,
                                                                          decoration: textFieldDecoration(hintText: "RoofLoad(Kg)", error: roofError),
                                                                        ),
                                                                      ),
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
                                                                      const Text("Empty Weight(Kg)"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                emptyWeightError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                emptyWeightError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: emptyWeight,
                                                                          decoration: textFieldDecoration(hintText: "Empty Weight(Kg)", error: emptyWeightError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Rear Axle Load(Kg)"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                rearAxleError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                rearAxleError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: rearAxle,
                                                                          decoration: textFieldDecoration(hintText: "Rear Axle Load(Kg)", error: rearAxleError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  //--------front axle.--------
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Front Axle Load(Kg)"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                frontAxleError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                frontAxleError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: frontAxle,
                                                                          decoration: textFieldDecoration(hintText: "Front Axle Load(Kg)", error: frontAxleError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  //------trailer load.-----
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Trailer Load"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                trailerError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                trailerError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: trailerLoad,
                                                                          decoration: textFieldDecoration(hintText: "Trailer Load", error: trailerError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Trailer Tongue Load"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                trailerTongueError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                trailerTongueError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: trailerTongue,
                                                                          decoration: textFieldDecoration(hintText: "Trailer Tongue Load", error: trailerTongueError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  //------axles.-------
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("No.Of Axles"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                axlesError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                axlesError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: axles,
                                                                          decoration: textFieldDecoration(hintText: "No.Of Axles", error: axlesError),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 10,),
                                                                  //------wheel Base----
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Wheel Base"),
                                                                      const SizedBox(height: 6,),
                                                                      SizedBox(
                                                                        width: 300,
                                                                        child: TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly
                                                                          ],
                                                                          autofocus: true,
                                                                          validator: (value){
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                wheelError = true;
                                                                              });
                                                                              return 'Required';
                                                                            }
                                                                            else{
                                                                              setState(() {
                                                                                wheelError = false;
                                                                              });
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller: wheel,
                                                                          decoration: textFieldDecoration(hintText: "Wheel Base", error: wheelError),
                                                                        ),
                                                                      ),
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
                                                                    const Text("Preferred Vendor"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              preferredError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              preferredError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: preferredVendorController,
                                                                        decoration: textFieldDecoration(hintText: "Preferred Vendor", error: preferredError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Unit Cost"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.digitsOnly
                                                                        ],
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              unitCostError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              unitCostError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: unitCostController,
                                                                        decoration: textFieldDecoration(hintText: "Unit Cost", error: unitCostError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Last Direct Cost"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.digitsOnly
                                                                        ],
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              lastCostError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              lastCostError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: lastCostController,
                                                                        decoration: textFieldDecoration(hintText: "Last Direct Cost", error: lastCostError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Last Purchase Date"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        autofocus: true,
                                                                        controller: purchaseDateController,
                                                                        decoration: textFieldDecoration(hintText: "Last Purchase Date"),
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
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Unit Price"),
                                                                    const SizedBox(height: 6,),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: TextFormField(
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.digitsOnly
                                                                        ],
                                                                        autofocus: true,
                                                                        validator: (value){
                                                                          if(value == null || value.isEmpty){
                                                                            setState(() {
                                                                              unitPriceError = true;
                                                                            });
                                                                            return 'Required';
                                                                          }
                                                                          else{
                                                                            setState(() {
                                                                              unitPriceError = false;
                                                                            });
                                                                          }
                                                                          return null;
                                                                        },
                                                                        controller: unitPriceController,
                                                                        decoration: textFieldDecoration(hintText: "Last Direct Cost", error: unitPriceError),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text("Unit Price"),
                                                                    const SizedBox(height: 6,),
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
                                                                    // ),
                                                                    SizedBox(
                                                                      width: 300,
                                                                      child: Focus(
                                                                          onFocusChange: (value) {
                                                                            setState(() {
                                                                              isPriceListFocused = value;
                                                                            });
                                                                          },
                                                                          child: LayoutBuilder(
                                                                        builder: (BuildContext context, BoxConstraints constraints) {
                                                                        return CustomPopupMenuButton(
                                                                          elevation: 4,
                                                                          validator: (value) {
                                                                            if(value == null || value.isEmpty){
                                                                              setState(() {
                                                                                priceListError = true;
                                                                              });
                                                                              return null;
                                                                            }
                                                                            return null;
                                                                          },
                                                                          textController: priceListController,
                                                                          childWidth: constraints.maxWidth,
                                                                          hintText: price,
                                                                          shape: const RoundedRectangleBorder(
                                                                              side: BorderSide(color: mTextFieldBorder),
                                                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                                                          ),
                                                                          offset: const Offset(1, 40),
                                                                          decoration: customPopupDecoration(hintText:"Select Transmission", error: priceListError,isFocused: isPriceListFocused),
                                                                          itemBuilder: (BuildContext context) {
                                                                            return _priceList.map<CustomPopupMenuItem<String>>((value) {
                                                                              return CustomPopupMenuItem(
                                                                                value: value,
                                                                                text: value,
                                                                                child: Container(),
                                                                              );
                                                                            }).toList();
                                                                          },
                                                                        );
                                                                      },)
                                                                      ),
                                                                    ),
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
              ),
            ),
          )
        ],
      ),
    );
  }

  customPopupDecoration({required String hintText, bool? error, bool? isFocused}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isFocused == true ? Colors.blue : error == true ? mErrorColor : mTextFieldBorder)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: error == true ? mErrorColor : mTextFieldBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: error == true ? mErrorColor : Colors.blue)),
    );
  }

  String capitalizeFirstWord(String value){
    if(value.isNotEmpty){
      var result =value[0].toUpperCase();
      for(int i=1;i<value.length;i++){
        if(value[i-1]=='1'){
          result=result+value[i].toUpperCase();
        }
        else{
          result=result+value[i];
        }
      }
      return result;
    }
    return "";
  }
}
