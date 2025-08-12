import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:new_project/utils/api/get_api.dart';
import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/custom_dividers/custom_vertical_divider.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';
import '../classes/env.dart';
import 'create_new_part_order.dart';


class PartOrderDetails2 extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map partDetails;
  final List partsList;
  const PartOrderDetails2({
    super.key,
    required this.drawerWidth,
    required this.selectedDestination,
    required Duration transitionDuration,
    required Duration reverseTransitionDuration,
    required this.partDetails,
    required this.partsList,
  });

  @override
  State<PartOrderDetails2> createState() => _PartOrderDetails2State();
}

class _PartOrderDetails2State extends State<PartOrderDetails2> {
  final GlobalKey<CustomPopupMenuButtonState> _popupKey = GlobalKey<CustomPopupMenuButtonState>();
  final validationKey = GlobalKey<FormState>();

  TextStyle fontWeight =const TextStyle(fontWeight: FontWeight.bold);
  TextStyle headerStyle =const TextStyle(fontWeight: FontWeight.bold,fontSize: 14);
  String totalAmountS = '';
  String partID= '';
  String phoneNo = "";
  var amount = <TextEditingController>[];
  final _horizontalScrollController = ScrollController();
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

  bool loading = false;
  List partsOrderList = [];
  List searchList = [];
  String selectedID ="";
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
        }
      });
    });
  }
  double totalAmountTemp = 0.0;
  @override
  initState(){
    super.initState();
    searchList = widget.partsList;
    selectedID = widget.partDetails['partsOrderId'];
    partID = widget.partDetails['partsOrderId']??"";
    phoneNo = widget.partDetails['phone'].toString();

    formattedDate = DateFormat('yyyy-MM-dd').format(date);
    // print('-----partItemDetails---');
    // print(widget.partDetails);
    mapData(widget.partDetails);
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
  Future getOrderList(String value)async{
    dynamic response;
    String url = '${StaticData.url}partsorder/search_by_partsorderId/$value';
    try{
      await getData(url: url,context: context).then((value){
        setState(() {
          if(value!=null){
            response = value;
            searchList = response;
          }
          loading = false;
        });
      });
    }
    catch(e){
      logOutApi(context:context ,exception:e.toString() ,response: response);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.white,
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDrawer(widget.drawerWidth,widget.selectedDestination),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(child:
            Scaffold(
              body:Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 250,color: Colors.white,child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0,top:18,left: 10),
                        child: Row(children: [
                          InkWell(

                              onTap:(){
                                Navigator.of(context).pop();
                              },
                              child:const Tooltip(
                                  message: 'Back',
                                  child: Icon(Icons.arrow_back_outlined,color: Colors.black,))),
                          const SizedBox(width: 5,),
                          const Text("Parts Order List",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                          const SizedBox(width: 5,),
                          SizedBox(
                            width: 110,
                            height:30,
                            child: OutlinedMButton(
                              text: '+ Part Order',
                              buttonColor:mSaveButton ,
                              textColor: Colors.white,
                              borderColor: mSaveButton,
                              onTap:(){
                                Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                    CreatePartOrder2(selectedDestination: widget.selectedDestination,
                                      drawerWidth: widget.drawerWidth,)
                                ));
                              },
                            ),
                          ),
                        ]),
                      ),
                      const Divider(height: 1,color: mTextFieldBorder,),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(height: 32,child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search by ID",
                            contentPadding: const EdgeInsets.fromLTRB(8, 4, 2, 2),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4),borderSide: const BorderSide(
                              color: mSaveButtonBorder, // Set your desired border color here
                              width: 2.0,        // You can adjust the width of the border as needed
                            ),),),
                          onChanged: (value){
                            if(value.isEmpty){
                              setState(() {
                                searchList = widget.partsList;
                              });
                            }
                            else {
                              getOrderList(value);
                            }
                          },
                        ),),
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                const Divider(thickness: 1,height: 1),
                                SizedBox(height:60,
                                  child: PartButton(
                                    buttonColor:selectedID==searchList[index]['partsOrderId']? mSaveButton:Colors.white,
                                    data: searchList[index],
                                    onTap: (){
                                      setState(() {
                                        selectedID=searchList[index]['partsOrderId'];
                                        mapData(searchList[index]);
                                      });
                                    }, borderColor: Colors.white, textColor: selectedID==searchList[index]['partsOrderId']? Colors.white :Colors.black,
                                  ),
                                ),
                                if(index == searchList.length-1)
                                  const Divider(thickness: 1,height: 1),

                              ],
                            );
                          },
                          shrinkWrap: true,
                        ),
                      )
                    ],
                  ),
                  ),
                  Expanded(
                    flex: 5,
                    child: LayoutBuilder(builder: (context, constraints) {
                      if(constraints.maxWidth >= 1140){
                        return buildMain(MediaQuery.of(context).size.width);
                      }
                      else{
                        return AdaptiveScrollbar(
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
                ],
              ),
            ))
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
          child: Form(
            key:validationKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 68.0,right: 68,top: 10),
                  child: Container(
                    //height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(partID,style: headerStyle,),
                              Text(phoneNo,style: headerStyle,)
                            ],),
                          Row(children: [
                            MaterialButton(
                                color:const Color(0XFF68758D),
                                child: Row(
                                  children: [
                                    Icon(Icons.file_copy_rounded,color: Colors.white,),
                                    const Text("Documents",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),),
                                  ],
                                ),
                                onPressed: (){

                                })
                          ],)
                        ]),),
                ),
                const SizedBox(height: 11,),
                const Divider(height: 1,color: mTextFieldBorder,),
                Padding(
                  padding: const EdgeInsets.only(top: 30,left: 68,bottom: 30,right: 68),
                  child: Column(children: [
                    buildStatusCard(),
                    const SizedBox(height: 20,),
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
                  ],),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  mapData(partDetails){
    partsOrderList = [];
    partID = partDetails['partsOrderId']??"";
    phoneNo = partDetails['phone'].toString();
    nameController.text = partDetails['invCustomerName']??"";
    phoneController.text = partDetails['phone']??"";
    addressLine1Controller.text = partDetails['addressLine1']??"";
    addressLine2Controller.text = partDetails['addressLine2']??"";
    faxController.text = partDetails['fax']??"";
    telController.text = partDetails['tel']??"";
    creditLimitController.text = partDetails['creditLimit'].toString();
    outStandingController.text = partDetails['outstanding'].toString();
    availableController.text = partDetails['available'].toString();
    notesController.text = partDetails['notes']??"";
    reportsController.text = partDetails['reports']??"";
    orderTypeController.text = partDetails['orderType']??"";
    for(int i=0;i<partDetails['parts'].length;i++){
      partsOrderList.add(partDetails['parts'][i]);

      //Amount Calculation.
      double orderQty = double.parse(partDetails['parts'][i]['orderQty'].toString());
      double itemCost = double.parse(partDetails['parts'][i]['retailPrice'].toString());
      double tempTotal = orderQty * itemCost;
      totalAmountTemp += tempTotal;

    }
  }
  Widget buildStatusCard(){
    return  Card(
      color: Colors.white,surfaceTintColor: Colors.white,elevation:4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),

      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex:1,child: Container()),
              // First step: Parts Order
              const Column(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
                  Text(
                    'Parts Order',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Line between steps
              const Expanded(
                child: Divider(height: 1,
                  //thickness: 2,
                  color: mTextFieldBorder,
                ),
              ),
              // Second step: Invoice
              const Column(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.grey,
                  ),
                  Text(
                    'Invoice',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(flex:1,child: Container()),

            ],
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
                  child: Text("Supplier",style: headerStyle),
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
                  padding: const EdgeInsets.only(top: 8,left: 6),
                  child: Text("Order Type",style: headerStyle),
                ),
                const SizedBox(height: 6,),
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
                          textController: orderTypeController,
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
                  padding:const  EdgeInsets.only(top: 8,left: 6),
                  child: Text("GL Group",style: headerStyle),
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
                  padding:  const EdgeInsets.only(top: 8,left: 6),
                  child: Text("Order Date",style: headerStyle),
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
                          child: Text("Address",style: headerStyle,),
                        ),
                        const Divider(color: mTextFieldBorder,height: 1),
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
                      child: Text("Reports",style: headerStyle,),
                    ),
                    const Divider(color:mTextFieldBorder,height: 1,),
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
                  try {
                    if ((partsOrderList[index]['orderQty'] != "0" && partsOrderList[index]['orderQty'] != "") &&
                        (partsOrderList[index]['retailPrice'] != "0" && partsOrderList[index]['retailPrice'] != "")) {

                      // Calculate the current line item amount
                      double tempAmount = double.parse(partsOrderList[index]['orderQty'].toString()) * double.parse(partsOrderList[index]['retailPrice'].toString());
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
                            Text("${partsOrderList[index]['description']}")
                            )),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child:
                            //Text("")
                            Text("${partsOrderList[index]['partNo']}")
                            )),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 1,child: Center(child:
                            Text("")
                              //Text(partsOrderList[index]['itemType'].toString())
                            )),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 1,child: Center(child:
                            // Text("")
                            Text(partsOrderList[index]['orderQty'].toString())
                            )),

                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 2,child: Center(child:
                            // Text("")
                            Text(partsOrderList[index]['retailPrice'].toString())
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
            const Divider(height: 1,color: mTextFieldBorder,),
            const SizedBox(height: 40,),
            // Padding(
            //   padding: const EdgeInsets.only(left: 18.0,bottom: 18),
            //   child: SizedBox(
            //     width: 200,height: 28,
            //     child: OutlinedMButton(
            //       text: '+ Add Parts',
            //       buttonColor:mSaveButton ,
            //       textColor: Colors.white,
            //       borderColor: mSaveButton,
            //       onTap: () {
            //         Navigator.push(context,
            //             PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>
            //                 CreatePartsOrder(
            //                   drawerWidth: widget.drawerWidth,
            //                   selectedDestination: widget.selectedDestination,
            //                   partsOrderList: partsOrderList.isNotEmpty ? partsOrderList:[],
            //                   pageName: 'partOrderDetails',
            //                  ),)).then((value) {
            //                   setState(() {
            //                     if(value!=null) {
            //                       partsOrderList = value;
            //                       for(int i=0;i<partsOrderList.length;i++){
            //                         double tempTotalAmount = 0.0; // Initialize totalAmountS as a double
            //                         for (int i = 0; i < partsOrderList.length; i++) {
            //                           try {
            //                             double itemCost = double.parse(partsOrderList[i]['itemCost'].toString());
            //                             double orderQuantity = double.parse(partsOrderList[i]['orderQuantity'].toString());
            //                             // Calculate the total for the current item
            //                             double tempTotal = itemCost * orderQuantity;
            //                             // Add the current item's total to the overall total
            //                             tempTotalAmount += tempTotal;
            //                             totalAmountS = tempTotalAmount.toString();
            //                             //Print the unformatted total amount for debugging.
            //                             // print('-------totalAmountS-----');
            //                             // print(totalAmountS);
            //                           } catch (e) {
            //                             print('Error parsing data for item at index $i: $e');
            //                           }
            //                         }
            //                       }
            //                     }
            //           });
            //         });
            //
            //       },
            //     ),
            //   ),
            // ),

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
                        if(totalAmountTemp!=0){
                          return Text(totalAmountTemp.toString());
                        }
                        else{
                          return Text(totalAmountS);
                        }
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
