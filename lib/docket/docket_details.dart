import 'dart:convert';
import 'dart:developer' as dev;
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/api/post_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_loader.dart';
import '../widgets/input_decoration_text_field.dart';
import 'bloc/docket_details_bloc.dart';
import 'model/docket_details_model.dart';

class DocketDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map docketData;
  const DocketDetails({Key? key,required this.docketData, required this.selectedDestination, required this.drawerWidth}) : super(key: key);

  @override
  State<DocketDetails> createState() => _DocketDetailsState();
}

class _DocketDetailsState extends State<DocketDetails>with SingleTickerProviderStateMixin {

  PageController page = PageController();
  bool loading = false;
  int v =1;
  var tabs = false;
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Customer Details'),
    const Tab(text: 'Order Details'),
    const Tab(text: 'Payment Details'),
    const Tab(text: 'Accessories'),
    const Tab(text: 'Booking Details'),
    const Tab(text: 'Exchange Details'),
  ];

  late TabController _tabController;
  int tabIndex=0;
  String userId="";

  // Map editDocketDetails = {};
  Map displayDocketDetails={};

  String modelName='';
  String type='';
  String labourType='';
  String categoryCode='';
  String modelCode='';
  String vehicleTypeCode='';
  String color='';
  String exShowRoomPrice='';
  String transmission='';
  String make='';
  String variantName='';
  _handleTabSelection(){
    if(_tabController.indexIsChanging){
      setState(() {
        tabIndex=_tabController.index;
      });
    }
  }
  String paymentId = "";
  String generalId = "";
  String bookId = "";
  String exchangeId = "";
  bool isShowButton = true;
  bool isBookButton = true;
  bool isExchangeButton = true;
  @override
  void initState() {
    loading = true;
    getInitialData().whenComplete(() {
      getPayment().whenComplete(() {
        getAccessories().whenComplete(() {
          docketDetailsBloc.fetchDocketNetwork(widget.docketData['dock_customer_id']);
          fetchPaymentDetails().whenComplete(() =>setState(() {
            fetchBookDetails().whenComplete(() => setState((){
              fetchExchangeDetails().whenComplete(() => setState((){
                loading = false;
              }));
            }));
          }));
        });
      });
    });
    super.initState();
    _tabController =  TabController(vsync: this, length:6);
    _tabController.addListener(_handleTabSelection);
    // exTermsAndCond.text ="1.Exchange car price was not matched so we have offered Rs 3000.00 discount\n\n2.We have recived the vehicle physically ";
    // editDocketDetails= widget.docketData;
    displayDocketDetails=widget.docketData;
    generalId = displayDocketDetails["general_id"]??"";
    // print('--------display docket details-----------');
    // print(displayDocketDetails);
    // print(displayDocketDetails["general_id"]);
    // print(generalId);
    // print('--------edit docket details-----------');
    // print(editDocketDetails);
    // print(editDocketDetails["general_id"]);
    modelName=displayDocketDetails['model_name']??'';
    type=displayDocketDetails['type']??"";
    labourType=displayDocketDetails['labour_type']??"";
    categoryCode=displayDocketDetails['vehicle_category_code']??"";
    vehicleTypeCode=displayDocketDetails['vehicle_type_code']??"";
    color=displayDocketDetails['color']??"";
    exShowRoomPrice=displayDocketDetails['ex_showroom_price']??"";
    transmission=displayDocketDetails['transmission']??'';
    modelCode=displayDocketDetails['model_code']??"";
    make=displayDocketDetails['make']??"";
    variantName=displayDocketDetails['varient_name']??"";
    // var code = rng.nextInt(900000) + 100000;
    // bookingInvNo.text= "VM${code.toString()}";
  }
  String? authToken;

  Future getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
    userId= prefs.getString("userId")??"";
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  // var rng =  Random();
  int index =0;

  final name = TextEditingController();
  final wo = TextEditingController();
  final mobile = TextEditingController();
  final emailId = TextEditingController();
  final panNo = TextEditingController();
  final dob = TextEditingController();
  final add1 = TextEditingController();
  final add2 = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final pin = TextEditingController();

  final bookingModel = TextEditingController();
  final bookingVariant = TextEditingController();
  final bookingColor = TextEditingController();
  final bookingDate = TextEditingController();
  final bookingCustId = TextEditingController();
  final bookingId = TextEditingController();
  final bookingChassisNo = TextEditingController();
  final bookingEngineNo = TextEditingController();
  final bookingVehicleRegNo = TextEditingController();
  final bookingAllotmentDate = TextEditingController();
  final bookingAllottedBy = TextEditingController();
  final bookingCarStatus = TextEditingController();

  bool checkedValue = false;
  List offers =["Consumer Offer","Corporate Offer","Exchange Bonus","Additional Discount","Accessories Disc"];
  final oemConsOffer = TextEditingController();
  final oemCorpOffer = TextEditingController();
  final oemExchOffer = TextEditingController();
  final oemAdditionalOffer = TextEditingController();
  final oemAccesOffer = TextEditingController();

  final selfConsOffer = TextEditingController();
  final selfCorpOffer = TextEditingController();
  final selfExchOffer = TextEditingController();
  final selfAdditionalOffer = TextEditingController();
  final selfAccesOffer = TextEditingController();

  double consTotal=0;
  double corpTotal =0;
  double exchTotal =0;
  double additionalTotal =0;
  double accessTotal =0;

  double grandTotal = 0;
  List paymentList =[];

  //PaymentDetailsTab Actual and Discounted
  final actualExShowroom = TextEditingController();
  final discountedExShowroom = TextEditingController();
  final actualLifeTax = TextEditingController();
  final discountedLifeTax = TextEditingController();
  final actualZeroDep = TextEditingController();
  final discountedZeroDep = TextEditingController();
  final actualInsurance = TextEditingController();
  final discountedInsurance = TextEditingController();
  final actualRegTr = TextEditingController();
  final discountedRegTr = TextEditingController();
  final actual3Rd4ThWarranty = TextEditingController();
  final discounted3Rd4ThWarranty = TextEditingController();
  final actualAccessories = TextEditingController();
  final discountedAccessories = TextEditingController();
  final actualOthers = TextEditingController();
  final discountedOthers = TextEditingController();
  final actualRefund = TextEditingController();
  final discountedRefund = TextEditingController();
  final actualTotal = TextEditingController();
  final discountedTotal = TextEditingController();

  bool isDisabled = false;
  bool financeScheme = false;
  final controller = TextEditingController();

  final existingCar = TextEditingController();
  final evaluationDate = TextEditingController();
  final financeCompany = TextEditingController();
  final financeAmount = TextEditingController();
  final bookingAmount = TextEditingController();
  final paymentMode = TextEditingController();

  final exModel = TextEditingController();
  final exLessPerClosAmt = TextEditingController();
  final exManufactureYear = TextEditingController();
  final exLessTrafficChallan = TextEditingController();
  final exRegNo = TextEditingController();
  final exLessBalance = TextEditingController();
  final exRelationship = TextEditingController();
  final exRCCopy = TextEditingController();
  final exVehicleCost = TextEditingController();
  final exTermsAndCond = TextEditingController();

  final bookingInvNo = TextEditingController();
  final bookingInvDate = TextEditingController();
  final bookingInsNo = TextEditingController();
  final bookDetailsDate = TextEditingController();
  final bookingEWNo = TextEditingController();
  final bookingMaruthiInsurance = TextEditingController();
  final bookingInsuranceRemarks = TextEditingController();
  final bookingInsRemarksNo= TextEditingController();

  final accessoriesAmount = TextEditingController();
  final recDate = TextEditingController();
  final recAmount = TextEditingController();
  final recNote = TextEditingController();

  List accessoriesList = [];
  final _currencies = [
    "Digital",
    "Cheque",
    "Cash"
  ];
  String issuedNotIssued ='Issued';
  String approvedBy = "Manager1";
  String accessoriesSign = "Yes";
  String _currentSelectedValue='Digital';

  late double sWidth;
  late double sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth =MediaQuery.of(context).size.width;
    sHeight =MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
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
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child:  Padding(
                    padding: const EdgeInsets.all(40),
                    child: StreamBuilder(
                      stream: docketDetailsBloc.getDocketDetails,
                      builder: (context,AsyncSnapshot <DocketDetailsModel> snapshot) {
                        if(snapshot.hasData){
                          if(index==0){
                            // editDocketDetails = snapshot.data!.docketData[0].list[0];
                            // name.text=displayDocketDetails["customer_name"]??"";
                            // // print('--------stream builder-------');
                            // // print(displayDocketDetails);
                            // wo.text=displayDocketDetails["wife_off"]??"";
                            // emailId.text=displayDocketDetails["email_id"];
                            // mobile.text=displayDocketDetails["mobile"];
                            // panNo.text=displayDocketDetails["pan_number"];
                            // dob.text=displayDocketDetails["date_of_birth"];
                            // // add1.text=displayDocketDetails["address_1"]??"";
                            // // add2.text=displayDocketDetails["address_2"]??"";
                            // // city.text=displayDocketDetails["city"]??"";
                            // // state.text=displayDocketDetails["state"]??"";
                            // // pin.text=displayDocketDetails["pincode"].toString();
                            // // bookingDate.text=displayDocketDetails['order_booking_date'];
                            //
                            //
                            //
                            // consTotal =double.parse(oemConsOffer.text.isEmpty? "0":oemConsOffer.text)+ double.parse(selfConsOffer.text.isEmpty ? "0":selfConsOffer.text);
                            // corpTotal =double.parse(oemCorpOffer.text.isEmpty? "0":oemCorpOffer.text)+ double.parse(selfCorpOffer.text.isEmpty ? "0":selfCorpOffer.text);
                            // exchTotal =double.parse(oemExchOffer.text.isEmpty? "0":oemExchOffer.text)+ double.parse(selfExchOffer.text.isEmpty ? "0":selfExchOffer.text);
                            // additionalTotal =double.parse(oemAdditionalOffer.text.isEmpty? "0":oemAdditionalOffer.text)+ double.parse(selfAdditionalOffer.text.isEmpty ? "0":selfAdditionalOffer.text);
                            // accessTotal =double.parse(oemAccesOffer.text.isEmpty? "0":oemAccesOffer.text)+ double.parse(selfAccesOffer.text.isEmpty ? "0":selfAccesOffer.text);
                            //
                            //
                            // grandTotal = consTotal+corpTotal+exchTotal+additionalTotal+accessTotal;
                            //
                            //
                            //
                            // actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                            //     double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                            //     double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                            //     double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                            //     double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                            //     double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                            //     double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                            //     double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                            //     double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                            // ).toString();
                            //
                            //
                            // discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                            //     double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                            //     double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                            //     double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                            //     double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                            //     double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                            //     double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                            //     double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                            //     double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                            // ).toString();
                            //
                            //
                            // if(displayDocketDetails['exchange_car']=="true"){
                            //   isDisabled=true;
                            //   existingCar.text=displayDocketDetails['existing_car_model'];
                            //   evaluationDate.text=displayDocketDetails['evaluation_date'];
                            // }
                            // if(displayDocketDetails['finance_scheme']=="true"){
                            //   financeScheme=true;
                            //   financeCompany.text=displayDocketDetails['finance_company'];
                            //   financeAmount.text=displayDocketDetails['finance_amount'].toString();
                            // }
                            // bookingAmount.text=displayDocketDetails['booking_amount'].toString();
                            // paymentMode.text=displayDocketDetails['payment_mode'];
                            //
                            //
                            //
                            // index=1;
                          }

                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        border: Border.all(color: Colors.blueAccent),
                                      ),
                                      // width: 80,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: SizedBox(
                                            width: 80,
                                            child: Row(
                                              children: [
                                                Icon(Icons.arrow_back_sharp,color: Colors.blue,size: 20),
                                                Expanded(child: Text("Go Back",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: const Color(0xff2f4295),
                                              ),
                                              width: 100,
                                              height: 30,
                                              child: InkWell(
                                                onTap: ()async {
                                                  Map requestBody={
                                                    "address_line_1": add1.text,
                                                    "address_line_2": add2.text,
                                                    "booking_amount": bookingAmount.text,
                                                    "brand_id": "",
                                                    "city": city.text,
                                                    "color":displayDocketDetails["color"],
                                                    "type":displayDocketDetails["type"],
                                                    "labour_type":displayDocketDetails["labour_type"],
                                                    "vehicle_category_code":displayDocketDetails["vehicle_category_code"],
                                                    "model_code":displayDocketDetails["model_code"],
                                                    "vehicle_type_code":displayDocketDetails["vehicle_type_code"],
                                                    "customer_name": name.text,
                                                    "dob": dob.text,
                                                    "email_id": emailId.text,
                                                    "evaluation_date":
                                                    evaluationDate.text.isEmpty ? "" : evaluationDate.text,
                                                    "ex_showroom_price": widget.docketData["ex_showroom_price"],
                                                    "existing_car": isDisabled,
                                                    "existing_car_model":
                                                    existingCar.text.isEmpty ? "" : existingCar.text,
                                                    "extended_warranty": widget.docketData['extented_warrenty'],
                                                    "fast_tag": widget.docketData['fast_tag'],
                                                    "finance_amount":
                                                    financeAmount.text.isEmpty ? "" : financeAmount.text,
                                                    "finance_company":
                                                    financeCompany.text.isEmpty ? "" : financeCompany.text,
                                                    "finance_scheme": financeScheme,
                                                    "insurance": widget.docketData['insurance'],
                                                    "mobile": mobile.text,
                                                    "model_id": widget.docketData['model_id'],
                                                    "varient_name": widget.docketData['varient_name'],
                                                    "on_road_price": widget.docketData['on_road_price'],
                                                    "pan_number": panNo.text,
                                                    "payment_mode": widget.docketData['payment_mode'],
                                                    "pincode": pin.text,
                                                    "rto": widget.docketData['rto'],
                                                    "state": state.text,
                                                    "wo_or_so": wo.text,
                                                    "year": "2022",
                                                    "accessories_charges": widget.docketData['accessories_charges'],
                                                    "transmission": widget.docketData['transmission'],
                                                    "booking_date": bookingDate.text,
                                                  };
                                                  // Navigator.push(context, MaterialPageRoute(
                                                  //   builder: (context) => BookedOrder(
                                                  //       drawerWidth: widget.drawerWidth,
                                                  //       selectedDestination: widget.selectedDestination,
                                                  //       bookDetails: requestBody,
                                                  //       fromDocket: true
                                                  //   ),
                                                  // ),
                                                  // );
                                                },
                                                child: const Center(
                                                  child: Text("Summary",style: TextStyle(color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            height: 30,
                                            // width: 200,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Order Booking Date",
                                                    style: TextStyle(
                                                      fontSize: 16,color: Colors.indigo,fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  ": ",
                                                  style: TextStyle(
                                                      fontSize: 16,color: Colors.indigo,fontWeight: FontWeight.bold
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            height: 30,
                                            // width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              onTap: () {
                                                _selectBookingDate(context);
                                              },
                                              style: const TextStyle(fontSize: 14),
                                              onChanged: (text){
                                                setState(() {

                                                });
                                              },
                                              controller: bookingDate,
                                              decoration: decorationInput4(bookingDate.text.isEmpty?"Date":"",true,false),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Card(
                                elevation: 10,
                                color: Colors.white,
                                surfaceTintColor: Colors.white,

                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.white10,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18, right: 16, top: 8, bottom: 16),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10, bottom: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "$make  $modelName",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.indigo[800],
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "On Road Price",
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.indigo[800],
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            ": Rs ${displayDocketDetails['onroad_price']}",
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.indigo[800],
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                )
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 8,),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Variant",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $variantName",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Type",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $type",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Transmission",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $transmission",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15,),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Color",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $color",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Labour Type",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $labourType",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Model Code",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $modelCode",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15,),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Ex-Showroom Price",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $exShowRoomPrice",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Category Code",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $categoryCode",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        children:  [
                                                          const Expanded(
                                                              child: Text("Vehicle Type Code",maxLines: 1,overflow: TextOverflow.ellipsis)
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                ": $vehicleTypeCode",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              // ------- tab bar --------
                              Align(
                                alignment: Alignment.topLeft,
                                child: TabBar(
                                  labelColor: Colors.indigo[800],
                                  labelStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                  unselectedLabelColor: Colors.grey,
                                  controller: _tabController,
                                  tabs: myTabs,
                                ),
                              ),
                              Container(
                                child: [
                                  customerTab(),
                                  orderDetails(),
                                  paymentDetails(),
                                  accessoriesTab(),
                                  bookingDetailsTab(),
                                  exchangeDetailsTab(),
                                ]
                                [tabIndex],
                              ),
                            ],
                          );
                        }
                        else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  final _horizontalScrollController = ScrollController();
  final _horizontalScrollController3 = ScrollController();
  List fetchPayList = [];
  Map customerDetails = {};
  customerTab(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: name.text.isNotEmpty ? const BoxDecoration() : const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: name,
                    decoration: decorationInput("Customer Name", name.text.isNotEmpty),
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: wo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: wo,
                    decoration: decorationInput("W/o",wo.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: mobile.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true,),
                    inputFormatters:  [
                      FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    maxLength: 10,
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: mobile,
                    decoration: decorationInput("Mobile",mobile.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: emailId.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: emailId,
                    decoration: decorationInput("Email ID",emailId.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: panNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: panNo,
                    decoration: decorationInput("PAN Number",panNo.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: dob.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    onTap: ()async{
                      DateTime? pickedDate=await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1999),
                        lastDate: DateTime.now(),
                      );
                      if(pickedDate!= null){
                        String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
                        setState(() {
                          dob.text=formattedDate;
                        });
                      }    else{
                        print('Date of birth not selected');
                      }
                    },
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: dob,
                    decoration: decorationInput("Date of Birth",dob.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: add1.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: add1,
                    decoration: decorationInput("Address  1",add1.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: add2.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: add2,
                    decoration: decorationInput("Address 2",add2.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: city.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: city,
                    decoration: decorationInput("City",city.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: state.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: state,
                    decoration: decorationInput("State",state.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  decoration: pin.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: pin,
                    decoration: decorationInput("Pin Code",pin.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50,),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Container(
          //       decoration: BoxDecoration(
          //       gradient: const LinearGradient(
          //         colors: [Color(0xff374ABE), Color(0xff64B6FF)],
          //         begin: Alignment.centerLeft,
          //         end: Alignment.centerRight,
          //       ),
          //       borderRadius: BorderRadius.circular(20.0)),child: Padding(
          //     padding: const EdgeInsets.only(left: 8.0,right: 8),
          //     child: TextButton(
          //       onPressed: (){
          //         if(tabIndex == 0){
          //           tabs = true;
          //           _tabController.animateTo((_tabController.index + 1) % 6);
          //         }
          //       }, child: const Text("Save",style: TextStyle(color: Colors.white)),),
          //   )),
          // ),
        ],
      ),
    );
  }
  orderDetails(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  Container(
                  decoration : isDisabled ? BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(5),boxShadow: const [BoxShadow(color:Colors.white,blurRadius: 2)]):BoxDecoration(color: Colors.grey[200]),
                  child: Transform.scale(
                    alignment:Alignment.topLeft,
                    scale: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: AnimatedContainer(height: 36,
                          duration: const Duration(seconds: 0),
                          // decoration: isDisabled ? BoxDecoration(border: Border.all(color: Colors.blue),boxShadow: [BoxShadow(color:Colors.white,blurRadius: 2)]):BoxDecoration(),
                          child: SwitchListTile(
                            activeColor: Colors.green,
                            value: isDisabled,
                            onChanged: (value) {
                              setState(() {
                                isDisabled = value;
                                if(value==false){
                                  existingCar.clear();
                                  evaluationDate.clear();
                                }
                              });
                            },
                            title: const Text('Exchange Car',style: TextStyle(fontSize: 18),),
                          )
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  decoration: existingCar.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (val){
                      setState(() {

                      });
                    },
                    enabled: isDisabled,
                    controller: existingCar,
                    decoration:decorationInput("Existing Car Model",existingCar.text.isNotEmpty),
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  decoration: evaluationDate.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextField(
                    onTap: (){
                      _selectEleDate(context);
                    },
                    style: const TextStyle(fontSize: 14),
                    onChanged: (val){
                      setState(() {

                      });
                    },
                    enabled: isDisabled,
                    controller: evaluationDate,
                    decoration:decorationInput("Evaluation Date",evaluationDate.text.isNotEmpty),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  decoration : financeScheme ? BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.blue),boxShadow: const [BoxShadow(color:Colors.white,blurRadius: 2)]):BoxDecoration(color: Colors.grey[200]),
                  child:  Transform.scale(
                    alignment:Alignment.topLeft,
                    scale: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: AnimatedContainer(height: 36,
                          duration: const Duration(seconds: 0),
                          //decoration: financeScheme ? BoxDecoration(border: Border.all(color: Colors.blue),boxShadow: [BoxShadow(color:Colors.white,blurRadius: 2)]):BoxDecoration(),
                          child: SwitchListTile(activeColor: Colors.green,
                            value: financeScheme,
                            onChanged: (value) {
                              setState(() {
                                financeScheme = value;
                                if(value==false){
                                  financeCompany.clear();
                                  financeAmount.clear();
                                }
                              });
                            },
                            title: const Text('Finance Scheme' ,style: TextStyle(fontSize: 18),),
                          )
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  decoration: financeCompany.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (val){
                      setState(() {

                      });
                    },
                    enabled: financeScheme,
                    controller: financeCompany,
                    decoration:decorationInput("Finance Company",financeCompany.text.isNotEmpty),
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  decoration: financeAmount.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (val){
                      setState(() {

                      });
                    },
                    enabled: financeScheme,
                    controller: financeAmount,
                    decoration:decorationInput("Finance Amount",financeAmount.text.isNotEmpty),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  decoration: bookingAmount.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (val){
                      setState(() {

                      });
                    },
                    controller: bookingAmount,
                    decoration:decorationInput("Booking Amount",bookingAmount.text.isNotEmpty),
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  decoration: paymentMode.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: Container(
                      child: TextField(
                        style: const TextStyle(fontSize: 14),
                        onChanged: (val){
                          setState(() {

                          });
                        },
                        controller: paymentMode,
                        decoration:decorationInput("Payment Mode",paymentMode.text.isNotEmpty),
                      )
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 50,),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0)),child: Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8),
              child: TextButton(
                onPressed: (){
                  if(tabIndex == 0){
                    tabs = true;
                    _tabController.animateTo((_tabController.index + 1) % 6);
                  }else if(tabIndex == 1){
                    if(tabs = true){
                      customerDetails = {
                        "general_id": widget.docketData["general_id"],
                        "make": displayDocketDetails["make"],
                        "model_name": displayDocketDetails["model_name"],
                        "type": displayDocketDetails["type"],
                        "transmission": displayDocketDetails["transmission"],
                        "color": displayDocketDetails["color"],
                        "labour_type": displayDocketDetails["labour_type"],
                        "model_code": displayDocketDetails["model_code"],
                        "ex_showroom_price": displayDocketDetails["ex_showroom_price"],
                        "vehicle_category_code": displayDocketDetails["vehicle_category_code"],
                        "vehicle_type_code": displayDocketDetails["vehicle_type_code"],
                        "onroad_price": displayDocketDetails["onroad_price"],
                        "varient_name": displayDocketDetails["varient_name"],
                        "status": "Booked",
                        "order_booking_date": displayDocketDetails["order_booking_date"],

                        "dock_customer_id": widget.docketData["dock_customer_id"],
                        "customer_name": name.text,
                        "wife_off": wo.text,
                        "mobile": mobile.text,
                        "pan_number": panNo.text,
                        "date_of_birth": dob.text,
                        "email_id": emailId.text,
                        "address_1": add1.text,
                        "address_2": add2.text,
                        "city": city.text,
                        "state": state.text,
                        "pincode": pin.text,
                        "exchange_car": isDisabled,
                        "existing_car_model": existingCar.text,
                        "evaluation_date": evaluationDate.text,
                        "finance_scheme": financeScheme,
                        "finance_company": financeCompany.text,
                        "finance_amount": financeAmount.text,
                        "booking_amount": bookingAmount.text,
                        "payment_mode": paymentMode.text,
                        'userid':userId,
                      };
                      // print('------- customer details ---------');
                      // print(customerDetails);
                      updateCustomerDetails(customerDetails);
                    }
                    _tabController.animateTo((_tabController.index + 1) % 6);
                  }
                }, child: const Text("Update",style: TextStyle(color: Colors.white)),),
            )),
          ),
        ],
      ),
    );
  }
  paymentDetails(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            children: [
              Center(
                child: AdaptiveScrollbar(
                  controller: _horizontalScrollController,
                  position: ScrollbarPosition.top,
                  sliderActiveColor: Colors.blue[800],
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: DataTable(
                          showCheckboxColumn: false,
                          headingRowHeight: 30,
                          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                return Colors.grey[100];
                              }),
                          columns: const[
                            DataColumn(
                              label: Text('SN'),
                            ),
                            DataColumn(
                              label: Text('offers'),
                            ),
                            DataColumn(
                              label: Text('OEM'),
                            ),
                            DataColumn(
                              label: Text('Self'),
                            ),
                            DataColumn(
                              label: Text('Amount'),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              6, (int index) => DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  index==5? Container():Text('${index+1}'),
                                ),
                                DataCell(
                                  index==5? const Text(""): Text(offers[index]),
                                ),
                                DataCell(
                                  index==5? const Text(""): Container(height: 30,width: 60,
                                    decoration: state.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                    child: TextField(expands: false,keyboardType: TextInputType.number,inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      style: const TextStyle(fontSize: 14),
                                      onChanged: (val){
                                        setState(() {
                                          //   print(double.parse(oemConsOffer.text)+ double.parse(selfConsOffer.text));
                                          consTotal =double.parse(oemConsOffer.text.isEmpty? "0":oemConsOffer.text)+ double.parse(selfConsOffer.text.isEmpty ? "0":selfConsOffer.text);
                                          corpTotal =double.parse(oemCorpOffer.text.isEmpty? "0":oemCorpOffer.text)+ double.parse(selfCorpOffer.text.isEmpty ? "0":selfCorpOffer.text);
                                          exchTotal =double.parse(oemExchOffer.text.isEmpty? "0":oemExchOffer.text)+ double.parse(selfExchOffer.text.isEmpty ? "0":selfExchOffer.text);
                                          additionalTotal =double.parse(oemAdditionalOffer.text.isEmpty? "0":oemAdditionalOffer.text)+ double.parse(selfAdditionalOffer.text.isEmpty ? "0":selfAdditionalOffer.text);
                                          accessTotal =double.parse(oemAccesOffer.text.isEmpty? "0":oemAccesOffer.text)+ double.parse(selfAccesOffer.text.isEmpty ? "0":selfAccesOffer.text);


                                          grandTotal = consTotal+corpTotal+exchTotal+additionalTotal+accessTotal;

                                        });
                                      },
                                      controller:index==0 ? oemConsOffer:index==1?oemCorpOffer:index==2?oemExchOffer:index==3?oemAdditionalOffer:oemAccesOffer,
                                      decoration:decorationInput3("",false),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  index==5? const Text("Total",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18),): Container(height: 30,width: 60,
                                    decoration: state.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                    child: TextField(expands: false,keyboardType: TextInputType.number,inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      style: const TextStyle(fontSize: 14),
                                      onChanged: (val){
                                        setState(() {
                                          consTotal =double.parse(oemConsOffer.text.isEmpty? "0":oemConsOffer.text)+ double.parse(selfConsOffer.text.isEmpty ? "0":selfConsOffer.text);
                                          corpTotal =double.parse(oemCorpOffer.text.isEmpty? "0":oemCorpOffer.text)+ double.parse(selfCorpOffer.text.isEmpty ? "0":selfCorpOffer.text);
                                          exchTotal =double.parse(oemExchOffer.text.isEmpty? "0":oemExchOffer.text)+ double.parse(selfExchOffer.text.isEmpty ? "0":selfExchOffer.text);
                                          additionalTotal =double.parse(oemAdditionalOffer.text.isEmpty? "0":oemAdditionalOffer.text)+ double.parse(selfAdditionalOffer.text.isEmpty ? "0":selfAdditionalOffer.text);
                                          accessTotal =double.parse(oemAccesOffer.text.isEmpty? "0":oemAccesOffer.text)+ double.parse(selfAccesOffer.text.isEmpty ? "0":selfAccesOffer.text);

                                          grandTotal = consTotal+corpTotal+exchTotal+additionalTotal+accessTotal;
                                        });
                                      },
                                      // controller: bookingAmount,
                                      controller:index==0 ? selfConsOffer:index==1?selfCorpOffer:index==2?selfExchOffer:index==3?selfAdditionalOffer:selfAccesOffer,
                                      decoration:decorationInput3("",false),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  index==5? Text("Rs ${grandTotal.toStringAsFixed(2)}"):Text('Rs ${index==0 ? consTotal.toStringAsFixed(2):index==1?corpTotal.toStringAsFixed(2):index==2?exchTotal.toStringAsFixed(2):index==3?additionalTotal.toStringAsFixed(2):accessTotal.toStringAsFixed(2)}'),
                                ),
                              ]
                          )
                          )
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Center(
                child: AdaptiveScrollbar(
                  controller: _horizontalScrollController3,
                  position: ScrollbarPosition.bottom,
                  sliderActiveColor: Colors.blue[800],
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController3,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingRowHeight: 30,
                        headingRowColor:
                        MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              return Colors.grey[100]; // Use the default value.
                            }),
                        columns: const [
                          DataColumn(
                            label: Text('SN'),
                          ),
                          DataColumn(
                            label: Text('Receipt Date'),
                          ),
                          DataColumn(
                            label: Text('Receipt No'),
                          ),
                          DataColumn(
                            label: Text('Payment Mode'),
                          ),
                          DataColumn(
                            label: Text('Amount'),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          paymentList.length+1,
                              (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                index==paymentList.length? Container():Text('${index+1}'),
                              ),
                              DataCell(
                                index==paymentList.length? const Text(""): Text(paymentList[index]['receipt_date']),
                              ),
                              DataCell(
                                index==paymentList.length? const Text(""):Text(paymentList[index]['payment_id']),
                              ),
                              DataCell(
                                index==paymentList.length? const Text(""): Text(paymentList[index]['payment_mode']),
                              ),
                              DataCell(
                                index==paymentList.length? buttonWidgetNewPaymentMode():Text("Rs ${paymentList[index]['payment_amount']}"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50,),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width/3.7,
            child: Column(
              children: [
                Container(
                  height: 28,
                  color: Colors.grey[100],
                  child: const Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text("Description"),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text("Actual"),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text("Discounted"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text("Ex-Showroom")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 30,
                                      child: TextField(
                                        controller: actualExShowroom,
                                        keyboardType: TextInputType.number,inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 30,
                                      child: TextField(controller: discountedExShowroom,
                                        keyboardType: TextInputType.number,inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();

                                          });
                                        },
                                        // controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Life Tax")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 30,
                                      child: TextField(controller: actualLifeTax,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        // controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 30,
                                      child: TextField(
                                        controller: discountedLifeTax,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Zero Dep Insurance")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(
                                        controller: actualZeroDep,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        // controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(
                                        controller: discountedZeroDep,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //  controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Insurance")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(
                                        controller: actualInsurance,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(
                                        controller: discountedInsurance,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Reg/TR/Np Registration")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(
                                        controller: actualRegTr,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(
                                        controller: discountedRegTr,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("3rd/4th Year Warranty")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(
                                        controller: actual3Rd4ThWarranty,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        // controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(controller: discounted3Rd4ThWarranty,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //  controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Accessories")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(controller: actualAccessories,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(controller: discountedAccessories,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();
                                          });
                                        },
                                        // controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Others")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(controller: actualOthers,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        // controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(controller: discountedOthers,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Refund")),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 30,
                                      child: TextField(controller: actualRefund,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            actualTotal.text = ( double.parse(actualExShowroom.text.isEmpty ? "0":actualExShowroom.text) +
                                                double.parse(actualLifeTax.text.isEmpty ? "0":actualLifeTax.text) +
                                                double.parse(actualZeroDep.text.isEmpty ? "0":actualZeroDep.text) +
                                                double.parse(actualInsurance.text.isEmpty ? "0":actualInsurance.text) +
                                                double.parse(actualRegTr.text.isEmpty ? "0":actualRegTr.text) +
                                                double.parse(actual3Rd4ThWarranty.text.isEmpty ? "0":actual3Rd4ThWarranty.text) +
                                                double.parse(actualAccessories.text.isEmpty ? "0":actualAccessories.text) +
                                                double.parse(actualOthers.text.isEmpty ? "0":actualOthers.text) +
                                                double.parse(actualRefund.text.isEmpty ? "0":actualRefund.text)
                                            ).toString();
                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 30,
                                      child: TextField(
                                        controller: discountedRefund,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {
                                            discountedTotal.text = ( double.parse(discountedExShowroom.text.isEmpty ? "0":discountedExShowroom.text) +
                                                double.parse(discountedLifeTax.text.isEmpty ? "0":discountedLifeTax.text) +
                                                double.parse(discountedZeroDep.text.isEmpty ? "0":discountedZeroDep.text) +
                                                double.parse(discountedInsurance.text.isEmpty ? "0":discountedInsurance.text) +
                                                double.parse(discountedRegTr.text.isEmpty ? "0":discountedRegTr.text) +
                                                double.parse(discounted3Rd4ThWarranty.text.isEmpty ? "0":discounted3Rd4ThWarranty.text) +
                                                double.parse(discountedAccessories.text.isEmpty ? "0":discountedAccessories.text) +
                                                double.parse(discountedOthers.text.isEmpty ? "0":discountedOthers.text) +
                                                double.parse(discountedRefund.text.isEmpty ? "0":discountedRefund.text)
                                            ).toString();
                                          });
                                        },
                                        // controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text("Total",style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold),)),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(controller: actualTotal,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {

                                          });
                                        },
                                        //controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(height: 30,
                                      child: TextField(controller: discountedTotal,
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (val){
                                          setState(() {

                                          });
                                        },
                                        //  controller: bookingAmount,
                                        decoration:decorationInput3("",false),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      //----------- save button -----------
                      if(isShowButton == true)
                        Align(alignment: Alignment.bottomRight,
                          child: Container(decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0)),child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8),
                            child: TextButton(
                              onPressed: (){
                                Map  requestBody={
                                  "dock_customer_id":widget.docketData["dock_customer_id"],
                                  "general_id":widget.docketData["general_id"],
                                  // "dock_pay_det_id": editDocketDetails["docket_id"],
                                  "oem_consumer_offer": oemConsOffer.text,
                                  "self_consumer_offer": selfConsOffer.text,
                                  "total_consumer_offer": consTotal,
                                  "oem_corporate_offer": oemCorpOffer.text,
                                  "self_corporate_offer": selfCorpOffer.text,
                                  "total_corporate_offer": corpTotal,
                                  "oem_exchange_bonus": oemExchOffer.text,
                                  "self_exchange_bonus": selfExchOffer.text,
                                  "total_exchange_bonus": exchTotal,
                                  "oem_additional_discount": oemAdditionalOffer.text,
                                  "self_additional_discount": selfAdditionalOffer.text,
                                  "total_additional_discount": additionalTotal,
                                  "oem_accessories_disc": oemAccesOffer.text,
                                  "self_accessories_disc": selfAccesOffer.text,
                                  "total_accessories_disc": accessTotal,
                                  "overall_amount": grandTotal,
                                  "ex_showroom_actual": actualExShowroom.text,
                                  "ex_showroom_discounted": discountedExShowroom.text,
                                  "life_tax_actual": actualLifeTax.text,
                                  "life_tax_discounted": discountedLifeTax.text,
                                  "zero_dep_insurance_actual": actualZeroDep.text,
                                  "zero_dep_insurance_discounted": discountedZeroDep.text,
                                  "insurance_actual": actualInsurance.text,
                                  "insurance_discounted": discountedInsurance.text,
                                  "reg_no_actual": actualRegTr.text,
                                  "reg_no_discounted": discountedRegTr.text,
                                  "warranty_year_actual": actual3Rd4ThWarranty.text,
                                  "warranty_year_discounted": discounted3Rd4ThWarranty.text,
                                  "accessories_actual": actualAccessories.text,
                                  "accessories_discounted": discountedAccessories.text,
                                  "others_actual": actualOthers.text,
                                  "others_discounted": discountedOthers.text,
                                  "refund_actual": actualRefund.text,
                                  "refund_discounted": discountedRefund.text,
                                  "total_actual_amount": actualTotal.text,
                                  "total_discounted_amount": discountedTotal.text,
                                };
                                addPaymentDetails(requestBody);
                              }, child: const Text("Save",style: TextStyle(color: Colors.white)),),
                          )),
                        ),
                      // ------- update button --------
                      if(isShowButton == false)
                        Align(alignment: Alignment.bottomRight,
                          child: Container(decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0)),child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8),
                            child: TextButton(
                              onPressed: (){
                                Map  requestBody={
                                  "dock_pay_det_id": paymentId,
                                  "general_id":widget.docketData["general_id"],
                                  "dock_customer_id":widget.docketData["dock_customer_id"],
                                  "oem_consumer_offer": oemConsOffer.text,
                                  "self_consumer_offer": selfConsOffer.text,
                                  "total_consumer_offer": consTotal,
                                  "oem_corporate_offer": oemCorpOffer.text,
                                  "self_corporate_offer": selfCorpOffer.text,
                                  "total_corporate_offer": corpTotal,
                                  "oem_exchange_bonus": oemExchOffer.text,
                                  "self_exchange_bonus": selfExchOffer.text,
                                  "total_exchange_bonus": exchTotal,
                                  "oem_additional_discount": oemAdditionalOffer.text,
                                  "self_additional_discount": selfAdditionalOffer.text,
                                  "total_additional_discount": additionalTotal,
                                  "oem_accessories_disc": oemAccesOffer.text,
                                  "self_accessories_disc": selfAccesOffer.text,
                                  "total_accessories_disc": accessTotal,
                                  "overall_amount": grandTotal,
                                  "ex_showroom_actual": actualExShowroom.text,
                                  "ex_showroom_discounted": discountedExShowroom.text,
                                  "life_tax_actual": actualLifeTax.text,
                                  "life_tax_discounted": discountedLifeTax.text,
                                  "zero_dep_insurance_actual": actualZeroDep.text,
                                  "zero_dep_insurance_discounted": discountedZeroDep.text,
                                  "insurance_actual": actualInsurance.text,
                                  "insurance_discounted": discountedInsurance.text,
                                  "reg_no_actual": actualRegTr.text,
                                  "reg_no_discounted": discountedRegTr.text,
                                  "warranty_year_actual": actual3Rd4ThWarranty.text,
                                  "warranty_year_discounted": discounted3Rd4ThWarranty.text,
                                  "accessories_actual": actualAccessories.text,
                                  "accessories_discounted": discountedAccessories.text,
                                  "others_actual": actualOthers.text,
                                  "others_discounted": discountedOthers.text,
                                  "refund_actual": actualRefund.text,
                                  "refund_discounted": discountedRefund.text,
                                  "total_actual_amount": actualTotal.text,
                                  "total_discounted_amount": discountedTotal.text,
                                };
                                // print('-------- payment update--------');
                                // print(requestBody);
                                updatePaymentDetails(requestBody);
                              }, child: const Text("Update",style: TextStyle(color: Colors.white)),),
                          )),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  buttonWidgetNewPaymentMode(){
    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: MaterialButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SizedBox(height: 350,width: 350,
                      child: Stack(
                        clipBehavior: Clip.none, children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child:  const CircleAvatar(
                              backgroundColor: Color(0xff3F43D2),
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  onTap:(){
                                    _selectDate(context);
                                  },
                                  controller: recDate,
                                  decoration: decorationInput3("Receipt Date",false),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                  FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: decorationInput3("Select",false),

                                        isEmpty: _currentSelectedValue == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _currentSelectedValue,
                                            isDense: true,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _currentSelectedValue = newValue.toString();
                                                state.didChange(newValue);
                                              });
                                            },
                                            items: _currencies.map(( value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: recNote,
                                  decoration: decorationInput3("Note",false),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly
                                  ],
                                  controller: recAmount,
                                  decoration: decorationInput3("Amount",false),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  child: const Text("Submit"),
                                  onPressed: () {
                                    Map requestBody ={
                                      "dock_customer_id":widget.docketData["dock_customer_id"],
                                      "general_id": widget.docketData["general_id"],
                                      "payment_amount": recAmount.text,
                                      "payment_mode": _currentSelectedValue,
                                      "receipt_date": recDate.text,
                                      "note": recNote.text,
                                    };
                                    // print('--------add payment pop up--------');
                                    // print(requestBody);
                                    addPaymentMode(requestBody).whenComplete(() {
                                      setState(() {

                                      });
                                    });
                                    recAmount.clear();
                                    recDate.clear();
                                    recNote.clear();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                      ),
                    ),
                  );
                });
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0)),
          padding: const EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              alignment: Alignment.center,
              child: const Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 4,right: 4),
                    child: Text(
                      "New",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
  accessoriesTab(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: DataTable(
                showCheckboxColumn: false,
                headingRowHeight: 30,
                headingRowColor:
                MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return Colors.grey[100]; // Use the default value.
                    }),
                columns: const [
                  DataColumn(
                    label: Text('Accessories'),
                  ),
                  DataColumn(
                    label: Text('Bill No'),
                  ),
                  DataColumn(
                    label: Text('Amount'),
                  ),
                  DataColumn(
                    label: Text('Approved By'),
                  ),
                  DataColumn(
                    label: Text('Signature'),
                  ),
                ],
                rows: List<DataRow>.generate(
                  accessoriesList.length+1,
                      (int index) => DataRow(
                    cells: <DataCell>[
                      DataCell(
                        index==accessoriesList.length? Container():Text(accessoriesList[index]['accessories']),
                      ),
                      DataCell(
                        index==accessoriesList.length? const Text(""): Text(accessoriesList[index]['accessories_id']),
                      ),
                      DataCell(
                        index==accessoriesList.length? const Text(""):Text(accessoriesList[index]['amount'].toString()),
                      ),
                      DataCell(
                        index==accessoriesList.length? const Text(""): Text(accessoriesList[index]['approved_by']),
                      ),
                      DataCell(
                        index==accessoriesList.length? accButtonWidget():Text("${accessoriesList[index]['signature']}"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ],
    );

  }
  accButtonWidget(){
    return
      Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: MaterialButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(height: 320,width: 350,
                        child: Stack(
                          clipBehavior: Clip.none, children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const CircleAvatar(
                                backgroundColor: Color(0xff3F43D2),
                                child: Icon(Icons.close),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: decorationInput3("Issued/NotIssued",false),

                                          isEmpty: issuedNotIssued == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: issuedNotIssued,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  issuedNotIssued = newValue.toString();
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: ["Issued","NotIssued"].map(( value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: accessoriesAmount,
                                    decoration: decorationInput3("Amount",false),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: decorationInput3("Approved By",false),

                                          isEmpty: approvedBy == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: approvedBy,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  approvedBy = newValue.toString();
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: ["Manager1","Manager2",].map(( value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                    FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: decorationInput3("Signature",false),

                                          isEmpty: accessoriesSign == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: accessoriesSign,
                                              isDense: true,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  accessoriesSign = newValue.toString();
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: ["Yes","No",].map(( value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(color: Colors.blueAccent,
                                    child: const Text("Submit",style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Map requestBody ={
                                        "dock_customer_id": widget.docketData["dock_customer_id"],
                                        "general_id": widget.docketData["general_id"],
                                        "accessories": issuedNotIssued,
                                        "amount": accessoriesAmount.text,
                                        "approved_by": approvedBy,
                                        "signature":accessoriesSign,
                                        "bill_no": "",
                                      };
                                      // print('------ accessory requestBody --------');
                                      // print(requestBody);
                                      accessoriesAmount.clear();
                                      addAccessories(requestBody).whenComplete(() {
                                        getAccessories();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                        ),
                      ),
                    );
                  });
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)),
            padding: const EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(

                alignment: Alignment.center,
                child: const Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 4,right: 4),
                      child: Text(
                        "New",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
  bookingDetailsTab(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              color: Colors.blueGrey[100],
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("VEHICLE DETAILS",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[900])),
                  ),
                ],
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //   decoration: bookingModel.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingModel,
                    decoration: decorationInput3("Model",bookingModel.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: bookingVarient.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingVariant,
                    decoration: decorationInput3("Variant",bookingVariant.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: bookingColor.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingColor,
                    decoration: decorationInput3("Color",bookingColor.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: bookingDate.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    onTap: ()async{
                      DateTime? pickedDate=await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1996),
                        lastDate: DateTime.now(),
                      );
                      if(pickedDate!= null){
                        String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
                        setState(() {
                          bookDetailsDate.text=formattedDate;
                        });
                      }    else{
                        print('Date of birth not selected');
                      }
                    },
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookDetailsDate,
                    decoration: decorationInput3("Date of Bookings",bookDetailsDate.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: bookingCustId.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingCustId,
                    decoration: decorationInput3("Customer ID",bookingCustId.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: bookingId.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingId,
                    decoration: decorationInput3("Booking ID",bookingId.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //  decoration: bookingClassisNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingChassisNo,
                    decoration: decorationInput3("Chassis No",bookingChassisNo.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //  decoration: bookingEngineNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingEngineNo,
                    decoration: decorationInput3("Engine No",bookingEngineNo.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //  decoration: bookingAllotmentNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingVehicleRegNo,
                    decoration: decorationInput3("Vehicle Reg No",bookingVehicleRegNo.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //  decoration: bookingAllotmentDate.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    onTap: ()async{
                      DateTime? pickedDate=await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1996),
                        lastDate: DateTime.now(),
                      );
                      if(pickedDate!= null){
                        String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
                        setState(() {
                          bookingAllotmentDate.text=formattedDate;
                        });
                      }    else{
                        print('Date of birth not selected');
                      }
                    },
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingAllotmentDate,
                    decoration: decorationInput3("Booking Allotment Date",bookingAllotmentDate.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //decoration: bookingAllottedBy.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingAllottedBy,
                    decoration: decorationInput3("Allotted By",bookingAllottedBy.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //  decoration: bookingCarStatus.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingCarStatus,
                    decoration: decorationInput3("Car Status",bookingCarStatus.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              color: Colors.blueGrey[100],
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("INVOICE DETAILS",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[900])),
                  ),
                ],
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //   decoration: bookingInvNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingInvNo,
                    decoration: decorationInput3("Inv. No ",bookingInvNo.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //  decoration: bookingInvDate.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    readOnly: true,showCursor: false,
                    onTap: (){
                      _selectInvoiceDate(context);
                    },
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingInvDate,
                    decoration: decorationInput3("Inv. Date",bookingInvDate.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //   decoration: bookingInsNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingInsNo,
                    decoration: decorationInput3("Ins. No",bookingInsNo.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //   decoration: bookingEWNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingEWNo,
                    decoration: decorationInput3("E/W No",bookingEWNo.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              color: Colors.blueGrey[100],
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Insurance/Extended Warranty",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[900])),
                  ),
                ],
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: bookingMaruthiInsurance.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingMaruthiInsurance,
                    decoration: decorationInput3("Maruthi Insurance",bookingMaruthiInsurance.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: bookingInsuranceRemarks.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingInsuranceRemarks,
                    decoration: decorationInput3("Insurance Remarks",bookingInsuranceRemarks.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //       decoration: bookingInsRemarksNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: bookingInsRemarksNo,
                    decoration: decorationInput3("Ins.Mgr Remarks for No",bookingInsRemarksNo.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(isBookButton == true)
                Center(
                  child: Container(width: 100,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Ink(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: TextButton(
                        onPressed: () {
                          Map  requestBody={
                            "model": bookingModel.text,
                            "date_of_booking": bookDetailsDate.text,
                            "chassis_no": bookingChassisNo.text,
                            "booking_allotment_date": bookingAllotmentDate.text,
                            "varient": bookingVariant.text,
                            "customer_id": bookingCustId.text,
                            "engine_no": bookingEngineNo.text,
                            "alloted_by": bookingAllottedBy.text,
                            "color": bookingColor.text,
                            "booking_id": bookingId.text,
                            "allotment_no": bookingVehicleRegNo.text,
                            "car_status": bookingCarStatus.text,
                            "invoice_no": bookingInvNo.text,
                            "invoice_date": bookingInvDate.text,
                            "ins_no": bookingInsNo.text,
                            "ew_no": bookingEWNo.text,
                            "maruthi_insurance": bookingMaruthiInsurance.text,
                            "insurance_remarks": bookingInsuranceRemarks.text,
                            "ins_mgr_remarks": bookingInsRemarksNo.text,
                            "general_id":widget.docketData["general_id"],
                            "dock_customer_id":widget.docketData["dock_customer_id"],
                          };
                          // print('--------- add book details --------');
                          // print(requestBody);
                          addBookDetails(requestBody);
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>const InvoiceScreen()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            "Save",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if(isBookButton == false)
                Center(
                  child: Container(width: 100,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Ink(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: TextButton(
                        onPressed: () {
                          Map  requestBody={
                            "booking_details_id": bookId,
                            "model": bookingModel.text,
                            "date_of_booking": bookDetailsDate.text,
                            "chassis_no": bookingChassisNo.text,
                            "booking_allotment_date": bookingAllotmentDate.text,
                            "varient": bookingVariant.text,
                            "customer_id": bookingCustId.text,
                            "engine_no": bookingEngineNo.text,
                            "alloted_by": bookingAllottedBy.text,
                            "color": bookingColor.text,
                            "booking_id": bookingId.text,
                            "allotment_no": bookingVehicleRegNo.text,
                            "car_status": bookingCarStatus.text,
                            "invoice_no": bookingInvNo.text,
                            "invoice_date": bookingInvDate.text,
                            "ins_no": bookingInsNo.text,
                            "ew_no": bookingEWNo.text,
                            "maruthi_insurance": bookingMaruthiInsurance.text,
                            "insurance_remarks": bookingInsuranceRemarks.text,
                            "ins_mgr_remarks": bookingInsRemarksNo.text,
                            "general_id":widget.docketData["general_id"],
                            "dock_customer_id":widget.docketData["dock_customer_id"],
                          };
                          // print('--------- update book details --------');
                          // print(requestBody);
                          bookingUpdate(requestBody);
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>const InvoiceScreen()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            "Update",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }
  exchangeDetailsTab(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //decoration: exModel.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exModel,
                    decoration: decorationInput3("Model",exModel.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: exManufactureYear.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly
                    ],
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exManufactureYear,
                    decoration: decorationInput3("Mfg Year",exManufactureYear.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: exLessPerClosAmt.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly
                    ],
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exLessPerClosAmt,
                    decoration: decorationInput3("Less Per Closing Amount",exLessPerClosAmt.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //decoration: exRegNo.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exRegNo,
                    decoration: decorationInput3("P.Reg.No",exRegNo.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //decoration: exRelationship.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exRelationship,
                    decoration: decorationInput3("Relationship",exRelationship.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //  decoration: exLessTrafficChallan.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exLessTrafficChallan,
                    decoration: decorationInput3("Less Traffic Challan",exLessTrafficChallan.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //  decoration: exRCCopy.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exRCCopy,
                    decoration: decorationInput3("Rc Copy",exRCCopy.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  // decoration: exVehicleCost.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly
                    ],
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exVehicleCost,
                    decoration: decorationInput3("Vehicle Cost",exVehicleCost.text.isNotEmpty),  ),
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child:  AnimatedContainer(height: 38,
                  duration: const Duration(seconds: 0),
                  margin: const EdgeInsets.all(16),
                  //decoration: exLessBalance.text.isNotEmpty ?const BoxDecoration():const BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                    controller: exLessBalance,
                    decoration: decorationInput3("Less Balance new car",exLessBalance.text.isNotEmpty),  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 2,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Terms And Conditions ",style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.grey)),
                            height: 150,
                            child: TextFormField(
                              style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                              controller: exTermsAndCond,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration:  const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding:EdgeInsets.only(left: 15, bottom: 10, top: 18, right: 15),
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 40,),
                Expanded(flex: 1,
                  child: Column(
                    children: [
                      if(isExchangeButton == true)
                        Align(alignment: Alignment.bottomRight,
                          child: Container(width: 80,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0)),child: Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8),
                                child: TextButton(onPressed: (){
                                  Map  requestBody={
                                    "dock_customer_id":widget.docketData["dock_customer_id"],
                                    "general_id":widget.docketData["general_id"],
                                    "model": exModel.text,
                                    "preg_no": exRegNo.text,
                                    "rc_copy": exRCCopy.text,
                                    "mfg_year": exManufactureYear.text,
                                    "relation_ship": exRelationship.text,
                                    "vehicle_cost": exVehicleCost.text,
                                    "less_per_closing_amount": exLessPerClosAmt.text,
                                    "less_trafic_challan": exLessTrafficChallan.text,
                                    "less_balance_new_car": exLessBalance.text,
                                    "terms_conditions": exTermsAndCond.text,
                                  };
                                  // print('------ add exchange request body ---------');
                                  // print(requestBody);
                                  addExchangeDetails(requestBody);
                                }, child: const Text("Save",style: TextStyle(color: Colors.white)),),
                              )),
                        ),
                      if(isExchangeButton == false)
                        Align(alignment: Alignment.bottomRight,
                          child: Container(width: 80,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0)),child: Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8),
                                child: TextButton(onPressed: (){
                                  Map  requestBody={
                                    "exchange_details_id": exchangeId,
                                    "general_id":widget.docketData["general_id"],
                                    "dock_customer_id":widget.docketData["dock_customer_id"],
                                    "model": exModel.text,
                                    "preg_no": exRegNo.text,
                                    "rc_copy": exRCCopy.text,
                                    "mfg_year": exManufactureYear.text,
                                    "relation_ship": exRelationship.text,
                                    "vehicle_cost": exVehicleCost.text,
                                    "less_per_closing_amount": exLessPerClosAmt.text,
                                    "less_trafic_challan": exLessTrafficChallan.text,
                                    "less_balance_new_car": exLessBalance.text,
                                    "terms_conditions": exTermsAndCond.text,
                                  };
                                  // print('--------- update exchange request body ---------');
                                  // print(requestBody);
                                  exchangeUpdate(requestBody);
                                }, child: const Text("Update",style: TextStyle(color: Colors.white)),),
                              )),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }
  Future<void> _selectBookingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null ) {
      setState(() {
        bookingDate.text = (picked.toLocal()).toString().split(' ')[0];
      });
    }
  }
  Future<void> _selectEleDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null ) {
      setState(() {
        evaluationDate.text = (picked.toLocal()).toString().split(' ')[0];
      });
    }
  }
  Future<void> _selectInvoiceDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null ) {
      setState(() {
        bookingInvDate.text = (picked.toLocal()).toString().split(' ')[0];
      });
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null ) {
      setState(() {
        recDate.text = (picked.toLocal()).toString().split(' ')[0];
      });
    }
  }

  Future<void> updateCustomerDetails(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/update_dock_customer_details"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        dev.log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Successful")));
      }
      else {
        dev.log("++++++ Status Code ++++++++");
        dev.log(response.statusCode.toString());
      }
    }
    catch (e) {
      dev.log(e.toString());
      dev.log(e.toString());
    }
  }

  Future addPaymentDetails(data) async{
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/dock_pay_details/add_dock_pay_details";
    postData(context: context, url: url,requestBody: data).then((value) {
      setState(() {
        // print(value);
        if(value != null){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Saved")));
        }
      });
    });
  }
  Future fetchPaymentDetails() async{
    dynamic temp;
    // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/dock_pay_details/get_all_by_customer_id/${widget.docketData['dock_customer_id']}");
    final response = await http.get(
      Uri.parse("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/dock_pay_details/get_all_by_customer_id/${widget.docketData['dock_customer_id']}"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if(response.statusCode == 200){
      setState(() {
        // print("---fetch pay id-------");
        // print("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/dock_pay_details/get_dock_pay_details_by_general_id/${widget.docketData['general_id']}");
        // print(response.body);
        // print('---response---');
        temp = jsonDecode(response.body);
        if(temp.isEmpty){
          setState(() {
            isShowButton = true;
          });
        }else{
          setState(() {
            isShowButton = false;
            // print('--------temp---------');
            // print(temp);
            paymentId = temp[0]['dock_pay_det_id'].toString();
            oemConsOffer.text = temp[0]["oem_consumer_offer"].toString();
            selfConsOffer.text = temp[0]['self_consumer_offer'].toString();
            consTotal = double.parse(temp[0]['total_consumer_offer'].toString());
            oemCorpOffer.text = temp[0]['oem_corporate_offer'].toString();
            selfCorpOffer.text = temp[0]['self_corporate_offer'].toString();
            corpTotal = double.parse(temp[0]['total_corporate_offer'].toString());
            oemExchOffer.text = temp[0]['oem_exchange_bonus'].toString();
            selfExchOffer.text = temp[0]['self_exchange_bonus'].toString();
            exchTotal = double.parse(temp[0]['total_exchange_bonus'].toString());
            oemAdditionalOffer.text = temp[0]['oem_additional_discount'].toString();
            selfAdditionalOffer.text = temp[0]['self_additional_discount'].toString();
            additionalTotal = double.parse(temp[0]['total_additional_discount'].toString());
            oemAccesOffer.text = temp[0]['oem_accessories_disc'].toString();
            selfAccesOffer.text = temp[0]['self_accessories_disc'].toString();
            accessTotal = double.parse(temp[0]['total_accessories_disc'].toString());
            grandTotal = double.parse(temp[0]['overall_amount'].toString());
            actualExShowroom.text = temp[0]['ex_showroom_actual'].toString();
            discountedExShowroom.text = temp[0]['ex_showroom_discounted'].toString();
            actualLifeTax.text = temp[0]['life_tax_actual'].toString();
            discountedLifeTax.text = temp[0]['life_tax_discounted'].toString();
            actualZeroDep.text = temp[0]['zero_dep_insurance_actual'].toString();
            discountedZeroDep.text = temp[0]['zero_dep_insurance_discounted'].toString();
            actualInsurance.text = temp[0]['insurance_actual'].toString();
            discountedInsurance.text = temp[0]['insurance_discounted'].toString();
            actualRegTr.text = temp[0]['reg_no_actual'].toString();
            discountedRegTr.text = temp[0]['reg_no_discounted'].toString();
            actual3Rd4ThWarranty.text = temp[0]['warranty_year_actual'].toString();
            discounted3Rd4ThWarranty.text = temp[0]['warranty_year_discounted'].toString();
            actualAccessories.text = temp[0]['accessories_actual'].toString();
            discountedAccessories.text = temp[0]['accessories_discounted'].toString();
            actualOthers.text = temp[0]['others_actual'].toString();
            discountedOthers.text = temp[0]['others_discounted'].toString();
            actualRefund.text = temp[0]['refund_actual'].toString();
            discountedRefund.text = temp[0]['refund_discounted'].toString();
            actualTotal.text = temp[0]['total_actual_amount'].toString();
            discountedTotal.text = temp[0]['total_discounted_amount'].toString();
          });
        }
      });
    }else{
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }
  Future<void> updatePaymentDetails(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/dock_pay_details/update_dock_pay_details"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        dev.log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Successful")));
      }
      else {
        dev.log("++++++ Status Code ++++++++");
        dev.log(response.statusCode.toString());
      }
    }
    catch (e) {
      dev.log(e.toString());
      dev.log(e.toString());
    }
  }

  Future addBookDetails(data) async{
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docketbookingdetails/add_booking_details";
    postData(context: context,url: url,requestBody: data).then((value) {
      setState(() {
        if(value != null){
          // print("------ add book value --------");
          // print(value);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Saved")));
        }
      });
    });
  }
  Future fetchBookDetails() async{
    dynamic temp;
    final response = await http.get(
      Uri.parse("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docketbookingdetails/get_all_booking_by_customer_id/${widget.docketData['dock_customer_id']}"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if(response.statusCode == 200){
      setState(() {
        // print('------ book response --------');
        // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docketbookingdetails/get_booking_details_by_general_id/${widget.docketData['general_id']}");
        // print(response.body);
        temp = jsonDecode(response.body);
        if(temp.isEmpty){
          setState(() {
            isBookButton = true;
          });
        }else{
          setState(() {
            isBookButton = false;
            // print('--------temp---------');
            // print(temp);
            bookId = temp[0]["booking_details_id"];
            bookingModel.text = temp[0]["model"];
            bookDetailsDate.text = temp[0]["date_of_booking"];
            bookingChassisNo.text = temp[0]["chassis_no"];
            bookingAllotmentDate.text = temp[0]["booking_allotment_date"];
            bookingVariant.text = temp[0]["varient"];
            bookingCustId.text = temp[0]["customer_id"];
            bookingEngineNo.text = temp[0]["engine_no"];
            bookingAllottedBy.text = temp[0]["alloted_by"];
            bookingColor.text = temp[0]["color"];
            bookingId.text = temp[0]["booking_id"];
            bookingCarStatus.text = temp[0]["car_status"];
            bookingInvNo.text = temp[0]["invoice_no"];
            bookingInvDate.text = temp[0]["invoice_date"];
            bookingInsNo.text = temp[0]["ins_no"];
            bookingEWNo.text = temp[0]["ew_no"];
            bookingMaruthiInsurance.text = temp[0]["maruthi_insurance"];
            bookingInsuranceRemarks.text = temp[0]["insurance_remarks"];
            bookingInsRemarksNo.text = temp[0]["ins_mgr_remarks"];
            bookingVehicleRegNo.text = temp[0]["allotment_no"];
          });
        }
      });
    }else{
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }
  Future<void> bookingUpdate(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docketbookingdetails/update_booking_details"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        dev.log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Successful")));
      }
      else {
        dev.log("++++++ Status Code ++++++++");
        dev.log(response.statusCode.toString());
      }
    }
    catch (e) {
      dev.log(e.toString());
      dev.log(e.toString());
    }
  }

  Future addExchangeDetails(data) async{
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_exchange/add_exchange_details";
    postData(requestBody: data,url: url,context: context).then((value) {
      setState(() {
        if(value != null){
          // print('------- exchange response ---------');
          // print(value);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Saved")));
          statusUpdate(value);
        }
      });
    });
  }
  Future fetchExchangeDetails() async{
    dynamic temp;
    // print("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_exchange/get_exchange_details_by_general_id/${widget.docketData['dock_customer_id']}");
    final response = await http.get(
      Uri.parse("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_exchange/get_all_exchange_details_by_customer_id/${widget.docketData['dock_customer_id']}"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if(response.statusCode == 200){
      setState(() {
        temp = jsonDecode(response.body);
        // print(temp);
        if(temp.isEmpty){
          setState(() {
            isExchangeButton = true;
          });
        }else{
          isExchangeButton = false;
          // print('--------temp---------');
          // print(temp);
          exchangeId = temp[0]["exchange_details_id"];
          exModel.text = temp[0]["model"];
          exRegNo.text = temp[0]["preg_no"];
          exRCCopy.text = temp[0]["rc_copy"];
          exManufactureYear.text = temp[0]["mfg_year"].toString();
          exRelationship.text = temp[0]["relation_ship"];
          exVehicleCost.text = temp[0]["vehicle_cost"].toString();
          exLessPerClosAmt.text = temp[0]["less_per_closing_amount"].toString();
          exLessTrafficChallan.text = temp[0]["less_trafic_challan"];
          exLessBalance.text = temp[0]["less_balance_new_car"];
          exTermsAndCond.text = temp[0]["terms_conditions"];
        }
      });
    }else{
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }
  Future<void> exchangeUpdate(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_exchange/update_exchange_details"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        dev.log(response.body);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Successful")));
        statusUpdate(requestBody);
        // Navigator.of(context).pop();
      }
      else {
        dev.log("++++++ Status Code ++++++++");
        dev.log(response.statusCode.toString());
      }
    }
    catch (e) {
      dev.log(e.toString());
      dev.log(e.toString());
    }
  }

  Future<void> statusUpdate(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/update_purchase_order/${widget.docketData['dock_customer_id']}/Invoiced"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        dev.log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Successful")));
        Navigator.of(context).pop();
      }
      else {
        dev.log("++++++ Status Code ++++++++");
        dev.log(response.statusCode.toString());
      }
    }
    catch (e) {
      dev.log(e.toString());
      dev.log(e.toString());
    }
  }

  addAccessories(requestBody) async {
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docketaccessories/add_accessories";
    postData(requestBody: requestBody,url: url,context: context).then((value) => {
      setState((){
        if(value != null){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Saved")));
          getAccessories();
        }
      })
    });
  }
  Future getAccessories() async {
    final response = await http
        .get(Uri.parse('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docketaccessories/get_all_accessories_by_customer_id/${widget.docketData['dock_customer_id']}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        // print('----- accessory body----');
        // print('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docketaccessories/get_accessories_by_general_id/${widget.docketData['general_id']}');
        // print(response.body);
        accessoriesList=jsonDecode(response.body);
        // print('--------accessory list--------');
        // print(accessoriesList);
      });
    } else {
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }

  addPaymentMode(requestBody) async {
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/payment/add_payment";
    postData(context: context, url: url,requestBody: requestBody).then((value) {
      setState(() {
        if(value != null){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Saved")));
          getPayment();
        }
      });
    });
  }
  Future getPayment() async {
    final response = await http
        .get(Uri.parse('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/payment/get_all_payment_by_customer_id/${widget.docketData['dock_customer_id']}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        paymentList=jsonDecode(response.body);
      });
    } else {
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }
}
