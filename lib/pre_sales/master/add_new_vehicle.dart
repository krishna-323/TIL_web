

import 'package:flutter/material.dart';

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
  var imageController = TextEditingController();
  String engineType='Select Customer Type';

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

  var engine = "--Select--";
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
  ];
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

              body: SingleChildScrollView(
                child: Form(
                  key: _addVehiclesForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color(0xffF4FAFF),
                        child: Column(
                          children: [
                            //-----top container--------
                            Container(
                              height: 60,
                              color: Colors.white,
                              child: Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(top:20.0,bottom: 20,left:50),
                                    child: Text("New Vehicle",style: TextStyle(color: Colors.indigo,fontSize: 18),),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            if(width>800)
                              Padding(
                                padding: const EdgeInsets.only(left:50.0,right:50,top:30),
                                child: Column(
                                  children: [
                                    Row(
                                      children:  [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Brand'),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: brandError ? 55:30,
                                            child: TextFormField(
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
                                              style: const TextStyle(fontSize: 14),
                                              controller: brandController,
                                              decoration: decorationInput5('Enter Brand', brandController.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children:  [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Name'),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: nameError ? 55:30,
                                            child: TextFormField(
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
                                              style: const TextStyle(fontSize: 14),
                                              controller: nameController,
                                              decoration: decorationInput5('Enter Name', nameController.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children:  [
                                        const SizedBox(
                                          width: 170,
                                          child: Text('Color'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 140,
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: colorError1 ? 55:30,
                                                  child: TextFormField(
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
                                                    style: const TextStyle(fontSize: 14),
                                                    controller: colorController1,
                                                    decoration: decorationInput5('Color 1', colorController1.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                              SizedBox(
                                                width: 140,
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: colorError2 ? 55:30,
                                                  child: TextFormField(
                                                    style: const TextStyle(fontSize: 14),
                                                    controller: colorController2,
                                                    decoration: decorationInput5('Color 2', colorController2.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                              SizedBox(
                                                width: 140,
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: colorError3 ? 55:30,
                                                  child: TextFormField(
                                                    style: const TextStyle(fontSize: 14),
                                                    controller: colorController3,
                                                    decoration: decorationInput5('Color 3', colorController3.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                              SizedBox(
                                                width: 140,
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: colorError4 ? 55:30,
                                                  child: TextFormField(
                                                    style: const TextStyle(fontSize: 14),
                                                    controller: colorController4,
                                                    decoration: decorationInput5('Color 4', colorController4.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                              SizedBox(
                                                width: 140,
                                                child: AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: colorError5 ? 55:30,
                                                  child: TextFormField(
                                                    style: const TextStyle(fontSize: 14),
                                                    controller: colorController5,
                                                    decoration: decorationInput5('Color 5', colorController5.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children:  [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Engine'),
                                        ),
                                        Row(
                                          children: [

                                            SizedBox(width: 200,
                                              child: CustomPopupMenuButton<String>( childWidth: 385,position: CustomPopupMenuPosition.under,
                                                decoration: customPopupDecoration(hintText: engineType),
                                                hintText: engineType,
                                                shape: const RoundedRectangleBorder(
                                                  side: BorderSide(color:Color(0xFFE0E0E0)),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                offset: const Offset(1, 12),
                                                tooltip: '',
                                                itemBuilder: (context) {
                                                  return customerTypes;
                                                },
                                                onSelected: (String value)  {
                                                  setState(() {
                                                    print(value);
                                                    engineType= value;

                                                  });
                                                },
                                                onCanceled: () {

                                                },
                                                child: Container(height: 30,width: 200,
                                                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 4),
                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(width: 150,child: Center(child: Text(engineType,style: TextStyle(color: Colors.grey[700],fontSize: 14,),maxLines: 1))),
                                                        const Icon(Icons.arrow_drop_down,color: Colors.grey,size: 14,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   color: Colors.white,
                                            //   width: 140,
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
                                            // const SizedBox(width: 20,),
                                            // Container(
                                            //   color: Colors.white,
                                            //   width: 140,
                                            //   child: AnimatedContainer(
                                            //     duration: const Duration(seconds: 0),
                                            //     height: engineError2 ? 50 : 30,
                                            //     child: DropdownSearch<String>(
                                            //       // validator: (value) {
                                            //       //   if (value == null ||
                                            //       //       value.isEmpty) {
                                            //       //     setState(() {
                                            //       //       engineError2 = true;
                                            //       //     });
                                            //       //     return "Required";
                                            //       //   } else {
                                            //       //     setState(() {
                                            //       //       engineError2 = false;
                                            //       //     });
                                            //       //   }
                                            //       // },
                                            //       popupProps: PopupProps.menu(
                                            //         constraints: const BoxConstraints(
                                            //             maxHeight: 200),
                                            //         showSearchBox: false,
                                            //         showSelectedItems: true,
                                            //         searchFieldProps: TextFieldProps(
                                            //           decoration:
                                            //           dropdownDecorationSearch(
                                            //               engine1.isNotEmpty),
                                            //           cursorColor: Colors.grey,
                                            //           style: const TextStyle(
                                            //             fontSize: 14,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       items: _engineList1,
                                            //       selectedItem: engine1,
                                            //       onChanged: engineDisplay1,
                                            //     ),
                                            //   ),
                                            // ),
                                            // const SizedBox(width: 20,),
                                            // Container(
                                            //   color: Colors.white,
                                            //   width: 140,
                                            //   child: AnimatedContainer(
                                            //     duration: const Duration(seconds: 0),
                                            //     height: engineError3 ? 50 : 30,
                                            //     child: DropdownSearch<String>(
                                            //       // validator: (value) {
                                            //       //   if (value == null ||
                                            //       //       value.isEmpty) {
                                            //       //     setState(() {
                                            //       //       engineError3 = true;
                                            //       //     });
                                            //       //     return "Required";
                                            //       //   } else {
                                            //       //     setState(() {
                                            //       //       engineError3 = false;
                                            //       //     });
                                            //       //   }
                                            //       // },
                                            //       popupProps: PopupProps.menu(
                                            //         constraints: const BoxConstraints(
                                            //             maxHeight: 200),
                                            //         showSearchBox: false,
                                            //         showSelectedItems: true,
                                            //         searchFieldProps: TextFieldProps(
                                            //           decoration:
                                            //           dropdownDecorationSearch(
                                            //               engine2.isNotEmpty),
                                            //           cursorColor: Colors.grey,
                                            //           style: const TextStyle(
                                            //             fontSize: 14,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       items: _engineList2,
                                            //       selectedItem: engine2,
                                            //       onChanged: engineDisplay2,
                                            //     ),
                                            //   ),
                                            // ),
                                            // const SizedBox(width: 20,),
                                            // Container(
                                            //   color: Colors.white,
                                            //   width: 140,
                                            //   child: AnimatedContainer(
                                            //     duration: const Duration(seconds: 0),
                                            //     height: engineError4 ? 50 : 30,
                                            //     child: DropdownSearch<String>(
                                            //       // validator: (value) {
                                            //       //   if (value == null ||
                                            //       //       value.isEmpty) {
                                            //       //     setState(() {
                                            //       //       engineError4 = true;
                                            //       //     });
                                            //       //     return "Required";
                                            //       //   } else {
                                            //       //     setState(() {
                                            //       //       engineError4 = false;
                                            //       //     });
                                            //       //   }
                                            //       // },
                                            //       popupProps: PopupProps.menu(
                                            //         constraints: const BoxConstraints(
                                            //             maxHeight: 200),
                                            //         showSearchBox: false,
                                            //         showSelectedItems: true,
                                            //         searchFieldProps: TextFieldProps(
                                            //           decoration:
                                            //           dropdownDecorationSearch(
                                            //               engine3.isNotEmpty),
                                            //           cursorColor: Colors.grey,
                                            //           style: const TextStyle(
                                            //             fontSize: 14,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       items: _engineList3,
                                            //       selectedItem: engine3,
                                            //       onChanged: engineDisplay3,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children:  [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Transmission'),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              width: 140,
                                              child: AnimatedContainer(
                                                duration: const Duration(seconds: 0),
                                                height: transmissionError1 ? 50 : 30,
                                                child: DropdownButtonFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.toString().isEmpty) {
                                                      setState(() {
                                                        transmissionError1 = true;
                                                      });
                                                      return "Required";
                                                    } else {
                                                      setState(() {
                                                        transmissionError1 = false;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  hint: const Text('--Select--'),
                                                  decoration: dropdownDecorationSearch(trans0.toString().isNotEmpty),
                                                  items: _transList0.map((Transmission value){
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text("${value.value}, ${value.key}"),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) => setState(() {
                                                    trans0 = value as Transmission?;
                                                  }),
                                                  selectedItemBuilder: (context) {
                                                    return _transList0.map((e) {
                                                      return Text(e.key);
                                                    }).toList();
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20,),
                                            Container(
                                              color: Colors.white,
                                              width: 140,
                                              child: AnimatedContainer(
                                                duration: const Duration(seconds: 0),
                                                height: transmissionError2 ? 50 : 30,
                                                child: DropdownButtonFormField(
                                                  hint: const Text('--Select--'),
                                                  decoration: dropdownDecorationSearch(trans.toString().isNotEmpty),
                                                  items: _transList.map((Transmission value){
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text("${value.value}, ${value.key}"),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) => setState(() {
                                                    trans = value as Transmission?;
                                                  }),
                                                  selectedItemBuilder: (context) {
                                                    return _transList.map((e) {
                                                      return Text(e.key);
                                                    }).toList();
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20,),
                                            Container(
                                              color: Colors.white,
                                              width: 140,
                                              child: AnimatedContainer(
                                                duration: const Duration(seconds: 0),
                                                height: transmissionError3 ? 50 : 30,
                                                child: DropdownButtonFormField(
                                                  hint: const Text('--Select--'),
                                                  decoration: dropdownDecorationSearch(trans1.toString().isNotEmpty),
                                                  items: _transList1.map((Transmission value){
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text("${value.value}, ${value.key}"),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) => setState(() {
                                                    trans1 = value as Transmission?;
                                                  }),
                                                  selectedItemBuilder: (context) {
                                                    return _transList1.map((e) {
                                                      return Text(e.key);
                                                    }).toList();
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20,),
                                            Container(
                                              color: Colors.white,
                                              width: 140,
                                              child: AnimatedContainer(
                                                duration: const Duration(seconds: 0),
                                                height: transmissionError4 ? 50 : 30,
                                                child: DropdownButtonFormField(
                                                  hint: const Text('--Select--'),
                                                  decoration: dropdownDecorationSearch(trans2.toString().isNotEmpty),
                                                  items: _transList2.map((Transmission value){
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text("${value.value}, ${value.key}"),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) => setState(() {
                                                    trans2 = value as Transmission?;
                                                  }),
                                                  selectedItemBuilder: (context) {
                                                    return _transList2.map((e) {
                                                      return Text(e.key);
                                                    }).toList();
                                                  },
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
                            if(width<800)
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Brand'),
                                        ),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: brandError ? 55:30,
                                            child: TextFormField(
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
                                              style: const TextStyle(fontSize: 14),
                                              controller: brandController,
                                              decoration: decorationInput5('', brandController.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Name'),
                                        ),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: nameError ? 55:30,
                                            child: TextFormField(
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
                                              style: const TextStyle(fontSize: 14),
                                              controller: nameController,
                                              decoration: decorationInput5('', nameController.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Color'),
                                        ),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: colorError1 ? 55:30,
                                            child: TextFormField(
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
                                              style: const TextStyle(fontSize: 14),
                                              controller: colorController1,
                                              decoration: decorationInput5('', colorController1.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: colorError2 ? 55:30,
                                            child: TextFormField(
                                              style: const TextStyle(fontSize: 14),
                                              controller: colorController2,
                                              decoration: decorationInput5('', colorController2.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: colorError3 ? 55:30,
                                            child: TextFormField(
                                              style: const TextStyle(fontSize: 14),
                                              controller: colorController3,
                                              decoration: decorationInput5('', colorController3.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: colorError4 ? 55:30,
                                            child: TextFormField(
                                              style: const TextStyle(fontSize: 14),
                                              controller: colorController4,
                                              decoration: decorationInput5('', colorController4.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: colorError5 ? 55:30,
                                            child: TextFormField(
                                              style: const TextStyle(fontSize: 14),
                                              controller: colorController5,
                                              decoration: decorationInput5('', colorController5.text.isNotEmpty),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Engine'),
                                        ),
                                        const SizedBox(height: 10,),
                                        // Container(
                                        //   color: Colors.white,
                                        //   width: 300,
                                        //   child: AnimatedContainer(
                                        //     duration: const Duration(seconds: 0),
                                        //     height: engineError1 ? 50 : 30,
                                        //     child: DropdownSearch<String>(
                                        //       validator: (value) {
                                        //         if (value == null ||
                                        //             value.isEmpty) {
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
                                        const SizedBox(height: 10,),
                                        // Container(
                                        //   color: Colors.white,
                                        //   width: 300,
                                        //   child: AnimatedContainer(
                                        //     duration: const Duration(seconds: 0),
                                        //     height: engineError2 ? 50 : 30,
                                        //     child: DropdownSearch<String>(
                                        //       // validator: (value) {
                                        //       //   if (value == null ||
                                        //       //       value.isEmpty) {
                                        //       //     setState(() {
                                        //       //       engineError2 = true;
                                        //       //     });
                                        //       //     return "Required";
                                        //       //   } else {
                                        //       //     setState(() {
                                        //       //       engineError2 = false;
                                        //       //     });
                                        //       //   }
                                        //       // },
                                        //       popupProps: PopupProps.menu(
                                        //         constraints: const BoxConstraints(
                                        //             maxHeight: 200),
                                        //         showSearchBox: false,
                                        //         searchFieldProps: TextFieldProps(
                                        //           decoration:
                                        //           dropdownDecorationSearch(
                                        //               engine1.isNotEmpty),
                                        //           cursorColor: Colors.grey,
                                        //           style: const TextStyle(
                                        //             fontSize: 14,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       items: _engineList1,
                                        //       selectedItem: engine1,
                                        //       onChanged: engineDisplay1,
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(height: 10,),
                                        // Container(
                                        //   color: Colors.white,
                                        //   width: 300,
                                        //   child: AnimatedContainer(
                                        //     duration: const Duration(seconds: 0),
                                        //     height: engineError3 ? 50 : 30,
                                        //     child: DropdownSearch<String>(
                                        //       // validator: (value) {
                                        //       //   if (value == null ||
                                        //       //       value.isEmpty) {
                                        //       //     setState(() {
                                        //       //       engineError3 = true;
                                        //       //     });
                                        //       //     return "Required";
                                        //       //   } else {
                                        //       //     setState(() {
                                        //       //       engineError3 = false;
                                        //       //     });
                                        //       //   }
                                        //       // },
                                        //       popupProps: PopupProps.menu(
                                        //         constraints: const BoxConstraints(
                                        //             maxHeight: 200),
                                        //         showSearchBox: false,
                                        //         searchFieldProps: TextFieldProps(
                                        //           decoration:
                                        //           dropdownDecorationSearch(
                                        //               engine2.isNotEmpty),
                                        //           cursorColor: Colors.grey,
                                        //           style: const TextStyle(
                                        //             fontSize: 14,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       items: _engineList2,
                                        //       selectedItem: engine2,
                                        //       onChanged: engineDisplay2,
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(height: 10,),
                                        // Container(
                                        //   color: Colors.white,
                                        //   width: 300,
                                        //   child: AnimatedContainer(
                                        //     duration: const Duration(seconds: 0),
                                        //     height: engineError4 ? 50 : 30,
                                        //     child: DropdownSearch<String>(
                                        //       // validator: (value) {
                                        //       //   if (value == null ||
                                        //       //       value.isEmpty) {
                                        //       //     setState(() {
                                        //       //       engineError4 = true;
                                        //       //     });
                                        //       //     return "Required";
                                        //       //   } else {
                                        //       //     setState(() {
                                        //       //       engineError4 = false;
                                        //       //     });
                                        //       //   }
                                        //       // },
                                        //       popupProps: PopupProps.menu(
                                        //         constraints: const BoxConstraints(
                                        //             maxHeight: 200),
                                        //         showSearchBox: false,
                                        //         searchFieldProps: TextFieldProps(
                                        //           decoration:
                                        //           dropdownDecorationSearch(
                                        //               engine3.isNotEmpty),
                                        //           cursorColor: Colors.grey,
                                        //           style: const TextStyle(
                                        //             fontSize: 14,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       items: _engineList3,
                                        //       selectedItem: engine3,
                                        //       onChanged: engineDisplay3,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 180,
                                          child: Text('Transmission'),
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          color: Colors.white,
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: transmissionError1 ? 50 : 30,
                                            child: DropdownButtonFormField(
                                              hint: const Text('--Select--'),
                                              decoration: dropdownDecorationSearch(trans0.toString().isNotEmpty),
                                              items: _transList0.map((Transmission value){
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text("${value.value}, ${value.key}"),
                                                );
                                              }).toList(),
                                              onChanged: (value) => setState(() {
                                                trans0 = value as Transmission?;
                                              }),
                                              selectedItemBuilder: (context) {
                                                return _transList0.map((e) {
                                                  return Text(e.key);
                                                }).toList();
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          color: Colors.white,
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: transmissionError2 ? 50 : 30,
                                            child: DropdownButtonFormField(
                                              hint: const Text('--Select--'),
                                              decoration: dropdownDecorationSearch(trans.toString().isNotEmpty),
                                              items: _transList.map((Transmission value){
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text("${value.value}, ${value.key}"),
                                                );
                                              }).toList(),
                                              onChanged: (value) => setState(() {
                                                trans = value as Transmission?;
                                              }),
                                              selectedItemBuilder: (context) {
                                                return _transList.map((e) {
                                                  return Text(e.key);
                                                }).toList();
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          color: Colors.white,
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: transmissionError3 ? 50 : 30,
                                            child: DropdownButtonFormField(
                                              hint: const Text('--Select--'),
                                              decoration: dropdownDecorationSearch(trans1.toString().isNotEmpty),
                                              items: _transList1.map((Transmission value){
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text("${value.value}, ${value.key}"),
                                                );
                                              }).toList(),
                                              onChanged: (value) => setState(() {
                                                trans1 = value as Transmission?;
                                              }),
                                              selectedItemBuilder: (context) {
                                                return _transList1.map((e) {
                                                  return Text(e.key);
                                                }).toList();
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          color: Colors.white,
                                          width: 300,
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: transmissionError4 ? 50 : 30,
                                            child: DropdownButtonFormField(
                                              hint: const Text('--Select--'),
                                              decoration: dropdownDecorationSearch(trans2.toString().isNotEmpty),
                                              items: _transList2.map((Transmission value){
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text("${value.value}, ${value.key}"),
                                                );
                                              }).toList(),
                                              onChanged: (value) => setState(() {
                                                trans2 = value as Transmission?;
                                              }),
                                              selectedItemBuilder: (context) {
                                                return _transList2.map((e) {
                                                  return Text(e.key);
                                                }).toList();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),

                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              bottomNavigationBar: SizedBox(
                height: 50,
                child: Row(
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(left: 20,top: 8,bottom: 8),
                      child: MaterialButton(onPressed: () {

                        if(_addVehiclesForm.currentState!.validate()){
                          Map _addVehiclePage = {
                            "brand": brandController.text,
                            "name": nameController.text,
                            "color1":colorController1.text,
                            "color2":colorController2.text,
                            "color3":colorController3.text,
                            "color4":colorController4.text,
                            "color5":colorController5.text,
                            "engine_1":engine,
                            "engine_2":engine1,
                            "engine_3":engine2,
                            "engine_4":engine3,
                            "transmission_1":trans0!.value,
                            "transmission_2":trans!.value,
                            "transmission_3":trans1!.value,
                            "transmission_4":trans2!.value,
                          };
                          print(_addVehiclePage);
                          addNewVehicles(_addVehiclePage);
                        }
                      },
                        color: Colors.blue,
                        child: const Center(
                          child: Text('Save',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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


}

class Transmission {
  final String key;
  final String value;
  Transmission({required this.key, required this.value});
}


