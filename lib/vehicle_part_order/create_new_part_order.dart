import 'dart:convert';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/custom_dividers/custom_vertical_divider.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../classes/env.dart';
import 'add_parts_from_master.dart';

class CreatePartOrder2 extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CreatePartOrder2({super.key,
    required this.drawerWidth,
    required this.selectedDestination,
  });

  @override
  State<CreatePartOrder2> createState() => _CreatePartOrder2State();
}

class _CreatePartOrder2State extends State<CreatePartOrder2> {
  final GlobalKey<CustomPopupMenuButtonState> _popupKey = GlobalKey<CustomPopupMenuButtonState>();
  final validationKey = GlobalKey<FormState>();

  TextStyle fontWeight = const TextStyle(fontWeight: FontWeight.bold);
  TextStyle headerTextStyle = const TextStyle(fontWeight: FontWeight.bold,fontSize: 14);
  String totalAmountS = '';
  var amount = <TextEditingController>[];
  final totalAmount = TextEditingController();
  final notesController = TextEditingController();
  final nameController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final phoneController = TextEditingController();
  final faxController = TextEditingController();
  final telController = TextEditingController();
  final reportsController = TextEditingController();
  final creditLimitController = TextEditingController();
  final outStandingController = TextEditingController();
  final availableController = TextEditingController();
  final supplierController = TextEditingController();
  final orderController = TextEditingController();
  final glGroupController = TextEditingController();
  final orderDateController = TextEditingController();
  final orderTypeController = TextEditingController();
  final _horizontalScrollController = ScrollController();
  bool loading = false;
  List partsOrderList = [];
  DateTime date = DateTime.now(); // Example: current date
  String formattedDate = "";
  String selectOrderType = 'Select Order Type';
  var orderType = [
    'Parts',
    'TUBE',
    'BOX',
    'Cover',
  ];

  Future postPartsDetails(partsDetails) async {
    String url = '${StaticData.url}partsorder/add_partsorder';
    postData(context: context, url: url, requestBody: partsDetails).then((value) {
      setState(() {
        if (value != null) {
          // print('--------Part ID--------');
          // print(value);
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Part Is Created: ${value['id']}',
            style:const TextStyle(fontWeight: FontWeight.bold),),duration: const Duration(seconds: 2),));
          ///Parts Order Quantity is Updating.
          for(int p=0;p<partsOrderList.length;p++){
            String partMasterId = partsOrderList[p]['partsMasterId'];
            // print('----------------')
            Map details = {
              "inStock": int.parse(partsOrderList[p]['inStock'].toString())
            };
            patchOrder(partMasterId,details);
          }

        }
      });
    });
  }
  Future<void> patchOrder(String orderId, updateData) async {
    final String apiUrl = "${StaticData.url}parts_master/patch_partsmaster/$orderId"; // Replace with your API endpoint

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        // Map tempResponse= jsonDecode(response.body);
        // ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        //   content: Text('Part Order Available Quantity Is Updated: ${tempResponse['inStock'].toString()} - Part MasterId Is ${tempResponse['partsMasterId']}',
        //   style:const TextStyle(fontWeight: FontWeight.bold),),duration: const Duration(seconds: 2),));
        if(mounted){
          Navigator.of(context).pop();
        }
      } else {
        print("Failed to update order. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (error) {
      print("Error updating order: $error");
    }
  }

  @override
  initState(){
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(date);
  }
  bool errorName = false;
  bool errorPhone = false;
  bool errorAddress1 = false;
  bool errorAddress2 = false;
  bool errorFax = false;
  bool errorTel = false;
  String? _nameValidate(v){
    if(v.isEmpty || v.trim().isEmpty){
      setState((){
        errorName = true;
      });
      return "Please Enter Name";
    }
    else{
      setState((){
        errorName = false;
      });
      return null;
    }
  }
  String? _phoneValidate(v){
    if(v.isEmpty || v.trim().isEmpty){
      setState((){
        errorPhone = true;
      });
      return "Please Enter Phone Number";
    }
    else{
      setState((){
        errorPhone = false;
      });
      return null;
    }
  }
  String? _address1Validate(v){
    if(v.isEmpty || v.trim().isEmpty){
      setState((){
        errorAddress1 = true;
      });
      return "Please Enter Address1";
    }
    else{
      setState((){
        errorAddress1 = false;
      });
      return null;
    }
  }
  String? _address2Validate(v){
    if(v.isEmpty || v.trim().isEmpty){
      setState((){
        errorAddress2 = true;
      });
      return "Please Enter Address2";
    }
    else{
      setState((){
        errorAddress2 = false;
      });
      return null;
    }
  }
  String? _faxValidate(v){
    if(v.isEmpty || v.trim().isEmpty){
      setState((){
        errorFax = true;
      });
      return "Please Enter Fax";
    }
    else{
      setState((){
        errorFax = false;
      });
      return null;
    }
  }
  String? _telValidate(v){
    if(v.isEmpty || v.trim().isEmpty){
      setState((){
        errorTel = true;
      });
      return "Please Enter Tel";
    }
    else{
      setState((){
        errorTel = false;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomDrawer(widget.drawerWidth,widget.selectedDestination),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(
              child:
              Scaffold(
                //backgroundColor: const Color(0xffF0F4F8),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: AppBar(
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Create Parts Order"),
                    actions: [
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,height: 28,
                            child: OutlinedMButton(
                              text: 'Save',
                              buttonColor:mSaveButton ,
                              textColor: Colors.white,
                              borderColor: mSaveButton,
                              onTap: (){
                                if(validationKey.currentState!.validate()){
                                  if(partsOrderList.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please Add At Least One Part...'),
                                          duration:Duration(seconds: 2) ,));
                                  }
                                  else{
                                    Map requestBody = {
                                      "addressLine1": addressLine1Controller.text,
                                      "addressLine2": addressLine2Controller.text,
                                      "amount": 323,
                                      "available": availableController.text.isEmpty? '0':double.parse(availableController.text),
                                      "creditLimit": creditLimitController.text.isEmpty ? "0":double.parse(creditLimitController.text),
                                      "fax": faxController.text,
                                      "glGroup": glGroupController.text,
                                      "invCustomerName": nameController.text,
                                      "notes": notesController.text,
                                      "orderDate": formattedDate,
                                      "orderType": orderTypeController.text,
                                      "outstanding": outStandingController.text.isEmpty? "0": double.parse(outStandingController.text),
                                      "parts": [],
                                      "phone": phoneController.text,
                                      "reports": reportsController.text,
                                      "supplier": supplierController.text,
                                      "tax": 0,
                                      "tel": telController.text,
                                      "totalAmount": double.parse(totalAmountS),
                                      "status":"In-Progress"
                                    };
                                    if(partsOrderList.isNotEmpty){
                                      for(int i=0;i<partsOrderList.length;i++){
                                        requestBody['parts'].add(
                                            {
                                              "availableQty": int.parse(partsOrderList[i]["inStock"].toString()),
                                              "dealerCost": double.parse(partsOrderList[i]["dealerCost"].toString()),
                                              "description": partsOrderList[i]["itemDescription"],
                                              "oldNo": "string",
                                              "orderQty": double.parse(partsOrderList[i]["orderQuantity"].toString()),
                                              "partNo": partsOrderList[i]["itemNo"],
                                              "retailPrice": double.parse(partsOrderList[i]["itemCost"].toString())
                                            }
                                        );
                                      }
                                    }

                                    // print('------Hare Krishna------');
                                    // print(partsOrderList);
                                    // print(requestBody['parts']);
                                    ///Posting Parts Order.
                                    postPartsDetails(requestBody);

                                    // print('-------parts--------');
                                    // print(requestBody['parts']);

                                  }
                                }
                              },

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
                body: CustomLoader(
                  inAsyncCall: loading,
                  child: LayoutBuilder(builder: (context, constraints) {
                    if(constraints.maxWidth >= 1140){
                      return buildMain(MediaQuery.of(context).size.width);
                    }
                    else {
                      return  AdaptiveScrollbar(
                        position: ScrollbarPosition.bottom,
                        underColor: Colors.blueGrey.withOpacity(0.3),
                        sliderDefaultColor: Colors.grey.withOpacity(0.7),
                        sliderActiveColor: Colors.grey,
                        controller: _horizontalScrollController,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: buildMain(1140),
                        ),
                      );
                  }
                  },),
                ),
              ),
            ),
          ]),
    );
  }

  Widget buildMain(double screenWidth){
   return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth,
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 30,left: 68,bottom: 30,right: 68),
            child: Form(
              key:validationKey,
              child: Column(
                children: [

                  buildHeader(),
                  const SizedBox(height: 20,),
                  buildInvoiceCard(),

                  const SizedBox(height: 20,),
                  buildCreditLimit(),

                  const SizedBox(height: 20,),
                  buildAddParts(),
                  const SizedBox(height: 20,),
                  buildTotalValues(),
                  const SizedBox(height: 20,),
                  buildOfficeUse(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Card(color: Colors.white,surfaceTintColor: Colors.white,elevation:4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0,bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding: const EdgeInsets.only(top: 8,left: 6),
                  child: Text("Supplier",style: headerTextStyle),
                ),
                const SizedBox(height: 6,),
                Container(decoration: BoxDecoration(color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4)),width: 250,height: 28,alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("TATA- Head Office",),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding:const EdgeInsets.only(top: 8,left: 6),
                  child: Text("Order Type",style: headerTextStyle),
                ),
                const SizedBox(height: 6,),
                // Container(decoration: BoxDecoration(color: Colors.grey[200],
                //     borderRadius: BorderRadius.circular(4)),
                //   width: 160,height: 28,
                //   alignment: Alignment.centerLeft,
                //   child:  Padding(
                //     padding: const EdgeInsets.only(left: 4.0),
                //     //child: Text("A13389",),
                //     child:  DropdownButton(
                //       hint: Text(dropdownvalue,),
                //       underline:const SizedBox.shrink(),
                //       menuMaxHeight: 200,
                //       // Initial Value
                //       //value: dropdownvalue,
                //       // Down Arrow Icon
                //       icon: dropdownvalue =="Select Order Type"?
                //       Icon(Icons.keyboard_arrow_down):
                //       Padding(
                //         padding: EdgeInsets.only(left: 60.0),
                //         child: Icon(Icons.keyboard_arrow_down),
                //       ),
                //
                //       // Array list of items
                //       items: orderType.map((String items) {
                //         return DropdownMenuItem(
                //           value: items,
                //           child: Text(items,
                //           ),
                //         );
                //       }).toList(),
                //       // After selecting the desired option,it will
                //       // change button value to selected value
                //       onChanged: (String? value) {
                //         setState(() {
                //           dropdownvalue = value!;
                //           orderTypeController.text = value;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                Container(
                  width: 200,height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      //border: Border.all(color: mTextFieldBorder),
                      borderRadius: BorderRadius.circular(4)),
                  child:   LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return CustomPopupMenuButton(
                          key:_popupKey,
                          decoration: customPopupDecoration(
                            hintText:selectOrderType,
                            onTap: () {
                              setState(() {
                                selectOrderType = "Select Order Type";
                                _popupKey.currentState?.showButtonMenu();
                              });
                            },),
                          // hintText: "ss",
                          //textController: customerTypeController,
                          childWidth: constraints.maxWidth,
                          offset: const Offset(1, 40),
                          tooltip: '',
                          itemBuilder:  (BuildContext context) {
                            return orderType.map((value) {
                              return CustomPopupMenuItem(

                                value: value,
                                text:value,
                                child: Container(),
                              );
                            }).toList();
                          },
                          onSelected: (value){
                            setState(() {
                              selectOrderType = value.toString();
                              orderTypeController.text = value.toString();
                            });

                          },
                          onCanceled: () {
                          },
                          hintText: '',
                          child: Container(),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding:const EdgeInsets.only(top: 8,left: 6),
                  child: Text("GL Group",style: headerTextStyle),
                ),
                const SizedBox(height: 6,),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 150,height: 28,alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text("ORD123F45678",),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,bottom: 8,right: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding:const EdgeInsets.only(top: 8,left: 6),
                  child: Text("Order Date",style: headerTextStyle ),
                ),
                const SizedBox(height: 6,),
                Container(decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(4)),width: 150,height: 28,alignment: Alignment.centerLeft,
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(formattedDate),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget buildInvoiceCard(){
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child:  Column(crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:  EdgeInsets.only(left: 18.0,bottom: 8,top: 8),
            child: Text("Invoicing Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
          ),
          const Divider(color: mTextFieldBorder,height: 1),
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex:2,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Padding(
                          padding:const EdgeInsets.only(left: 20.0,right: 8,top: 8,bottom: 8),
                          child: Text("Address",style: headerTextStyle,),
                        ),
                        const Divider(color: mTextFieldBorder,height: 1,),
                        const SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(child: Padding(
                              padding: const EdgeInsets.only(left:20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("Name",),
                                  ),
                                  const SizedBox(height: 6,),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                          validator: _nameValidate,
                                          controller: nameController,
                                          decoration: decoration(error: errorName)
                                      )
                                  ),
                                  const SizedBox(height: 15,),

                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("Address Line1"),
                                  ),
                                  const SizedBox(height: 6,),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        validator: _address1Validate,
                                        controller: addressLine1Controller,
                                        decoration: decoration(error: errorAddress1),

                                      )
                                  ),
                                  const SizedBox(height: 15,),

                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("Address Line2"),
                                  ),
                                  const SizedBox(height: 6,),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        validator: _address2Validate,
                                        controller: addressLine2Controller,
                                        decoration: decoration(error: errorAddress2),
                                      )
                                  ),
                                  const SizedBox(height: 25,)
                                ],),
                            )),
                            const SizedBox(width: 35,),
                            Flexible(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Phone"),
                                ),
                                const SizedBox(height: 6,),
                                Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextFormField(
                                      validator: _phoneValidate,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      controller: phoneController,
                                      decoration: decoration(error: errorPhone),

                                    )
                                ),
                                const SizedBox(height: 15,),

                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Fax"),
                                ),
                                const SizedBox(height: 6,),
                                Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextFormField(
                                      validator: _faxValidate,
                                      controller: faxController,
                                      decoration: decoration(error:errorFax),
                                    )
                                ),
                                const SizedBox(height: 15,),

                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Tel"),
                                ),
                                const SizedBox(height: 6,),
                                Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextFormField(
                                      validator: _telValidate,
                                      controller: telController,
                                      decoration: decoration(error: errorTel),
                                    )
                                ),
                                const SizedBox(height: 25,)

                              ],)),
                            const SizedBox(width: 35,),
                          ],)
                      ],)),
                //const CustomVDivider(height: 300, width: 1, color: mTextFieldBorder),
                const VerticalDivider(width: 1, color: mTextFieldBorder,thickness: 1,),
                Expanded(child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding:const EdgeInsets.all(8.0),
                      child: Text("Reports",style: headerTextStyle,),
                    ),
                    const Divider(color: mTextFieldBorder,height: 1,),
                    const SizedBox(height: 10,),
                    Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4)),
                      //height: 200,
                      alignment: Alignment.centerLeft,
                      child:  Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: reportsController,
                            maxLines: 8,
                            decoration: const InputDecoration(border: InputBorder.none,
                                contentPadding:EdgeInsets.only(left: 8,bottom: 10,right: 8,top: 10) ),

                          )
                      ),
                    ),
                  ],))
              ],
            ),
          ),

        ],
      ),
    );
  }
  Widget buildCreditLimit(){
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8),
            width: 1,)),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0,bottom: 20),
        child: Column(children: [
          Row(children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Credit Limit",),
                  ),
                  const SizedBox(height: 6,),
                  Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4)),
                    height: 35,
                    alignment: Alignment.centerLeft,
                    child:  Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: creditLimitController,
                          decoration:decoration(error: false),

                        )
                    ),
                  ),
                ],),
            )),
            const SizedBox(width: 35,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child:  Text("Outstanding",),
                ),
                const SizedBox(height: 6,),
                Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4)),
                  height: 35,
                  alignment: Alignment.centerLeft,
                  child:  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: outStandingController,
                        decoration: decoration(error: false),
                      )
                  ),
                ),
              ],)),
            const SizedBox(width: 35,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child:  Text("Available",),
                ),
                const SizedBox(height: 6,),
                Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4)),
                  height: 35,
                  alignment: Alignment.centerLeft,
                  child:  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: availableController,
                        decoration: decoration(error:false),
                      )
                  ),
                ),
              ],)),
            const SizedBox(width: 35,),
          ],)
        ]),
      ),
    );
  }
  Widget buildAddParts(){
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8),
            width: 1,)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:  EdgeInsets.only(left: 18.0,bottom: 8,top: 8),
              child: Text("Add Parts",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            Container(
              decoration: BoxDecoration(
                  color:Colors.grey[100],
                  border: Border(
                      top: BorderSide(color:mTextFieldBorder.withOpacity(0.8),),
                      bottom: BorderSide(color:mTextFieldBorder.withOpacity(0.8),)
                  )),
              height: 34,
              child:  Row(
                children:  [
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text('SN',style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 4,child: Center(child: Text("Description",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text("Part No",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 1,child: Center(child: Text("UOM",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 1,child: Center(child: Text("QTY",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Text("Rate",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Text("Amount",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  // Expanded(flex: 1,child: Center(child: Text("Edit",style:fontWeight,))),
                  // const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                ],
              ),
            ),
            if(partsOrderList.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: partsOrderList.length,
                itemBuilder: (context, index) {
                  amount.add(TextEditingController());
                  // print('----$index----');
                  // print(index);
                  try {
                    if ((partsOrderList[index]['orderQuantity'] != "0" && partsOrderList[index]['orderQuantity'] != "") &&
                        (partsOrderList[index]['itemCost'] != "0" && partsOrderList[index]['itemCost'] != "")) {

                      // Calculate the current line item amount
                      double tempAmount = double.parse(partsOrderList[index]['orderQuantity'].toString()) * double.parse(partsOrderList[index]['itemCost'].toString());
                      // Update the amount for the specific index
                      amount[index].text = tempAmount.toString();

                    }
                  } catch (e) {
                    print('-------Exception--In ListView Builder------');
                    print(e);
                  }


                  return Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          children:  [
                            Expanded(child: Center(child: Text('${index+1}'))),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 4,child: Center(child:
                            Text("${partsOrderList[index]['itemDescription']}")
                            )),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child:
                            //Text("")
                            Text("${partsOrderList[index]['itemNo']}")
                            )),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 1,child: Center(child:
                            //Text("")
                            Text(partsOrderList[index]['itemType'].toString())
                            )),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 1,child: Center(child:
                            // Text("")
                            Text(partsOrderList[index]['orderQuantity'].toString())
                            )),

                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 2,child: Center(child:
                            // Text("")
                            Text(partsOrderList[index]['itemCost'].toString())
                            )),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 2,child: Center(child:
                            //Text("")
                            Builder(
                                builder: (context) {
                                  return Text(amount[index].text.toString());
                                }
                            )
                            )),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            // Expanded(flex:1,
                            //   child: InkWell(onTap: (){
                            //     setState(() {
                            //       // selectedParts.removeAt(index);
                            //     });
                            //   },
                            //       hoverColor: mHoverColor,
                            //       child: const SizedBox(width: 30,height: 30,
                            //           child: Center(child: Icon(Icons.edit,color: Colors.orange,size: 18,)))),
                            // ),
                          ],
                        ),
                      ),
                      const Divider(height: 1,color: mTextFieldBorder,),
                    ],
                  );

                },),

            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,bottom: 18),
              child: SizedBox(
                width: 200,height: 28,
                child: OutlinedMButton(
                  text: '+ Add Parts',
                  buttonColor:mSaveButton ,
                  textColor: Colors.white,
                  borderColor: mSaveButton,
                  onTap: () {
                    Navigator.push(context,
                        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
                            AddPartsOrderFromMaster(
                              drawerWidth: widget.drawerWidth,
                              selectedDestination: widget.selectedDestination,
                              partsOrderList: partsOrderList.isNotEmpty ? partsOrderList:[],
                              pageName: 'newPart',
                            ),)).then((value) {
                      setState(() {
                        if(value!=null) {
                          partsOrderList = value;
                          for(int i=0;i<partsOrderList.length;i++){
                            double tempTotalAmount = 0.0; // Initialize totalAmountS as a double
                            for (int i = 0; i < partsOrderList.length; i++) {
                              try {
                                double itemCost = double.parse(partsOrderList[i]['itemCost'].toString());
                                double orderQuantity = double.parse(partsOrderList[i]['orderQuantity'].toString());
                                // Calculate the total for the current item
                                double tempTotal = itemCost * orderQuantity;
                                // Add the current item's total to the overall total
                                tempTotalAmount += tempTotal;
                                totalAmountS = tempTotalAmount.toString();
                                // Print the unformatted total amount for debugging
                                // print(tempTotalAmount);
                              } catch (e) {
                                print('Error parsing data for item at index $i: $e');
                              }
                            }
                          }

                        }
                      });
                    });

                  },
                ),
              ),
            ),
            const SizedBox(height: 40,),

          ]),
    );
  }
  Widget buildTotalValues(){
    return Column(children: [
      const SizedBox(height: 30,),
      Row(children: [
        Expanded(child: Container()),
        Expanded(child: Container()),
        Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Amount :",style: fontWeight,),
                  Builder(
                      builder: (context) {
                        //return Text("0");
                        return Text(totalAmountS);
                      }
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Tax :",style: fontWeight,),
                  const Text(""),
                ],
              ),
              const Row(
                children: [
                  Text("Total Amount :",
                    style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.blue),),
                  Text(""),
                ],
              ),

            ])),
      ],),
      const SizedBox(height: 30,)
    ],);
  }
  Widget buildOfficeUse(){
    return Card(color: Colors.white,surfaceTintColor: Colors.white,elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
        children: [

          const Padding(
            padding:  EdgeInsets.only(left: 18.0,bottom: 8,top: 8),
            child: Text("Office Use:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
          ),
          const Divider(color: mTextFieldBorder,height: 1),
          const SizedBox(height: 20,),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6,),
              const Padding(
                padding: EdgeInsets.only(left: 15.0,right: 15),
                child: Text("NOTES:"),
              ),
              const SizedBox(height: 6,),
              SizedBox(
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0,left: 15,right: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),
                            borderRadius: BorderRadius.circular(8),color: const Color(0xd5f8f7f7),),
                          child:  TextFormField(
                            controller: notesController,
                            decoration: const InputDecoration(border: InputBorder.none,
                                contentPadding: EdgeInsets.only(right: 5,top: 10,left: 5)),
                            style: const TextStyle(fontSize: 14),
                            maxLines: 10,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }
  InputDecoration decoration({required bool error }){
    return  InputDecoration(
      border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:const BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight:error==true ?60:35 ),
      contentPadding:const EdgeInsets.only(left: 8,bottom: 10,right: 8),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)), );
  }
  customPopupDecoration({required String hintText , GestureTapCallback? onTap}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      enabledBorder:  const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      suffixIcon: InkWell(onTap: onTap,
          child:  Icon(hintText=="Select Order Type" ?
          Icons.arrow_drop_down_circle_sharp : Icons.clear, color: mSaveButton, size: 14)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black,),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 0, 0, 10),

    );

  }
}
