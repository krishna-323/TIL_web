

import 'package:flutter/material.dart';
import 'package:new_project/widgets/motows_buttons/outlined_mbutton.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/input_decoration_text_field.dart';
class AddNewVehicles extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const AddNewVehicles({Key? key,required this.drawerWidth, required this.selectedDestination}) : super(key: key);

  @override
  State<AddNewVehicles> createState() => _AddVehiclesState();
}

class _AddVehiclesState extends State<AddNewVehicles> {

  var brandController = TextEditingController();
  var nameController = TextEditingController();
  var colorController1 = TextEditingController();
  var colorController2 = TextEditingController();
  var colorController3 = TextEditingController();
  var colorController4 = TextEditingController();
  var colorController5 = TextEditingController();
  var engineController1 = TextEditingController();
  var engineController2 = TextEditingController();
  var engineController3 = TextEditingController();
  var engineController4 = TextEditingController();
  var typeController = TextEditingController();
  var transmissionController1 = TextEditingController();
  var transmissionController2 = TextEditingController();
  var transmissionController3 = TextEditingController();
  var transmissionController4 = TextEditingController();
  var imageController = TextEditingController();
  String engineType='Select Engine Type';

  List <CustomPopupMenuEntry<String>> customerTypes =<CustomPopupMenuEntry<String>>[

    const CustomPopupMenuItem(height: 30,
      value: 'Petrol',
      child: Center(child: SizedBox(width: 350,child: Text('Petrol',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 30,
      value: 'Diesel',
      child: Center(child: SizedBox(width: 350,child: Text('Diesel',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 30,
      value: 'EV',
      child: Center(child: SizedBox(width: 350,child: Text('EV',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    )
  ];
  List <String> engineList = [
    "Petrol",
    "Diesel",
    "EV",
  ];
  List <String> transType = [
    "Automatic Transmission",
    "Manual Transmission",
    "Automated Manual Transmission",
    "Continuously Variable Transmission",
  ];
  List <String> transType1 = [
    "Automatic Transmission",
    "Manual Transmission",
    "Automated Manual Transmission",
    "Continuously Variable Transmission",
  ];
  List <String> transType2 = [
    "Automatic Transmission",
    "Manual Transmission",
    "Automated Manual Transmission",
    "Continuously Variable Transmission",
  ];
  List <String> transType3 = [
    "Automatic Transmission",
    "Manual Transmission",
    "Automated Manual Transmission",
    "Continuously Variable Transmission",
  ];
  String engine = "--Select--";
  final _engineList = [
    'Petrol',
    'Diesel',
    'EV',
    'Hybrid',
  ];
  var engine1 = "--Select--";
  final _engineList1 = [
    'Petrol',
    'Diesel',
    'EV',
    'Hybrid',
  ];
  var engine2 = "--Select--";
  final _engineList2 = [
    'Petrol',
    'Diesel',
    'EV',
    'Hybrid',
  ];
  var engine3 = "--Select--";
  final _engineList3 = [
    'Petrol',
    'Diesel',
    'EV',
    'Hybrid',
  ];

  void engineDisplay(String? ed){
    setState(() {
      engine = ed!;
    });
  }
  void engineDisplay1(String? ed1){
    setState(() {
      engine1 = ed1!;
    });
  }
  void engineDisplay2(String? ed2){
    setState(() {
      engine2 = ed2!;
    });
  }
  void engineDisplay3(String? ed3){
    setState(() {
      engine3 = ed3!;
    });
  }


  Transmission? trans0;
  final _transList0 = <Transmission>[
    Transmission(key: 'AT', value: 'Automatic Transmission'),
    Transmission(key: 'MT', value: 'Manual Transmission'),
    Transmission(key: 'AMT', value: 'Automated Manual Transmission'),
    Transmission(key: 'CVT', value: 'Continuously Variable Transmission')
  ].cast<String>();
  Transmission? trans;
  final _transList = <Transmission>[
    Transmission(key: 'AT', value: 'Automatic Transmission'),
    Transmission(key: 'MT', value: 'Manual Transmission'),
    Transmission(key: 'AMT', value: 'Automated Manual Transmission'),
    Transmission(key: 'CVT', value: 'Continuously Variable Transmission')
  ];
  Transmission? trans1;
  final _transList1 = <Transmission>[
    Transmission(key: 'AT', value: 'Automatic Transmission'),
    Transmission(key: 'MT', value: 'Manual Transmission'),
    Transmission(key: 'AMT', value: 'Automated Manual Transmission'),
    Transmission(key: 'CVT', value: 'Continuously Variable Transmission')
  ];
  Transmission? trans2;
  final _transList2 = <Transmission>[
    Transmission(key: 'AT', value: 'Automatic Transmission'),
    Transmission(key: 'MT', value: 'Manual Transmission'),
    Transmission(key: 'AMT', value: 'Automated Manual Transmission'),
    Transmission(key: 'CVT', value: 'Continuously Variable Transmission')
  ];


  String? authToken;

  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }


  Future addNewVehicles(Map<dynamic, dynamic> data)async{
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/add_new_vehicle";
    postData(context: context,url: url,requestBody: data).then((value) {
      setState(() {
        if(value!=null){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Saved")));
          Navigator.of(context).pop();
          // print('---------------');
        }
      });
    });
  }


  @override
  void initState(){
    getInitialData();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    try{
    }
    catch(e){}
  }

  bool brandError = false;
  bool nameError = false;
  bool colorError1 = false;
  bool colorError2 = false;
  bool colorError3 = false;
  bool colorError4 = false;
  bool colorError5 = false;
  bool engineError1 = false;
  bool engineError2 = false;
  bool engineError3 = false;
  bool engineError4 = false;
  bool typeError = false;
  bool isTypeFocused = false;
  bool isTransFocused = false;
  bool isTransFocused1 = false;
  bool isTransFocused2 = false;
  bool isTransFocused3 = false;
  bool transmissionError1 = false;
  bool transmissionError2 = false;
  bool transmissionError3 = false;
  bool transmissionError4 = false;
  bool imageUploadError = false;

  // List colorData = [0];

  final _addVehiclesForm = GlobalKey<FormState>();
  var size,width,height;
  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size;
    width=size.width;
    height=size.height;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
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
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(88.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: AppBar(
                      elevation: 1,
                      surfaceTintColor: Colors.white,
                      shadowColor: Colors.black,
                      title: const Text("New Vehicle"),
                      actions: [
                        Row(
                          children:  [
                            Padding(
                              padding: const EdgeInsets.only(right: 20,top: 8,bottom: 8),
                              child: SizedBox(
                                width: 100,
                                height: 28,
                                child: OutlinedMButton(
                                  text: 'Save',
                                  textColor: mSaveButton,
                                  borderColor: mSaveButton,
                                  onTap: () {
                                    if(_addVehiclesForm.currentState!.validate()){
                                      Map _addVehiclePage = {
                                        "brand": brandController.text,
                                        "name": nameController.text,
                                        "color1":colorController1.text,
                                        "color2":colorController2.text,
                                        "color3":colorController3.text,
                                        "color4":colorController4.text,
                                        "color5":colorController5.text,
                                        "engine_1":engineType,
                                        "engine_2":"",
                                        "engine_3":"",
                                        "engine_4":"",
                                        "transmission_1":engine,
                                        "transmission_2":engine1,
                                        "transmission_3":engine2,
                                        "transmission_4":engine3,
                                      };
                                      // print(_addVehiclePage);
                                      addNewVehicles(_addVehiclePage);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _addVehiclesForm,
                  child: FocusTraversalGroup(
                    policy: OrderedTraversalPolicy(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 50),
                          child: Container(
                            // width: 800,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: mTextFieldBorder.withOpacity(0.8),
                                width: 1
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 30, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Brand"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 300,
                                            child: TextFormField(
                                              autofocus: true,
                                              validator: (value){
                                                if(value == null || value.isEmpty){
                                                  setState(() {
                                                    brandError = true;
                                                  });
                                                  return 'Required';
                                                }
                                                else{
                                                  setState(() {
                                                    brandError = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              controller: brandController,
                                              decoration: textFieldDecoration(hintText: "Brand", error: brandError),
                                              onChanged: (value) {
                                                brandController.value = TextEditingValue(
                                                  text: capitalizeFirstWord(value),
                                                  selection: brandController.selection,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 20,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Name"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 300,
                                            child: TextFormField(
                                              autofocus: true,
                                              validator: (value){
                                                if(value == null || value.isEmpty){
                                                  setState(() {
                                                    nameError = true;
                                                  });
                                                  return 'Required';
                                                }
                                                else{
                                                  setState(() {
                                                    nameError = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              controller: nameController,
                                              decoration: textFieldDecoration(hintText: "Name", error: nameError),
                                              onChanged: (value) {
                                                nameController.value = TextEditingValue(
                                                  text: capitalizeFirstWord(value),
                                                  selection: nameController.selection,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Color 1"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 150,
                                            child: TextFormField(
                                              autofocus: true,
                                              validator: (value){
                                                if(value == null || value.isEmpty){
                                                  setState(() {
                                                    colorError1 = true;
                                                  });
                                                  return 'Required';
                                                }
                                                else{
                                                  setState(() {
                                                    colorError1 = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              controller: colorController1,
                                              decoration: textFieldDecoration(hintText: "Color 1", error: colorError1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Color 2"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 150,
                                            child: TextFormField(
                                              autofocus: true,
                                              controller: colorController2,
                                              decoration: textFieldDecoration(hintText: "Color 2", error: colorError2),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Color 3"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 150,
                                            child: TextFormField(
                                              autofocus: true,
                                              controller: colorController3,
                                              decoration: textFieldDecoration(hintText: "Color 3", error: colorError3),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Color 4"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 150,
                                            child: TextFormField(
                                              autofocus: true,
                                              controller: colorController4,
                                              decoration: textFieldDecoration(hintText: "Color 4", error: colorError4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Color 5"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 150,
                                            child: TextFormField(
                                              autofocus: true,
                                              controller: colorController5,
                                              decoration: textFieldDecoration(hintText: "Color 5", error: colorError5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  const Text("Engine"),
                                  const SizedBox(height: 6,),
                                  SizedBox(
                                    width: 300,
                                    child: Focus(
                                      onFocusChange: (value) {
                                        setState(() {
                                          isTypeFocused = value;
                                        });
                                      },
                                      skipTraversal: true,
                                      descendantsAreFocusable: true,
                                      child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints) {
                                            return CustomPopupMenuButton(elevation: 4,
                                              validator: (value) {
                                                if(value==null||value.isEmpty){
                                                  setState(() {
                                                    typeError=true;
                                                  });
                                                  return null;
                                                }
                                                return null;
                                              },
                                              decoration: customPopupDecoration(hintText: 'Select Engine Type',error: typeError,isFocused: isTypeFocused),
                                              hintText: engineType,
                                              textController: typeController,
                                              childWidth: constraints.maxWidth,
                                              shape:  RoundedRectangleBorder(
                                                side: BorderSide(color:typeError? Colors.redAccent :mTextFieldBorder),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              offset: const Offset(1, 40),
                                              tooltip: '',
                                              itemBuilder:  (BuildContext context) {
                                                return engineList.map((value) {
                                                  return CustomPopupMenuItem(
                                                    value: value,
                                                    text:value,
                                                    child: Container(),
                                                  );
                                                }).toList();
                                              },
                                              onSelected: (String value)  {
                                                setState(() {
                                                  typeController.text=value;
                                                  engineType = value;
                                                  typeError=false;
                                                });
                                              },
                                              onCanceled: () {
                                              },
                                              child: Container(),
                                            );
                                          }
                                      ),
                                    ),
                                  ),
                                  if(typeError)
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
                                  const SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Transmission 1"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 300,
                                            child: Focus(
                                              onFocusChange: (value) {
                                                setState(() {
                                                  isTransFocused = value;
                                                });
                                              },
                                              skipTraversal: true,
                                              descendantsAreFocusable: true,
                                              child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    return CustomPopupMenuButton(
                                                      elevation: 4,
                                                      validator: (value) {
                                                        if(value==null||value.isEmpty){
                                                          setState(() {
                                                            transmissionError1 = true;
                                                          });
                                                          return null;
                                                        }
                                                        return null;
                                                      },
                                                      decoration: customPopupDecoration(hintText: '--Select--',error: transmissionError1,isFocused: isTransFocused),
                                                      hintText: engine,
                                                      textController: transmissionController1,
                                                      childWidth: constraints.maxWidth,
                                                      shape:  RoundedRectangleBorder(
                                                        side: BorderSide(color:transmissionError1 ? Colors.redAccent :mTextFieldBorder),
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      offset: const Offset(1, 40),
                                                      tooltip: '',
                                                      itemBuilder:  (BuildContext context) {
                                                        return transType.map((value) {
                                                          return CustomPopupMenuItem(
                                                            value: value,
                                                            text:value,
                                                            child: Container(),
                                                          );
                                                        }).toList();
                                                      },

                                                      onSelected: (String value)  {
                                                        setState(() {
                                                          transmissionController1.text=value;
                                                          engine = value;
                                                          transmissionError1 = false;
                                                        });

                                                      },
                                                      onCanceled: () {

                                                      },
                                                      child: Container(),
                                                    );
                                                  }
                                              ),
                                            ),
                                          ),
                                          if(transmissionError1)
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
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Transmission 2"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 300,
                                            child: Focus(
                                              onFocusChange: (value) {
                                                setState(() {
                                                  isTransFocused1 = value;
                                                });
                                              },
                                              skipTraversal: true,
                                              descendantsAreFocusable: true,
                                              child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    return CustomPopupMenuButton(
                                                      elevation: 4,
                                                      decoration: customPopupDecoration(hintText: '--Select--',error: transmissionError2,isFocused: isTransFocused1),
                                                      hintText: engine1,
                                                      textController: transmissionController2,
                                                      childWidth: constraints.maxWidth,
                                                      shape:  RoundedRectangleBorder(
                                                        side: BorderSide(color:transmissionError2 ? Colors.redAccent :mTextFieldBorder),
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      offset: const Offset(1, 40),
                                                      tooltip: '',
                                                      itemBuilder:  (BuildContext context) {
                                                        return transType1.map((value) {
                                                          return CustomPopupMenuItem(
                                                            value: value,
                                                            text:value,
                                                            child: Container(),
                                                          );
                                                        }).toList();
                                                      },

                                                      onSelected: (String value)  {
                                                        setState(() {
                                                          transmissionController2.text=value;
                                                          engine1 = value;
                                                          transmissionError2 = false;
                                                        });

                                                      },
                                                      onCanceled: () {

                                                      },
                                                      child: Container(),
                                                    );
                                                  }
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Transmission 3"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 300,
                                            child: Focus(
                                              onFocusChange: (value) {
                                                setState(() {
                                                  isTransFocused2 = value;
                                                });
                                              },
                                              skipTraversal: true,
                                              descendantsAreFocusable: true,
                                              child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    return CustomPopupMenuButton(
                                                      elevation: 4,
                                                      decoration: customPopupDecoration(hintText: '--Select--',error: transmissionError3,isFocused: isTransFocused2),
                                                      hintText: engine2,
                                                      textController: transmissionController3,
                                                      childWidth: constraints.maxWidth,
                                                      shape:  RoundedRectangleBorder(
                                                        side: BorderSide(color:transmissionError2 ? Colors.redAccent :mTextFieldBorder),
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      offset: const Offset(1, 40),
                                                      tooltip: '',
                                                      itemBuilder:  (BuildContext context) {
                                                        return transType2.map((value) {
                                                          return CustomPopupMenuItem(
                                                            value: value,
                                                            text:value,
                                                            child: Container(),
                                                          );
                                                        }).toList();
                                                      },

                                                      onSelected: (String value)  {
                                                        setState(() {
                                                          transmissionController3.text=value;
                                                          engine2 = value;
                                                          transmissionError3 = false;
                                                        });

                                                      },
                                                      onCanceled: () {

                                                      },
                                                      child: Container(),
                                                    );
                                                  }
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Transmission 4"),
                                          const SizedBox(height: 6,),
                                          SizedBox(
                                            width: 300,
                                            child: Focus(
                                              onFocusChange: (value) {
                                                setState(() {
                                                  isTransFocused3 = value;
                                                });
                                              },
                                              skipTraversal: true,
                                              descendantsAreFocusable: true,
                                              child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    return CustomPopupMenuButton(
                                                      elevation: 4,
                                                      decoration: customPopupDecoration(hintText: '--Select--',error: transmissionError4,isFocused: isTransFocused3),
                                                      hintText: engine3,
                                                      textController: transmissionController4,
                                                      childWidth: constraints.maxWidth,
                                                      shape:  RoundedRectangleBorder(
                                                        side: BorderSide(color:transmissionError4 ? Colors.redAccent :mTextFieldBorder),
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      offset: const Offset(1, 40),
                                                      tooltip: '',
                                                      itemBuilder:  (BuildContext context) {
                                                        return transType3.map((value) {
                                                          return CustomPopupMenuItem(
                                                            value: value,
                                                            text:value,
                                                            child: Container(),
                                                          );
                                                        }).toList();
                                                      },

                                                      onSelected: (String value)  {
                                                        setState(() {
                                                          transmissionController4.text=value;
                                                          engine3 = value;
                                                          transmissionError4 = false;
                                                        });

                                                      },
                                                      onCanceled: () {

                                                      },
                                                      child: Container(),
                                                    );
                                                  }
                                              ),
                                            ),
                                          ),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  customPopupDecoration ({required String hintText, bool? error, bool? isFocused}){
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

class Transmission {
  final String key;
  final String value;
  Transmission({required this.key, required this.value});
}


