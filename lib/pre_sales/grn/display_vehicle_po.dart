import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'add_grn_from_po.dart';
class ViewGrn extends StatefulWidget {

  final double drawerWidth;
  final double selectedDestination;
  const ViewGrn({Key? key, required this.drawerWidth, required this.selectedDestination}) : super(key: key);

  @override
  State<ViewGrn> createState() => _ViewGrnState();
}

class _ViewGrnState extends State<ViewGrn> {
  String?authToken;
  final vendorName=TextEditingController();
  final orderNumber=TextEditingController();
  final dateInput=TextEditingController();
  bool vendorError=false;
  bool orderError=false;
//Grn List storing response data inside the grnList.
  List vendorNameList=[];
  //function Fetch Vendor Name.
  Future<List> fetchVendorNameData()async{
    await Future.delayed(const Duration(microseconds: 100));
    List storeVendorName=[];
    //This VendorNameList Used In
    for(int i=0;i<vendorNameList.length;i++){
      storeVendorName.add(grnDataForDropDown.fromJson(vendorNameList[i]));
    }
    return storeVendorName;
  }
  //Function For Purchase Order Number.
  final dateNow=DateFormat('dd-MM-yyyy');
  List displayList=[];
  bool loading =false;
  List purchaseOrderNumber=[];
  Future<List> fetchPurchaseOrderNumber()async{
    await Future.delayed(const Duration(microseconds: 100));
    List list=[];
    //This VendorNameList Used In
    for(int i=0;i<purchaseOrderNumber.length;i++){
      list.add(grnPurchaseOrderNumber.fromJson(purchaseOrderNumber[i]));
    }
    return list;
  }

  Future fetchPurchaseData() async {
    //dynamic response it is a variable.
    dynamic response;
//url storing in variable.
    String url='https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_all_new_vehi_pur';
//Try For Exception.
    try{
      //getData Is method Importing form other Class.
      await getData(context:context,url:url).then((value) {
        setState(() {
          //value != null it Has Some Data.
          if(value!=null){
            //assigning to response dynamic variable.
            response=value;
            displayList=value;
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading=false;
      });
    }
  }

  @override
  initState(){
    super.initState();
    fetchVenderNameDropDown();
    fetchPurchaseOrderNumberDropDown();
    fetchPurchaseData();
    loading=true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDrawer(widget.drawerWidth, widget.selectedDestination),
            const VerticalDivider(width: 1,
              thickness: 1,),
            Expanded(
              child: Scaffold(

                body:
                CustomLoader(
                  inAsyncCall: loading,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.1,
                              )),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Search Purchase Order',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),

                          ),
                        ),
                        // for(int i=0;i<grnList.length;i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 20,bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //vendor name
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Vendor Name',style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    height: 30,
                                    width: 335,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color.fromRGBO(119,119,119, 1))),
                                    child:Padding(
                                      padding:  const EdgeInsets.only(left: 10,),

                                      child: TextFieldSearch(

                                        decoration: InputDecoration(

                                            suffixIcon:InkWell(
                                              child:vendorName.text.isEmpty? const Icon(Icons.search_sharp):const Icon(Icons.close_sharp),
                                              onTap: (){
                                                setState(() {
                                                  vendorName.clear();
                                                  fetchPurchaseData();
                                                });
                                              },),
                                            helperStyle: const TextStyle(fontSize: 10),hintText: 'Enter Vendor Name',
                                            border: InputBorder.none),
                                        label: '',
                                        controller: vendorName,
                                        future:(){
                                          return fetchVendorNameData();
                                        },

                                        getSelectedValue: (grnDataForDropDown newValue){
                                          // print("+++++++++++++Indise GetSelected Value");
                                          // print(newValue.vendor_name);
                                          searchByName(newValue.vendor_name);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //purchase order number
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Purchase Order Number',style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    width: 335,
                                    height: 30,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color.fromRGBO(119,119,119, 1))),
                                    child:Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFieldSearch(
                                        decoration:  InputDecoration(
                                          //Ternary Condition For Search Icon.
                                          suffixIcon:InkWell(child:orderNumber.text.isEmpty? const Icon(Icons.search_sharp):const Icon(Icons.close_sharp),
                                            onTap: (){
                                              setState(() {
                                                orderNumber.clear();
                                                fetchPurchaseData();
                                              });
                                            },),
                                          helperStyle: TextStyle(fontSize: 10),hintText: 'Enter Purchase Order',
                                          border: InputBorder.none,
                                        ),
                                        label: '',
                                        controller: orderNumber,
                                        future: (){
                                          return fetchPurchaseOrderNumber();
                                        },
                                        getSelectedValue: (grnPurchaseOrderNumber listOrder){
                                          // print('++++++++Purchase+++++++');
                                          searchByPurchaseOrderNumber(listOrder.po_id);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //purchase order date.
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Purchase Order Date'),
                                  const SizedBox(height: 10,),
                                  Container(
                                    width: 335,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.black,width: 0.6)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 5),
                                      child:
                                      TextFormField(
                                        //   onEditingComplete: (){
                                        //     searchByDate(dateinput.text);
                                        // },
                                        controller: dateInput, //editing controller of this TextField
                                        decoration:  InputDecoration(hintText: 'Choose Date',
                                          border: InputBorder.none,

                                          suffixIcon:InkWell(child: dateInput.text.isEmpty?const Icon(Icons.search_sharp):const Icon(Icons.close_sharp),
                                            onTap: (){
                                              setState(() {
                                                dateInput.clear();
                                                fetchPurchaseData();
                                              });
                                            },),

                                        ),
                                        readOnly: true,  //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            context: context, initialDate: DateTime.now(),
                                            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                            lastDate:  DateTime.now(),

                                          );

                                          if(pickedDate != null ){
                                            print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                            print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                            //you can implement different kind of Date Format here according to your requirement

                                            setState(() {

                                              dateInput.text = formattedDate; //
                                              searchByDate(dateInput.text);// set output date to TextField value.
                                            });
                                          }else{
                                            print("Date is not selected");
                                          }
                                        },

                                      ),

                                    ),
                                  ),
                                ],
                              )
                            ],),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                            height: 40,
                            color: Colors.grey[200],
                            child:
                            const Row(
                              children: [
                                Expanded(child: Center(child: Text("VENDOR NAME"))),
                                Expanded(child: Center(child: Text("PURCHASE ORDER NUMBER"))),
                                Expanded(child: Center(child: Text('ORDER DATE'))),
                                Expanded(child: Center(child: Text('EXCEPTED DELIVERY'))),
                                Expanded(child: Center(child: Text("AMOUNT"))),
                                Expanded(child: Center(child: Text("SELECT"))),
                              ],
                            )
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 20,),
                            //This Data Getting  Form Vendor Name.
                            for(int i=0;i<displayList.length;i++)
                              Column(
                                children: [
                                  InkWell(
                                    onTap: (){
                                    },
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(
                                                      height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(displayList[i]['vendor_name'])),
                                                ))),
                                        Expanded(
                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: SizedBox(
                                                      height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text(displayList[i]['po_id'])),
                                                ))),
                                        Expanded(
                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: SizedBox(
                                                      height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Center(
                                                          child: Text(displayList[i]['date']))),
                                                ))),
                                        Expanded(
                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: SizedBox(
                                                      height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 50),
                                                        child: Row(
                                                          children: [Text(displayList[i]['expected_delivery_date'])],
                                                        ),
                                                      )),
                                                ))),
                                        Expanded(
                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top:8.0),
                                                  child: SizedBox(
                                                      height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Center(
                                                          child: Column(
                                                            children:  [
                                                              Center(
                                                                child: Text(displayList[i]['grand_total'].toStringAsFixed(2)),
                                                              ),
                                                            ],
                                                          ))),
                                                ))),
                                        Expanded(
                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top:8.0),
                                                  child: SizedBox(
                                                      height: 30,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Center(

                                                          child: Column(

                                                            children:  [
                                                              Center(
                                                                child:
                                                                MaterialButton(color: Colors.blue,
                                                                    child: const Text('Generate GRN',style: TextStyle(color: Colors.white),),
                                                                    onPressed: (){
                                                                      // print(displayList[i]);
                                                                      setState(() {
                                                                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>UpdatedGrn(
                                                                          drawerWidth:widget.drawerWidth ,
                                                                                selectedDestination: widget.selectedDestination,
                                                                                vendorName:displayList[i]['vendor_name'],
                                                                                vendorId: displayList[i]['new_vendor_id'],
                                                                                purchaseOrderNumber: displayList[i]['po_id'],
                                                                                dateInput:displayList[i]['date'],
                                                                                selectId:displayList[i]['new_pur_vehi_id'],
                                                                                freightAmount:displayList[i]['freight_amount'].toString(),
                                                                                termsCondition: displayList[i]['terms_conditions'],
                                                                                customerNotes: displayList[i]['customer_notes'],
                                                                                grandTotal: displayList[i]['grand_total'],
                                                                                basePrice: displayList[i]['base_price'],
                                                                                taxAmount:displayList[i]['tax'],
                                                                        ),
                                                                        transitionDuration: Duration.zero,
                                                                          reverseTransitionDuration: Duration.zero
                                                                        ));
                                                                      });


                                                                    }),
                                                              ),
                                                            ],
                                                          ))),
                                                ))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        )
                      ]
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
      ),

    );
  }

//Fetch Data By Vendor Name Inside DropDown.
  Future searchByName(String contact_persons_name,)async{
    dynamic response;
    String url='https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_vendor_name_search/$contact_persons_name';
    try{
      await getData(context: context,url: url).then((value){
        setState(() {
          if(value!=null){
            response=value;
            displayList=value;
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        loading=false;
      });
    }

    // SharedPreferences prefs=await SharedPreferences.getInstance();
    // String? authToken=prefs.getString('authToken');
    // final response=await http.get(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_vendor_name_search/$contact_persons_name'),
    //   headers: {
    //     "Content-Type": "application/json",
    //     'Authorization': 'Bearer $authToken'
    //   },
    // );
    // if(response.statusCode==200){
    //   setState(() {
    //     print('_________________SearchByVendorName---------');
    //     print(response.body);
    //
    //      displayList =jsonDecode(response.body);
    //   });
    // }
    // else{
    //   print(response.statusCode.toString());
    // }
  }

//Fetch By Purchase Order Number Inside DropDown.
  Future searchByPurchaseOrderNumber(String po_id,)async{
    dynamic response;
    String url='https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_purchase_order_search/$po_id';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            displayList=value;
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,response:response ,exception: e.toString());
      setState(() {
        loading=false;
      });
    }
    // SharedPreferences prefs=await SharedPreferences.getInstance();
    // String? authToken=prefs.getString('authToken');
    // final response=await http.get(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_purchase_order_search/$po_id'),
    //   headers: {
    //     "Content-Type": "application/json",
    //     'Authorization': 'Bearer $authToken'
    //   },
    // );
    // if(response.statusCode==200){
    //   setState(() {
    //     print('_________________SearchByVendorName---------');
    //     print(response.body);
    //
    //     displayList =jsonDecode(response.body);
    //   });
    // }
    // else{
    //   print(response.statusCode.toString());
    // }
  }
//Fetch DropDown VendorNames in After Searching Name.
  Future fetchVenderNameDropDown()async{
    dynamic resonse;
    String url='https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_all_new_vehi_pur';
    try{
      await getData(context:context ,url: url).then((value) {
        setState(() {
          if(value!=null){
            resonse=value;
            vendorNameList=value;
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context:context ,exception:e.toString() ,response:resonse );
      setState(() {
        loading=false;
      });
    }
    //  SharedPreferences prefs=await SharedPreferences.getInstance();
    //  String? authToken=prefs.getString('authToken');
    // try{
    //   final response=await http.get(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_all_new_vehi_pur'),
    //     headers: {
    //       "Content-Type": "application/json",
    //       'Authorization': 'Bearer $authToken'
    //     },
    //   );
    //   if(response.statusCode==200){
    //     setState(() {
    //       vendorNameList =jsonDecode(response.body);
    //      // print("+++++++++++++++++++Response +++++++++++++++++++++++");
    //      // print(vendorNameList.toString());
    //     });
    //   }
    //   else{
    //     print(response.statusCode.toString());
    //   }
    // }
    // catch(e){
    //   print(e);
    //   print(e.toString());
    // }
  }
//Fetch  PurchaseOderNumbers Value Inside Dropdown.
  Future fetchPurchaseOrderNumberDropDown()async{
    dynamic response;
    String url='https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_all_new_vehi_pur';
    try{
      await getData(context: context,url:url ).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            purchaseOrderNumber=value;
          }
          loading=false;
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception:toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
    // SharedPreferences prefs=await SharedPreferences.getInstance();
    // String? authToken=prefs.getString('authToken');
    // try{
    //   final response=await http.get(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_all_new_vehi_pur'),
    //     headers: {
    //       "Content-Type": "application/json",
    //       'Authorization': 'Bearer $authToken'
    //     },
    //   );
    //   if(response.statusCode==200){
    //     setState(() {
    //       purchaseOrderNumber =jsonDecode(response.body);
    //       //print("+++++++++++++++++++Response +++++++++++++++++++++++");
    //     //  print(vendorNameList.toString());
    //     });
    //   }
    //   else{
    //     print(response.statusCode.toString());
    //   }
    // }
    // catch(e){
    //   print(e);
    //   print(e.toString());
    // }
  }
  //This IS For Date.
  Future searchByDate(String date)async{
    dynamic response;
    String url='https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_date_search/$date';
    try{
      await getData(url: url,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            displayList=value;
          }
          loading=false;
        });

      });
    }
    catch(e){
      logOutApi(context:context ,response:response ,exception: toString());
      setState(() {
        loading=false;
      });
    }

    // SharedPreferences prefs=await SharedPreferences.getInstance();
    // String? authToken=prefs.getString('authToken');
    // final response=await http.get(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_date_search/$date'),
    //   headers: {
    //     "Content-Type": "application/json",
    //     'Authorization': 'Bearer $authToken'
    //   },
    // );
    // if(response.statusCode==200){
    //   setState(() {
    //     print('_________________SearchByVendorName---------');
    //     print(response.body);
    //
    //     displayList =jsonDecode(response.body);
    //   });
    // }
    // else{
    //   print(response.statusCode.toString());
    // }
  }

}
//This Is For Vendor Name
class grnDataForDropDown{
  final String vendor_name;
// final double po_id;
// final double grand_total;
  final String label;
  grnDataForDropDown({
    required this.vendor_name,

    //required this.po_id,
    // required this.grand_total,
    required this.label,
  });

  factory grnDataForDropDown.fromJson(Map<String, dynamic> json) {
    print("++++++++++++++++++++");
    print(json);

    return grnDataForDropDown(
      vendor_name: json['vendor_name'],

      // po_id: json['po_id'],
      //   grand_total: json['grand_total'],
      label: json['vendor_name'],
    );
  }

}
//This Is For Purchase Order Number.
class grnPurchaseOrderNumber{
  final String po_id;

  final String label;
  grnPurchaseOrderNumber({
    required this.po_id,


    required this.label,
  });

  factory grnPurchaseOrderNumber.fromJson(Map<String, dynamic> json) {
    print("++++++++++++++++++++");
    print(json);

    return grnPurchaseOrderNumber(
      po_id: json['po_id'],

      label: json['po_id'],
    );
  }

}