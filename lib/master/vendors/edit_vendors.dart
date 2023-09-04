import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/widgets/motows_buttons/outlined_mbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/input_decoration_text_field.dart';
import 'bloc/vendors_details_bloc.dart';

class EditVendors extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map vendorData;

  const EditVendors(
      {Key? key,
        required this.selectedDestination,
        required this.drawerWidth,
        required this.vendorData})
      : super(key: key);

  @override
  State<EditVendors> createState() => _AddNewVendorsState();
}

class _AddNewVendorsState extends State<EditVendors>
    with SingleTickerProviderStateMixin {
  final top_details = GlobalKey<FormState>();

  var tabs = false;


  void vendorDisplayName(String? v) {
    setState(() {
      vendor = v!;
    });
  }



  // drop down for customer page.


  //top text fields controller names.

  Map _vendrpage = {};
  var companyname = TextEditingController();
  var email = TextEditingController();
  var vendorCode = TextEditingController();
  var work = TextEditingController();
  var mobile = TextEditingController();
  var contact_person_name = TextEditingController();
  var contact_person_email = TextEditingController();
  var contact_person_phone = TextEditingController();
  var gstController1 = TextEditingController();
  var panController1 = TextEditingController();

  //other details error display.

//error display.
  bool vendorTypeError = false;
  bool company = false;
  bool emailError = false;
  bool vendorCodeError = false;
  bool mobileError = false;
  bool contact_person_name_error = false;
  bool contact_person_email_error = false;
  bool contact_person_phone_error = false;
  bool gstError1 = false;
  bool panError1 = false;
  bool vendorError = false;


  bool isChecked = false;


  final List<Widget> myTabs = [
    const Tab(text: 'Pay-To Address'),
    const Tab(text: 'Ship-From Address'),
  ];

//Address Page Textfields.
  Map address_page = {};

  var vendorAdd1 = TextEditingController();
  var vendorAdd2 = TextEditingController();
  var vendorState = TextEditingController();
  var vendorZip = TextEditingController();
  var vendorRegion = TextEditingController();
  var vendorCity = TextEditingController();
  var vendorGst = TextEditingController();
  var vendorPan = TextEditingController();

  var payNameController = TextEditingController();
  var payAdd1 = TextEditingController();
  var payAdd2 = TextEditingController();
  var payState = TextEditingController();
  var payZip = TextEditingController();
  var payRegion = TextEditingController();
  var payCity = TextEditingController();
  var payGst = TextEditingController();
  var payPan = TextEditingController();

  var shipNameController = TextEditingController();
  var shipAdd1 = TextEditingController();
  var shipAdd2 = TextEditingController();
  var shipState = TextEditingController();
  var shipZip = TextEditingController();
  var shipRegion = TextEditingController();
  var shipCity = TextEditingController();
  var shipGst = TextEditingController();
  var shipPan = TextEditingController();

  bool vendorAdd1Error = false;
  bool vendorAdd2Error = false;
  bool vendorStateError = false;
  bool vendorZipError = false;
  bool vendorRegionError = false;
  bool vendorCityError = false;
  bool vendorGstError = false;
  bool vendorPanError = false;

  bool payNameError = false;
  bool payAdd1Error = false;
  bool payAdd2Error = false;
  bool payStateError = false;
  bool payZipError = false;
  bool payRegionError = false;
  bool payCityError = false;
  bool payGstError = false;
  bool payPanError = false;

  bool shipNameError = false;
  bool shipAdd1Error = false;
  bool shipAdd2Error = false;
  bool shipStateError = false;
  bool shipZipError = false;
  bool shipRegionError = false;
  bool shipCityError = false;
  bool shipGstError = false;
  bool shipPanError = false;



  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getInitialData().whenComplete((){
      // selectedId = widget.vendorData['new_vendor_id'];
    });
    _tabController = TabController(length: myTabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    // print('-------widget.vendorData------');
    // print(widget.vendorData);
    selectedId = widget.vendorData['new_vendor_id'];
    companyname.text = widget.vendorData["company_name"];
    vendor = widget.vendorData["vendor_display_name"];
    email.text = widget.vendorData["vendor_email"];
    mobile.text = widget.vendorData["vendor_mobile_phone"];
    contact_person_name.text = widget.vendorData["contact_persons_name"];
    contact_person_email.text = widget.vendorData["contact_persons_email_id"];
    contact_person_phone.text = widget.vendorData["contact_persons_mobile"];
    gstController1.text = widget.vendorData["gst"];
    panController1.text = widget.vendorData["pan"];
    vendorAdd1.text = widget.vendorData["vendor_address1"];
    vendorAdd2.text = widget.vendorData["vendor_address2"];
    vendorState.text = widget.vendorData["vendor_state"];
    vendorZip.text = widget.vendorData["vendor_zip"];
    vendorRegion.text = widget.vendorData["vendor_region"];
    vendorCity.text = widget.vendorData["vendor_city"];
    vendorGst.text = widget.vendorData["vendor_gst"];
    vendorPan.text = widget.vendorData["vendor_pan"];
    payNameController.text = widget.vendorData["pay_to_name"];
    payAdd1.text = widget.vendorData["payto_address1"];
    payAdd2.text = widget.vendorData["payto_address2"];
    payState.text = widget.vendorData["payto_state"];
    payZip.text = widget.vendorData["payto_zip"];
    payRegion.text = widget.vendorData["payto_region"];
    payCity.text = widget.vendorData["payto_city"];
    payGst.text = widget.vendorData["payto_gst"];
    payPan.text = widget.vendorData["payto_pan"];
    shipNameController.text = widget.vendorData["ship_to_name"];
    shipAdd1.text = widget.vendorData["shipto_address1"];
    shipAdd2.text = widget.vendorData["shipto_address2"];
    shipState.text = widget.vendorData["shipto_state"];
    shipZip.text = widget.vendorData["shipto_zip"];
    shipRegion.text = widget.vendorData["shipto_region"];
    shipCity.text = widget.vendorData["shipto_city"];
    shipGst.text = widget.vendorData["shipto_gst"];
    shipPan.text = widget.vendorData["shipto_pan"];
    vendorType = widget.vendorData["vendor_type"];
    vendorCode.text = widget.vendorData["vendor_code"];
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  var vendor = "";
  final vendorItems = [
    'Mr.',
    'Ms.',
  ];

  var vendorType = "--Select--";
  final _vendorTypeList = [
    'Corporate',
    'Individual',
  ];

  void vendorTypeDisplay(String? vtd){
    setState(() {
      vendorType = vtd!;
    });
  }

  String? authToken;

  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }

  String selectedId = "";

  var size, width, height;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: CustomAppBar()),
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
                      title: const Text("Edit Vendors"),
                    ),
                  )
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //top container.
                    // Container(
                    //   height: 60,
                    //   color: Colors.white,
                    //   child: Row(
                    //     children: const [
                    //       Padding(
                    //         padding: EdgeInsets.only(top:20.0,bottom:20,left:70),
                    //         child: Text("Edit Vendors",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.indigo),),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    if (width > 800)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),

                            Form(
                              key: top_details,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          //----------- vendor type -------
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 150,
                                                  child: Text('Vendor Type')),
                                              // SizedBox(
                                              //   width: 300,
                                              //   child: AnimatedContainer(
                                              //     duration: const Duration(seconds: 0),
                                              //     height: vendorTypeError ? 50 : 30,
                                              //     child: DropdownSearch<String>(
                                              //       validator: (value) {
                                              //         if (value == null ||
                                              //             value=="--Select--") {
                                              //           setState(() {
                                              //             vendorTypeError = true;
                                              //           });
                                              //           return "Required";
                                              //         } else {
                                              //           setState(() {
                                              //             vendorTypeError = false;
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
                                              //               vendorType.isNotEmpty),
                                              //           cursorColor: Colors.grey,
                                              //           style: const TextStyle(
                                              //             fontSize: 14,
                                              //           ),
                                              //         ),
                                              //       ),
                                              //       items: _vendorTypeList,
                                              //       selectedItem: vendorType,
                                              //       onChanged: vendorTypeDisplay,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 150,
                                                  child: Text('Vendor Name')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height: company ? 50 : 30,
                                                  // height: 38,
                                                  duration: const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          company = true;
                                                        });
                                                        return "Please Enter Vendor Name";
                                                      } else {
                                                        setState(() {
                                                          company = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style:
                                                    const TextStyle(fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller: companyname,
                                                    decoration: decorationInput5(
                                                        "Vendor Name",
                                                        companyname.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          //-------------- vendor Code -----------
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 150,
                                                  child: Text('Vendor Code')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height: emailError ? 50 : 30,
                                                  // height: 38,
                                                  duration: const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          vendorCodeError = true;
                                                        });
                                                        return "Please Enter Code";
                                                      } else {
                                                        setState(() {
                                                          vendorCodeError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style:
                                                    const TextStyle(fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller: vendorCode,
                                                    decoration: decorationInput5(
                                                        "Vendor Code", vendorCode.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          //-------vendor email------
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 150,
                                                  child: Text('Vendor Email')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height: emailError ? 50 : 30,
                                                  // height: 38,
                                                  duration: const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          emailError = true;
                                                        });
                                                        return "Please Enter Email";
                                                      } else {
                                                        setState(() {
                                                          emailError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style:
                                                    const TextStyle(fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller: email,
                                                    decoration: decorationInput5(
                                                        "Email", email.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          //------Vendor phone and mobile.-----
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 150,
                                                  child: Text('Vendor Phone')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height: mobileError ? 50 : 30,
                                                  // height: 38,
                                                  duration: const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          mobileError = true;
                                                        });
                                                        return "Required";
                                                      } else {
                                                        setState(() {
                                                          mobileError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style:
                                                    const TextStyle(fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller: mobile,
                                                    decoration: decorationInput5(
                                                        "Mobile", mobile.text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          //  -------contact person name-----
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      'Contact Person Name')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height:
                                                  contact_person_name_error
                                                      ? 50
                                                      : 30,
                                                  // height: 38,
                                                  duration:
                                                  const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          contact_person_name_error =
                                                          true;
                                                        });
                                                        return "Please Enter Contact Person Name";
                                                      } else {
                                                        setState(() {
                                                          contact_person_name_error =
                                                          false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller: contact_person_name,
                                                    decoration: decorationInput5(
                                                        "Contact Person Name",
                                                        contact_person_name
                                                            .text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          //--------- contact person Email-------
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      'Contact Person Email')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height:
                                                  contact_person_email_error
                                                      ? 50
                                                      : 30,
                                                  // height: 38,
                                                  duration:
                                                  const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          contact_person_email_error =
                                                          true;
                                                        });
                                                        return "Please Enter Contact Person Name";
                                                      } else {
                                                        setState(() {
                                                          contact_person_email_error =
                                                          false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller:
                                                    contact_person_email,
                                                    decoration: decorationInput5(
                                                        "Contact Person Email",
                                                        contact_person_email
                                                            .text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          // ---------contact person phone-------
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      'Contact Person phone')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height:
                                                  contact_person_phone_error
                                                      ? 50
                                                      : 30,
                                                  // height: 38,
                                                  duration:
                                                  const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    maxLength: 10,
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
                                                          contact_person_phone_error =
                                                          true;
                                                        });
                                                        return "Please Enter Contact Person Number";
                                                      } else {
                                                        setState(() {
                                                          contact_person_phone_error =
                                                          false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller:
                                                    contact_person_phone,
                                                    decoration: decorationInput5(
                                                        "Contact Person Phone",
                                                        contact_person_phone
                                                            .text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          //------gst----
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      'GST')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height:
                                                  gstError1
                                                      ? 50
                                                      : 30,
                                                  // height: 38,
                                                  duration:
                                                  const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          gstError1 =
                                                          true;
                                                        });
                                                        return "Required";
                                                      } else {
                                                        setState(() {
                                                          gstError1 =
                                                          false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller:
                                                    gstController1,
                                                    decoration: decorationInput5(
                                                        "GST",
                                                        gstController1
                                                            .text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          //-------pan------
                                          Row(
                                            children: [
                                              const SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      'PAN')),
                                              SizedBox(
                                                width: 300,
                                                child: AnimatedContainer(
                                                  height:
                                                  panError1
                                                      ? 50
                                                      : 30,
                                                  // height: 38,
                                                  duration:
                                                  const Duration(seconds: 0),
                                                  margin: const EdgeInsets.all(0),
                                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          panError1 =
                                                          true;
                                                        });
                                                        return "Required";
                                                      } else {
                                                        setState(() {
                                                          panError1 =
                                                          false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller:
                                                    panController1,
                                                    decoration: decorationInput5(
                                                        "PAN",
                                                        panController1
                                                            .text.isNotEmpty),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 65,
                                  ),

                                  //tab bar.
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      // width: 400,
                                      child: TabBar(
                                        indicatorColor: Colors.blue,
                                        labelColor: Colors.lightBlue,
                                        unselectedLabelColor: Colors.lightBlue,
                                        controller: _tabController,
                                        tabs: myTabs,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    child: [
                                      //address page.
                                      addressPage(),
                                      addressPage1(),
                                      //other page details.
                                      // otherDetails(),
                                    ][_tabIndex],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (width < 800)
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Form(
                              key:top_details,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200, child: Text('Vendor Type')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // SizedBox(
                                      //   width: 340,
                                      //   child: AnimatedContainer(
                                      //     duration: const Duration(seconds: 0),
                                      //     height: vendorTypeError ? 50 : 30,
                                      //     child: DropdownSearch<String>(
                                      //       validator: (value) {
                                      //         if (value == null ||
                                      //             value=="--Select--") {
                                      //           setState(() {
                                      //             vendorTypeError = true;
                                      //           });
                                      //           return "Required";
                                      //         } else {
                                      //           setState(() {
                                      //             vendorTypeError = false;
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
                                      //               vendorType.isNotEmpty),
                                      //           cursorColor: Colors.grey,
                                      //           style: const TextStyle(
                                      //             fontSize: 14,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       items: _vendorTypeList,
                                      //       selectedItem: vendorType,
                                      //       onChanged: vendorTypeDisplay,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  //company name
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200, child: Text('Vendor Name')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: company ? 50 : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                setState(() {
                                                  company = true;
                                                });
                                                return "Please Enter Vendor Name";
                                              } else {
                                                setState(() {
                                                  company = false;
                                                });
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: companyname,
                                            decoration: decorationInput5(
                                                "Vendor Name",
                                                companyname.text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200, child: Text('Vendor Code')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: vendorCodeError ? 50 : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                setState(() {
                                                  vendorCodeError = true;
                                                });
                                                return "Please Enter Vendor Code";
                                              } else {
                                                setState(() {
                                                  vendorCodeError = false;
                                                });
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: vendorCode,
                                            decoration: decorationInput5(
                                                "Vendor Code",
                                                vendorCode.text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  //vendor email
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200, child: Text('Vendor Email')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: emailError ? 50 : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                setState(() {
                                                  emailError = true;
                                                });
                                                return "Please Enter Email";
                                              } else {
                                                setState(() {
                                                  emailError = false;
                                                });
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: email,
                                            decoration: decorationInput5(
                                                "Email", email.text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  //vendor phone.
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200, child: Text('Vendor Phone')),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: mobileError ? 50 : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                setState(() {
                                                  mobileError = true;
                                                });
                                                return "Please Enter Mobile Number";
                                              } else {
                                                setState(() {
                                                  mobileError = false;
                                                });
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: mobile,
                                            decoration: decorationInput5(
                                                "Mobile", mobile.text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // if (_addcolums == false)
                                      //   InkWell(
                                      //     child: const Text(
                                      //       'add more details',
                                      //       style: TextStyle(
                                      //           color:
                                      //               Color.fromRGBO(69, 139, 202, 1)),
                                      //     ),
                                      //     onTap: () {
                                      //       setState(() {
                                      //         _addcolums = true;
                                      //       });
                                      //     },
                                      //   )
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200,
                                          child: Text('Contact Person Name')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: contact_person_name_error
                                              ? 50
                                              : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  contact_person_name_error =
                                                  true;
                                                });
                                                return "Please Enter Contact Person Name";
                                              } else {
                                                setState(() {
                                                  contact_person_name_error =
                                                  false;
                                                });
                                              }
                                              return null;
                                            },
                                            style:
                                            const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: companyname,
                                            decoration: decorationInput5(
                                                "Contact Person Name",
                                                companyname.text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // Contact Person Email
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200,
                                          child: Text('Contact Person Email')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: contact_person_email_error
                                              ? 50
                                              : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  contact_person_email_error =
                                                  true;
                                                });
                                                return "Please Enter Contact Person Name";
                                              } else {
                                                setState(() {
                                                  contact_person_email_error =
                                                  false;
                                                });
                                              }
                                              return null;
                                            },
                                            style:
                                            const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: contact_person_email,
                                            decoration: decorationInput5(
                                                "Contact Person Email",
                                                contact_person_email
                                                    .text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // Contact Phone
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200,
                                          child: Text('Contact Person Phone')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: contact_person_phone_error
                                              ? 50
                                              : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
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
                                                  contact_person_phone_error =
                                                  true;
                                                });
                                                return "Please Enter Contact Person Number";
                                              } else {
                                                setState(() {
                                                  contact_person_phone_error =
                                                  false;
                                                });
                                              }
                                              return null;
                                            },
                                            style:
                                            const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: contact_person_phone,
                                            decoration: decorationInput5(
                                                "Contact Person Phone",
                                                contact_person_phone
                                                    .text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),
                                  //----gst----------
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200,
                                          child: Text('GST')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: gstError1
                                              ? 50
                                              : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  gstError1 =
                                                  true;
                                                });
                                                return "Required";
                                              } else {
                                                setState(() {
                                                  gstError1 =
                                                  false;
                                                });
                                              }
                                              return null;
                                            },
                                            style:
                                            const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: gstController1,
                                            decoration: decorationInput5(
                                                "GST",
                                                gstController1
                                                    .text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  //-------pan-------
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          width: 200,
                                          child: Text('PAN')),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 340,
                                        child: AnimatedContainer(
                                          height: panError1
                                              ? 50
                                              : 30,
                                          // height: 38,
                                          duration: const Duration(seconds: 0),
                                          margin: const EdgeInsets.all(0),
                                          // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  panError1 =
                                                  true;
                                                });
                                                return "Required";
                                              } else {
                                                setState(() {
                                                  panError1 =
                                                  false;
                                                });
                                              }
                                              return null;
                                            },
                                            style:
                                            const TextStyle(fontSize: 14),
                                            onChanged: (text) {
                                              setState(() {});
                                            },
                                            controller: panController1,
                                            decoration: decorationInput5(
                                                "PAN",
                                                panController1
                                                    .text.isNotEmpty),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),

                                  //tab bar.
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      // width: 400,
                                      child: TabBar(
                                        indicatorColor: Colors.blue,
                                        labelColor: Colors.lightBlue,
                                        unselectedLabelColor: Colors.lightBlue,
                                        controller: _tabController,
                                        tabs: myTabs,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    child: [
                                      addressPage(),
                                      addressPage1(),
                                    ][_tabIndex],
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
              //----------bottomNavigation bar-------------
              bottomNavigationBar: SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 30,
                        child: OutlinedMButton(
                          text: 'Save',
                          textColor: mSaveButton,
                          borderColor: mSaveButton,
                          onTap: () {
                            setState(() {
                              if (top_details.currentState!.validate()) {
                                if(_tabIndex == 0){
                                  tabs = true;
                                  _tabController.animateTo((_tabController.index + 1)%2);
                                }
                                else if(_tabIndex == 1){
                                  if(tabs == true){
                                    _vendrpage = {
                                      "new_vendor_id": widget.vendorData["new_vendor_id"],
                                      "company_name": companyname.text,
                                      "vendor_display_name": vendor,
                                      "vendor_email": email.text,
                                      "vendor_mobile_phone": mobile.text,
                                      "gst":gstController1.text,
                                      "pan":panController1.text,
                                      "contact_persons_name":
                                      contact_person_name.text,
                                      "contact_persons_email_id":
                                      contact_person_email.text,
                                      "contact_persons_mobile":
                                      contact_person_phone.text,
                                      "vendor_address1":"",
                                      "vendor_address2":"",
                                      "vendor_state":"",
                                      "vendor_zip":"",
                                      "vendor_region":"",
                                      "vendor_city":"",
                                      "vendor_gst":"",
                                      "vendor_pan":"",
                                      "pay_to_name":payNameController.text,
                                      "payto_address1":payAdd1.text,
                                      "payto_address2":payAdd2.text,
                                      "payto_state":payState.text,
                                      "payto_zip":payZip.text,
                                      "payto_region":payRegion.text,
                                      "payto_city":payCity.text,
                                      "payto_gst":payGst.text,
                                      "payto_pan":payPan.text,
                                      "ship_to_name":shipNameController.text,
                                      "shipto_address1": shipAdd1.text,
                                      "shipto_address2": shipAdd2.text,
                                      "shipto_state": shipState.text,
                                      "shipto_zip": shipZip.text,
                                      "shipto_region": shipRegion.text,
                                      "shipto_city": shipCity.text,
                                      "shipto_gst": shipGst.text,
                                      "shipto_pan": shipPan.text,
                                      "vendor_type": vendorType,
                                      "vendor_code": vendorCode.text,
                                    };
                                    // print(_vendrpage);
                                    editVendor(_vendrpage);
                                  }
                                  if(tabs == false){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edited')));
                                  }
                                }
                              }
                            });
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8, bottom: 8),
                      //   child: SizedBox(
                      //     height: 30,
                      //     child: MaterialButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             if (top_details.currentState!.validate()) {
                      //               if(_tabIndex == 0){
                      //                 tabs = true;
                      //                 _tabController.animateTo((_tabController.index + 1)%2);
                      //               }
                      //               else if(_tabIndex == 1){
                      //                 if(tabs == true){
                      //                   _vendrpage = {
                      //                     "new_vendor_id": widget.vendorData["new_vendor_id"],
                      //                     "company_name": companyname.text,
                      //                     "vendor_display_name": vendor,
                      //                     "vendor_email": email.text,
                      //                     "vendor_mobile_phone": mobile.text,
                      //                     "gst":gstController1.text,
                      //                     "pan":panController1.text,
                      //                     "contact_persons_name":
                      //                     contact_person_name.text,
                      //                     "contact_persons_email_id":
                      //                     contact_person_email.text,
                      //                     "contact_persons_mobile":
                      //                     contact_person_phone.text,
                      //                     "vendor_address1":"",
                      //                     "vendor_address2":"",
                      //                     "vendor_state":"",
                      //                     "vendor_zip":"",
                      //                     "vendor_region":"",
                      //                     "vendor_city":"",
                      //                     "vendor_gst":"",
                      //                     "vendor_pan":"",
                      //                     "pay_to_name":payNameController.text,
                      //                     "payto_address1":payAdd1.text,
                      //                     "payto_address2":payAdd2.text,
                      //                     "payto_state":payState.text,
                      //                     "payto_zip":payZip.text,
                      //                     "payto_region":payRegion.text,
                      //                     "payto_city":payCity.text,
                      //                     "payto_gst":payGst.text,
                      //                     "payto_pan":payPan.text,
                      //                     "ship_to_name":shipNameController.text,
                      //                     "shipto_address1": shipAdd1.text,
                      //                     "shipto_address2": shipAdd2.text,
                      //                     "shipto_state": shipState.text,
                      //                     "shipto_zip": shipZip.text,
                      //                     "shipto_region": shipRegion.text,
                      //                     "shipto_city": shipCity.text,
                      //                     "shipto_gst": shipGst.text,
                      //                     "shipto_pan": shipPan.text,
                      //                     "vendor_type": vendorType,
                      //                     "vendor_code": vendorCode.text,
                      //                   };
                      //                   // print(_vendrpage);
                      //                   editVendor(_vendrpage);
                      //                 }
                      //                 if(tabs == false){
                      //                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edited')));
                      //                 }
                      //               }
                      //             }
                      //           });
                      //         },
                      //         color: Colors.blue,
                      //         child: const Center(
                      //           child: Text(
                      //             'Save',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         )),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: OutlinedMButton(
                          text :"Delete",
                          borderColor: Colors.redAccent,
                          textColor:  Colors.redAccent,
                          onTap: () {
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
                                                          // print(userId);
                                                          deleteVendor();
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
                        ),
                      ),
                      // MaterialButton(
                      //   color:Colors.red,
                      //   onPressed: (){
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return Dialog(
                      //           backgroundColor: Colors.transparent,
                      //           child: StatefulBuilder(
                      //             builder: (context, setState) {
                      //               return SizedBox(
                      //                 height: 200,
                      //                 width: 300,
                      //                 child: Stack(children: [
                      //                   Container(
                      //                     decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                      //                     margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                      //                     child: Padding(
                      //                       padding: const EdgeInsets.only(left: 20.0,right: 25),
                      //                       child: Column(
                      //                         children: [
                      //                           const SizedBox(
                      //                             height: 20,
                      //                           ),
                      //                           const Icon(
                      //                             Icons.warning_rounded,
                      //                             color: Colors.red,
                      //                             size: 50,
                      //                           ),
                      //                           const SizedBox(
                      //                             height: 10,
                      //                           ),
                      //                           const Center(
                      //                               child: Text(
                      //                                 'Are You Sure, You Want To Delete ?',
                      //                                 style: TextStyle(
                      //                                     color: Colors.indigo,
                      //                                     fontWeight: FontWeight.bold,
                      //                                     fontSize: 15),
                      //                               )),
                      //                           const SizedBox(
                      //                             height: 35,
                      //                           ),
                      //                           Row(
                      //                             mainAxisAlignment:
                      //                             MainAxisAlignment.spaceBetween,
                      //                             children: [
                      //                               MaterialButton(
                      //                                 color: Colors.red,
                      //                                 onPressed: () {
                      //                                   // print(userId);
                      //                                   deleteVendor();
                      //                                 },
                      //                                 child: const Text(
                      //                                   'Ok',
                      //                                   style: TextStyle(color: Colors.white),
                      //                                 ),
                      //                               ),
                      //                               MaterialButton(
                      //                                 color: Colors.blue,
                      //                                 onPressed: () {
                      //                                   setState(() {
                      //                                     Navigator.of(context).pop();
                      //                                   });
                      //                                 },
                      //                                 child: const Text(
                      //                                   'Cancel',
                      //                                   style: TextStyle(color: Colors.white),
                      //                                 ),
                      //                               )
                      //                             ],
                      //                           )
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   Positioned(right: 0.0,
                      //
                      //                     child: InkWell(
                      //                       child: Container(
                      //                           width: 30,
                      //                           height: 30,
                      //                           decoration: BoxDecoration(
                      //                               borderRadius: BorderRadius.circular(15),
                      //                               border: Border.all(
                      //                                 color:
                      //                                 const Color.fromRGBO(204, 204, 204, 1),
                      //                               ),
                      //                               color: Colors.blue),
                      //                           child: const Icon(
                      //                             Icons.close_sharp,
                      //                             color: Colors.white,
                      //                           )),
                      //                       onTap: () {
                      //                         setState(() {
                      //                           Navigator.of(context).pop();
                      //                         });
                      //                       },
                      //                     ),
                      //                   ),
                      //                 ],
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: const Row(
                      //       children: [
                      //         Icon(Icons.delete,color: Colors.white,),
                      //         Text('Delete',style: TextStyle(color:Colors.white),)
                      //       ]
                      //   ),
                      // ),
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



  addressPage() {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.blue[50],
            ),
            width: width/1.3,
            // height: 100,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pay To',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Pay-To Name'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: payNameError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payNameError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payNameError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payNameController,
                                    decoration: decorationInput5(
                                        "",
                                        payNameController.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('Address 1'),
                            ),
                            Expanded(
                              child:  SizedBox(
                                width: 300,
                                child: AnimatedContainer(
                                  height: payAdd1Error ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payAdd1Error = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payAdd1Error = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payAdd1,
                                    decoration: decorationInput5(
                                        "",
                                        payAdd1.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('Address 2'),
                            ),
                            Expanded(
                              child:  SizedBox(
                                width: 300,
                                child: AnimatedContainer(
                                  height: payAdd2Error ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payAdd2Error = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payAdd2Error = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payAdd2,
                                    decoration: decorationInput5(
                                        "",
                                        payAdd2.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('State'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: payStateError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payStateError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payStateError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payState,
                                    decoration: decorationInput5(
                                        "",
                                        payState.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('ZIP'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: payZipError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payZipError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payZipError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payZip,
                                    decoration: decorationInput5(
                                        "",
                                        payZip.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('Region'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: payRegionError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payRegionError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payRegionError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payRegion,
                                    decoration: decorationInput5(
                                        "",
                                        payRegion.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('City'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: payCityError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payCityError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payCityError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payCity,
                                    decoration: decorationInput5(
                                        "",
                                        payCity.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('GST'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: payGstError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payGstError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payGstError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payGst,
                                    decoration: decorationInput5(
                                        "",
                                        payGst.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('PAN'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: payPanError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          payPanError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          payPanError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: payPan,
                                    decoration: decorationInput5(
                                        "",
                                        payPan.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
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
        const SizedBox(height: 20,),
      ],
    );
  }
  addressPage1() {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.blue[50],
            ),
            width: width/1.3,
            // height: 100,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ship From',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Ship-To Name'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: shipNameError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipNameError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipNameError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipNameController,
                                    decoration: decorationInput5(
                                        "",
                                        shipNameController.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('Address 1'),
                            ),
                            Expanded(
                              child:  SizedBox(
                                width: 300,
                                child: AnimatedContainer(
                                  height: shipAdd1Error ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipAdd1Error = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipAdd1Error = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipAdd1,
                                    decoration: decorationInput5(
                                        "",
                                        shipAdd1.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('Address 2'),
                            ),
                            Expanded(
                              child:  SizedBox(
                                width: 300,
                                child: AnimatedContainer(
                                  height: shipAdd2Error ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipAdd2Error = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipAdd2Error = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipAdd2,
                                    decoration: decorationInput5(
                                        "",
                                        shipAdd2.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('State'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: shipStateError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipStateError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipStateError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipState,
                                    decoration: decorationInput5(
                                        "",
                                        shipState.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('ZIP'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: shipZipError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipZipError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipZipError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipZip,
                                    decoration: decorationInput5(
                                        "",
                                        shipZip.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('Region'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: shipRegionError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipRegionError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipRegionError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipRegion,
                                    decoration: decorationInput5(
                                        "",
                                        shipRegion.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('City'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: shipCityError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipCityError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipCityError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipCity,
                                    decoration: decorationInput5(
                                        "",
                                        shipCity.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('GST'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: shipGstError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipGstError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipGstError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipGst,
                                    decoration: decorationInput5(
                                        "",
                                        shipGst.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text('PAN'),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100,
                                child: AnimatedContainer(
                                  height: shipPanError ? 50 : 30,
                                  // height: 38,
                                  duration: const Duration(seconds: 0),
                                  margin: const EdgeInsets.all(0),
                                  // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        setState(() {
                                          shipPanError = true;
                                        });
                                        return "Required";
                                      } else {
                                        setState(() {
                                          shipPanError = false;
                                        });
                                      }
                                      return null;
                                    },
                                    style:
                                    const TextStyle(fontSize: 14),
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    controller: shipPan,
                                    decoration: decorationInput5(
                                        "",
                                        shipPan.text.isNotEmpty),
                                  ),
                                ),
                              ),
                            ),
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
        const SizedBox(height: 20,),
      ],
    );
  }



  Future editVendor(Map<dynamic, dynamic> vendorPage) async {
    // print(vendrpage);
    try {
      final response = await http.put(
          Uri.parse(
              "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/update_new_vendor"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(vendorPage));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: new Text("Edit Success"),
        ));
        print(response.body);
        Navigator.of(context).pop();
      } else {
        print("++++++ Status Code ++++++++");
        print(response.statusCode.toString());
      }
    } catch (e) {
      print(e.toString());
      print(e);
    }
  }

  Future deleteVendor() async{
    print('========================================');
    print(selectedId);
    try{
      final response = await http.delete(
        Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/delete_new_vendor/$selectedId'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken'
        },
      );
      if(response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content: new Text('Data Deleted'),)
          );
          print('--------------from delete vendors -------------');
          vendorDetailsBloc.fetchVendorNetwork(selectedId);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          // editVendor(_vendrpage);
        });
      }else{
        print(response.statusCode.toString());
      }
    }
    catch(e){
      print(e.toString());
      print(e);
    }
  }
}
