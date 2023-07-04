import 'dart:core';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/custom_dividers/custom_vertical_divider.dart';
import '../../widgets/custom_search_textfield/custom_search_field.dart';
import '../../widgets/motows_buttons/outlined_icon_mbutton.dart';





class EditVehiclePurchaseOrder extends StatefulWidget {

  final double drawerWidth;
  final double selectedDestination;
  final Map poList;
  const EditVehiclePurchaseOrder({Key? key, required this.selectedDestination, required this.drawerWidth,required this.poList}) : super(key: key);

  @override
  State<EditVehiclePurchaseOrder> createState() => _EditPurchaseOrderState();
}

class _EditPurchaseOrderState extends State<EditVehiclePurchaseOrder> {

  late double width ;


  var exceptedDate = TextEditingController();
  var subAmountTotal = TextEditingController();
  var subTaxTotal = TextEditingController();
  var subDiscountTotal = TextEditingController();
  final termsAndConditions = TextEditingController();
  final customerNotes = TextEditingController();
  final freightController =TextEditingController();
  final reference = TextEditingController();
  final additionalCharges=TextEditingController();
  final grandTotalController =TextEditingController();
  bool changeFreightAmount=false;
  // For Bill To Variables.
  final vendorSearchController=TextEditingController();
  List vendorList=[];
  Map vendorData ={
    'Name':'',
    'city': '',
    'state': '',
    'street': '',
    'zipcode': '',
  };
  bool loading=false;
  bool showVendorDetails =false;
  bool addNewVendorAddress = false;
  String billToName='';
  String billToCity='';
  String billToStreet="";
  String billToState='';
  String billToZipcode="";

  // Ship To Variable  Declaration.
  final wareHouseController=TextEditingController();
  bool showWareHouseDetails=false;
  bool addNewWarehouseAddress=false;
  Map wareHouse ={
    'Name':'',
    'city': '',
    'state': '',
    'street': '',
    'zipcode': '',

  };
  String shipToName='';
  String shipToCity='';
  String shipToStreet="";
  String shipToState='';
  String shipToZipcode="";

  Map storePoList = {};

  //Table Line Items Data.
   var units =<TextEditingController>[];
  // Vehicle Variant Data.
  String vehicleVariantID="";
  List vvList=[];
  Future getAllVehicleVariant() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchaseline/get_vehicle_purchase_details/$vehicleVariantID';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
           response = value;
            vvList = value;
            // print('-------line Item------');
            // print(vvList);
           // Table Line Items Assigning.
           for(int i=0;i<vvList.length;i++){
             units.add(TextEditingController());
             units[i].text=vvList[i]['quantity'].toString();
             // print('-------try to print Qty----------');
             // print(units[i].text);
           }

          }

        });
      });
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {

      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storePoList = widget.poList;
    // print('-----check herer--------');
    // print(storePoList);

    vehicleVariantID = widget.poList['new_pur_vehi_id']??'';
    // Bill To Assign.
    billToName=storePoList['billAddressName']??"";
    billToCity=storePoList['billAddressCity']??'';
    billToState=storePoList['billAddressState']??"";
    billToStreet=storePoList['billAddressStreet']??"";
    billToZipcode=storePoList['billAddressZipcode']??"";
    // Ship To Assign.
    shipToState=storePoList['shippingAddressState']??"";
    shipToCity=storePoList['shippingAddressCity']??"";
    shipToName=storePoList['shippingAddressName']??"";
    shipToStreet=storePoList['shippingAddressStreet']??"";
    shipToZipcode=storePoList['shippingAddressZipcode']??"";

    reference.text = storePoList['reference']??"";
    exceptedDate.text =storePoList['expected_delivery_date']??"";
    customerNotes.text=storePoList['customer_notes']??"";
    termsAndConditions.text= storePoList['terms_conditions']??"";
    freightController.text = storePoList['freight_amount'].toStringAsFixed(2);
    getInitialData().whenComplete((){
      getAllVehicleVariant();
      // vendor Data.
      fetchVendorsData();
    });

  }
  String ? authToken;


  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }
  @override
  Widget build(BuildContext context) {
    width =MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar:  const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child:
            Scaffold(
              backgroundColor: const Color(0xffF0F4F8),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(88.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: AppBar(
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Display Purchase Order Details",style: TextStyle(color: Colors.indigo),),

                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,left: 68,bottom: 30,right: 68),
                  child: Column(
                    children: [
                      buildHeaderCard(),
                      const SizedBox(height: 10,),
                      buildContentCard(),

                    ],
                  ),
                ),
              ),  bottomNavigationBar: SizedBox(height: 50,
              child: Row(
                children: [
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

  Widget buildHeaderCard(){
    return  Card(color: Colors.white,surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///Header Details
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Address",style: TextStyle(fontSize: 18)),
                const SizedBox(height: 5,),
                SizedBox(
                  width: width/2.8,
                  child: const Text("Ikyam Solutions Private Limited #742, RJ Villa, Cross, 8th A Main Rd, Koramangala 4th Block, Koramangala, Bengaluru, Karnataka 560034",maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.grey)),
                ),
                const Text("9087877767",style: TextStyle(fontSize: 14,color: Colors.grey))

              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 42,
                  child: Icon(Icons.car_rental,color: Color(0xffCCBA13),size: 90),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget buildContentCard(){
    return Card(color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Bill to Details
               Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                     Padding(
                      padding: const EdgeInsets.only(left: 18.0,top: 8,right: 8,bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2,top: 2),
                            child: Text("Bill to Address"),
                          ),
                          if(storePoList.isNotEmpty)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showVendorDetails = false;
                                    addNewVendorAddress = true;
                                  });
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    const SizedBox(height: 10,),
                    if(addNewVendorAddress)
                      Center(
                        child: SizedBox(height: 32,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 18),
                            child: CustomTextFieldSearch(
                              decoration:textFieldDecoration(hintText: 'Search Vendor') ,
                              controller: vendorSearchController,
                              future: fetchData,
                              getSelectedValue: (VendorModelAddress value) {
                                setState(() {
                                  showVendorDetails=true;
                                  vendorData = {
                                    'Name':value.label,
                                    'city': value.city,
                                    'state': value.state,
                                    'street': value.street,
                                    'zipcode': value.zipcode,
                                  };
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(showVendorDetails==true?vendorData['Name']??"":billToName,style: const TextStyle(fontWeight: FontWeight.bold)),

                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 70,child:  Text("Street")),
                              const Text(": "),
                              Expanded(child: Text(showVendorDetails==true?vendorData['street']??"":billToStreet,maxLines: 2,overflow: TextOverflow.ellipsis)),
                            ],
                          ),

                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 70,child: Text("City")),
                              const Text(": "),
                              Expanded(child: Text(showVendorDetails==true?vendorData['city']??"":billToCity,maxLines: 2,overflow: TextOverflow.ellipsis)),
                            ],
                          ),

                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 70,child: Text("State")),
                              const Text(": "),
                              Expanded(child: Text(showVendorDetails==true?vendorData['state']??"":billToState,maxLines: 2,overflow: TextOverflow.ellipsis)),
                            ],
                          ),

                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 70,child: Text("ZipCode :")),
                              const Text(": "),
                              Expanded(child: Text(showVendorDetails==true?vendorData['zipcode']??"":billToZipcode,maxLines: 2,overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
              const CustomVDivider(height: 220, width: 1, color: mTextFieldBorder),

              ///Ship to Details
               Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                     Padding(
                      padding: const EdgeInsets.only(left: 18.0,top: 8,right: 8,bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2,top: 2),
                            child: Text("Ship to Address"),
                          ),
                          if(storePoList.isNotEmpty)
                            SizedBox(
                              height: 24,
                              child:  OutlinedIconMButton(
                                text: 'Change Details',
                                textColor: mSaveButton,
                                borderColor: Colors.transparent, icon: const Icon(Icons.change_circle_outlined,size: 14,color: Colors.blue),
                                onTap: (){
                                  setState(() {
                                    showWareHouseDetails = false;
                                    addNewWarehouseAddress = true;
                                  });
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1),
                    const SizedBox(height: 10,),
                    if(addNewWarehouseAddress)
                      Center(
                        child: SizedBox(height: 32,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 18),
                            child: CustomTextFieldSearch(
                              decoration:textFieldDecoration(hintText: 'Search warehouse'),
                              controller: wareHouseController,
                              future: fetchData,
                              getSelectedValue: (VendorModelAddress value) {
                                setState(() {
                                  showWareHouseDetails=true;
                                  wareHouse ={
                                    'Name':value.label,
                                    'city': value.city,
                                    'state': value.state,
                                    'street': value.street,
                                    'zipcode': value.zipcode,
                                  };
                                });


                                // print(value.value);
                                // print(value.city);
                                // print(value.street);// this prints the selected option which could be an object
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(showWareHouseDetails==true?wareHouse['Name']??"":shipToName,style: const TextStyle(fontWeight: FontWeight.bold)),

                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 70,child:  Text("Street")),
                              const Text(": "),
                              Expanded(child: Text(showWareHouseDetails==true?wareHouse['street']??"":shipToStreet,maxLines: 2,overflow: TextOverflow.ellipsis)),
                            ],
                          ),

                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 70,child: Text("City")),
                              const Text(": "),
                              Expanded(child: Text(showWareHouseDetails==true?wareHouse['city']??"":shipToCity,maxLines: 2,overflow: TextOverflow.ellipsis)),
                            ],
                          ),

                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 70,child: Text("State")),
                              const Text(": "),
                              Expanded(child: Text(showWareHouseDetails==true?wareHouse['state']??"":shipToState,maxLines: 2,overflow: TextOverflow.ellipsis)),
                            ],
                          ),

                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 70,child: Text("ZipCode :")),
                              const Text(": "),
                              Expanded(child: Text(showWareHouseDetails==true?wareHouse['zipcode']??"":shipToZipcode,maxLines: 2,overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              const CustomVDivider(height: 220, width: 1, color: mTextFieldBorder),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children:  [
                      Container(
                        height: 200,
                        width: 400,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Reference #'),

                                        const SizedBox(height: 10,),
                                        Container(
                                          width: 120,
                                          height: 32,
                                          color: Colors.grey[200],
                                          child: TextFormField(
                                            controller: reference,
                                            decoration:textFieldSalesInvoice(hintText: 'Reference ') ,
                                          ),
                                        )
                                      ],),
                                    const SizedBox(width: 1,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Expected Delivery Date'),
                                        const SizedBox(height: 10,),
                                        Container(
                                          width: 140,
                                          height: 32,
                                          color: Colors.grey[200],
                                          child: TextFormField(showCursor: false,
                                            controller: exceptedDate,
                                            onTap: ()async{
                                              DateTime? pickedDate=await showDatePicker(context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1999),
                                                  lastDate: DateTime.now()

                                              );
                                              if(pickedDate!=null){
                                                String formattedDate=DateFormat('dd/MM/yyyy').format(pickedDate);
                                                setState(() {
                                                  exceptedDate.text=formattedDate;
                                                });
                                              }
                                              else{
                                                log('Date not selected');
                                              }
                                            },
                                            decoration: textFieldSalesInvoiceDate(hintText: 'Expected Date'),
                                          ),
                                        )
                                      ],)
                                  ]),
                              const SizedBox(height: 25,),

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
          const Divider(color: mTextFieldBorder,height: 1),
          const SizedBox(height: 18,),
          buildLineCard(),
        ],
      ),
    );
  }

  Widget buildLineCard(){
    return SizedBox(

      child: Column(
        children: [

          ///-----------------------------Table Starts-------------------------
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18,right: 18),
            child: Container(color: const Color(0xffF3F3F3),
              height: 34,
              child: const Row(
                children:  [
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text('SL NO'))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 4,child: Center(child: Text("Items/Service"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Qty"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex:2,child: Center(child: Text("Price/Item"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 1,child: Center(child: Text("Discount"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Text("Tax %"))),
                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex:2,child: Center(child: Text("Amount"))),

                  CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder,),
          ),
          // for(int i=0;i<vvList.length;i++)
          ListView.builder(
            physics:const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: vvList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:18.0,right: 18),
                    child: Row(children: [
                      const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                      Expanded(child: Center(child: Text("${index + 1} "))),
                      const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                      Expanded(flex:4,child: Center(child: Text(vvList[index]['model'].toString()))),
                      const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                     // Expanded(child: Center(child: Text(vvList[index]['quantity'].toString()))),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.only(left: 12,right: 12,bottom: 2,top:2),
                        child: Container(
                            decoration: BoxDecoration(color:  const Color(0xffF3F3F3),borderRadius: BorderRadius.circular(4)),
                            height: 30,
                            child: TextField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              controller: units[index],
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 12,right: 8,top: 2),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent))
                              ),

                              onChanged: (v) {
                                setState(() {
                                  //subAmountTotal.text=subAmountTotal.text;
                                //  discountPercentage[index].text='0';
                                });
                              },
                            )),
                      )),
                      const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                      Expanded(flex:2,child: Center(child: Text(vvList[index]['unit_price'].toString()))),
                      const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                      Expanded(flex: 1,child: Center(child: Text(vvList[index]['discount'].toString()))),
                      const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                      Expanded(flex: 2,child: Center(child: Text(vvList[index]['tax_code']??""))),
                      const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                      Expanded(flex: 2,child: Center(child: Text(vvList[index]['amount'].toString()))),
                      const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    ],),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18,right: 18),
                    child: Divider(height: 1,color: mTextFieldBorder,),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20,),
          ///-----------------------------Table Ends-------------------------

          ///SUB TOTAL
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 18,right: 18),
            child: Container(
              color: const Color(0xffF3F3F3),
              height: 34,
              child: Row(
                children:   [
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  const Expanded(child: Center(child: Text(''))),
                  const Expanded(flex: 4,child: Center(child: Text(""))),
                  const Expanded(child: Center(child: Text(""))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  const Expanded(flex: 2,child: Center(child: Text("Sub Total"))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Builder(
                      builder: (context) {
                        return Text(storePoList['discounted_price'].toStringAsFixed(2));
                      }
                  ))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Builder(
                      builder: (context) {
                        return Text(storePoList['tax'].toStringAsFixed(2));
                      }
                  ))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Builder(
                      builder: (context) {
                        return Text(storePoList['base_price'].toStringAsFixed(2));
                      }
                  ))),
                  const SizedBox(width: 30,height: 30,),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 18,right: 18),
            child: Divider(height: 1,color: mTextFieldBorder),
          ),
          ///------Foooter----------
          buildFooter(),
          const Divider(height: 0.5,color: mTextFieldBorder,),
        ],
      ),
    );
  }
  Widget buildFooter(){
    return Padding(
      padding: const EdgeInsets.only(left: 18,right: 18,bottom: 20),
      child: SizedBox(

        child: Column(

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child:Column(
                    children: [
                      const SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Terms and Conditions",),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(

                          decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(border: InputBorder.none),
                              controller: termsAndConditions,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              minLines: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Customer Notes",),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(

                          decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(border: InputBorder.none),
                              controller: customerNotes,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              minLines: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],)
                ),
                const SizedBox(width: 25,),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0,bottom: 0,left: 10),
                    child: SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),

                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Total Taxable Amount"),
                                  Text(storePoList['base_price'].toStringAsFixed(2)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Freight Amount",style: TextStyle(color: Colors.blue),),
                                  Container(
                                      height: 25,
                                      width: 100,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: TextFormField(
                                          onChanged: (value){
                                            setState(() {
                                              if(freightController.text.isNotEmpty){
                                                changeFreightAmount=true;
                                                 grandTotalController.text = (double.parse(freightController.text)+ double.parse(storePoList['base_price'].toStringAsFixed(2))).toString();

                                              }

                                            });
                                          },
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontSize: 16),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                          controller: freightController,
                                          keyboardType:
                                          TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],

                                        ),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Container(
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total"),
                                    Text((changeFreightAmount==true?grandTotalController.text:storePoList['grand_total'].toString())),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  textFieldSalesInvoice({required String hintText, bool? error}) {
    return  InputDecoration(border: InputBorder.none,
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(10, 00, 0, 15),
    );
  }
  textFieldSalesInvoiceDate({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.calendar_month_rounded,size: 12,color: Colors.grey,),
      border: InputBorder.none,
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(10, 00, 0, 0),
    );
  }
  // New Vendor Search Decoration Function.
  textFieldDecoration({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.search,size: 18),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  // Search Form Class.
  fetchData() async {
    List list = [];
    // create a list of 3 objects from a fake json response
    for(int i=0;i<vendorList.length;i++){
      list.add( VendorModelAddress.fromJson({
        "label":vendorList[i]['company_name'],
        "value":vendorList[i]['company_name'],
        "city":vendorList[i]['payto_city'],
        "state":vendorList[i]['payto_state'],
        "zipcode":vendorList[i]['payto_zip'],
        "street":vendorList[i]['payto_address1']+", "+vendorList[i]['payto_address2'],
      }));
    }

    return list;
  }
  // Vendor Data async Function.
  fetchVendorsData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_all_new_vendor';
    try {
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
    catch (e) {
      logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }

}
 // Class.
 class VendorModelAddress {
  String label;
  String city;
  String state;
  String zipcode;
  String street;
  dynamic value;
  VendorModelAddress({
    required this.label,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.street,
    this.value
  });

  factory VendorModelAddress.fromJson(Map<String, dynamic> json) {
    return VendorModelAddress(
      label: json['label'],
      value: json['value'],
      city: json['city'],
      state: json['state'],
      street: json['street'],
      zipcode: json['zipcode'],

    );
  }
}


