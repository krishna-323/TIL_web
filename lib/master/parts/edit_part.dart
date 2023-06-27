import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/master/parts/bloc/part_details_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../widgets/input_decoration_text_field.dart';

class EditPart extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map itemData;
  const EditPart({Key? key, required this.drawerWidth, required this.selectedDestination, required this. itemData}) : super(key: key);

  @override
  _EditPartState createState() => _EditPartState();
}

class _EditPartState extends State<EditPart> {


  void unitSelectionChanged(String? u){
    setState(() {
      unitDropdownValue = u!;
    });
  }
  void acc1SelectionChanged(String? a1){
    setState(() {
      sellingAccountDropdownValue = a1!;
    });
  }
  void acc2SelectionChanged(String? a2){
    setState(() {
      purchaseDropdownValue = a2!;
    });
  }
  void gstSelectionChanged(String? gst){
    setState(() {
      taxQuesDropdownValue = gst!;
      cgstSgst=double.parse(gst)/2;
    });
  }
  void igstSelectionChanged(String? igst){
    setState(() {
      taxQues2dropdownValue = igst!;
    });
  }
  void exRemSelectionChanged(String? ex){
    setState(() {
      exceptionDropdownValue = ex!;
    });
  }


  @override
  void initState(){
    // print(widget.itemData);
    selectedId = widget.itemData["newitem_id"];
    description.text = widget.itemData["description"];
    exceptionDropdownValue = widget.itemData["exemption_reason"];
    item.text=widget.itemData['item_code'];
    nameController.text = widget.itemData["name"];
    purchaseDropdownValue = widget.itemData["purchase_account"];
    purchasePrice.text = widget.itemData["purchase_price"].toString();
    sacController.text = widget.itemData["sac"];
    sellingAccountDropdownValue = widget.itemData["selling_account"];
    sellingPrice.text = widget.itemData["selling_price"].toString();
    taxCodeController.text = widget.itemData["tax_code"];
    _tasktax = widget.itemData["tax_preference"] == "Taxable"?0:1;
    _goodsService=widget.itemData["type"]=="Sevices"?1:0;
    unitDropdownValue = widget.itemData["unit"];
    getInitialData();
    // print("-------edit items---------");
    // print(widget.itemData);


    super.initState();
  }

  getInitialData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }
  List<String> textlist = [];


  final sellingPrice = TextEditingController();
  // final account = TextEditingController();
  final description = TextEditingController();
  final tax = TextEditingController();
  final purchasePrice = TextEditingController();
  // final account2 = TextEditingController();
  final nameController = TextEditingController();
  final item=TextEditingController();
  // final unitController = TextEditingController();
  final skuController = TextEditingController();
  final taxCodeController = TextEditingController();
  final sacController = TextEditingController();
  final goodsController = TextEditingController();
  final servicesController = TextEditingController();
  final taxableController = TextEditingController();
  final nonTaxableController = TextEditingController();
  final checkController = TextEditingController();
  final salesInfoController = TextEditingController();
  final purchaseInfoController = TextEditingController();
  final exemptionController = TextEditingController();

  bool sellingPriceError = false;
  bool accountError = false;
  bool descriptionError = false;
  bool taxError = false;
  bool tax2bool = false;
  bool purchasePriceError = false;
  bool account1bool = false;
  bool description2bool = false;
  bool nameError = false;
  bool itemCodeError=false;
  bool skuError = false;
  bool hsnError = false;
  bool sacError = false;
  bool unitError = false;
  bool exemptionError = false;
  bool checkError = false;

  bool isDisabled = true;
  bool isDisabled1 = true;
  bool isServiceDisable = true;

  var unitDropdownValue = "";
  var sellingAccountDropdownValue = "";
  var taxQuesDropdownValue = "";
  var taxQues2dropdownValue = "";
  var purchaseDropdownValue = "";
  var exceptionDropdownValue = "";
  var unit = [
    "DOZEN",
    "BOX",
    "GRAMS",
    "KILOGRAMS",
    "METERS",
    "TABLETS",
    "UNITS",
    "PIECES",
    "PAIRS"
  ];
  var acc1 = [
    'Discount',
    'General Income',
    'Interest Income',
    'Late Fee Income',
    'Sales',
    'Other Charges',
    'Shipping Charge'
  ];
  var taxques = [
    '8',
    '12',
    '18',
    '28',
  ];
  var taxques2 = [
    '8',
    '12',
    '18',
    '28',
  ];
  var acc2 = [
    'Acc2 1',
    'Acc2 2',
    'Acc2 3',
    'Acc2 4',
    'Acc2 5',
  ];
  var exmRe = [
    'ExRe 1',
    'ExRe 2',
    'ExRe 3',
    'ExRe 4',
    'ExRe 5',
  ];

  dynamic size;
  dynamic height;
  dynamic width;

  String selectedId = "";
  String type='';

  int _goodsService = 0;
  int _tasktax = 0;

  String? authToken;


  double cgstSgst=0;

  final addItemsForm=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(

              body: SingleChildScrollView(
                child:
                Form(
                  key:addItemsForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------------- first container-------------------
                      if(width>1000)
                        Container(
                          color: const Color(0xffF4FAFF),
                          child: Padding(
                            padding: const EdgeInsets.only(left:50,top:20),
                            child: Column(
                              children: [
                                const Align(alignment:Alignment.topLeft,
                                  child:  Text(
                                    "Edit Item",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Row(
                                  children:  [
                                    //type
                                    SizedBox(
                                      width: 180,
                                      child: Row(
                                        children: const [
                                          Text('Type'),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 190,
                                          child: _typeRadioButton(
                                            title: "Goods",
                                            value: 0,
                                            onChanged: (newValue) => setState(() {
                                              _goodsService = newValue;
                                            }),
                                          ),
                                        ),
                                        SizedBox(width: 190,
                                          child: _typeRadioButton(
                                            title: "Services",
                                            value: 1,
                                            onChanged: (newValue) => setState(() {
                                              _goodsService = newValue;
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if(_goodsService == 0)
                                  Column(
                                    children: [
                                      //name
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          const SizedBox(
                                            width:180,
                                            child: Text('Name*',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),),
                                          ),
                                          Container(
                                            width: 350,
                                            color: const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration:const Duration(seconds: 0),
                                              height: nameError ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      nameError = true;
                                                    });
                                                    // print(namebool);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      nameError = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller: nameController,
                                                decoration: decorationInput5(
                                                    '',
                                                    nameController
                                                        .text.isNotEmpty),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      //itemcode
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          const SizedBox(
                                            width:180,
                                            child: Text('Item Code',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 350,
                                            color:const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration:const Duration(seconds: 0),
                                              height: itemCodeError ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      itemCodeError = true;
                                                    });
                                                    // print(namebool);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      itemCodeError = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller:item,
                                                decoration: decorationInput5(
                                                    '',
                                                    item
                                                        .text.isNotEmpty),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      //Description
                                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width:180,
                                            child: Text('Description'),
                                          ),
                                          Container(
                                            width: 350,
                                            color: const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              height: descriptionError ? 80 : 70,
                                              // height: 38,
                                              duration: const Duration(seconds: 0),
                                              margin: const EdgeInsets.all(0),
                                              // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: TextFormField(
                                                maxLines: null,
                                                //Error display code.
                                                // validator: (value) {
                                                //   if (value == null || value.isEmpty) {
                                                //     setState(() {
                                                //       descriptionError = true;
                                                //     });
                                                //
                                                //     return "Required";
                                                //   } else {
                                                //     setState(() {
                                                //       descriptionbool = false;
                                                //     });
                                                //   }
                                                //   return null;
                                                // },
                                                style: const TextStyle(fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller: description,
                                                decoration: decorationInput6("Description", description.text.isNotEmpty),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      // unit
                                      Row( crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          const SizedBox(
                                            width:180,
                                            child: Row(
                                              children: [
                                                Text('Unit',
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    )),
                                                Icon(CupertinoIcons.question_circle,
                                                  color: Colors.grey,)
                                              ],
                                            ),
                                          ),
                                          // Container(
                                          //   width: 350,
                                          //   color:const Color.fromRGBO(255, 255, 255, 1),
                                          //   child: AnimatedContainer(
                                          //     duration:const Duration(seconds: 0),
                                          //     height: unitError ? 55 : 30,
                                          //     child: DropdownSearch<String>(
                                          //       validator: (value) {
                                          //         if (value == null || value.isEmpty) {
                                          //           setState(() {
                                          //             unitError = true;
                                          //           });
                                          //           //print(unitError);
                                          //           return "Required";
                                          //         } else {
                                          //           setState(() {
                                          //             unitError = false;
                                          //           });
                                          //         }
                                          //         return null;
                                          //       },
                                          //       popupProps: PopupProps.menu(
                                          //         constraints:const BoxConstraints(maxHeight: 200),
                                          //         showSearchBox: true,
                                          //         searchFieldProps: TextFieldProps(
                                          //           decoration: dropdownDecorationSearch(unitDropdownValue.isNotEmpty),
                                          //           cursorColor: Colors.grey,
                                          //           style:const TextStyle(
                                          //             fontSize: 14,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       items: unit,
                                          //       selectedItem: unitDropdownValue,
                                          //       onChanged: unitSelectionChanged,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      // hsn
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width:180,
                                            child: Text(
                                              'Tax Code',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 350,
                                            color:const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration:const Duration(seconds: 0),
                                              height: hsnError ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      hsnError = true;
                                                    });
                                                    //print(hsnError);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      hsnError = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller: taxCodeController,
                                                decoration: decorationInput5(
                                                    '',
                                                    taxCodeController
                                                        .text.isNotEmpty),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      // tax preference
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width:180,
                                                child: Row(
                                                  children: [
                                                    Text('Tax Preference*',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(width: 190,
                                                    child: _taxRadioButton(
                                                      title: "Taxable",
                                                      value: 0,
                                                      onChanged: (newValue) => setState(() {
                                                        _tasktax = newValue;
                                                      }),
                                                    ),
                                                  ),
                                                  SizedBox(width: 190,
                                                    child: _taxRadioButton(
                                                      title: "Non-Taxable",
                                                      value: 1,
                                                      onChanged: (newValue) => setState(() {
                                                        _tasktax = newValue;
                                                      }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height:15),
                                          if(_tasktax==1)
                                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width:180,
                                                  child: Row(
                                                    children: [
                                                      Text('Exemption Reason*',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                      Icon(
                                                        CupertinoIcons.question_circle,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                // Column(
                                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                                //   children: [
                                                //     Container(
                                                //       width: 350,
                                                //       color:const Color.fromRGBO(255, 255, 255, 1),
                                                //       child: AnimatedContainer(
                                                //         duration:const Duration(seconds: 0),
                                                //         height: exemptionError ? 55 : 30,
                                                //         child: DropdownSearch<String>(
                                                //           validator: (value) {
                                                //             if (value == null || value.isEmpty) {
                                                //               setState(() {
                                                //                 exemptionError = true;
                                                //               });
                                                //               //print(exemptionError);
                                                //               return "Required";
                                                //             } else {
                                                //               setState(() {
                                                //                 exemptionError = false;
                                                //               });
                                                //             }
                                                //             return null;
                                                //           },
                                                //           popupProps: PopupProps.menu(
                                                //             constraints:const BoxConstraints(maxHeight: 200),
                                                //             showSearchBox: true,
                                                //             searchFieldProps: TextFieldProps(
                                                //               decoration: dropdownDecorationSearch(exceptionDropdownValue.isNotEmpty),
                                                //               cursorColor: Colors.grey,
                                                //               style:const TextStyle(
                                                //                 fontSize: 14,
                                                //               ),
                                                //             ),
                                                //           ),
                                                //           items: exmRe,
                                                //           selectedItem: exceptionDropdownValue,
                                                //           onChanged: exRemSelectionChanged,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                if (_goodsService == 1)
                                  Column(
                                      children:[
                                        //name
                                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const SizedBox(
                                              width:180,
                                              child: Text('Name*',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 350,
                                                  color:const Color.fromRGBO(255, 255, 255, 1),
                                                  child: AnimatedContainer(
                                                    duration:const Duration(seconds: 0),
                                                    height: nameError ? 55 : 30,
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            nameError = true;
                                                          });
                                                          // print(nameError);
                                                          return "Required";
                                                        } else {
                                                          setState(() {
                                                            nameError = false;
                                                          });
                                                        }
                                                        return null;
                                                      },
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                      onChanged: (text) {
                                                        setState(() {});
                                                      },
                                                      controller: nameController,
                                                      decoration: decorationInput5(
                                                          '',
                                                          nameController
                                                              .text.isNotEmpty),
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        //item code
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const SizedBox(
                                              width:180,
                                              child: Text('Item Code',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 350,
                                              color:const Color.fromRGBO(255, 255, 255, 1),
                                              child: AnimatedContainer(
                                                duration:const Duration(seconds: 0),
                                                height: itemCodeError ? 55 : 30,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      setState(() {
                                                        itemCodeError = true;
                                                      });
                                                      // print(namebool);
                                                      return "Required";
                                                    } else {
                                                      setState(() {
                                                        itemCodeError = false;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  onChanged: (text) {
                                                    setState(() {});
                                                  },
                                                  controller:item,
                                                  decoration: decorationInput5(
                                                      '',
                                                      item
                                                          .text.isNotEmpty),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        //Description
                                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width:180,
                                              child: Text('Description'),
                                            ),
                                            Container(
                                              width: 350,
                                              color:const Color.fromRGBO(255, 255, 255, 1),
                                              child: AnimatedContainer(
                                                height: descriptionError ? 80 : 70,
                                                // height: 38,
                                                duration: const Duration(seconds: 0),
                                                margin: const EdgeInsets.all(0),
                                                // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: TextFormField(
                                                  maxLines: null,
                                                  //Error display code.
                                                  // validator: (value) {
                                                  //   if (value == null || value.isEmpty) {
                                                  //     setState(() {
                                                  //       descriptionbool = true;
                                                  //     });
                                                  //
                                                  //     return "Required";
                                                  //   } else {
                                                  //     setState(() {
                                                  //       descriptionbool = false;
                                                  //     });
                                                  //   }
                                                  //   return null;
                                                  // },
                                                  style: const TextStyle(fontSize: 14),
                                                  onChanged: (text) {
                                                    setState(() {});
                                                  },
                                                  controller: description,
                                                  decoration: decorationInput6("Description", description.text.isNotEmpty),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        // unit
                                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const SizedBox(
                                              width:180,
                                              child: Row(
                                                children: [
                                                  Text('Unit',
                                                      style: TextStyle(
                                                          color: Colors.red
                                                      )),
                                                  Icon(CupertinoIcons.question_circle,
                                                    color: Colors.grey,)
                                                ],
                                              ),
                                            ),

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Container(
                                                //   width: 350,
                                                //   color:const Color.fromRGBO(255, 255, 255, 1),
                                                //   child: AnimatedContainer(
                                                //     duration:const Duration(seconds: 0),
                                                //     height: unitError ? 55 : 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             unitError = true;
                                                //           });
                                                //           //print(unitError);
                                                //           return "Required";
                                                //         } else {
                                                //           setState(() {
                                                //             unitError = false;
                                                //           });
                                                //         }
                                                //         return null;
                                                //       },
                                                //       popupProps: PopupProps.menu(
                                                //         constraints:const BoxConstraints(maxHeight: 200),
                                                //         showSearchBox: true,
                                                //         searchFieldProps: TextFieldProps(
                                                //           decoration: dropdownDecorationSearch(unitDropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style:const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: unit,
                                                //       selectedItem: unitDropdownValue,
                                                //       onChanged: unitSelectionChanged,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        // checkbox
                                        Padding(
                                          padding: const EdgeInsets.only(left:160),
                                          child: CheckboxListTile(
                                            title: const Row(
                                              children: [
                                                Text('It is a digital service'),
                                                Icon(CupertinoIcons.question_circle,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                            value: isServiceDisable,
                                            onChanged: (value) {
                                              setState(() {
                                                isServiceDisable = value!;
                                              });
                                            },
                                            controlAffinity: ListTileControlAffinity.leading,
                                          ),
                                        ),
                                        const SizedBox(height:15),
                                        // sac
                                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width:180,
                                              child: Text(
                                                'SAC',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  Container(
                                                    width: 350,
                                                    color:const Color.fromRGBO(255, 255, 255, 1),
                                                    child: AnimatedContainer(
                                                      duration:const Duration(seconds: 0),
                                                      height: sacError ? 55 : 30,
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              sacError = true;
                                                            });
                                                            // print(sacError);
                                                            return "Required";
                                                          } else {
                                                            setState(() {
                                                              sacError = false;
                                                            });
                                                          }
                                                          return null;
                                                        },
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        onChanged: (text) {
                                                          setState(() {});
                                                        },
                                                        controller: sacController,
                                                        decoration: decorationInput5(
                                                            '',
                                                            sacController
                                                                .text.isNotEmpty),
                                                      ),
                                                    ),
                                                  ),

                                                ]
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        // tax preference radio buttons.
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width:180,
                                                  child: Row(
                                                    children: [
                                                      Text('Tax Preference*',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 190,
                                                      child: _taxRadioButton(
                                                        title: "Taxable",
                                                        value: 0,
                                                        onChanged: (newValue) => setState(() {
                                                          _tasktax = newValue;
                                                        }),
                                                      ),
                                                    ),
                                                    SizedBox(width: 190,
                                                      child: _taxRadioButton(
                                                        title: "Non-Taxable",
                                                        value: 1,
                                                        onChanged: (newValue) => setState(() {
                                                          _tasktax = newValue;
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if(_tasktax==1)
                                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width:180,
                                                    child: Row(
                                                      children: [
                                                        Text('Exemption Reason*',
                                                          style: TextStyle(color: Colors.red),
                                                        ),
                                                        Icon(
                                                          CupertinoIcons.question_circle,
                                                          color: Colors.grey,
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  // Container(
                                                  //   width: 350,
                                                  //   color:const Color.fromRGBO(255, 255, 255, 1),
                                                  //   child: AnimatedContainer(
                                                  //     duration:const Duration(seconds: 0),
                                                  //     height: exemptionError ? 55 : 30,
                                                  //     child: DropdownSearch<String>(
                                                  //       validator: (value) {
                                                  //         if (value == null || value.isEmpty) {
                                                  //           setState(() {
                                                  //             exemptionError = true;
                                                  //           });
                                                  //           //print(exemptionError);
                                                  //           return "Required";
                                                  //         } else {
                                                  //           setState(() {
                                                  //             exemptionError = false;
                                                  //           });
                                                  //         }
                                                  //         return null;
                                                  //       },
                                                  //       popupProps: PopupProps.menu(
                                                  //         constraints:const BoxConstraints(maxHeight: 200),
                                                  //         showSearchBox: true,
                                                  //         searchFieldProps: TextFieldProps(
                                                  //           decoration: dropdownDecorationSearch(exceptionDropdownValue.isNotEmpty),
                                                  //           cursorColor: Colors.grey,
                                                  //           style:const TextStyle(
                                                  //             fontSize: 14,
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //       items: exmRe,
                                                  //       selectedItem: exceptionDropdownValue,
                                                  //       onChanged: exRemSelectionChanged,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ]
                                  ),

                              ],
                            ),
                          ),
                        ),
                      if(width<1000)
                        Container(
                          color: const Color(0xffF4FAFF),
                          child: Padding(
                            padding: const EdgeInsets.only(left:15),
                            child: Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                //type Radio buttons
                                Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children:  [
                                    //type
                                    SizedBox(
                                      width: 180,
                                      child: Row(
                                        children: const [
                                          Text('Type'),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 190,
                                          child: _typeRadioButton(
                                            title: "Goods",
                                            value: 0,
                                            onChanged: (newValue) => setState(() {
                                              _goodsService = newValue;
                                            }),
                                          ),
                                        ),
                                        SizedBox(width: 190,
                                          child: _typeRadioButton(
                                            title: "Services",
                                            value: 1,
                                            onChanged: (newValue) => setState(() {
                                              _goodsService = newValue;
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if(_goodsService == 0)
                                  Column(crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      //name
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          const Text('Name*',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),),
                                          const SizedBox(height:10),
                                          Container(
                                            width: 350,
                                            color:const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration:const Duration(seconds: 0),
                                              height: nameError ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      nameError = true;
                                                    });
                                                    // print(nameError);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      nameError = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller: nameController,
                                                decoration: decorationInput5(
                                                    '',
                                                    nameController
                                                        .text.isNotEmpty),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      //Item code.
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          const Text('Item Code',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(height:10),
                                          Container(
                                            width: 350,
                                            color:const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration:const Duration(seconds: 0),
                                              height: itemCodeError ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      itemCodeError = true;
                                                    });
                                                    // print(itemCodeError);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      itemCodeError = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller:item,
                                                decoration: decorationInput5(
                                                    '',
                                                    item
                                                        .text.isNotEmpty),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      //Description code.
                                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Description'),
                                          const SizedBox(height:10),
                                          Container(
                                            width: 350,
                                            color:const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              height: descriptionError ? 80 : 70,
                                              // height: 38,
                                              duration: const Duration(seconds: 0),
                                              margin: const EdgeInsets.all(0),
                                              // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: TextFormField(
                                                maxLines: null,
                                                //Error display code.
                                                // validator: (value) {
                                                //   if (value == null || value.isEmpty) {
                                                //     setState(() {
                                                //       descriptionError = true;
                                                //     });
                                                //
                                                //     return "Required";
                                                //   } else {
                                                //     setState(() {
                                                //       descriptionError = false;
                                                //     });
                                                //   }
                                                //   return null;
                                                // },
                                                style: const TextStyle(fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller: description,
                                                decoration: decorationInput6("Description", description.text.isNotEmpty),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      // unit
                                      Column( crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          Row(
                                            children: const [
                                              Text('Unit',
                                                  style: TextStyle(
                                                      color: Colors.red
                                                  )),
                                              Icon(CupertinoIcons.question_circle,
                                                color: Colors.grey,)
                                            ],
                                          ),
                                          const SizedBox(height:10),
                                          // Container(
                                          //   width: 350,
                                          //   color:const Color.fromRGBO(255, 255, 255, 1),
                                          //   child: AnimatedContainer(
                                          //     duration:const Duration(seconds: 0),
                                          //     height: unitError ? 55 : 30,
                                          //     child: DropdownSearch<String>(
                                          //       validator: (value) {
                                          //         if (value == null || value.isEmpty) {
                                          //           setState(() {
                                          //             unitError = true;
                                          //           });
                                          //           // print(unitError);
                                          //           return "Required";
                                          //         } else {
                                          //           setState(() {
                                          //             unitError = false;
                                          //           });
                                          //         }
                                          //         return null;
                                          //       },
                                          //       popupProps: PopupProps.menu(
                                          //         constraints:const BoxConstraints(maxHeight: 200),
                                          //         showSearchBox: true,
                                          //         searchFieldProps: TextFieldProps(
                                          //           decoration: dropdownDecorationSearch(unitDropdownValue.isNotEmpty),
                                          //           cursorColor: Colors.grey,
                                          //           style:const TextStyle(
                                          //             fontSize: 14,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       items: unit,
                                          //       selectedItem: unitDropdownValue,
                                          //       onChanged: unitSelectionChanged,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      // hsn
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Tax Code',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(height:10),
                                          Container(
                                            width: 350,
                                            color:const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration:const Duration(seconds: 0),
                                              height: hsnError ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      hsnError = true;
                                                    });
                                                    // print(hsnError);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      hsnError = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller: taxCodeController,
                                                decoration: decorationInput5(
                                                    '',
                                                    taxCodeController
                                                        .text.isNotEmpty),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      // tax preference Radio buttons.
                                      Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          const Text('Tax Preference*',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(height:10),
                                          Row(
                                            children: [
                                              SizedBox(width: 190,
                                                child: _taxRadioButton(
                                                  title: "Taxable",
                                                  value: 0,
                                                  onChanged: (newValue) => setState(() {
                                                    _tasktax = newValue;
                                                  }),
                                                ),
                                              ),
                                              SizedBox(width: 190,
                                                child: _taxRadioButton(
                                                  title: "Non-Taxable",
                                                  value: 1,
                                                  onChanged: (newValue) => setState(() {
                                                    _tasktax = newValue;
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      if(_tasktax==1)
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                Text('Exemption Reason*',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                                Icon(
                                                  CupertinoIcons.question_circle,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height:10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Container(
                                                //   width: 350,
                                                //   color:const Color.fromRGBO(255, 255, 255, 1),
                                                //   child: AnimatedContainer(
                                                //     duration:const Duration(seconds: 0),
                                                //     height: exemptionError ? 55 : 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             exemptionError = true;
                                                //           });
                                                //           //  print(exemptionError);
                                                //           return "Required";
                                                //         } else {
                                                //           setState(() {
                                                //             exemptionError = false;
                                                //           });
                                                //         }
                                                //         return null;
                                                //       },
                                                //       popupProps: PopupProps.menu(
                                                //         constraints: const BoxConstraints(maxHeight: 200),
                                                //         showSearchBox: true,
                                                //         searchFieldProps: TextFieldProps(
                                                //           decoration: dropdownDecorationSearch(exceptionDropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style:const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: exmRe,
                                                //       selectedItem: exceptionDropdownValue,
                                                //       onChanged: exRemSelectionChanged,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                if (_goodsService == 1)
                                  Column(crossAxisAlignment:CrossAxisAlignment.start,
                                      children:[
                                        //name
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const Text('Name*',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),),
                                            const SizedBox(height:10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Container(
                                                  width: 350,
                                                  color:const Color.fromRGBO(255, 255, 255, 1),
                                                  child: AnimatedContainer(
                                                    duration:const Duration(seconds: 0),
                                                    height: nameError ? 55 : 30,
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            nameError = true;
                                                          });
                                                          // print(nameError);
                                                          return "Required";
                                                        } else {
                                                          setState(() {
                                                            nameError = false;
                                                          });
                                                        }
                                                        return null;
                                                      },
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                      onChanged: (text) {
                                                        setState(() {});
                                                      },
                                                      controller: nameController,
                                                      decoration: decorationInput5(
                                                          '',
                                                          nameController
                                                              .text.isNotEmpty),
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height:10),
                                        //Item code
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const Text('Item Code',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            const SizedBox(height:10),
                                            Container(
                                              width: 350,
                                              color:const Color.fromRGBO(255, 255, 255, 1),
                                              child: AnimatedContainer(
                                                duration:const Duration(seconds: 0),
                                                height: itemCodeError ? 55 : 30,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      setState(() {
                                                        itemCodeError = true;
                                                      });
                                                      // print(namebool);
                                                      return "Required";
                                                    } else {
                                                      setState(() {
                                                        itemCodeError = false;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  onChanged: (text) {
                                                    setState(() {});
                                                  },
                                                  controller:item,
                                                  decoration: decorationInput5(
                                                      '',
                                                      item
                                                          .text.isNotEmpty),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        //description
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Description'),
                                            const SizedBox(height:10),
                                            Container(
                                              width: 350,
                                              color:const Color.fromRGBO(255, 255, 255, 1),
                                              child: AnimatedContainer(
                                                height: descriptionError ? 80 : 70,
                                                // height: 38,
                                                duration: const Duration(seconds: 0),
                                                margin: const EdgeInsets.all(0),
                                                // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: TextFormField(
                                                  maxLines: null,
                                                  //Error display code.
                                                  // validator: (value) {
                                                  //   if (value == null || value.isEmpty) {
                                                  //     setState(() {
                                                  //       descriptionbool = true;
                                                  //     });
                                                  //
                                                  //     return "Required";
                                                  //   } else {
                                                  //     setState(() {
                                                  //       descriptionbool = false;
                                                  //     });
                                                  //   }
                                                  //   return null;
                                                  // },
                                                  style: const TextStyle(fontSize: 14),
                                                  onChanged: (text) {
                                                    setState(() {});
                                                  },
                                                  controller: description,
                                                  decoration: decorationInput6("Description", description.text.isNotEmpty),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        // unit
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            Row(
                                              children: const [
                                                Text('Unit',
                                                    style: TextStyle(
                                                        color: Colors.red
                                                    )),
                                                Icon(CupertinoIcons.question_circle,
                                                  color: Colors.grey,)
                                              ],
                                            ),
                                            const SizedBox(height:10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Container(
                                                //   width: 350,
                                                //   color:const Color.fromRGBO(255, 255, 255, 1),
                                                //   child: AnimatedContainer(
                                                //     duration:const Duration(seconds: 0),
                                                //     height: unitError ? 55 : 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             unitError = true;
                                                //           });
                                                //           // print(unitError);
                                                //           return "Required";
                                                //         } else {
                                                //           setState(() {
                                                //             unitError = false;
                                                //           });
                                                //         }
                                                //         return null;
                                                //       },
                                                //       popupProps: PopupProps.menu(
                                                //         constraints:const BoxConstraints(maxHeight: 200),
                                                //         showSearchBox: true,
                                                //         searchFieldProps: TextFieldProps(
                                                //           decoration: dropdownDecorationSearch(unitDropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style:const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: unit,
                                                //       selectedItem: unitDropdownValue,
                                                //       onChanged: unitSelectionChanged,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        // checkbox
                                        CheckboxListTile(
                                          title: Row(
                                            children: const [
                                              Text('It is a digital service'),
                                              Icon(CupertinoIcons.question_circle,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          value: isServiceDisable,
                                          onChanged: (value) {
                                            setState(() {
                                              isServiceDisable = value!;
                                            });
                                          },
                                          controlAffinity: ListTileControlAffinity.leading,
                                        ),
                                        const SizedBox(height:15),
                                        // sac
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'SAC',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            const SizedBox(height:10),
                                            Container(
                                              width: 350,
                                              color: const Color.fromRGBO(255, 255, 255, 1),
                                              child: AnimatedContainer(
                                                duration: const Duration(seconds: 0),
                                                height: sacError ? 55: 30,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      setState(() {
                                                        sacError = true;
                                                      });
                                                      // print(sacError);
                                                      return "Required";
                                                    } else {
                                                      setState(() {
                                                        sacError = false;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  onChanged: (text) {
                                                    setState(() {});
                                                  },
                                                  controller: sacController,
                                                  decoration: decorationInput5(
                                                      '',
                                                      sacController
                                                          .text.isNotEmpty),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        // tax preference radio buttons.
                                        Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:CrossAxisAlignment.start,
                                              children: [
                                                const Text('Tax Preference*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                const SizedBox(height:10),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 190,
                                                      child: _taxRadioButton(
                                                        title: "Taxable",
                                                        value: 0,
                                                        onChanged: (newValue) => setState(() {
                                                          _tasktax = newValue;
                                                        }),
                                                      ),
                                                    ),
                                                    SizedBox(width: 190,
                                                      child: _taxRadioButton(
                                                        title: "Non-Taxable",
                                                        value: 1,
                                                        onChanged: (newValue) => setState(() {
                                                          _tasktax = newValue;
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if(_tasktax==1)
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: const [
                                                      Text('Exemption Reason*',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                      Icon(
                                                        CupertinoIcons.question_circle,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height:10),
                                                  // Container(
                                                  //   width: 350,
                                                  //   color: const Color.fromRGBO(255, 255, 255, 1),
                                                  //   child: AnimatedContainer(
                                                  //     duration: const Duration(seconds: 0),
                                                  //     height: exemptionError ? 55 : 30,
                                                  //     child: DropdownSearch<String>(
                                                  //       validator: (value) {
                                                  //         if (value == null || value.isEmpty) {
                                                  //           setState(() {
                                                  //             exemptionError = true;
                                                  //           });
                                                  //           // print(exemptionError);
                                                  //           return "Required";
                                                  //         } else {
                                                  //           setState(() {
                                                  //             exemptionError = false;
                                                  //           });
                                                  //         }
                                                  //         return null;
                                                  //       },
                                                  //       popupProps: PopupProps.menu(
                                                  //         constraints: const BoxConstraints(maxHeight: 200),
                                                  //         showSearchBox: true,
                                                  //         searchFieldProps: TextFieldProps(
                                                  //           decoration: dropdownDecorationSearch(exceptionDropdownValue.isNotEmpty),
                                                  //           cursorColor: Colors.grey,
                                                  //           style: const TextStyle(
                                                  //             fontSize: 14,
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //       items: exmRe,
                                                  //       selectedItem: exceptionDropdownValue,
                                                  //       onChanged: exRemSelectionChanged,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ]
                                  ),
                              ],
                            ),
                          ),
                        ),
                      // ---------------second container--------------

                      Container(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        child:
                        Column(
                          children: [
                            const SizedBox(height:50),
                            if(width>1100)
                              Padding(
                                padding: const EdgeInsets.only(left:50),
                                child: Row(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex:2,
                                      child: SizedBox(
                                        height: 410,
                                        width: width*0.4,
                                        child:
                                        Column(
                                          children: [
                                            //sales information
                                            Row(
                                              children: const [
                                                Text('Sales Information',
                                                  style: TextStyle(
                                                    fontSize:20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height:20),
                                            //selling price
                                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                              children:  [
                                                const SizedBox(
                                                  width:180,
                                                  child: Text('Selling Price*',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      decoration: TextDecoration.underline,
                                                      decorationStyle: TextDecorationStyle.dotted,
                                                    ),),
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                height: 30,
                                                                width: 60,
                                                                decoration:const   BoxDecoration(
                                                                  //  borderRadius: BorderRadius.only(
                                                                  //   topLeft: Radius.circular(3),
                                                                  //   topRight: Radius.circular(3),
                                                                  //
                                                                  // ),
                                                                    color: Color.fromRGBO(224, 224, 224, 1),
                                                                    border:Border(
                                                                      left: BorderSide(
                                                                          color: Colors.grey
                                                                      ),
                                                                      top:BorderSide(color:Colors.grey),
                                                                      bottom:BorderSide(color:Colors.grey),
                                                                    )
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(12, 2, 0, 0),
                                                                  child: Text('INR',
                                                                    style: TextStyle(
                                                                      color: Colors.grey[700],
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 15,
                                                                    ),),
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                width: 250,
                                                                child: AnimatedContainer(
                                                                  duration: const Duration(seconds: 0),
                                                                  height: sellingPriceError ? 55: 30,
                                                                  child: TextFormField(
                                                                    keyboardType: TextInputType.number,
                                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                    validator: (value) {
                                                                      if (value == null ||
                                                                          value.isEmpty) {
                                                                        setState(() {
                                                                          sellingPriceError = true;
                                                                        });
                                                                        // print(sellingPriceError);
                                                                        return "Required";
                                                                      } else {
                                                                        setState(() {
                                                                          sellingPriceError = false;
                                                                        });
                                                                      }
                                                                      return null;
                                                                    },
                                                                    style: const TextStyle(
                                                                        fontSize: 14),
                                                                    onChanged: (text) {
                                                                      setState(() {});
                                                                    },
                                                                    controller: sellingPrice,
                                                                    decoration: decorationInput5(
                                                                        '',
                                                                        sellingPrice
                                                                            .text.isNotEmpty),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                        ]
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height:15),
                                            //account
                                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                              children:  [
                                                const SizedBox(
                                                  width:180,
                                                  child: Text('Account*',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      decoration: TextDecoration.underline,
                                                      decorationStyle: TextDecorationStyle.dotted,
                                                    ),),
                                                ),
                                                // SizedBox(
                                                //   width: 310,
                                                //   child: AnimatedContainer(
                                                //     duration:const Duration(seconds: 0),
                                                //     height: accountError ? 55 : 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             accountError = true;
                                                //           });
                                                //           // print(accountError);
                                                //           return "Required";
                                                //         } else {
                                                //           setState(() {
                                                //             accountError = false;
                                                //           });
                                                //         }
                                                //         return null;
                                                //       },
                                                //       popupProps: PopupProps.menu(
                                                //         constraints:const BoxConstraints(maxHeight: 200),
                                                //         showSearchBox: true,
                                                //         searchFieldProps: TextFieldProps(
                                                //           decoration: dropdownDecorationSearch(sellingAccountDropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style:const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: acc1,
                                                //       selectedItem: sellingAccountDropdownValue,
                                                //       onChanged: acc1SelectionChanged,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            const SizedBox(height:15),
                                            // //description
                                            // Row(crossAxisAlignment: CrossAxisAlignment.start,
                                            //   children: [
                                            //     const SizedBox(
                                            //       width:180,
                                            //       child: Text('Description'),
                                            //     ),
                                            //     Container(
                                            //       width: 310,
                                            //       child: AnimatedContainer(
                                            //         height: descriptionbool ? 80 : 70,
                                            //         // height: 38,
                                            //         duration: const Duration(seconds: 0),
                                            //         margin: const EdgeInsets.all(0),
                                            //         // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            //         child: TextFormField(
                                            //           maxLines: null,
                                            //
                                            //           style: const TextStyle(fontSize: 14),
                                            //           onChanged: (text) {
                                            //             setState(() {});
                                            //           },
                                            //           controller: description,
                                            //           decoration: decorationInput6("Description", description.text.isNotEmpty),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            // const SizedBox(height:15),
                                            // //gst
                                            // Row(crossAxisAlignment: CrossAxisAlignment.start,
                                            //   children:  [
                                            //     SizedBox(
                                            //       width:180,
                                            //       child: Row(
                                            //         children:  [
                                            //           const Text('GST %',
                                            //               style:TextStyle(color:Colors.red)
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //     Column(
                                            //       crossAxisAlignment: CrossAxisAlignment.start,
                                            //       children: [
                                            //         SizedBox(
                                            //           width: 310,
                                            //           child: AnimatedContainer(
                                            //             duration: Duration(seconds: 0),
                                            //             height: taxbool ? 55 : 30,
                                            //             child: DropdownSearch<String>(
                                            //               validator: (value) {
                                            //                 if (value == null || value.isEmpty) {
                                            //                   setState(() {
                                            //                     taxbool = true;
                                            //                   });
                                            //                   print(taxbool);
                                            //                   return "Required";
                                            //                 } else {
                                            //                   setState(() {
                                            //                     taxbool = false;
                                            //                   });
                                            //                 }
                                            //               },
                                            //               popupProps: PopupProps.menu(
                                            //                 constraints: BoxConstraints(maxHeight: 200),
                                            //                 showSearchBox: true,
                                            //                 searchFieldProps: TextFieldProps(
                                            //                   decoration: dropdownDecorationSearch(taxquesdropdownValue.isNotEmpty),
                                            //                   cursorColor: Colors.grey,
                                            //                   style: TextStyle(
                                            //                     fontSize: 14,
                                            //                   ),
                                            //                 ),
                                            //               ),
                                            //               items: taxques,
                                            //               selectedItem: taxquesdropdownValue,
                                            //               onChanged: gstSelectionChanged,
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ],
                                            // ),
                                            //
                                            // const SizedBox(height:15),
                                            // //igst
                                            // Row(crossAxisAlignment: CrossAxisAlignment.start,
                                            //   children:  [
                                            //     SizedBox(
                                            //       width:180,
                                            //       child: Row(
                                            //         children:  [
                                            //           const Text('IGST %',style:TextStyle(color:Colors.red)),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //     SizedBox(
                                            //       width: 310,
                                            //       child: AnimatedContainer(
                                            //         duration: Duration(seconds: 0),
                                            //         height: tax2bool ? 55: 30,
                                            //         child: DropdownSearch<String>(
                                            //           validator: (value) {
                                            //             if (value == null || value.isEmpty) {
                                            //               setState(() {
                                            //                 tax2bool = true;
                                            //               });
                                            //               print(tax2bool);
                                            //               return "Required";
                                            //             } else {
                                            //               setState(() {
                                            //                 tax2bool = false;
                                            //               });
                                            //             }
                                            //           },
                                            //           popupProps: PopupProps.menu(
                                            //             constraints: BoxConstraints(maxHeight: 200),
                                            //             showSearchBox: true,
                                            //             searchFieldProps: TextFieldProps(
                                            //               decoration: dropdownDecorationSearch(taxques2dropdownValue.isNotEmpty),
                                            //               cursorColor: Colors.grey,
                                            //               style: TextStyle(
                                            //                 fontSize: 14,
                                            //               ),
                                            //             ),
                                            //           ),
                                            //           items: taxques2,
                                            //           selectedItem: taxques2dropdownValue,
                                            //           onChanged: igstSelectionChanged,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(width:5),
                                    Expanded(
                                      flex:2,
                                      child: SizedBox(
                                        height: 400,
                                        width: width*0.4,
                                        child:
                                        Column(
                                          children: [
                                            //purchase information
                                            Row(
                                              children: const [
                                                Text('Purchase Information',
                                                  style: TextStyle(
                                                    fontSize:20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height:20),
                                            //purchase price
                                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                              children:  [
                                                const SizedBox(
                                                  width:180,
                                                  child: Text('Purchase Price*',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      decoration: TextDecoration.underline,
                                                      decorationStyle: TextDecorationStyle.dotted,
                                                    ),),
                                                ),

                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                height: 30,
                                                                width: 60,
                                                                decoration: const BoxDecoration(
                                                                    color: Color.fromRGBO(224, 224, 224, 1),
                                                                    border:Border(
                                                                      left: BorderSide(
                                                                          color: Colors.grey
                                                                      ),
                                                                      top:BorderSide(color:Colors.grey),
                                                                      bottom:BorderSide(color:Colors.grey),
                                                                    )
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                                                                  child: Text('INR',
                                                                    style: TextStyle(
                                                                      color: Colors.grey[700],
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 15,
                                                                    ),),
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                width: 250,
                                                                child: AnimatedContainer(
                                                                  duration: const Duration(seconds: 0),
                                                                  height: purchasePriceError ? 55 : 30,
                                                                  child: TextFormField(
                                                                    keyboardType: TextInputType.number,
                                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                    validator: (value) {
                                                                      if (value == null ||
                                                                          value.isEmpty) {
                                                                        setState(() {
                                                                          purchasePriceError = true;
                                                                        });
                                                                        // print(purchasePriceError);
                                                                        return "Required";
                                                                      } else {
                                                                        setState(() {
                                                                          purchasePriceError = false;
                                                                        });
                                                                      }
                                                                      return null;
                                                                    },
                                                                    style: const TextStyle(
                                                                        fontSize: 14),
                                                                    onChanged: (text) {
                                                                      setState(() {});
                                                                    },
                                                                    controller: purchasePrice,
                                                                    decoration: decorationInput5(
                                                                        '',
                                                                        purchasePrice
                                                                            .text.isNotEmpty),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                        ]
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height:15),
                                            //account
                                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                              children:  [
                                                const SizedBox(
                                                  width:180,
                                                  child: Text('Account*',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      decoration: TextDecoration.underline,
                                                      decorationStyle: TextDecorationStyle.dotted,
                                                    ),),
                                                ),
                                                // SizedBox(
                                                //   width: 310,
                                                //   child: AnimatedContainer(
                                                //     duration:const Duration(seconds: 0),
                                                //     height: account1bool ? 55: 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             account1bool = true;
                                                //           });
                                                //           //print(account1bool);
                                                //           return "Required";
                                                //         } else {
                                                //           setState(() {
                                                //             account1bool = false;
                                                //           });
                                                //         }
                                                //         return null;
                                                //       },
                                                //       popupProps: PopupProps.menu(
                                                //         constraints:const BoxConstraints(maxHeight: 200),
                                                //         showSearchBox: true,
                                                //         searchFieldProps: TextFieldProps(
                                                //           decoration: dropdownDecorationSearch(purchaseDropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style:const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: acc2,
                                                //       selectedItem: purchaseDropdownValue,
                                                //       onChanged: acc2SelectionChanged,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            const SizedBox(height:15),
                                            //description
                                            // Row(crossAxisAlignment: CrossAxisAlignment.start,
                                            //   children: [
                                            //     const SizedBox(
                                            //       width:180,
                                            //       child: Text('Description'),
                                            //     ),
                                            //     Container(
                                            //       width: 310,
                                            //       child: AnimatedContainer(
                                            //         height: description2bool ? 80 : 70,
                                            //         // height: 38,
                                            //         duration: const Duration(seconds: 0),
                                            //         margin: const EdgeInsets.all(0),
                                            //         // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            //         child: TextFormField(
                                            //           maxLines: null,
                                            //           style: const TextStyle(fontSize: 14),
                                            //           onChanged: (text) {
                                            //             setState(() {});
                                            //           },
                                            //           controller: description2,
                                            //           decoration: decorationInput6("Purchase Description", description2.text.isNotEmpty),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(width<1100)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 570,
                                    width:350,

                                    child:
                                    Column(
                                      children: [
                                        //sales information
                                        Padding(
                                          padding: const EdgeInsets.only(left:15),
                                          child: Row(
                                            children: const [
                                              Text('Sales Information',
                                                style: TextStyle(
                                                  fontSize:20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height:20),
                                        //selling price
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const Text('Selling Price*',
                                              style: TextStyle(
                                                color: Colors.red,
                                                decoration: TextDecoration.underline,
                                                decorationStyle: TextDecorationStyle.dotted,
                                              ),),
                                            const SizedBox(height:10),
                                            SizedBox(
                                              width:310,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 60,
                                                    decoration:const   BoxDecoration(
                                                      //  borderRadius: BorderRadius.only(
                                                      //   topLeft: Radius.circular(3),
                                                      //   topRight: Radius.circular(3),
                                                      //
                                                      // ),
                                                        color: Color.fromRGBO(224, 224, 224, 1),
                                                        border:Border(
                                                          left: BorderSide(
                                                              color: Colors.grey
                                                          ),
                                                          top:BorderSide(color:Colors.grey),
                                                          bottom:BorderSide(color:Colors.grey),
                                                        )
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(12, 2, 0, 0),
                                                      child: Text('INR',
                                                        style: TextStyle(
                                                          color: Colors.grey[700],
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 15,
                                                        ),),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: AnimatedContainer(
                                                      duration: const Duration(seconds: 0),
                                                      height: sellingPriceError ? 55: 30,
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              sellingPriceError = true;
                                                            });
                                                            // print(sellingPriceError);
                                                            return "Required";
                                                          } else {
                                                            setState(() {
                                                              sellingPriceError = false;
                                                            });
                                                          }
                                                          return null;
                                                        },
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        onChanged: (text) {
                                                          setState(() {});
                                                        },
                                                        controller: sellingPrice,
                                                        decoration: decorationInput5(
                                                            '',
                                                            sellingPrice
                                                                .text.isNotEmpty),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        //account
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const Text('Account*',
                                              style: TextStyle(
                                                color: Colors.red,
                                                decoration: TextDecoration.underline,
                                                decorationStyle: TextDecorationStyle.dotted,
                                              ),),
                                            const SizedBox(height:10),
                                            // SizedBox(
                                            //   width: 310,
                                            //   child: AnimatedContainer(
                                            //     duration: const Duration(seconds: 0),
                                            //     height: accountError ? 55 : 30,
                                            //     child: DropdownSearch<String>(
                                            //       validator: (value) {
                                            //         if (value == null || value.isEmpty) {
                                            //           setState(() {
                                            //             accountError = true;
                                            //           });
                                            //           // print(accountError);
                                            //           return "Required";
                                            //         } else {
                                            //           setState(() {
                                            //             accountError = false;
                                            //           });
                                            //         }
                                            //         return null;
                                            //       },
                                            //       popupProps: PopupProps.menu(
                                            //         constraints: const BoxConstraints(maxHeight: 200),
                                            //         showSearchBox: true,
                                            //         searchFieldProps: TextFieldProps(
                                            //           decoration: dropdownDecorationSearch(sellingAccountDropdownValue.isNotEmpty),
                                            //           cursorColor: Colors.grey,
                                            //           style: const TextStyle(
                                            //             fontSize: 14,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       items: acc1,
                                            //       selectedItem: sellingAccountDropdownValue,
                                            //       onChanged: acc1SelectionChanged,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        //description
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Description'),
                                            const SizedBox(height:10),
                                            SizedBox(
                                              width: 310,
                                              child: AnimatedContainer(
                                                height: descriptionError ? 80 : 70,
                                                // height: 38,
                                                duration: const Duration(seconds: 0),
                                                margin: const EdgeInsets.all(0),
                                                // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: TextFormField(
                                                  maxLines: null,
                                                  style: const TextStyle(fontSize: 14),
                                                  onChanged: (text) {
                                                    setState(() {});
                                                  },
                                                  controller: description,
                                                  decoration: decorationInput6("Description", description.text.isNotEmpty),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        //gst
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const Text('GST %',style:TextStyle(color:Colors.red)),
                                            const SizedBox(height:10),
                                            // SizedBox(
                                            //   width: 310,
                                            //   child: AnimatedContainer(
                                            //     duration: const Duration(seconds: 0),
                                            //     height: taxError ? 55 : 30,
                                            //     child: DropdownSearch<String>(
                                            //       validator: (value) {
                                            //         if (value == null || value.isEmpty) {
                                            //           setState(() {
                                            //             taxError = true;
                                            //           });
                                            //           print(taxError);
                                            //           return "Required";
                                            //         } else {
                                            //           setState(() {
                                            //             taxError = false;
                                            //           });
                                            //         }
                                            //         return null;
                                            //       },
                                            //       popupProps: PopupProps.menu(
                                            //         constraints: const BoxConstraints(maxHeight: 200),
                                            //         showSearchBox: true,
                                            //         searchFieldProps: TextFieldProps(
                                            //           decoration: dropdownDecorationSearch(taxQuesDropdownValue.isNotEmpty),
                                            //           cursorColor: Colors.grey,
                                            //           style: const TextStyle(
                                            //             fontSize: 14,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       items: taxques,
                                            //       selectedItem: taxQuesDropdownValue,
                                            //       onChanged: gstSelectionChanged,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),

                                        const SizedBox(height:15),
                                        //ist
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const Text('IGST %',style:TextStyle(color:Colors.red)),
                                            const SizedBox(height:10),
                                            // SizedBox(
                                            //   width: 310,
                                            //   child: AnimatedContainer(
                                            //     duration: const Duration(seconds: 0),
                                            //     height: tax2bool ? 55: 30,
                                            //     child: DropdownSearch<String>(
                                            //       validator: (value) {
                                            //         if (value == null || value.isEmpty) {
                                            //           setState(() {
                                            //             tax2bool = true;
                                            //           });
                                            //           print(tax2bool);
                                            //           return "Required";
                                            //         } else {
                                            //           setState(() {
                                            //             tax2bool = false;
                                            //           });
                                            //         }
                                            //         return null;
                                            //       },
                                            //       popupProps: PopupProps.menu(
                                            //         constraints: const BoxConstraints(maxHeight: 200),
                                            //         showSearchBox: true,
                                            //         searchFieldProps: TextFieldProps(
                                            //           decoration: dropdownDecorationSearch(taxQues2dropdownValue.isNotEmpty),
                                            //           cursorColor: Colors.grey,
                                            //           style: const TextStyle(
                                            //             fontSize: 14,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       items: taxques2,
                                            //       selectedItem: taxQues2dropdownValue,
                                            //       onChanged: igstSelectionChanged,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(width:5),
                                  SizedBox(
                                    height: 400,
                                    width: 350,
                                    child:
                                    Column(
                                      children: [
                                        //purchase information
                                        Padding(
                                          padding: const EdgeInsets.only(left:15),
                                          child: Row(
                                            children: const [
                                              Text('Purchase Information',
                                                style: TextStyle(
                                                  fontSize:20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height:20),
                                        //cost price
                                        Padding(
                                          padding: const EdgeInsets.only(left:15),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            children:  [
                                              const Text('Purchase Price*',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  decoration: TextDecoration.underline,
                                                  decorationStyle: TextDecorationStyle.dotted,
                                                ),),
                                              const SizedBox(height:10),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 60,
                                                    decoration: const BoxDecoration(
                                                        color: Color.fromRGBO(224, 224, 224, 1),
                                                        border:Border(
                                                          left: BorderSide(
                                                              color: Colors.grey
                                                          ),
                                                          top:BorderSide(color:Colors.grey),
                                                          bottom:BorderSide(color:Colors.grey),
                                                        )
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                                                      child: Text('INR',
                                                        style: TextStyle(
                                                          color: Colors.grey[700],
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 15,
                                                        ),),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 250,
                                                    child: AnimatedContainer(
                                                      duration: const Duration(seconds: 0),
                                                      height: purchasePriceError ? 55 : 30,
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              purchasePriceError = true;
                                                            });
                                                            // print(purchasePriceError);
                                                            return "Required";
                                                          } else {
                                                            setState(() {
                                                              purchasePriceError = false;
                                                            });
                                                          }
                                                          return null;
                                                        },
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        onChanged: (text) {
                                                          setState(() {});
                                                        },
                                                        controller: purchasePrice,
                                                        decoration: decorationInput5(
                                                            '',
                                                            purchasePrice
                                                                .text.isNotEmpty),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height:15),
                                        //account
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            const Text('Account*',
                                              style: TextStyle(
                                                color: Colors.red,
                                                decoration: TextDecoration.underline,
                                                decorationStyle: TextDecorationStyle.dotted,
                                              ),),
                                            const SizedBox(height:10),
                                            // SizedBox(
                                            //   width: 310,
                                            //   child: AnimatedContainer(
                                            //     duration: const Duration(seconds: 0),
                                            //     height: account1bool ? 55: 30,
                                            //     child: DropdownSearch<String>(
                                            //       validator: (value) {
                                            //         if (value == null || value.isEmpty) {
                                            //           setState(() {
                                            //             account1bool = true;
                                            //           });
                                            //           //print(account1bool);
                                            //           return "Required";
                                            //         } else {
                                            //           setState(() {
                                            //             account1bool = false;
                                            //           });
                                            //         }
                                            //         return null;
                                            //       },
                                            //       popupProps: PopupProps.menu(
                                            //         constraints: const BoxConstraints(maxHeight: 200),
                                            //         showSearchBox: true,
                                            //         searchFieldProps: TextFieldProps(
                                            //           decoration: dropdownDecorationSearch(purchaseDropdownValue.isNotEmpty),
                                            //           cursorColor: Colors.grey,
                                            //           style: const TextStyle(
                                            //             fontSize: 14,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       items: acc2,
                                            //       selectedItem: purchaseDropdownValue,
                                            //       onChanged: acc2SelectionChanged,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(height:15),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height:15),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar:  SizedBox(
                height:60,
                child: Padding(
                  padding: const EdgeInsets.only(left:50),
                  child: Row(
                    children: [
                      MaterialButton(
                        color:Colors.blue,
                        textColor:Colors.white,
                        onPressed: ()
                        {
                          setState(() {
                            if(addItemsForm.currentState!.validate()){
                              Map requestBody={
                                "newitem_id":widget.itemData["newitem_id"],
                                "description": description.text,
                                "exemption_reason": _tasktax == 1 ?exceptionDropdownValue:"",
                                'item_code':item.text,
                                "name": nameController.text,
                                "purchase_account": purchaseDropdownValue,
                                "purchase_price": purchasePrice.text,
                                "sac": _goodsService==1?sacController.text:"",
                                "selling_account": sellingAccountDropdownValue,
                                "selling_price": sellingPrice.text,
                                "tax_code": _goodsService==0?taxCodeController.text:"",
                                "tax_preference": _tasktax == 0 ?"Taxable":"NonTaxable",
                                "type": _goodsService==1 ? "Services" : "Goods",
                                "unit": unitDropdownValue,
                              };
                              print('-------Add items details');
                              saveData(requestBody);
                            }
                          });

                        },
                        child: const Text('Save'),),
                      const SizedBox(width:10),
                      MaterialButton(
                        color: Colors.white70,
                        // height: 40,
                        // minWidth: 80,
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop();
                          }
                          );
                        },
                        child: const Text('Cancel',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),),
                      const SizedBox(width:10),
                      MaterialButton(
                        color: Colors.red,
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return SizedBox(
                                      height: 200,
                                      width: 300,
                                      child: Stack(children: [
                                        Container(
                                          decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                          margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20.0,right: 25),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.red,
                                                  size: 50,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Center(
                                                    child: Text(
                                                      'Are You Sure, You Want To Delete ?',
                                                      style: TextStyle(
                                                          color: Colors.indigo,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15),
                                                    )),
                                                const SizedBox(
                                                  height: 35,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    MaterialButton(
                                                      color: Colors.red,
                                                      onPressed: () {

                                                        deleteItems();
                                                      },
                                                      child: const Text(
                                                        'Ok',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    MaterialButton(
                                                      color: Colors.blue,
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.of(context).pop();
                                                        });
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                )
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
                                    );
                                  },
                                ),
                              );
                            },
                          );

                        },
                        child: Row(children: const [
                          Icon(Icons.delete,color: Colors.white,),
                          Text("Delete",style: TextStyle(color: Colors.white),)
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveData(Map<dynamic, dynamic> requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/update_newitem"
      ),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Edit Success"),
        ));
        // print("----------from Edit Items --------------");
        print(response.body);
        Navigator.of(context).pop();

      }
      else {
        print("++++++ Status Code ++++++++");
        print(response.statusCode.toString());
      }
    }
    catch (e) {
      print(e.toString());
      print(e);
    }
  }

  Widget _typeRadioButton({required String title, required int value, required  onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _goodsService,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  Widget _taxRadioButton({required String title, required int value, required  onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _tasktax,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  Future deleteItems() async{
    print('========================================');
    print(selectedId);
    try{
      final deleteVendorsValue = await http.delete(
        Uri.parse(
            'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/delete_newitem/$selectedId'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken'
        },
      );
      if(deleteVendorsValue.statusCode ==200){
        setState(() {
          // print(selectedId);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Data Deleted'),)
          );
          // fetchItemData();
          partDetailsBloc.fetchItemNetwork(selectedId,type);
          Navigator.of(context).pop();
          Navigator.of(context).pop();

        });
      }
      else{
        //If response Not Getting It Will Through Exception Error.
        setState(() {
          print(deleteVendorsValue.statusCode.toString());
        });
      }
    }
    catch(e){
      print(e.toString());
      print(e);
    }
  }
}


















