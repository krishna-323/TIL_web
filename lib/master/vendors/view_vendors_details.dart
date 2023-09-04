import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';
import 'add_new_vendor.dart';
import 'bloc/vendors_details_bloc.dart';
import 'edit_vendors.dart';
import 'model/vendors_details_model.dart';


class ViewVendors extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map vendorList;

  const ViewVendors({
    Key? key,
    required this.vendorList,
    required this.drawerWidth,
    required this.selectedDestination,
  }) : super(key: key);

  @override
  State<ViewVendors> createState() => _ViewVendorsState();
}

class _ViewVendorsState extends State<ViewVendors> with SingleTickerProviderStateMixin {
  String selectedId = "";
  late int selectedIndex;
  String? authToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getInitialData().whenComplete(() {
      _tabController = TabController(length: myTabs.length, vsync: this);
      _tabController.addListener(_handleTabSelection);
      selectedId = widget.vendorList['new_vendor_id'];
      vendorDetailsBloc.fetchVendorNetwork(widget.vendorList['new_vendor_id']);
      fetchVendorsData();

    });

  }

  Future getInitialData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }

  List vendorList = [];
  bool loading = false;
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

  Future fetchVendorsData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_all_new_vendor';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            vendorList = value;
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                body: CustomLoader(
                  inAsyncCall: loading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        controller: ScrollController(),
                        child: SizedBox(
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 300,
                                child: AppBar(
                                  title: const Text("Customer",style: TextStyle(fontSize: 20)),
                                  elevation: 1,
                                  surfaceTintColor: Colors.white,
                                  shadowColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(border: Border.all(color:  Colors.blue),borderRadius: BorderRadius.circular(4)),
                                          child: InkWell(
                                            hoverColor: mHoverColor,
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => AddNewVendors(
                                                          drawerWidth: widget
                                                              .drawerWidth,
                                                          selectedDestination:
                                                          widget
                                                              .selectedDestination))).then((value) => fetchVendorsData());
                                            },
                                            child: const Center(
                                              child: Text("+ Customer",
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   color: Colors.grey[200],
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(
                              //         left: 10, right: 10, top: 10, bottom: 10),
                              //     child: Column(
                              //       children: [
                              //         Row(
                              //           mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             const Text("All Vendors"),
                              //             Row(
                              //               children: [
                              //                 SizedBox(
                              //                     width: 60,
                              //                     child: MaterialButton(
                              //                       onPressed: () {
                              //                         Navigator.push(
                              //                             context,
                              //                             MaterialPageRoute(
                              //                                 builder: (context) => AddNewVendors(
                              //                                     drawerWidth: widget
                              //                                         .drawerWidth,
                              //                                     selectedDestination:
                              //                                     widget
                              //                                         .selectedDestination))).then(
                              //                                 (value) =>
                              //                                 fetchVendorsData());
                              //                       },
                              //                       color: Colors.blue,
                              //                       child: const Text("+ New",
                              //                           style: TextStyle(
                              //                               color: Colors.white)),
                              //                     ))
                              //               ],
                              //             )
                              //           ],
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              const Divider(height: 1),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: vendorList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          color: selectedId ==
                                              vendorList[index]["new_vendor_id"]
                                              ? Colors.grey[100]
                                              : Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8.0, top: 10, bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          vendorList[index]
                                                          ['contact_persons_name'],
                                                          style: TextStyle(
                                                              color:
                                                              Colors.blue[800]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  selectedId = vendorList[index]
                                                  ["new_vendor_id"];
                                                  // print(vendorList[index]["first_name"]);
                                                  setState(() {
                                                    selectedIndex = index;
                                                    vendorDetailsBloc.fetchVendorNetwork(vendorList[index]['new_vendor_id']);
                                                    selectedId = vendorList[index]['new_vendor_id'];
                                                  });
                                                },
                                              ),
                                            ],
                                          )),
                                      const Divider(height: 1),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      // --------------tab bar------------
                      StreamBuilder(
                          stream: vendorDetailsBloc.getVendorDetails,
                          builder: (context, AsyncSnapshot <VendorModel>snapshot) {
                            if (snapshot.hasData) {
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
                                             primary: true,
                                           // controller: ScrollController(),
                                            child: Column(
                                              children:   [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: SizedBox(
                                                    // width: 500,
                                                    child: TabBar(
                                                      indicatorColor: Colors.blue,
                                                      labelColor: Colors.black,
                                                      unselectedLabelColor: Colors.lightBlue,
                                                      tabs:myTabs,
                                                      controller: _tabController,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: [
                                                    //-------- overView------
                                                    Column(
                                                      children: [
                                                        const SizedBox(height: 20,),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 50, right: 50,top: 20,bottom: 10),
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
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                      Text('Vendor Details',
                                                                        style: TextStyle(
                                                                          color: Colors.blue,
                                                                          fontSize: 18,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  color: Colors.grey,
                                                                  thickness: 1,
                                                                  endIndent: 0,
                                                                  indent: 0,
                                                                  height: 0,
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          //----name---
                                                                          Row(
                                                                            children: [
                                                                              const SizedBox(
                                                                                width: 120,
                                                                                child: Text(
                                                                                  'Name ',
                                                                                  style:
                                                                                  TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                ),
                                                                              ),
                                                                              Text(snapshot.data!.vendorDocketData[0].vendorData['contact_persons_name']),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                          //----company name-----
                                                                          Row(
                                                                            children:  [
                                                                              const SizedBox(
                                                                                width: 120,
                                                                                child: Text(
                                                                                  'Vendor Name',
                                                                                  style:
                                                                                  TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                ),
                                                                              ),

                                                                              Text(snapshot.data!.vendorDocketData[0].vendorData['company_name'])
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                          //------ vendor code --------
                                                                          Row(
                                                                            children:  [
                                                                              const SizedBox(
                                                                                width: 120,
                                                                                child: Text(
                                                                                  'Vendor Code',
                                                                                  style:
                                                                                  TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                ),
                                                                              ),

                                                                              Text(snapshot.data!.vendorDocketData[0].vendorData['vendor_code'])
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          // ------- vendor type ------
                                                                          Row(
                                                                            children:  [
                                                                              const SizedBox(
                                                                                width: 120,
                                                                                child: Text(
                                                                                  'Vendor Type',
                                                                                  style:
                                                                                  TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                ),
                                                                              ),

                                                                              Text(snapshot.data!.vendorDocketData[0].vendorData['vendor_type'])
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                          //-----vendor email------
                                                                          Row(
                                                                            children:  [
                                                                              const SizedBox(
                                                                                width: 120,
                                                                                child: Text(
                                                                                  'Vendor Email',
                                                                                  style:
                                                                                  TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                ),
                                                                              ),

                                                                              Text(snapshot.data!.vendorDocketData[0].vendorData['vendor_email'])
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                          //-----vendor phone------
                                                                          Row(
                                                                            children:  [
                                                                              const SizedBox(
                                                                                width: 120,
                                                                                child: Text(
                                                                                  'Vendor Phone',
                                                                                  style:
                                                                                  TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                ),
                                                                              ),

                                                                              Text(snapshot.data!.vendorDocketData[0].vendorData['vendor_mobile_phone'])
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          //-----gst-----
                                                                          Row(
                                                                            children:  [
                                                                              const SizedBox(
                                                                                width: 100,
                                                                                child: Text(
                                                                                  'GST',
                                                                                  style:
                                                                                  TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                ),
                                                                              ),

                                                                              Text(snapshot.data!.vendorDocketData[0].vendorData['gst'])
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                          //--------pan---------
                                                                          Row(
                                                                            children:  [
                                                                              const SizedBox(
                                                                                width: 100,
                                                                                child: Text(
                                                                                  'PAN',
                                                                                  style:
                                                                                  TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                ),
                                                                              ),

                                                                              Text(snapshot.data!.vendorDocketData[0].vendorData['pan'])
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 50,top: 20,right: 50,bottom: 20),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
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
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                        child: Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: const [
                                                                            Text('Pay-To Address',
                                                                              style: TextStyle(
                                                                                color: Colors.blue,
                                                                                fontSize: 18,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const Divider(
                                                                        color: Colors.grey,
                                                                        thickness: 1,
                                                                        endIndent: 0,
                                                                        indent: 0,
                                                                        height: 0,
                                                                      ),
                                                                      const SizedBox(height: 10,),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                                                                        child: Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Name',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['pay_to_name'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Address 1',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Expanded(child: Text(snapshot.data!.vendorDocketData[0].vendorData['payto_address1']))
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Address 2',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Expanded(child: Text(snapshot.data!.vendorDocketData[0].vendorData['payto_address2']))
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'City',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['payto_city'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'State',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['payto_state'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Zip',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['payto_zip'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Country',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['payto_region'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'GST',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['payto_gst'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'PAN',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['payto_pan'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(width: 50,),
                                                              Expanded(
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
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                        child: Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: const [
                                                                            Text('Ship-From Address',
                                                                              style: TextStyle(
                                                                                color: Colors.blue,
                                                                                fontSize: 18,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const Divider(
                                                                        color: Colors.grey,
                                                                        thickness: 1,
                                                                        endIndent: 0,
                                                                        indent: 0,
                                                                        height: 0,
                                                                      ),
                                                                      const SizedBox(height: 10,),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                                                        child: Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Name',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['ship_to_name'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Address 1',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Expanded(child: Text(snapshot.data!.vendorDocketData[0].vendorData['shipto_address1']))
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Address 2',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Expanded(child: Text(snapshot.data!.vendorDocketData[0].vendorData['shipto_address2']))
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'City',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['shipto_city'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'State',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['shipto_state'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Zip',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['shipto_zip'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'Country',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['shipto_region'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'GST',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['shipto_gst'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 100,
                                                                                  child: Text(
                                                                                    'PAN',
                                                                                    style:
                                                                                    TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                                  ),
                                                                                ),
                                                                                Text(snapshot.data!.vendorDocketData[0].vendorData['shipto_pan'])
                                                                              ],
                                                                            ),
                                                                            const SizedBox(height: 10,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    //------------ History ---------
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
                                                                  child: const Row(
                                                                    children:  [
                                                                      Expanded(child: Center(child: Text("GRN Number",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                      Expanded(child: Center(child: Text("GRN Date",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                      Expanded(child: Center(child: Text("Order QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                      Expanded(child: Center(child: Text("Received QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                      Expanded(child: Center(child: Text("Short QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
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
                                                                  child: const Column(
                                                                    children: [
                                                                      Row(
                                                                        children:  [
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
                                                                                  child: Icon(CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,),
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
                                                                  child: const Row(
                                                                    children:  [
                                                                      Expanded(child: Center(child: Text("Invoice Number",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                      Expanded(child: Center(child: Text("Invoice Date",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                      Expanded(child: Center(child: Text("Customer Name",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                      Expanded(child: Center(child: Text("Sales QTY",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
                                                                      Expanded(child: Center(child: Text("In Stock",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),))),
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
                                                                  child: const Column(
                                                                    children: [
                                                                      Row(
                                                                        children:  [
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
                                                                                  child: Text('Virat'),
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
                                                                                  child: Icon(CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,),
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
                                        bottomNavigationBar: SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 30),
                                            child: Row(
                                              children: [
                                                // SizedBox(
                                                //   height: 30,
                                                //   width: 80,
                                                //   child: MaterialButton(
                                                //     onPressed: () {
                                                //       Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                //       EditVendors(selectedDestination: 3.3,
                                                //         vendorData:snapshot.data!.vendorDocketData[0].vendorData,
                                                //         drawerWidth: 190,),
                                                //         transitionDuration: Duration.zero,
                                                //         reverseTransitionDuration: Duration.zero
                                                //      ));
                                                //     },
                                                //     color: Colors.blue,
                                                //     child: const Row(
                                                //       children: [
                                                //         Icon(Icons.edit,color: Colors.white),
                                                //         Text("Edit",
                                                //             style: TextStyle(
                                                //                 color: Colors.white)
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  width: 80,
                                                  height: 30,
                                                  child: OutlinedMButton(
                                                    text :"Edit",
                                                    borderColor: Colors.indigo,
                                                    textColor:  Colors.indigo,
                                                    onTap: () {
                                                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                          EditVendors(selectedDestination: 3.3,
                                                            vendorData:snapshot.data!.vendorDocketData[0].vendorData,
                                                            drawerWidth: 190,),
                                                          transitionDuration: Duration.zero,
                                                          reverseTransitionDuration: Duration.zero
                                                      ));
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                              );

                            }   else{
                              print("Snapshot Error");
                              return Container();
                            }
                          }
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }




}
