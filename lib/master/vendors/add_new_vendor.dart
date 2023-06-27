import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../widgets/input_decoration_text_field.dart';
//comment
class AddNewVendors extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;

  const AddNewVendors(
      {Key? key, required this.selectedDestination, required this.drawerWidth})
      : super(key: key);

  @override
  State<AddNewVendors> createState() => _AddNewVendorsState();
}

class _AddNewVendorsState extends State<AddNewVendors>
    with SingleTickerProviderStateMixin {
  final topDetailsForm = GlobalKey<FormState>();
  final addressPageForm = GlobalKey<FormState>();
  final otherDetailsPageForm = GlobalKey<FormState>();
  var tabs = false;

  void vendorDisplayName(String? v) {
    setState(() {
      vendor = v!;
    });
  }




  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }

  // drop down for customer page.
  var selectedValue = "";
  dynamic countryName = [
    'India',
    'Afghanistan',
    'Usa',
    'Bangalore',
    'China',
    'Ukraine',
    'Russia',
    'Japan',
    'Soudhi arebia'
  ];

  //top text fields controller names.

  Map mapPayTo = {};
  Map mapShipTo = {};
  var companyName = TextEditingController();
  var email = TextEditingController();
  var vendorCode = TextEditingController();
  var work = TextEditingController();
  var mobile = TextEditingController();
  var contactPersonName = TextEditingController();
  var contactPersonEmail = TextEditingController();
  var contactPersonPhone = TextEditingController();
  var gstController1 = TextEditingController();
  var panController1 = TextEditingController();

  //other details error display.

//error display.
  bool vendorTypeError = false;
  bool company = false;
  bool emailError = false;
  bool vendorCodeError = false;
  bool workPhoneError = false;
  bool mobileError = false;
  bool contactPersonNameError = false;
  bool contactPersonEmailError = false;
  bool contactPersonPhoneError = false;
  bool gstError1 = false;
  bool panError1 = false;
  bool gstError = false;
  bool vendorError = false;




  bool isChecked = false;



  final List<Widget> myTabs = [
    const Tab(text: 'Pay-To Address'),
    const Tab(text: 'Ship-From Address'),
  ];

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
    _tabController = TabController(length: myTabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    getInitialData();
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

  dynamic size;
  dynamic width;
  dynamic height;
  var tab = false;
  bool loading=false;
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

              body: CustomLoader(
                inAsyncCall: loading,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //---------top Container------
                      Container(
                        height: 60,
                        color: Colors.white,
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:70,top:20.0,bottom:20),
                              child: Text("New Vendors",style: TextStyle(color:Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),

                      if (width > 800)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Form(
                                key: topDetailsForm,
                                child:
                                Column(
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
                                            //-------vendor name ------------
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
                                                      controller: companyName,
                                                      decoration: decorationInput5(
                                                          "Vendor Name",
                                                          companyName.text.isNotEmpty),
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
                                            //-------vendor email---------
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
                                            //  -----------contact person name---------
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
                                                    contactPersonNameError
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
                                                            contactPersonNameError =
                                                            true;
                                                          });
                                                          return "Please Enter Contact Person Name";
                                                        } else {
                                                          setState(() {
                                                            contactPersonNameError =
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
                                                      controller: contactPersonName,
                                                      decoration: decorationInput5(
                                                          "Contact Person Name",
                                                          contactPersonName
                                                              .text.isNotEmpty),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            //----------- contact person Email--------
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
                                                    contactPersonEmailError
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
                                                            contactPersonEmailError =
                                                            true;
                                                          });
                                                          return "Please Enter Contact Person Name";
                                                        } else {
                                                          setState(() {
                                                            contactPersonEmailError =
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
                                                      contactPersonEmail,
                                                      decoration: decorationInput5(
                                                          "Contact Person Email",
                                                          contactPersonEmail
                                                              .text.isNotEmpty),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            //---------- contact person phone--------
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
                                                    contactPersonPhoneError
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
                                                            contactPersonPhoneError =
                                                            true;
                                                          });
                                                          return "Please Enter Contact Person Number";
                                                        } else {
                                                          setState(() {
                                                            contactPersonPhoneError =
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
                                                      contactPersonPhone,
                                                      decoration: decorationInput5(
                                                          "Contact Person Phone",
                                                          contactPersonPhone
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

                                    //---------tab bar.------------
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: SizedBox(
                                        width: 400,
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
                                        addressPage1()
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
                                key:topDetailsForm,
                                child: Column(
                                  children: [

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
                                              controller: companyName,
                                              decoration: decorationInput5(
                                                  "Vendor Name",
                                                  companyName.text.isNotEmpty),
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
                                            height: contactPersonNameError
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
                                                    contactPersonNameError =
                                                    true;
                                                  });
                                                  return "Please Enter Contact Person Name";
                                                } else {
                                                  setState(() {
                                                    contactPersonNameError =
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
                                              controller: companyName,
                                              decoration: decorationInput5(
                                                  "Contact Person Name",
                                                  companyName.text.isNotEmpty),
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
                                            height: contactPersonEmailError
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
                                                    contactPersonEmailError =
                                                    true;
                                                  });
                                                  return "Please Enter Contact Person Name";
                                                } else {
                                                  setState(() {
                                                    contactPersonEmailError =
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
                                              controller: contactPersonEmail,
                                              decoration: decorationInput5(
                                                  "Contact Person Email",
                                                  contactPersonEmail
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
                                            height: contactPersonPhoneError
                                                ? 50
                                                : 30,
                                            // height: 38,
                                            duration: const Duration(seconds: 0),
                                            margin: const EdgeInsets.all(0),
                                            // decoration: name.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: TextFormField(
                                              maxLength: 10,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  setState(() {
                                                    contactPersonPhoneError =
                                                    true;
                                                  });
                                                  return "Please Enter Contact Person Number";
                                                } else {
                                                  setState(() {
                                                    contactPersonPhoneError =
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
                                              controller: contactPersonPhone,
                                              decoration: decorationInput5(
                                                  "Contact Person Phone",
                                                  contactPersonPhone
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
                                      height: 65,
                                    ),
                                    //tab bar.
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: SizedBox(
                                        width: 400,
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
                                        //address page
                                        addressPage(),
                                        addressPage1()
                                        // other details pagge.
                                        // _other_details_page(),
                                      ][_tabIndex],
                                    ),

                                  ],),
                              ),

                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              bottomNavigationBar: SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              MaterialButton(
                                  onPressed: () {
                                    if (topDetailsForm.currentState!.validate()) {
                                      if(_tabIndex == 0){
                                        tabs = true;
                                        _tabController.animateTo((_tabController.index + 1) % 2);
                                      }
                                      else if(_tabIndex == 1){
                                        if(tabs == true){
                                          mapPayTo = {
                                            "company_name": companyName.text,
                                            "vendor_display_name": vendor,
                                            "vendor_email": email.text,
                                            "vendor_mobile_phone": mobile.text,
                                            "gst":gstController1.text,
                                            "pan":panController1.text,
                                            "contact_persons_name":
                                            contactPersonName.text,
                                            "contact_persons_email_id":
                                            contactPersonEmail.text,
                                            "contact_persons_mobile":
                                            contactPersonPhone.text,
                                            "vendor_address1":"",
                                            "vendor_address2":"",
                                            "vendor_state":"",
                                            "vendor_zip":"",
                                            "vendor_region":"",
                                            "vendor_city":"",
                                            "vendor_gst":"",
                                            "vendor_pan":"",
                                            "pay_to_name": payNameController.text,
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
                                          saveVendor(mapPayTo);
                                        }
                                        if(tabs == false){
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Enter Data')));
                                        }
                                      }
                                    }
                                  },
                                  color: Colors.blue,
                                  child: const Center(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
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
                              width: 50,
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
                                    maxLength: 6,
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
                              child: Text('Country'),
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
                              width: 50,
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
                              width: 50,
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
                                    maxLength: 6,
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
                              child: Text('Country'),
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
                              width: 50,
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



  Future saveVendor(Map<dynamic, dynamic> vendorPage) async {
    String url= "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/add_new_vendor";
    postData(requestBody: vendorPage,url: url,context: context).then((value) {
      setState(() {
        if(value!=null){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Saved')));
          Navigator.of(context).pop();
        }
        loading=true;
      });
    });
  }
//  ------------------------------------------
}
