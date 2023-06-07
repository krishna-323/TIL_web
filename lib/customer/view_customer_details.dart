import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../utils/api/getApi.dart';
import '../utils/custom_loader.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';
import 'add_new_customer.dart';
import 'bloc/customer_details_bloc.dart';
import 'edit_customer.dart';
import 'model/customer_details_model.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
class ViewCustomers extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map customerList;
final String customerId;


   const ViewCustomers({
    Key? key, required this.drawerWidth,
    required this.selectedDestination,
    required this.customerList,
     required this.customerId}) : super(key: key);


  @override
  State<ViewCustomers> createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers>with SingleTickerProviderStateMixin {

  String selectedId = "";
  late int selectedIndex;
  String ? authToken;
  bool loading = false;

  _handleTabSelection(){
  if(_tabController.indexIsChanging){
    setState(() {
      _tabIndex=_tabController.index;
    });
  }
}
  String storeName='';
  @override
  void dispose() {
  _tabController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    storeName=widget.customerId;
    // print('---------check---------');
    // print(storeName);
    loading=true;
    // TabController length We Can Change According Our Requirements.
    _tabController=TabController(length: 1, vsync: this);
    _tabController.addListener(_handleTabSelection);
    getInitialData().whenComplete((){
      selectedId = widget.customerList['customer_id'];
      fetchCustomerListData();
      customerDetailsBloc.fetchCustomerNetwork(widget.customerList['customer_id']).whenComplete((){
        setState(() {
          loading=false;
        });
      });

    }

    );
    super.initState();
  }

  Future getInitialData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }

  List customerList=[];
  List forAdding=[];



  Future fetchCustomerListData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/get_all_newcustomer';
    try {
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            customerList = value;
            for(int i=0;i<customerList.length;i++){
              if(storeName==customerList[i]['customer_id']){
                scrollToName(i);
                // print('-------inside-------------');
                // print(value);
              }
            }
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
  Future scrollToName(int index)async{
    await controller.scrollToIndex(index,preferPosition: AutoScrollPosition.begin);
  }


  final List<Widget> myTabs=[
    const Tab(text:'General'),
    // If We Want More Tabs Here We Can Add.
    //const Tab(text:"Transaction"),
  ];
  late TabController _tabController;
  int _tabIndex=0;

  dynamic size,width,height;
  late   AutoScrollController controller=AutoScrollController();
  int store=0;
  @override
  Widget build(BuildContext context) {
   size=MediaQuery.of(context).size;
    width=size.width;
    height=size.height;
    return  Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
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
                body:
                CustomLoader(
                  inAsyncCall: loading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 300,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 12),
                                  child: Row(  crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [

                                      Column(
                                        children: const [
                                          SizedBox(height: 10,),
                                          Text("Customer",style: TextStyle(fontSize: 20)),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(right: 4),
                                        child: Container(
                                            width: 120,
                                            height: 30,
                                            decoration: BoxDecoration(border: Border.all(color:  Colors.blue),borderRadius: BorderRadius.circular(4)),
                                            child: InkWell(
                                              hoverColor: mHoverColor,
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => AddNewCustomer(drawerWidth: widget.drawerWidth,
                                                //           selectedDestination: widget.selectedDestination,
                                                //           title: 6,))).then((value) => fetchCustomerListData());
                                                Navigator.of(context).push(PageRouteBuilder(
                                                  pageBuilder: (context,animation1,animation2) => AddNewCustomer(
                                                    drawerWidth:widget.drawerWidth ,
                                                    selectedDestination: widget.selectedDestination, title: 1,
                                                  ),
                                                  transitionDuration: Duration.zero,
                                                  reverseTransitionDuration: Duration.zero,
                                                )).then((value) => fetchCustomerListData());
                                              },
                                              child: const Center(
                                                child: Text("+ Customer",
                                                    style: TextStyle(
                                                        color: Colors.blue)),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),

                                const Divider(height: 1),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 4, bottom: 10),
                                  child: SizedBox(height: 30, child: TextFormField(  style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration:decorationSearch('Search Customer'),  ),),
                                ),
                              ],
                            ),
                            const Divider(height: 1),
                           Expanded(
                             child: ListView.builder(
                              controller: controller,
                             itemCount: customerList.length,
                             itemBuilder: (BuildContext context, int index) {
                                     return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child:   Container(
                              color: selectedId == customerList[index]["customer_id"] ? Colors.blue[100] : Colors.transparent,
                              child: InkWell(
                              hoverColor: mHoverColor,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, top: 12, bottom: 12),
                                child: Row(
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(customerList[index]['customer_name'],
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 2,),
                                        Text(customerList[index]['mobile'],),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                selectedId = customerList[index]["customer_id"];
                                setState(() {
                                  selectedIndex = index;
                                  customerDetailsBloc.fetchCustomerNetwork(customerList[index]['customer_id']);
                                  selectedId = customerList[index]['customer_id'];
                                });

                              },
                              )
                        ),
                      );
                                  },
                    // children: customerList.map((data){
                    //  // if(selectedId == data["newcustomer_id"]){
                    //
                    //     // stop= int.parse(data["newcustomer_id"]
                    //     // );
                    // //  }
                    //   print(data['newcustomer_id']);
                    //   return ;
                    // }).toList(),
                  ),
                           ),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      // --------------tab bar------------
                      StreamBuilder(
                          stream: customerDetailsBloc.getCustomerDetails,
                          builder: (context, AsyncSnapshot <CustomerModel>snapshot) {
                            if (snapshot.hasData)
                            {
                              return
                                Flexible(
                                    flex: 4,
                                    child: DefaultTabController(
                                        length: 2,
                                        child: Scaffold(backgroundColor: Colors.white,
                                          body: SingleChildScrollView(
                                            controller: ScrollController(),
                                            child: Column(
                                              children:   [
                                                SizedBox(height: 60,
                                                  child: headerSection(snapshot.data!.customerDocketData[0].customerData["customer_name"],
                                                      snapshot.data!.customerDocketData[0].customerData["type"]
                                                  ),
                                                ),
                                                const Divider(height: 1),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: SizedBox(
                                                    height: 40,
                                                    child:
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox( height: 40,
                                                          width: 150,
                                                          child: TabBar(
                                                            indicator: BoxDecoration(
                                                              color: Colors.blue[100],
                                                            ),
                                                            indicatorColor: Colors.black,
                                                            labelColor: Colors.black,
                                                            unselectedLabelColor: Colors.lightBlue,
                                                            controller: _tabController,
                                                            tabs:myTabs,

                                                          ),
                                                        ),

                                                        Row(
                                                          children: [
                                                            Padding(
                                                                padding: const EdgeInsets.only(right: 14,bottom: 8,top: 8),
                                                                child: SizedBox(
                                                                  width: 80,
                                                                  height: 30,
                                                                  child: OutlinedMButton(
                                                                    text :"Edit",
                                                                    borderColor: Colors.indigo,
                                                                    textColor:  Colors.indigo,
                                                                    onTap: (){
                                                                      // Navigator.push(context, MaterialPageRoute(
                                                                      //     builder: (context) => EditCustomer(
                                                                      //       drawerWidth: widget.drawerWidth,
                                                                      //       selectedDestination: widget.selectedDestination,
                                                                      //       customerDataGet:snapshot.data!.customerDocketData[0].customerData, title: 1,
                                                                      //     )
                                                                      // )).
                                                                      // then((value) {
                                                                      //   customerDetailsBloc.fetchCustomerNetwork(selectedId);
                                                                      //   fetchCustomerListData();
                                                                      // });

                                                                      Navigator.of(context).push(PageRouteBuilder(
                                                                        pageBuilder: (context,animation1,animation2) => EditCustomer(
                                                                          drawerWidth: widget.drawerWidth,
                                                                          selectedDestination: widget.selectedDestination,
                                                                          customerDataGet:snapshot.data!.customerDocketData[0].customerData, title: 1,
                                                                        ),
                                                                        transitionDuration: Duration.zero,
                                                                        reverseTransitionDuration: Duration.zero,
                                                                      )).then((value) {
                                                                        customerDetailsBloc.fetchCustomerNetwork(selectedId);
                                                                        fetchCustomerListData();
                                                                      });
                                                                    },

                                                                  ),
                                                                )
                                                            ),
                                                            Padding(
                                                                padding: const EdgeInsets.only(right: 14,bottom: 8,top: 8),
                                                                child: SizedBox(
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
                                                                                                    deleteCustomerData();
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
                                                                )
                                                            )
                                                          ],
                                                        )

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(height: 1,),
                                                Container(
                                                  child:[
                                                    profileTab(snapshot),
                                                    const Text("Comments"),

                                                  ]
                                                  [_tabIndex], )
                                              ],
                                            ),
                                          ),

                                        )
                                    )
                                );

                            }
                            else{
                              // print("------------Snapshot Error--------");
                              return Container();
                            }

                          }
                      )
                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );

  }
  // Widget listViewScrollName(BuildContext context){
  //     return
  // }

  decorationSearch(String hintString,) {
    return InputDecoration(
      prefixIcon: const Icon(
        Icons.search,
        size: 18,
      ),
      prefixIconColor: Colors.blue,
      fillColor: Colors.white,
      counterText: "",
      contentPadding: const EdgeInsets.fromLTRB(12, -11, 01, 3),
      hintText: hintString,hintStyle: const TextStyle(fontSize: 14,color: Colors.grey),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.blue, width: 0.5)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.blue)),
    );
  }

  Widget headerSection(String customerName, customerType) {
    return  Padding(
      padding: const EdgeInsets.only(
          left: 40, right: 10, top: 10, bottom: 4),
      child: Row(  crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [

          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(customerName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
               Text(customerType,style: TextStyle(fontSize: 14)),
            ],
          ),


        ],
      ),
    );
  }

  Widget profileTab(AsyncSnapshot<CustomerModel> snapshot) {
    // print(snapshot.data!.customerDocketData[0].customerData);
    return Column(
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.only(left: 60,right:20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Customer Name', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(snapshot.data!.customerDocketData[0].customerData["customer_name"]),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Mobile Number', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(snapshot.data!.customerDocketData[0].customerData["mobile"]),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Email', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(snapshot.data!.customerDocketData[0].customerData["email_id"]),
                ],
              ),
              const SizedBox(height: 25),

            ],
          ),
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 60,right:20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Customer Type', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(snapshot.data!.customerDocketData[0].customerData["type"]),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('GSTIN', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(snapshot.data!.customerDocketData[0].customerData["gstin"]),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('PAN Number', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(snapshot.data!.customerDocketData[0].customerData["pan_number"]),
                ],
              ),
              const SizedBox(height: 25),

            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 60,right:20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Location', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(snapshot.data!.customerDocketData[0].customerData["location"]),
                ],
              ),
              const SizedBox(height: 25),

            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 60,right:20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Expanded(flex: 4,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 150,
                      child: Text('Billing Address', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                      ),
                    ),
                    const SizedBox(height: 4,),
                    SizedBox(width: 300,
                      child: Text(
                          snapshot.data!.customerDocketData[0].customerData["street_address"] +", "+
                              snapshot.data!.customerDocketData[0].customerData["location"] +", "+
                              snapshot.data!.customerDocketData[0].customerData["city"] +", "+
                              // snapshot.data!.customerDocketData[0].customerData["billing_state"] +", "+
                              snapshot.data!.customerDocketData[0].customerData["pin_code"]
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: const SizedBox()),
              Expanded(flex: 4,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 150,
                      child: Text('Shipping Address', style: TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                      ),
                    ),
                    const SizedBox(height: 4,),
                    SizedBox(width: 300,
                      child: Text(
                        snapshot.data!.customerDocketData[0].customerData["street_address"] +", "+
                            snapshot.data!.customerDocketData[0].customerData["location"] +", "+
                            snapshot.data!.customerDocketData[0].customerData["city"] +", "+
                            snapshot.data!.customerDocketData[0].customerData["pin_code"]
                            // snapshot.data!.customerDocketData[0].customerData["shipping_city"] +", "+
                            // snapshot.data!.customerDocketData[0].customerData["shipping_zipcode"],maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),

        // Align(
        //
        //   alignment: Alignment.bottomLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 20,right:20),
        //     child:
        //     Column(
        //       children: [
        //         //----name-----
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Customer Name',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //             Text(snapshot.data!.customerDocketData[0].customerData["first_name"]),
        //             SizedBox(width:15),
        //
        //           ],
        //         ),
        //         const SizedBox(height: 20,),
        //         //----company name-----
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Company Name',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //
        //             Text(snapshot.data!.customerDocketData[0].customerData['company_name'])
        //           ],
        //         ),
        //         const SizedBox(height: 10,),
        //         //-----customer email------
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Customer Email',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //             Text(snapshot.data!.customerDocketData[0].customerData['customer_email'])
        //           ],
        //         ),
        //         const SizedBox(height: 10,),
        //         //-----customer phone------
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Customer Phone',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //
        //             Text(snapshot.data!.customerDocketData[0].customerData['customer_phone'])
        //           ],
        //         ),
        //         const SizedBox(height: 10,),
        //         //--------website-------
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Website',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //
        //             Text(snapshot.data!.customerDocketData[0].customerData['website'])
        //           ],
        //         ),
        //         const SizedBox(
        //           height: 35,
        //         ),
        //
        //         //-----Other Details------
        //         const Align(
        //           alignment: Alignment.topLeft,
        //           child: Text(
        //             'Other Details',
        //             style: TextStyle(fontSize: 16),
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 20,
        //         ),
        //         //-----currency-----
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Currency',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //
        //             Text(snapshot.data!.customerDocketData[0].customerData['currency'])
        //           ],
        //         ),
        //         const SizedBox(height: 15,),
        //         //----opening balance----
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Opening Balance',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //
        //             Text(snapshot.data!.customerDocketData[0].customerData['opening_balance'])
        //           ],
        //         ),
        //         const SizedBox(height: 15,),
        //         //----payment terms-----
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Payment Terms',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //
        //             Text(snapshot.data!.customerDocketData[0].customerData['payment_terms'])
        //           ],
        //         ),
        //         const SizedBox(height: 15,),
        //         //source of supply-------
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Place Of Supply',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //
        //             Text(snapshot.data!.customerDocketData[0].customerData['place_of_supply'])
        //           ],
        //         ),
        //         //Tax prefarance.
        //         const SizedBox(height: 15,),
        //         //source of supply-------
        //         Row(
        //           children:  [
        //             const SizedBox(
        //               width: 150,
        //               child: Text(
        //                 'Tax Preference',
        //                 style:
        //                 TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //               ),
        //             ),
        //             Text(snapshot.data!.customerDocketData[0].customerData["tax_preferences"]== 'yes' ? 'Taxable' :'NonTaxable' ),
        //           ],
        //         ),
        //         const SizedBox(
        //           height: 35,
        //         ),
        //
        //         //  --------Address-----
        //         const Align(
        //           alignment: Alignment.topLeft,
        //           child: Text(
        //             'Address',
        //             style: TextStyle(fontSize: 16),
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 20,
        //         ),
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             //-----billing Address-------
        //             Container(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children:  [
        //                   const Align(
        //                     alignment: Alignment.topLeft,
        //                     child: Text(
        //                       'Billing Address',
        //                       style: TextStyle(fontSize: 16),
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     height: 20,
        //                   ),
        //                   //------billing attention----
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Attention',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['billing_attention'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  ------billing country-----
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Country',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['billing_country'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  --------billing address street1------
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Address',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['billing_address_street1'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  -------billing city-------
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'City',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['billing_city'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  -----billing state----
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'State',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['billing_state'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  ---billing zipcode---
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Zip Code',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['billing_zipcode'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  -----billing phone-----
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Phone',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['billing_phone'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                 ],
        //               ),
        //             ),
        //             //------shipping address -----
        //             Container(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children:  [
        //                   const Align(
        //                     alignment: Alignment.topLeft,
        //                     child: Text(
        //                       'Shipping Address',
        //                       style: TextStyle(fontSize: 16),
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     height: 20,
        //                   ),
        //                   //------shipping attention----
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Attention',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['shipping_attention'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  ------shipping country-----
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Country',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['shipping_country'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  --------shipping address street1------
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Address',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['shipping_address_street1'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  -------shipping city-------
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'City',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['shipping_city'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  -----shipping state----
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'State',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['shipping_state'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  ---shipping zipcode---
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Zip Code',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['shipping_zipcode'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                   //  -----shipping phone-----
        //                   Row(
        //                     children:  [
        //                       const SizedBox(
        //                         width: 150,
        //                         child: Text(
        //                           'Phone',
        //                           style:
        //                           TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
        //                         ),
        //                       ),
        //
        //                       Text(snapshot.data!.customerDocketData[0].customerData['shipping_phone'])
        //                     ],
        //                   ),
        //                   const SizedBox(height: 15,),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //         Container(height: 25,)
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Future deleteCustomerData() async {
    try{
      final deleteResponse=await http.delete(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/delete_newcustomer/$selectedId'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken'
        },
      );

      if(deleteResponse.statusCode ==200){
        setState(() {
          print('------------------Delete Item Details (Api)--------------');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:  Text('Data Deleted'),)
          );
          fetchCustomerListData();
          customerDetailsBloc.fetchCustomerNetwork(selectedId);
          // ViewCustomers(drawerWidth: widget.drawerWidth, customerList: {}, selectedDestination: widget.selectedDestination,);
          Navigator.of(context).pop();
        });
      }
      else{
        //If Data is Not Present It Will Through This Exception.
        setState(() {
          print('-----------------status----------');
          print(deleteResponse.statusCode.toString());
        });
      }
    }
    catch(e){
      print(e.toString());
      print(e);
    }
  }
}
