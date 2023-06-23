import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/input_decoration_text_field.dart';
class AddItems extends StatefulWidget {

  final double drawerWidth;
  final double selectedDestination;
  const AddItems({Key? key,  required this.drawerWidth, required this.selectedDestination}) : super(key: key);

  @override
  _AddItemsState createState() => _AddItemsState();
}
// enum SingingCharacter {goods, services,taxable, nontaxable }
// enum SingingCharacter {taxable, nontaxable }

class _AddItemsState extends State<AddItems> {

  void unitSelectionChanged(String? u){
    setState(() {
      unitdropdownValue = u!;
    });
  }
  void acc1SelectionChanged(String? a1){
    setState(() {
      acc1dropdownValue = a1!;
    });
  }
  void acc2SelectionChanged(String? a2){
    setState(() {
      acc2dropdownValue = a2!;
    });
  }
  void gstSelectionChanged(String? gst){
    setState(() {
      taxquesdropdownValue = gst!;
      cgstSgst=double.parse(gst)/2;

    });
  }
  void igstSelectionChanged(String? igst){
    setState(() {
      taxques2dropdownValue = igst!;
    });
  }
  void exRemSelectionChanged(String? ex){
    setState(() {
      exRedropdownValue = ex!;
    });
  }


  List<String> textlist = [];

  final sellingPrice = TextEditingController();
  // final account = TextEditingController();
  final description = TextEditingController();
  final tax = TextEditingController();
  final purchasePrice = TextEditingController();
  // final account2 = TextEditingController();
  final description2 = TextEditingController();
  final nameController = TextEditingController();
  final item=TextEditingController();

  // final unitController = TextEditingController();
  final skuController = TextEditingController();
  final hsnController = TextEditingController();
  final sacController = TextEditingController();
  final goodsController = TextEditingController();
  final servicesController = TextEditingController();
  final taxableController = TextEditingController();
  final nonTaxableController = TextEditingController();
  final checkController = TextEditingController();
  final salesInfoController = TextEditingController();
  final purchaseInfoController = TextEditingController();
  final exemptionController = TextEditingController();

  double cgstSgst=0;

  bool sellingpricebool = false;
  bool accountbool = false;
  bool account1bool=false;
  bool descriptionbool = false;
  bool taxbool = false;
  bool tax2bool = false;
  bool costpricebool = false;
  bool account2bool = false;
  bool description2bool = false;
  bool namebool = false;
  bool itemcode=false;
  bool skubool = false;
  bool hsnbool = false;
  bool sacbool = false;
  bool unitbool = false;
  bool exemptionbool = false;
  bool checkbool = false;

  bool isDisabled = false;
  bool isDisabled1 = false;
  bool isServiceDisable = false;

  var unitdropdownValue = "";
  var acc1dropdownValue = "";
  var taxquesdropdownValue = "";
  var taxques2dropdownValue = "";
  var acc2dropdownValue = "";
  var exRedropdownValue = "";
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
    'Discount',
    'General Income',
    'Interest Income',
    'Late Fee Income',
    'Sales',
    'Other Charges',
    'Shipping Charge'
  ];
  var exmRe = [
    'ExRe 1',
    'ExRe 2',
    'ExRe 3',
    'ExRe 4',
    'ExRe 5',
  ];

  dynamic size;
  dynamic    height;
  dynamic width;


  int _character = 0;
  int _taskTax = 0;
  String? authToken;
  String? selectedId;
  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialData();
  }
  final addItemsForm=GlobalKey<FormState>();
  bool loading=false;
  // Custom Unit Type.
  List <CustomPopupMenuEntry<String>> unitTypes =<CustomPopupMenuEntry<String>>[

    const CustomPopupMenuItem(height: 40,
      value: 'DOZEN',
      child: Center(child: SizedBox(width: 350,child: Text('DOZEN',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'BOX',
      child: Center(child: SizedBox(width: 350,child: Text('BOX',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'GRAMS',
      child: Center(child: SizedBox(width: 350,child: Text('GRAMS',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'KILOGRAMS',
      child: Center(child: SizedBox(width: 350,child: Text('KILOGRAMS',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'METERS',
      child: Center(child: SizedBox(width: 350,child: Text('METERS',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'TABLETS',
      child: Center(child: SizedBox(width: 350,child: Text('TABLETS',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'UNITS',
      child: Center(child: SizedBox(width: 350,child: Text('UNITS',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'PIECES',
      child: Center(child: SizedBox(width: 350,child: Text('PIECES',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'PAIRS',
      child: Center(child: SizedBox(width: 350,child: Text('PAIRS',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
  ];
  String unitTypeText = "Select Unit Type";
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

              body: CustomLoader(
                inAsyncCall: loading,                  child: SingleChildScrollView(
                child:
                Form(
                  key:addItemsForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //-------------- first container-------------------
                      if(width>1000)
                        Container(
                          color: const Color(0xffF4FAFF),
                          child: Padding(
                            padding: const EdgeInsets.only(left:50,top:20),
                            child: Column(
                              children: [
                                const Align(alignment:Alignment.topLeft,
                                  child:  Text(
                                    "Create Item",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                //type Radio buttons
                                Row(
                                  children:  [
                                    //type
                                    const SizedBox(
                                      width: 180,
                                      child: Row(
                                        children: [
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
                                              _character = newValue;
                                            }),
                                          ),
                                        ),
                                        SizedBox(width: 190,
                                          child: _typeRadioButton(
                                            title: "Services",
                                            value: 1,
                                            onChanged: (newValue) => setState(() {
                                              _character = newValue;
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if(_character == 0)
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
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 350,
                                            color: const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration: const Duration(seconds: 0),
                                              height: namebool ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      namebool = true;
                                                    });
                                                    // print(namebool);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      namebool = false;
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
                                      //Item Code
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
                                            color: const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration: const Duration(seconds: 0),
                                              height: itemcode ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      itemcode = true;
                                                    });
                                                    // print(namebool);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      itemcode = false;
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
                                              height: descriptionbool ? 60 : 50,
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
                                       Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          SizedBox(
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
                                          //     height: unitbool ? 55 : 30,
                                          //     child: DropdownSearch<String>(
                                          //       validator: (value) {
                                          //         if (value == null || value.isEmpty) {
                                          //           setState(() {
                                          //             unitbool = true;
                                          //           });
                                          //           // print(unitbool);
                                          //           return "Required";
                                          //         } else {
                                          //           setState(() {
                                          //             unitbool = false;
                                          //           });
                                          //         }
                                          //         return null;
                                          //       },
                                          //       popupProps: PopupProps.menu(
                                          //         constraints:const BoxConstraints(maxHeight: 200),
                                          //         showSearchBox: true,
                                          //         searchFieldProps: TextFieldProps(
                                          //
                                          //           decoration: dropdownDecorationSearch(unitdropdownValue.isNotEmpty),
                                          //           cursorColor: Colors.grey,
                                          //           style:const TextStyle(
                                          //             fontSize: 14,
                                          //           ),
                                          //         ),
                                          //
                                          //       ),
                                          //
                                          //       items: unit,
                                          //       selectedItem: unitdropdownValue,
                                          //
                                          //       onChanged: unitSelectionChanged,
                                          //     ),
                                          //
                                          //   ),
                                          // ),
                                          Container(
                                            height: 30,
                                            width: 350,
                                            decoration: BoxDecoration(border: Border.all(color: Colors.black54,),
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(4),
                                              ),),
                                            child: CustomPopupMenuButton<String>( 
                                            childHeight: 200,
                                              childWidth: 350,position: CustomPopupMenuPosition.under,
                                              decoration: customPopupCreateAddItem(hintText: unitTypeText),
                                              hintText: "",
                                              shape: const RoundedRectangleBorder(
                                                side: BorderSide(color:Color(0xFFE0E0E0)),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              offset: const Offset(1, 12),
                                              tooltip: '',
                                              itemBuilder: (context) {
                                                return unitTypes;
                                              },
                                              onSelected: (String value)  {
                                                setState(() {
                                                  unitTypeText = value;
                                                });
                                              },
                                              onCanceled: () {

                                              },
                                              child: Container(),
                                            ),
                                          ),
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
                                              height: hsnbool ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      hsnbool = true;
                                                    });
                                                    // print(hsnbool);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      hsnbool = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller: hsnController,
                                                decoration: decorationInput5(
                                                    '',
                                                    hsnController
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
                                                        _taskTax = newValue;
                                                      }),
                                                    ),
                                                  ),
                                                  SizedBox(width: 190,
                                                    child: _taxRadioButton(
                                                      title: "Non-Taxable",
                                                      value: 1,
                                                      onChanged: (newValue) => setState(() {
                                                        _taskTax = newValue;
                                                      }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height:15),
                                          if(_taskTax==1)
                                            const Row(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
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
                                                //         height: exemptionbool ? 55 : 30,
                                                //         child: DropdownSearch<String>(
                                                //           validator: (value) {
                                                //             if (value == null || value.isEmpty) {
                                                //               setState(() {
                                                //                 exemptionbool = true;
                                                //               });
                                                //               // print(exemptionbool);
                                                //               return "Required";
                                                //             } else {
                                                //               setState(() {
                                                //                 exemptionbool = false;
                                                //               });
                                                //             }
                                                //             return null;
                                                //           },
                                                //           popupProps: PopupProps.menu(
                                                //             constraints:const BoxConstraints(maxHeight: 200),
                                                //             showSearchBox: true,
                                                //             searchFieldProps: TextFieldProps(
                                                //               decoration: dropdownDecorationSearch(exRedropdownValue.isNotEmpty),
                                                //               cursorColor: Colors.grey,
                                                //               style:const TextStyle(
                                                //                 fontSize: 14,
                                                //               ),
                                                //             ),
                                                //           ),
                                                //           items: exmRe,
                                                //           selectedItem: exRedropdownValue,
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
                                if (_character == 1)
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
                                                    height: namebool ? 55 : 30,
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            namebool = true;
                                                          });
                                                          // print(namebool);
                                                          return "Required";
                                                        } else {
                                                          setState(() {
                                                            namebool = false;
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
                                        //Item code
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
                                                height: itemcode ? 55 : 30,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      setState(() {
                                                        itemcode = true;
                                                      });
                                                      // print(namebool);
                                                      return "Required";
                                                    } else {
                                                      setState(() {
                                                        itemcode = false;
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
                                        //Discription Row.
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
                                                height: descriptionbool ? 80 : 70,
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

                                            // Column(
                                            //   crossAxisAlignment: CrossAxisAlignment.start,
                                            //   children: [
                                            //     Container(
                                            //       width: 350,
                                            //       color:const Color.fromRGBO(255, 255, 255, 1),
                                            //       child: AnimatedContainer(
                                            //         duration:const Duration(seconds: 0),
                                            //         height: unitbool ? 55 : 30,
                                            //         child: DropdownSearch<String>(
                                            //           validator: (value) {
                                            //             if (value == null || value.isEmpty) {
                                            //               setState(() {
                                            //                 unitbool = true;
                                            //               });
                                            //               //print(unitbool);
                                            //               return "Required";
                                            //             } else {
                                            //               setState(() {
                                            //                 unitbool = false;
                                            //               });
                                            //             }
                                            //             return null;
                                            //           },
                                            //           popupProps: PopupProps.menu(
                                            //             constraints:const BoxConstraints(maxHeight: 200),
                                            //             showSearchBox: true,
                                            //             searchFieldProps: TextFieldProps(
                                            //               decoration: dropdownDecorationSearch(unitdropdownValue.isNotEmpty),
                                            //               cursorColor: Colors.grey,
                                            //               style:const TextStyle(
                                            //                 fontSize: 14,
                                            //               ),
                                            //             ),
                                            //           ),
                                            //           items: unit,
                                            //           selectedItem: unitdropdownValue,
                                            //           onChanged: unitSelectionChanged,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
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
                                                      height: sacbool ? 55 : 30,
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              sacbool = true;
                                                            });
                                                            // print(sacbool);
                                                            return "Required";
                                                          } else {
                                                            setState(() {
                                                              sacbool = false;
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
                                                          _taskTax = newValue;
                                                        }),
                                                      ),
                                                    ),
                                                    SizedBox(width: 190,
                                                      child: _taxRadioButton(
                                                        title: "Non-Taxable",
                                                        value: 1,
                                                        onChanged: (newValue) => setState(() {
                                                          _taskTax = newValue;
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height:10),
                                            if(_taskTax==1)
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
                                                  //   color: const Color.fromRGBO(255, 255, 255, 1),
                                                  //   child: AnimatedContainer(
                                                  //     duration: const Duration(seconds: 0),
                                                  //     height: exemptionbool ? 55 : 30,
                                                  //     child: DropdownSearch<String>(
                                                  //       validator: (value) {
                                                  //         if (value == null || value.isEmpty) {
                                                  //           setState(() {
                                                  //             exemptionbool = true;
                                                  //           });
                                                  //           //print(exemptionbool);
                                                  //           return "Required";
                                                  //         } else {
                                                  //           setState(() {
                                                  //             exemptionbool = false;
                                                  //           });
                                                  //         }
                                                  //         return null;
                                                  //       },
                                                  //       popupProps: PopupProps.menu(
                                                  //         constraints:const BoxConstraints(maxHeight: 200),
                                                  //         showSearchBox: true,
                                                  //         searchFieldProps: TextFieldProps(
                                                  //           decoration: dropdownDecorationSearch(exRedropdownValue.isNotEmpty),
                                                  //           cursorColor: Colors.grey,
                                                  //           style:const TextStyle(
                                                  //             fontSize: 14,
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //       items: exmRe,
                                                  //       selectedItem: exRedropdownValue,
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
                                    const SizedBox(
                                      width: 180,
                                      child: Row(
                                        children: [
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
                                              _character = newValue;
                                            }),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(width: 190,
                                            child: _typeRadioButton(
                                              title: "Services",
                                              value: 1,
                                              onChanged: (newValue) => setState(() {
                                                _character = newValue;
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if(_character == 0)
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
                                            color: const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration:const Duration(seconds: 0),
                                              height: namebool ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      namebool = true;
                                                    });
                                                    // print(namebool);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      namebool = false;
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
                                      //Item Code
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
                                            color: const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              duration: const Duration(seconds: 0),
                                              height: itemcode ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      itemcode = true;
                                                    });
                                                    // print(namebool);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      itemcode = false;
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
                                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Description'),
                                          const SizedBox(height:10),
                                          Container(
                                            width: 350,
                                            color:const Color.fromRGBO(255, 255, 255, 1),
                                            child: AnimatedContainer(
                                              height: descriptionbool ? 80 : 70,
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
                                      Column( crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          const Row(
                                            children: [
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
                                          //     height: unitbool ? 55 : 30,
                                          //     child: DropdownSearch<String>(
                                          //       validator: (value) {
                                          //         if (value == null || value.isEmpty) {
                                          //           setState(() {
                                          //             unitbool = true;
                                          //           });
                                          //           // print(unitbool);
                                          //           return "Required";
                                          //         } else {
                                          //           setState(() {
                                          //             unitbool = false;
                                          //           });
                                          //         }
                                          //         return null;
                                          //       },
                                          //       popupProps: PopupProps.menu(
                                          //         constraints:const BoxConstraints(maxHeight: 200),
                                          //         showSearchBox: true,
                                          //         searchFieldProps: TextFieldProps(
                                          //           decoration: dropdownDecorationSearch(unitdropdownValue.isNotEmpty),
                                          //           cursorColor: Colors.grey,
                                          //           style:const TextStyle(
                                          //             fontSize: 14,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       items: unit,
                                          //       selectedItem: unitdropdownValue,
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
                                              height: hsnbool ? 55 : 30,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      hsnbool = true;
                                                    });
                                                    // print(hsnbool);
                                                    return "Required";
                                                  } else {
                                                    setState(() {
                                                      hsnbool = false;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                onChanged: (text) {
                                                  setState(() {});
                                                },
                                                controller: hsnController,
                                                decoration: decorationInput5(
                                                    '',
                                                    hsnController
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
                                                    _taskTax = newValue;
                                                  }),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(width: 190,
                                                  child: _taxRadioButton(
                                                    title: "Non-Taxable",
                                                    value: 1,
                                                    onChanged: (newValue) => setState(() {
                                                      _taskTax = newValue;
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height:15),
                                      if(_taskTax==1)
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Row(
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
                                            const SizedBox(height:10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Container(
                                                //   width: 350,
                                                //   color: const Color.fromRGBO(255, 255, 255, 1),
                                                //   child: AnimatedContainer(
                                                //     duration: const Duration(seconds: 0),
                                                //     height: exemptionbool ? 55 : 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             exemptionbool = true;
                                                //           });
                                                //           //print(exemptionbool);
                                                //           return "Required";
                                                //         } else {
                                                //           setState(() {
                                                //             exemptionbool = false;
                                                //           });
                                                //         }
                                                //         return null;
                                                //       },
                                                //       popupProps: PopupProps.menu(
                                                //         constraints: const BoxConstraints(maxHeight: 200),
                                                //         showSearchBox: true,
                                                //         searchFieldProps: TextFieldProps(
                                                //           decoration: dropdownDecorationSearch(exRedropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style: const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: exmRe,
                                                //       selectedItem: exRedropdownValue,
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
                                if (_character == 1)
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
                                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                                  child: AnimatedContainer(
                                                    duration: const Duration(seconds: 0),
                                                    height: namebool ? 55 : 30,
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            namebool = true;
                                                          });
                                                          // print(namebool);
                                                          return "Required";
                                                        } else {
                                                          setState(() {
                                                            namebool = false;
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
                                        //item code
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
                                              color: const Color.fromRGBO(255, 255, 255, 1),
                                              child: AnimatedContainer(
                                                duration: const Duration(seconds: 0),
                                                height: itemcode ? 55 : 30,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      setState(() {
                                                        itemcode = true;
                                                      });
                                                      // print(namebool);
                                                      return "Required";
                                                    } else {
                                                      setState(() {
                                                        itemcode = false;
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
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Description'),
                                            const SizedBox(height:10),
                                            Container(
                                              width: 350,
                                              color: const Color.fromRGBO(255, 255, 255, 1),
                                              child: AnimatedContainer(
                                                height: descriptionbool ? 80 : 70,
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
                                            const Row(
                                              children: [
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
                                                //   color: const Color.fromRGBO(255, 255, 255, 1),
                                                //   child: AnimatedContainer(
                                                //     duration: const Duration(seconds: 0),
                                                //     height: unitbool ? 55 : 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             unitbool = true;
                                                //           });
                                                //           // print(unitbool);
                                                //           return "Required";
                                                //         } else {
                                                //           setState(() {
                                                //             unitbool = false;
                                                //           });
                                                //         }
                                                //         return null;
                                                //       },
                                                //       popupProps: PopupProps.menu(
                                                //         constraints: const BoxConstraints(maxHeight: 200),
                                                //         showSearchBox: true,
                                                //         searchFieldProps: TextFieldProps(
                                                //           decoration: dropdownDecorationSearch(unitdropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style: const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: unit,
                                                //       selectedItem: unitdropdownValue,
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
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                  Container(
                                                    width: 350,
                                                    color: const Color.fromRGBO(255, 255, 255, 1),
                                                    child: AnimatedContainer(
                                                      duration: const Duration(seconds: 0),
                                                      height: sacbool ? 55: 30,
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              sacbool = true;
                                                            });
                                                            //print(sacbool);
                                                            return "Required";
                                                          } else {
                                                            setState(() {
                                                              sacbool = false;
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
                                                          _taskTax = newValue;
                                                        }),
                                                      ),
                                                    ),
                                                    SizedBox(width: 190,
                                                      child: _taxRadioButton(
                                                        title: "Non-Taxable",
                                                        value: 1,
                                                        onChanged: (newValue) => setState(() {
                                                          _taskTax = newValue;
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if(_taskTax==1)
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Row(
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
                                                  const SizedBox(height:10),
                                                  // Container(
                                                  //   width: 350,
                                                  //   color: const Color.fromRGBO(255, 255, 255, 1),
                                                  //   child: AnimatedContainer(
                                                  //     duration: const Duration(seconds: 0),
                                                  //     height: exemptionbool ? 55 : 30,
                                                  //     child: DropdownSearch<String>(
                                                  //       validator: (value) {
                                                  //         if (value == null || value.isEmpty) {
                                                  //           setState(() {
                                                  //             exemptionbool = true;
                                                  //           });
                                                  //           //print(exemptionbool);
                                                  //           return "Required";
                                                  //         } else {
                                                  //           setState(() {
                                                  //             exemptionbool = false;
                                                  //           });
                                                  //         }
                                                  //         return null;
                                                  //       },
                                                  //       popupProps: PopupProps.menu(
                                                  //         constraints: const BoxConstraints(maxHeight: 200),
                                                  //         showSearchBox: true,
                                                  //         searchFieldProps: TextFieldProps(
                                                  //           decoration: dropdownDecorationSearch(exRedropdownValue.isNotEmpty),
                                                  //           cursorColor: Colors.grey,
                                                  //           style: const TextStyle(
                                                  //             fontSize: 14,
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //       items: exmRe,
                                                  //       selectedItem: exRedropdownValue,
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
                      //---------------second container--------------

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
                                            const Row(
                                              children: [
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
                                                                  height: sellingpricebool ? 55: 30,
                                                                  child: TextFormField(
                                                                    keyboardType: TextInputType.number,
                                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                    validator: (value) {
                                                                      if (value == null ||
                                                                          value.isEmpty) {
                                                                        setState(() {
                                                                          sellingpricebool = true;
                                                                        });
                                                                        //print(sellingpricebool);
                                                                        return "Required";
                                                                      } else {
                                                                        setState(() {
                                                                          sellingpricebool = false;
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
                                                //     duration: const Duration(seconds: 0),
                                                //     height: accountbool ? 55 : 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             accountbool = true;
                                                //           });
                                                //           print(accountbool);
                                                //           return "Required";
                                                //         } else {
                                                //           setState(() {
                                                //             accountbool = false;
                                                //           });
                                                //         }
                                                //         return null;
                                                //       },
                                                //       popupProps: PopupProps.menu(
                                                //         constraints: const BoxConstraints(maxHeight: 200),
                                                //         showSearchBox: true,
                                                //         searchFieldProps: TextFieldProps(
                                                //           decoration: dropdownDecorationSearch(acc1dropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style: const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: acc1,
                                                //       selectedItem: acc1dropdownValue,
                                                //       onChanged: acc1SelectionChanged,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            const SizedBox(height:15),

                                            const SizedBox(height:15),
                                            //This Code Is For Gst And Igst.
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
                                            //
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
                                            //           const Text('IGST %',
                                            //                   style:TextStyle(color:Colors.red)
                                            //               ),
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
                                            const Row(
                                              children:  [
                                                Text('Purchase Information',
                                                  style: TextStyle(
                                                    fontSize:20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height:20),
                                            //cost price
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
                                                                  height: costpricebool ? 55 : 30,
                                                                  child: TextFormField(
                                                                    keyboardType: TextInputType.number,
                                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                    validator: (value) {
                                                                      if (value == null ||
                                                                          value.isEmpty) {
                                                                        setState(() {
                                                                          costpricebool = true;
                                                                        });
                                                                        print(costpricebool);
                                                                        return "Required";
                                                                      } else {
                                                                        setState(() {
                                                                          costpricebool = false;
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
                                                //     duration: const Duration(seconds: 0),
                                                //     height: account1bool ? 55: 30,
                                                //     child: DropdownSearch<String>(
                                                //       validator: (value) {
                                                //         if (value == null || value.isEmpty) {
                                                //           setState(() {
                                                //             account1bool = true;
                                                //           });
                                                //           print(account1bool);
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
                                                //           decoration: dropdownDecorationSearch(acc2dropdownValue.isNotEmpty),
                                                //           cursorColor: Colors.grey,
                                                //           style: const TextStyle(
                                                //             fontSize: 14,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       items: acc2,
                                                //       selectedItem: acc2dropdownValue,
                                                //       onChanged: acc2SelectionChanged,
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
                                    height: 350,
                                    width:350,

                                    child:
                                    Column(
                                      children: [
                                        //sales information
                                        const Padding(
                                          padding: EdgeInsets.only(left:15),
                                          child: Row(
                                            children: [
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
                                                      height: sellingpricebool ? 55: 30,
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              sellingpricebool = true;
                                                            });
                                                            // print(sellingpricebool);
                                                            return "Required";
                                                          } else {
                                                            setState(() {
                                                              sellingpricebool = false;
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
                                            //     height: accountbool ? 55 : 30,
                                            //     child: DropdownSearch<String>(
                                            //       validator: (value) {
                                            //         if (value == null || value.isEmpty) {
                                            //           setState(() {
                                            //             accountbool = true;
                                            //           });
                                            //           print(accountbool);
                                            //           return "Required";
                                            //         } else {
                                            //           setState(() {
                                            //             accountbool = false;
                                            //           });
                                            //         }
                                            //         return null;
                                            //       },
                                            //       popupProps: PopupProps.menu(
                                            //         constraints: const BoxConstraints(maxHeight: 200),
                                            //         showSearchBox: true,
                                            //         searchFieldProps: TextFieldProps(
                                            //           decoration: dropdownDecorationSearch(acc1dropdownValue.isNotEmpty),
                                            //           cursorColor: Colors.grey,
                                            //           style: const TextStyle(
                                            //             fontSize: 14,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       items: acc1,
                                            //       selectedItem: acc1dropdownValue,
                                            //       onChanged: acc1SelectionChanged,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(height:15),
                                        //description
                                        // Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Text('Description'),
                                        //     SizedBox(height:10),
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
                                        // Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children:  [
                                        //     const Text('GST %',
                                        //             style:TextStyle(color:Colors.red)
                                        //         ),
                                        //     SizedBox(height:10),
                                        //     SizedBox(
                                        //       width: 310,
                                        //       child: AnimatedContainer(
                                        //         duration: Duration(seconds: 0),
                                        //         height: taxbool ? 55 : 30,
                                        //         child: DropdownSearch<String>(
                                        //           validator: (value) {
                                        //             if (value == null || value.isEmpty) {
                                        //               setState(() {
                                        //                 taxbool = true;
                                        //               });
                                        //               print(taxbool);
                                        //               return "Required";
                                        //             } else {
                                        //               setState(() {
                                        //                 taxbool = false;
                                        //               });
                                        //             }
                                        //           },
                                        //           popupProps: PopupProps.menu(
                                        //             constraints: BoxConstraints(maxHeight: 200),
                                        //             showSearchBox: true,
                                        //             searchFieldProps: TextFieldProps(
                                        //               decoration: dropdownDecorationSearch(taxquesdropdownValue.isNotEmpty),
                                        //               cursorColor: Colors.grey,
                                        //               style: TextStyle(
                                        //                 fontSize: 14,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           items: taxques,
                                        //           selectedItem: taxquesdropdownValue,
                                        //           onChanged: gstSelectionChanged,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        //
                                        // const SizedBox(height:15),
                                        // //igst
                                        // Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children:[
                                        //     const Text('IGST %',
                                        //             style:TextStyle(color:Colors.red)
                                        //         ),
                                        //     SizedBox(height:10),
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
                                  Container(width:5),
                                  SizedBox(
                                    height: 400,
                                    width: 350,
                                    child:
                                    Column(
                                      children: [
                                        //purchase information
                                        const Padding(
                                          padding: EdgeInsets.only(left:15),
                                          child: Row(
                                            children: [
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
                                              const Text('Cost Price*',
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
                                                      height: costpricebool ? 55 : 30,
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              costpricebool = true;
                                                            });
                                                            return "Required";
                                                          } else {
                                                            setState(() {
                                                              costpricebool = false;
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
                                        // Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children:  [
                                        //     const Text('Account*',
                                        //       style: TextStyle(
                                        //         color: Colors.red,
                                        //         decoration: TextDecoration.underline,
                                        //         decorationStyle: TextDecorationStyle.dotted,
                                        //       ),),
                                        //     const SizedBox(height:10),
                                        //     SizedBox(
                                        //       width: 310,
                                        //       child: AnimatedContainer(
                                        //         duration: const Duration(seconds: 0),
                                        //         height: account1bool ? 55: 30,
                                        //         child: DropdownSearch<String>(
                                        //           validator: (value) {
                                        //             if (value == null || value.isEmpty) {
                                        //               setState(() {
                                        //                 account1bool = true;
                                        //               });
                                        //               // print(account1bool);
                                        //               return "Required";
                                        //             } else {
                                        //               setState(() {
                                        //                 account1bool = false;
                                        //               });
                                        //             }
                                        //             return null;
                                        //           },
                                        //           popupProps: PopupProps.menu(
                                        //             constraints: const BoxConstraints(maxHeight: 200),
                                        //             showSearchBox: true,
                                        //             searchFieldProps: TextFieldProps(
                                        //               decoration: dropdownDecorationSearch(acc2dropdownValue.isNotEmpty),
                                        //               cursorColor: Colors.grey,
                                        //               style: const TextStyle(
                                        //                 fontSize: 14,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           items: acc2,
                                        //           selectedItem: acc2dropdownValue,
                                        //           onChanged: acc2SelectionChanged,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        const SizedBox(height:15),
                                        //description
                                        // Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Text('Description'),
                                        //     SizedBox(height:10),
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
                                        //
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
              ),
              bottomNavigationBar: Container(
                height:60,
                decoration:BoxDecoration(border:Border.all(color:const Color.fromRGBO(204, 204, 204, 1))),
                child: Padding(
                  padding: const EdgeInsets.only(left:50),
                  child: Row(
                    children: [
                      MaterialButton(
                        color:Colors.blue,
                        textColor:Colors.white,
                        onPressed: () {
                          setState(() {
                            if(addItemsForm.currentState!.validate()){
                              Map requestBody={
                                "description": description.text,
                                "exemption_reason": _taskTax == 1 ?exRedropdownValue:"",
                                'item_code':item.text,
                                "name": nameController.text,
                                "purchase_account": acc2dropdownValue,
                                "purchase_price":double.parse(purchasePrice.text),
                                "sac":_character==1?sacController.text:"",
                                "selling_account": acc1dropdownValue,
                                "selling_price": double.parse(sellingPrice.text),
                                "tax_code": _character==0?hsnController.text:"",
                                "tax_preference": _taskTax == 0 ?"Taxable":"NonTaxable",
                                "type": _character==1 ? "Sevices" : "Goods",
                                "unit": unitdropdownValue,
                              };
                              print(requestBody);
                              saveData(requestBody);
                            }

                          }
                          );
                        },
                        child: const Text('Save'),),
                      const SizedBox(width:30),
                      SizedBox(
                        width: 80,
                        height: 30,
                        child: MaterialButton(
                            onPressed: (){
                              setState(() {
                                Navigator.of(context).pop();

                              });
                            },
                            color: Colors.white,
                            child: const Center(
                              child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),
                            )),
                      ),
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

  Future<void> saveData(Map <dynamic,dynamic> requestBody) async {
    String url="https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/add_newitem";
    postData(context:context ,url:url ,requestBody:requestBody ).then((value) {
      setState(() {
        if(value!=null){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Saved')));
          Navigator.of(context).pop();
        }
        loading= true;
      });
    });

    // try {
    //   final response = await http.post(Uri.parse(
    //       "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/add_newitem"),
    //       headers: {
    //         "Content-Type": "application/json",
    //         'Authorization': 'Bearer $authToken'
    //
    //       },
    //       body: json.encode(requestBody)
    //   );
    //   if (response.statusCode == 200) {
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text("Data Saved"),
    //     ));
    //     print(response.body);
    //     Navigator.of(context).pop();
    //
    //   }
    //   else {
    //     print("++++++ Status Code ++++++++");
    //     print(response.statusCode.toString());
    //   }
    // }
    // catch (e) {
    //   print(e.toString());
    //   print(e);
    // }
  }

  Widget _typeRadioButton({required String title, required int value, required  onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _character,
      onChanged: onChanged,
      title: Text(title),
    );
  }
  Widget _taxRadioButton({required String title, required int value, required  onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _taskTax,
      onChanged: onChanged,
      title: Text(title),
    );
  }
  customPopupCreateAddItem ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down,color: Colors.grey,),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: hintText=="Select User Role"? TextStyle(color: Colors.black54):TextStyle(color: Colors.black,),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
}


















