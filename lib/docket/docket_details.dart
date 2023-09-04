import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:new_project/docket/summary_receipt.dart';
import 'package:new_project/utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/api/post_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_loader.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/custom_dividers/custom_vertical_divider.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';

class DocketDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map docketData;

  const DocketDetails(
      {Key? key, required this.docketData, required this.selectedDestination, required this.drawerWidth})
      : super(key: key);

  @override
  State<DocketDetails> createState() => _DocketDetailsState();
}

class _DocketDetailsState extends State<DocketDetails>
    with SingleTickerProviderStateMixin {

  PageController page = PageController();
  bool loading = false;
  int v = 1;
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
  int tabIndex = 0;
  String userId = "";

  // Map editDocketDetails = {};
  Map displayDocketDetails = {};

  String modelName = '';
  String type = '';
  String labourType = '';
  String categoryCode = '';
  String modelCode = '';
  String vehicleTypeCode = '';
  String color = '';
  String exShowRoomPrice = '';
  String transmission = '';
  String make = '';
  String variantName = '';

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        tabIndex = _tabController.index;
      });
    }
  }

  String paymentId = "";
  String generalId = "";
  String docketId = "";
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
          fetchPaymentDetails().whenComplete(() =>
              setState(() {
                fetchBookDetails().whenComplete(() =>
                    setState(() {
                      fetchExchangeDetails().whenComplete(() =>
                          setState(() {
                            loading = false;
                          }));
                    }));
              }));
        });
      });
    });
    super.initState();
    _tabController = TabController(vsync: this, length: 6);
    _tabController.addListener(_handleTabSelection);
    // exTermsAndCond.text ="1.Exchange car price was not matched so we have offered Rs 3000.00 discount\n\n2.We have recived the vehicle physically ";
    // editDocketDetails= widget.docketData;
    displayDocketDetails = widget.docketData;
    generalId = displayDocketDetails["general_id"] ?? "";
    docketId = displayDocketDetails["docket_id"] ?? "";
    docketCustomerId = widget.docketData["dock_customer_id"] ?? "";

    modelName = displayDocketDetails['model_name'] ?? '';
    type = displayDocketDetails['type'] ?? "";
    labourType = displayDocketDetails['labour_type'] ?? "";
    categoryCode = displayDocketDetails['vehicle_category_code'] ?? "";
    vehicleTypeCode = displayDocketDetails['vehicle_type_code'] ?? "";
    color = displayDocketDetails['color'] ?? "";
    exShowRoomPrice = displayDocketDetails['ex_showroom_price'].toString();
    transmission = displayDocketDetails['transmission'] ?? '';
    modelCode = displayDocketDetails['model_code'] ?? "";
    make = displayDocketDetails['make'] ?? "";
    variantName = displayDocketDetails['varient_name'] ?? "";
    name.text = displayDocketDetails['customer_name'] ?? "";
    mobile.text = displayDocketDetails['mobile'] ?? "";
    emailId.text = displayDocketDetails['email_id'] ?? "";
    panNo.text = displayDocketDetails['pan_number'] ?? "";
    add1.text = displayDocketDetails['street_address'] ?? "";
    city.text = displayDocketDetails['location'] ?? "";
    state.text = displayDocketDetails['city'] ?? "";
    pin.text = displayDocketDetails['pin_code'] ?? "";
    existingCar.text = displayDocketDetails['car_model'] ?? "";
    financeCompany.text = displayDocketDetails['finance_company'] ?? "";
    evaluationDate.text = displayDocketDetails['evaluation_date'] ?? "";
    financeAmount.text = displayDocketDetails['finance_amount'] ?? "";
    displayDocketDetails['exchange'] == "Yes" ? isDisabled = true : false;
    displayDocketDetails['car_finance'] == "Yes" ? financeScheme = true : false;

    bookingModel.text = displayDocketDetails['model'] ?? "";
    bookingVariant.text = displayDocketDetails['variant'] ?? "";
    bookingColor.text = displayDocketDetails['color'] ?? "";
    bookingCustId.text = displayDocketDetails['customer_id'] ?? "";
    // var code = rng.nextInt(900000) + 100000;
    // bookingInvNo.text= "VM${code.toString()}";
    if (bookingDate.text.isEmpty) {
      bookingDate.text = formatDate(DateTime.now());
    }

    variantController.text=displayDocketDetails['varient_name']??"";
    typeController.text=displayDocketDetails['type']??"";
    transmissionController.text=displayDocketDetails['transmission']??'';
    colorController.text=displayDocketDetails['color']??"";
    labourTypeCon.text=displayDocketDetails['labour_type']??"";
    modelController.text=displayDocketDetails['model_code']??"";
    exShowroomPriceCon.text=displayDocketDetails['ex_showroom_price'].toString();
    categoryCodeController.text=displayDocketDetails['vehicle_category_code']??"";
    vehicleTypeCodeCon.text=displayDocketDetails['vehicle_type_code']??"";
  }

  String? authToken;

  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
    userId = prefs.getString("userId") ?? "";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // var rng =  Random();
  int index = 0;

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
  List offers = [
    "Consumer Offer",
    "Corporate Offer",
    "Exchange Bonus",
    "Additional Discount",
    "Accessories Disc"
  ];
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

  double consTotal = 0;
  double corpTotal = 0;
  double exchTotal = 0;
  double additionalTotal = 0;
  double accessTotal = 0;

  double grandTotal = 0;
  List paymentList = [];
  String docketCustomerId = "";
  String autoPayId = "";
  String autoAccessoryId = "";
  String autoExchangeId = "";

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
  final bookingInsRemarksNo = TextEditingController();

  final accessoriesAmount = TextEditingController();
  final recDate = TextEditingController();
  final recAmount = TextEditingController();
  final recNote = TextEditingController();
  final selectValueController = TextEditingController();
  final selectTypeController = TextEditingController();
  final selectIssueController = TextEditingController();
  final selectApproveController = TextEditingController();
  final selectSignatureController = TextEditingController();

  final vehicleDataCard=GlobalKey<FormState>();
  final variantController=TextEditingController();
  final typeController=TextEditingController();
  final colorController=TextEditingController();
  final labourTypeCon=TextEditingController();
  final exShowroomPriceCon=TextEditingController();
  final categoryCodeController=TextEditingController();
  final transmissionController=TextEditingController();
  final modelController=TextEditingController();
  final vehicleTypeCodeCon=TextEditingController();
  bool variantError=false;
  bool typeError=false;
  bool colorError=false;
  bool labourError=false;
  bool exShowroomError=false;
  bool categoryError=false;
  bool transmissionError=false;
  bool modelError=false;
  bool vehicleCodeError=false;

  List accessoriesList = [];
  List<String> currencies = [
    "Digital",
    "Cheque",
    "Cash"
  ];
  List<String> issue = ["Issued", "NotIssued"];
  List<String> approve = ["Manager1", "Manager2"];
  List<String> signature = ["Yes", "No"];

  String issuedNotIssued = 'Issued';
  String approvedBy = "Manager1";
  String accessoriesSign = "Yes";
  String currentSelectedValue = 'Digital';

  late double sWidth;
  late double sHeight;

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery
        .of(context)
        .size
        .width;
    sHeight = MediaQuery
        .of(context)
        .size
        .height;
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
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: AppBar(
                    title: const Text("Docket Details"),
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10, top: 8),
                        child: SizedBox(
                          height: 30,
                          width: 120,
                          child: OutlinedMButton(
                            text: "Summary",
                            borderColor: mSaveButton,
                            textColor: mSaveButton,
                            onTap: () {
                              Map summaryBody = {
                                "make": widget
                                    .docketData['make'],
                                "model": widget
                                    .docketData['model'],
                                "variant": widget
                                    .docketData['variant'],
                                "color": widget
                                    .docketData['color'],
                                "exchange": widget
                                    .docketData['exchange'],
                                "car_model": widget
                                    .docketData['car_model'],
                                "evaluation_date": widget
                                    .docketData['evaluation_date'],
                                "car_finance": widget
                                    .docketData['car_finance'],
                                "finance_company": widget
                                    .docketData['finance_company'],
                                "finance_amount": widget
                                    .docketData['finance_amount'],
                                "customer_name": widget
                                    .docketData['customer_name'],
                                "mobile": widget
                                    .docketData['mobile'],
                                "email_id": widget
                                    .docketData['email_id'],
                                "type": widget
                                    .docketData['type'],
                                "pan_number": widget
                                    .docketData['pan_number'],
                                "street_address": widget
                                    .docketData['street_address'],
                                "pin_code": widget
                                    .docketData['pin_code'],
                                "city": widget
                                    .docketData['city'],
                                "location": widget
                                    .docketData['location'],
                                "labour_type": widget
                                    .docketData['labour_type'],
                                "model_code": widget
                                    .docketData['model_code'],
                                "vehicle_category_code": widget
                                    .docketData['vehicle_category_code'],
                                "ex_showroom_price": widget
                                    .docketData['ex_showroom_price'],
                                "onroad_price": widget
                                    .docketData['onroad_price'],
                                "transmission": widget
                                    .docketData['transmission'],
                              };
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SummaryReceipt(
                                          summaryDetails: summaryBody,
                                          drawerWidth: widget
                                              .drawerWidth,
                                          selectedDestination: widget
                                              .selectedDestination,
                                          date: bookingDate
                                              .text,
                                        ),
                                  )
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              body: CustomLoader(
                inAsyncCall: loading,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: [
                            // Flexible(
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       borderRadius: const BorderRadius.all(
                            //         Radius.circular(10),
                            //       ),
                            //       border: Border.all(
                            //           color: Colors.blueAccent),
                            //     ),
                            //     // width: 80,
                            //     child: InkWell(
                            //       onTap: () {
                            //         Navigator.of(context).pop();
                            //       },
                            //       child: const Padding(
                            //         padding: EdgeInsets.all(4.0),
                            //         child: SizedBox(
                            //           width: 80,
                            //           child: Row(
                            //             children: [
                            //               Icon(Icons.arrow_back_sharp,
                            //                   color: Colors.blue,
                            //                   size: 20),
                            //               Expanded(child: Text("Go Back",
                            //                 style: TextStyle(
                            //                     color: Colors.blue,
                            //                     fontWeight: FontWeight
                            //                         .bold,
                            //                     fontSize: 12),
                            //                 maxLines: 1,
                            //                 overflow: TextOverflow
                            //                     .ellipsis,)),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  // Expanded(
                                  //     flex: 2,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.only(
                                  //           right: 10),
                                  //       child: SizedBox(
                                  //         width: 100,
                                  //         height: 30,
                                  //         child: OutlinedMButton(
                                  //           text: "Summary",
                                  //           borderColor: mSaveButton,
                                  //           textColor: mSaveButton,
                                  //           onTap: () {
                                  //             Map summaryBody = {
                                  //               "make": widget
                                  //                   .docketData['make'],
                                  //               "model": widget
                                  //                   .docketData['model'],
                                  //               "variant": widget
                                  //                   .docketData['variant'],
                                  //               "color": widget
                                  //                   .docketData['color'],
                                  //               "exchange": widget
                                  //                   .docketData['exchange'],
                                  //               "car_model": widget
                                  //                   .docketData['car_model'],
                                  //               "evaluation_date": widget
                                  //                   .docketData['evaluation_date'],
                                  //               "car_finance": widget
                                  //                   .docketData['car_finance'],
                                  //               "finance_company": widget
                                  //                   .docketData['finance_company'],
                                  //               "finance_amount": widget
                                  //                   .docketData['finance_amount'],
                                  //               "customer_name": widget
                                  //                   .docketData['customer_name'],
                                  //               "mobile": widget
                                  //                   .docketData['mobile'],
                                  //               "email_id": widget
                                  //                   .docketData['email_id'],
                                  //               "type": widget
                                  //                   .docketData['type'],
                                  //               "pan_number": widget
                                  //                   .docketData['pan_number'],
                                  //               "street_address": widget
                                  //                   .docketData['street_address'],
                                  //               "pin_code": widget
                                  //                   .docketData['pin_code'],
                                  //               "city": widget
                                  //                   .docketData['city'],
                                  //               "location": widget
                                  //                   .docketData['location'],
                                  //               "labour_type": widget
                                  //                   .docketData['labour_type'],
                                  //               "model_code": widget
                                  //                   .docketData['model_code'],
                                  //               "vehicle_category_code": widget
                                  //                   .docketData['vehicle_category_code'],
                                  //               "ex_showroom_price": widget
                                  //                   .docketData['ex_showroom_price'],
                                  //               "onroad_price": widget
                                  //                   .docketData['onroad_price'],
                                  //               "transmission": widget
                                  //                   .docketData['transmission'],
                                  //             };
                                  //             Navigator.push(
                                  //                 context,
                                  //                 MaterialPageRoute(
                                  //                   builder: (context) =>
                                  //                       SummaryReceipt(
                                  //                         summaryDetails: summaryBody,
                                  //                         drawerWidth: widget
                                  //                             .drawerWidth,
                                  //                         selectedDestination: widget
                                  //                             .selectedDestination,
                                  //                         date: bookingDate
                                  //                             .text,
                                  //                       ),
                                  //                 )
                                  //             );
                                  //           },
                                  //         ),
                                  //       ),
                                  //     )
                                  // ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                  const Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 30,
                                      // width: 200,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Order Booking Date",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.indigo,
                                                fontWeight: FontWeight
                                                    .bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          ),
                                          Text(
                                            ": ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.indigo,
                                                fontWeight: FontWeight
                                                    .bold
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow
                                                .ellipsis,
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
                                        onChanged: (text) {
                                          setState(() {

                                          });
                                        },
                                        controller: bookingDate,
                                        decoration: textFieldDecoration("Date",
                                            bookingDate.text.isNotEmpty),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),
                                  color: Colors.white,borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:45,
                                        bottom: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "$make  $modelName",
                                            style: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold,
                                              color: Colors.indigo[800],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        MaterialButton(
                                          color:Colors.blue,
                                          onPressed: () {
                                            editDocketCard(context);
                                          },
                                          child:const Text("Edit",style:TextStyle(color:Colors.white)),),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 50.0),
                                        child: Column(children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(width:100,
                                                child: Text(
                                                    "Variant",
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  ": $variantName",
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(width:100,
                                                child: Text(
                                                    "Color",
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  ": $color",
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(width:100,
                                                child: Text(
                                                    "Type",
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  ": $type",
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(width:150,
                                              child: Text(
                                                  "Transmission",
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                ": $transmission",
                                                maxLines: 2,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(width:150,
                                              child: Text(
                                                  "Category Code",
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis),
                                            ),
                                            Expanded(
                                              child: Text(
                                                ": $categoryCode",
                                                maxLines: 2,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const  SizedBox(width:150,
                                              child: Text(
                                                  "Vehicle Type Code",
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis),
                                            ),
                                            Expanded(
                                              child: Text(
                                                ": $vehicleTypeCode",
                                                maxLines: 2,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],),
                                    )
                                  ],)
                                ],),
                              ),
                            ),
                          ),
                          const SizedBox(width:10),
                          Expanded(
                            child: Container(  decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),
                                color: Colors.white,borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "On Road Price",
                                          maxLines: 1,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight
                                                .bold,
                                            color: Colors
                                                .indigo[800],
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ": Rs ${displayDocketDetails['onroad_price']}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo[800],
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width:150,
                                            child: Text(
                                                "Ex-Showroom Price",
                                                maxLines: 1,
                                                overflow: TextOverflow
                                                    .ellipsis),
                                          ),
                                          Expanded(
                                            child: Text(
                                              ": $exShowRoomPrice",
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width:150,
                                            child: Text(
                                                "Model Code",
                                                maxLines: 1,
                                                overflow: TextOverflow
                                                    .ellipsis),
                                          ),
                                          Expanded(
                                            child: Text(
                                              ": $modelCode",
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width:150,
                                            child: Text(
                                                "Labour Type",
                                                maxLines: 1,
                                                overflow: TextOverflow
                                                    .ellipsis),
                                          ),
                                          Expanded(
                                            child: Text(
                                              ": $labourType",
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],)
                                ]),
                              ),
                            ),
                          ),
                        ],),
                        const SizedBox(height: 30),
                        // ------- tab bar --------
                        Align(
                          alignment: Alignment.topLeft,
                          child: TabBar(
                            labelColor: Colors.indigo[800],
                            labelStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
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
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // final _horizontalScrollController = ScrollController();
  // final _horizontalScrollController3 = ScrollController();
  List fetchPayList = [];
  Map customerDetails = {};

  customerTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Customer Name"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: name,
                      decoration: textFieldDecoration(
                          "Customer Name", name.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              // Expanded(
              //   child:  Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text("W/o"),
              //       const SizedBox(height: 6,),
              //       TextFormField(
              //         style: const TextStyle(fontSize: 14),
              //         onChanged: (text){
              //           setState(() {
              //
              //           });
              //         },
              //         controller: wo,
              //         decoration: textFieldDecoration("W/o", wo.text.isNotEmpty),
              //       )
              //     ],
              //   ),
              // ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email ID"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: emailId,
                      decoration: textFieldDecoration(
                          "Email ID", emailId.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Mobile"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                      ],
                      maxLength: 10,
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: mobile,
                      decoration: textFieldDecoration(
                          "Mobile", mobile.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("PAN Number"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: panNo,
                      decoration: textFieldDecoration(
                          "PAN Number", panNo.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              // Expanded(
              //   child:  Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text("Date of Birth"),
              //       const SizedBox(height: 6,),
              //       TextFormField(
              //         onTap: ()async{
              //           DateTime? pickedDate=await showDatePicker(
              //             context: context,
              //             initialDate: DateTime.now(),
              //             firstDate: DateTime(1999),
              //             lastDate: DateTime.now(),
              //           );
              //           if(pickedDate!= null){
              //             String formattedDate=DateFormat('dd-MM-yyyy').format(pickedDate);
              //             setState(() {
              //               dob.text=formattedDate;
              //             });
              //           }    else{
              //             print('Date of birth not selected');
              //           }
              //         },
              //         style: const TextStyle(fontSize: 14),
              //         onChanged: (text){
              //           setState(() {
              //
              //           });
              //         },
              //         controller: dob,
              //         decoration: textFieldDecoration("Date of Birth",dob.text.isNotEmpty),  ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Address  1"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: add1,
                      decoration: textFieldDecoration(
                          "Address  1", add1.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("City"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: city,
                      decoration: textFieldDecoration(
                          "City", city.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("State"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: state,
                      decoration: textFieldDecoration(
                          "State", state.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pin Code"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 6,
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: pin,
                      decoration: textFieldDecoration(
                          "Pin Code", pin.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(child: Container()),
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
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 120,
              height: 28,
              child: OutlinedMButton(
                text: 'Update',
                textColor: mSaveButton,
                borderColor: mSaveButton,
                onTap: () {
                  if (tabIndex == 0) {
                    if (tabs = true) {
                      Map requestBody = {
                        "city": city.text,
                        "customer_id": widget.docketData["customer_id"],
                        "customer_name": name.text,
                        "email_id": emailId.text,
                        "gstin": "",
                        "location": state.text,
                        "mobile": mobile.text,
                        "pan_number": panNo.text,
                        "pin_code": pin.text,
                        "street_address": add1.text,
                        "type": ""
                      };
                      updateCustomerDetails(requestBody);
                    }
                    _tabController.animateTo((_tabController.index + 1) % 6);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  orderDetails() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Exchange Car"),
                    const SizedBox(height: 6,),
                    Container(
                      decoration: isDisabled ? BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(color: Colors.white, blurRadius: 2)
                          ]) : BoxDecoration(color: Colors.grey[200]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: AnimatedContainer(height: 36,
                            duration: const Duration(seconds: 0),
                            // decoration: isDisabled ? BoxDecoration(border: Border.all(color: Colors.blue),boxShadow: [BoxShadow(color:Colors.white,blurRadius: 2)]):BoxDecoration(),
                            // child: SwitchListTile(
                            //   activeColor: Colors.green,
                            //   value: isDisabled,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       isDisabled = value;
                            //       if (value == true) {
                            //         existingCar.text =
                            //             displayDocketDetails['car_model'] ??
                            //                 "";
                            //         evaluationDate.text =
                            //             displayDocketDetails['evaluation_date'] ??
                            //                 "";
                            //       }
                            //       else if (value == false) {
                            //         existingCar.clear();
                            //         evaluationDate.clear();
                            //       }
                            //     });
                            //   },
                            //   title: const Text('Exchange Car',
                            //     style: TextStyle(fontSize: 18),),
                            // )
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Exchange Car"),
                              buildCustomToggleSwitch(
                                  value: isDisabled,
                                  onChanged: (value) {
                                    setState(() {
                                      isDisabled = value;
                                      if (value == true) {
                                        existingCar.text =
                                            displayDocketDetails['car_model'] ??
                                                "";
                                        evaluationDate.text =
                                            displayDocketDetails['evaluation_date'] ??
                                                "";
                                      }
                                      else if (value == false) {
                                        existingCar.clear();
                                        evaluationDate.clear();
                                      }
                                    });
                                  },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Existing Car Model"),
                    const SizedBox(height: 6,),
                    TextField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      enabled: isDisabled,
                      controller: existingCar,
                      decoration: textFieldToggleDecoration(
                          "Existing Car Model", existingCar.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Evaluation Date"),
                    const SizedBox(height: 6,),
                    TextField(
                      onTap: () {
                        _selectEleDate(context);
                      },
                      style: const TextStyle(fontSize: 14),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      enabled: isDisabled,
                      controller: evaluationDate,
                      decoration: textFieldToggleDecoration(
                          "Evaluation Date", evaluationDate.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Finance Scheme"),
                    const SizedBox(height: 6,),
                    Container(
                      decoration: financeScheme ? BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blue),
                          boxShadow: const [
                            BoxShadow(color: Colors.white, blurRadius: 2)
                          ]) : BoxDecoration(color: Colors.grey[200]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: AnimatedContainer(height: 36,
                            duration: const Duration(seconds: 0),
                            // decoration: financeScheme ? BoxDecoration(border: Border.all(color: Colors.blue),boxShadow: const [BoxShadow(color:Colors.white,blurRadius: 2)]):const BoxDecoration(),
                            // child: SwitchListTile(activeColor: Colors.green,
                            //   value: financeScheme,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       financeScheme = value;
                            //       if (value == true) {
                            //         financeCompany.text =
                            //             displayDocketDetails['finance_company'] ??
                            //                 "";
                            //         financeAmount.text =
                            //             displayDocketDetails['finance_amount'] ??
                            //                 "";
                            //       }
                            //       else if (value == false) {
                            //         financeCompany.clear();
                            //         financeAmount.clear();
                            //       }
                            //     });
                            //   },
                            //   title: const Text('Finance Scheme',
                            //     style: TextStyle(fontSize: 18),
                            //   ),
                            //   controlAffinity: ListTileControlAffinity
                            //       .trailing,
                            // )
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Finance Scheme"),
                              buildCustomToggleSwitch(
                                value: financeScheme,
                                  onChanged: (value) {
                                    setState(() {
                                      financeScheme = value;
                                      if (value == true) {
                                        financeCompany.text =
                                            displayDocketDetails['finance_company'] ??
                                                "";
                                        financeAmount.text =
                                            displayDocketDetails['finance_amount'] ??
                                                "";
                                      }
                                      else if (value == false) {
                                        financeCompany.clear();
                                        financeAmount.clear();
                                      }
                                    });
                                  },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Finance Company"),
                    const SizedBox(height: 6,),
                    TextField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      enabled: financeScheme,
                      controller: financeCompany,
                      decoration: textFieldToggleDecoration(
                          "Finance Company", financeCompany.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Finance Amount"),
                    const SizedBox(height: 6,),
                    TextField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (val) {
                        setState(() {

                        });
                      },
                      enabled: financeScheme,
                      controller: financeAmount,
                      decoration: textFieldToggleDecoration(
                          "Finance Amount", financeAmount.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50,),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 120,
              height: 28,
              child: OutlinedMButton(
                text: 'Update',
                textColor: mSaveButton,
                borderColor: mSaveButton,
                onTap: () {
                  if (tabIndex == 1) {
                    if (tabs = true) {
                      Map orderUpDetails = {
                        "car_finance": financeScheme ? "Yes" : "No",
                        "car_model": existingCar.text,
                        "color": widget.docketData["color"],
                        "cust_vehi_id": widget.docketData["cust_vehi_id"],
                        "customer_id": widget.docketData["customer_id"],
                        "evaluation_date": evaluationDate.text,
                        "exchange": isDisabled ? "Yes" : "No",
                        "finance_amount": financeAmount.text,
                        "finance_company": financeCompany.text,
                        "general_id": widget.docketData["general_id"],
                        "make": widget.docketData["make"],
                        "model": widget.docketData["model"],
                        "variant": widget.docketData["varient_name"]
                      };
                      updateOrderDetails(orderUpDetails);
                    }
                    _tabController.animateTo((_tabController.index + 1) % 6);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  paymentDetails() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  //First Table.
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18,right: 18),
                      child: Divider(height: 1,color: mTextFieldBorder,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18,right: 18),
                      child: Container(color: const Color(0xffF3F3F3),
                        height: 34,
                        child:  Row(
                          children:  [
                            const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Align(alignment: Alignment.centerLeft,child: Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Text('Offer Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[800],
                                    fontSize: 16,
                                  )),
                            ))),
                            const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                          ],
                        ),
                      ),
                    ),
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
                            Expanded(child: Center(child: Text('SL No'))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Offers"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("OEM"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Self"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Amount"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18,right: 18),
                      child: Divider(height: 1,color: mTextFieldBorder,),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:6,
                      itemBuilder: (BuildContext context, int index) {
                        if(index<5){
                          return Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(left:18.0,right:18),
                              child: SizedBox(height:50,
                                child: Row(children: [
                                  const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                  Expanded(child: Center(child: Text('${index + 1}'))),
                                  const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                  Expanded(child: Center(child: Text(offers[index]??""))),
                                  const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 30,
                                          decoration: state.text
                                              .isNotEmpty
                                              ? const BoxDecoration()
                                              : const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(color: Color(
                                                    0xFFEEEEEE),
                                                    blurRadius: 2)
                                              ]),
                                          child: TextField(
                                            expands: false,
                                            textAlign: TextAlign.right,
                                            keyboardType: TextInputType
                                                .number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: const TextStyle(
                                                fontSize: 14),
                                            onChanged: (val) {
                                              setState(() {
                                                consTotal = double.parse(
                                                    oemConsOffer.text
                                                        .isEmpty
                                                        ? "0"
                                                        : oemConsOffer
                                                        .text) +
                                                    double.parse(
                                                        selfConsOffer.text
                                                            .isEmpty
                                                            ? "0"
                                                            : selfConsOffer
                                                            .text);
                                                corpTotal = double.parse(
                                                    oemCorpOffer.text
                                                        .isEmpty
                                                        ? "0"
                                                        : oemCorpOffer
                                                        .text) +
                                                    double.parse(
                                                        selfCorpOffer.text
                                                            .isEmpty
                                                            ? "0"
                                                            : selfCorpOffer
                                                            .text);
                                                exchTotal = double.parse(
                                                    oemExchOffer.text
                                                        .isEmpty
                                                        ? "0"
                                                        : oemExchOffer
                                                        .text) +
                                                    double.parse(
                                                        selfExchOffer.text
                                                            .isEmpty
                                                            ? "0"
                                                            : selfExchOffer
                                                            .text);
                                                additionalTotal =
                                                    double.parse(
                                                        oemAdditionalOffer
                                                            .text.isEmpty
                                                            ? "0"
                                                            : oemAdditionalOffer
                                                            .text) +
                                                        double.parse(
                                                            selfAdditionalOffer
                                                                .text
                                                                .isEmpty
                                                                ? "0"
                                                                : selfAdditionalOffer
                                                                .text);
                                                accessTotal =
                                                    double.parse(
                                                        oemAccesOffer.text
                                                            .isEmpty
                                                            ? "0"
                                                            : oemAccesOffer
                                                            .text) +
                                                        double.parse(
                                                            selfAccesOffer
                                                                .text
                                                                .isEmpty
                                                                ? "0"
                                                                : selfAccesOffer
                                                                .text);
                                                grandTotal = consTotal +
                                                    corpTotal +
                                                    exchTotal +
                                                    additionalTotal +
                                                    accessTotal;
                                              });
                                            },
                                            controller: index == 0
                                                ? oemConsOffer
                                                : index == 1
                                                ? oemCorpOffer
                                                : index == 2
                                                ? oemExchOffer
                                                : index == 3
                                                ? oemAdditionalOffer
                                                : oemAccesOffer,
                                            decoration: textFieldPaymentDecoration(
                                                "", false),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 30,
                                          decoration: state.text
                                              .isNotEmpty
                                              ? const BoxDecoration()
                                              : const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(color: Color(
                                                    0xFFEEEEEE),
                                                    blurRadius: 2)
                                              ]),
                                          child: TextField(
                                            expands: false,
                                            textAlign: TextAlign.right,
                                            keyboardType: TextInputType
                                                .number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: const TextStyle(
                                                fontSize: 14),
                                            onChanged: (val) {
                                              setState(() {
                                                consTotal = double.parse(
                                                    oemConsOffer.text
                                                        .isEmpty
                                                        ? "0"
                                                        : oemConsOffer
                                                        .text) +
                                                    double.parse(
                                                        selfConsOffer.text
                                                            .isEmpty
                                                            ? "0"
                                                            : selfConsOffer
                                                            .text);
                                                corpTotal = double.parse(
                                                    oemCorpOffer.text
                                                        .isEmpty
                                                        ? "0"
                                                        : oemCorpOffer
                                                        .text) +
                                                    double.parse(
                                                        selfCorpOffer.text
                                                            .isEmpty
                                                            ? "0"
                                                            : selfCorpOffer
                                                            .text);
                                                exchTotal = double.parse(
                                                    oemExchOffer.text
                                                        .isEmpty
                                                        ? "0"
                                                        : oemExchOffer
                                                        .text) +
                                                    double.parse(
                                                        selfExchOffer.text
                                                            .isEmpty
                                                            ? "0"
                                                            : selfExchOffer
                                                            .text);
                                                additionalTotal =
                                                    double.parse(
                                                        oemAdditionalOffer
                                                            .text
                                                            .isEmpty
                                                            ? "0"
                                                            : oemAdditionalOffer
                                                            .text) +
                                                        double.parse(
                                                            selfAdditionalOffer
                                                                .text
                                                                .isEmpty
                                                                ? "0"
                                                                : selfAdditionalOffer
                                                                .text);
                                                accessTotal =
                                                    double.parse(
                                                        oemAccesOffer.text
                                                            .isEmpty
                                                            ? "0"
                                                            : oemAccesOffer
                                                            .text) +
                                                        double.parse(
                                                            selfAccesOffer
                                                                .text
                                                                .isEmpty
                                                                ? "0"
                                                                : selfAccesOffer
                                                                .text);

                                                grandTotal =
                                                    consTotal +
                                                        corpTotal +
                                                        exchTotal +
                                                        additionalTotal +
                                                        accessTotal;
                                              });
                                            },
                                            // controller: bookingAmount,
                                            controller: index == 0
                                                ? selfConsOffer
                                                : index == 1
                                                ? selfCorpOffer
                                                : index == 2
                                                ? selfExchOffer
                                                : index == 3
                                                ? selfAdditionalOffer
                                                : selfAccesOffer,
                                            decoration: textFieldPaymentDecoration(
                                                "", false),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                  Expanded(
                                    child: Center(
                                      child: Text('Rs ${index == 0
                                          ? consTotal
                                          .toStringAsFixed(2)
                                          : index == 1
                                          ? corpTotal.toStringAsFixed(
                                          2)
                                          : index == 2
                                          ? exchTotal
                                          .toStringAsFixed(2)
                                          : index == 3
                                          ? additionalTotal
                                          .toStringAsFixed(2)
                                          : accessTotal
                                          .toStringAsFixed(2)}'),
                                    ),
                                  ),
                                  const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                                ]),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 18,right: 18),
                              child: Divider(height: 1,color: mTextFieldBorder,),
                            ),
                          ],);
                        }
                        else{
                          return      Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:18.0,right:18),
                                child: Row(children: [
                                  const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                  Expanded(flex: 3,child:Container()),
                                  const Expanded(
                                    child: Center(
                                      child: Text("Total",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),),
                                    ),
                                  ),
                                  const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                          "Rs ${grandTotal
                                              .toStringAsFixed(2)}"),
                                    ),
                                  ),
                                  const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                ],),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 18,right: 18),
                                child: Divider(height: 1,color: mTextFieldBorder,),
                              ),
                            ],
                          );
                        }
                      },),
                  ]),
                  const SizedBox(height: 30,),
                  // Second Table.
                  Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18,right: 18),
                      child: Divider(height: 1,color: mTextFieldBorder,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18,right: 18),
                      child: Container(color: const Color(0xffF3F3F3),
                        height: 34,
                        child:  Row(
                          children:  [
                            const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Align(alignment: Alignment.centerLeft,child: Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Text('Payment Details',  style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[800],
                                fontSize: 16,
                              )),
                            ))),
                            const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                          ],
                        ),
                      ),
                    ),
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
                            Expanded(child: Center(child: Text('SL No'))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Receipt Data"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Receipt No"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Payment Mode"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Amount"))),
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18,right: 18),
                      child: Divider(height: 1,color: mTextFieldBorder,),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: paymentList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if(index<paymentList.length){
                          return Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(left:18.0,right:18),
                              child: Row(children: [
                                const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                Expanded(child: Center(child: Text('${index + 1}'))),
                                const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                Expanded(child: Center(child: Text( paymentList[index]['receipt_date']??""))),
                                const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                Expanded(child: Center(child: Text(  paymentList[index]['payment_id']??""))),
                                const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                Expanded(child: Center(child: Text(  paymentList[index]['payment_mode']??""))),
                                const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                Expanded(child: Center(child: Text("Rs ${paymentList[index]['payment_amount'].toString()}"))),
                                const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                              ],),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 18,right: 18),
                              child: Divider(height: 1,color: mTextFieldBorder,),
                            )
                          ],);
                        }
                        else{
                          return Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(left:18.0,right:18),
                              child: Row(children: [
                                const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                                Expanded(flex: 4,child: Container()),
                                buttonWidgetNewPaymentMode(),
                                const CustomVDivider(height: 50, width: 1, color: mTextFieldBorder),
                              ],),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 18,right: 18),
                              child: Divider(height: 1,color: mTextFieldBorder,),
                            ),
                          ],);
                        }
                      },),
                    const SizedBox(height: 50,),
                  ]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 3.7,
                child: Container(decoration: BoxDecoration(
                    border: Border.all(color: mTextFieldBorder,),
                    borderRadius: BorderRadius.circular(1)),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)
                          ),
                          color: Colors.grey[100],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Summary Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight
                                        .bold,
                                    color: Colors.indigo[800],
                                    fontSize: 16,
                                  ),),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1,),
                      Container(
                        height: 30,
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
                      const Divider(height: 1,),
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
                                              textAlign: TextAlign.right,
                                              controller: actualExShowroom,
                                              keyboardType: TextInputType
                                                  .number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedExShowroom,
                                              keyboardType: TextInputType
                                                  .number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              // controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: actualLifeTax,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              // controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedLifeTax,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                    child: Text("Zero Dep Insurance")),
                                Expanded(
                                    child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(height: 30,
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: actualZeroDep,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              // controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedZeroDep,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //  controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: actualInsurance,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedInsurance,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                    child: Text("Reg/TR/Np Registration")),
                                Expanded(
                                    child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(height: 30,
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: actualRegTr,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedRegTr,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                    child: Text("3rd/4th Year Warranty")),
                                Expanded(
                                    child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(height: 30,
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: actual3Rd4ThWarranty,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              // controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discounted3Rd4ThWarranty,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //  controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: actualAccessories,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedAccessories,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              // controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                          child: SizedBox(
                                            height: 30,
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: actualOthers,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              // controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedOthers,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: actualRefund,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  actualTotal.text =
                                                      (double.parse(
                                                          actualExShowroom.text
                                                              .isEmpty
                                                              ? "0"
                                                              : actualExShowroom
                                                              .text) +
                                                          double.parse(
                                                              actualLifeTax.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              actualZeroDep.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              actualInsurance
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : actualInsurance
                                                                  .text) +
                                                          double.parse(
                                                              actualRegTr.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRegTr
                                                                  .text) +
                                                          double.parse(
                                                              actual3Rd4ThWarranty
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actual3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              actualAccessories
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualAccessories
                                                                  .text) +
                                                          double.parse(
                                                              actualOthers.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualOthers
                                                                  .text) +
                                                          double.parse(
                                                              actualRefund.text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : actualRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedRefund,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {
                                                  discountedTotal.text =
                                                      (double.parse(
                                                          discountedExShowroom
                                                              .text
                                                              .isEmpty
                                                              ? "0"
                                                              : discountedExShowroom
                                                              .text) +
                                                          double.parse(
                                                              discountedLifeTax
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedLifeTax
                                                                  .text) +
                                                          double.parse(
                                                              discountedZeroDep
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedZeroDep
                                                                  .text) +
                                                          double.parse(
                                                              discountedInsurance
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedInsurance
                                                                  .text) +
                                                          double.parse(
                                                              discountedRegTr
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRegTr
                                                                  .text) +
                                                          double.parse(
                                                              discounted3Rd4ThWarranty
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discounted3Rd4ThWarranty
                                                                  .text) +
                                                          double.parse(
                                                              discountedAccessories
                                                                  .text.isEmpty
                                                                  ? "0"
                                                                  : discountedAccessories
                                                                  .text) +
                                                          double.parse(
                                                              discountedOthers
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedOthers
                                                                  .text) +
                                                          double.parse(
                                                              discountedRefund
                                                                  .text
                                                                  .isEmpty
                                                                  ? "0"
                                                                  : discountedRefund
                                                                  .text)
                                                      ).toString();
                                                });
                                              },
                                              // controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                ),
                                Expanded(
                                    child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(height: 30,
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: actualTotal,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {

                                                });
                                              },
                                              //controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
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
                                              textAlign: TextAlign.right,
                                              controller: discountedTotal,
                                              style: const TextStyle(
                                                  fontSize: 14),
                                              onChanged: (val) {
                                                setState(() {

                                                });
                                              },
                                              //  controller: bookingAmount,
                                              decoration: textFieldPaymentDecoration(
                                                  "", false),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // ----------- save button -----------
        if(isShowButton == true)
          Align(alignment: Alignment.bottomRight,
            child: SizedBox(
                width: 120,
                height: 28,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8),
                  child: OutlinedMButton(
                    onTap: () {
                      if (tabIndex == 2) {
                        if (tabs = true) {
                          Map requestBody = {
                            "dock_customer_id": "",
                            "docket_id": widget.docketData["docket_id"],
                            "general_id": widget.docketData["general_id"],
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
                            "self_additional_discount": selfAdditionalOffer
                                .text,
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
                            "zero_dep_insurance_discounted": discountedZeroDep
                                .text,
                            "insurance_actual": actualInsurance.text,
                            "insurance_discounted": discountedInsurance.text,
                            "reg_no_actual": actualRegTr.text,
                            "reg_no_discounted": discountedRegTr.text,
                            "warranty_year_actual": actual3Rd4ThWarranty.text,
                            "warranty_year_discounted": discounted3Rd4ThWarranty
                                .text,
                            "accessories_actual": actualAccessories.text,
                            "accessories_discounted": discountedAccessories
                                .text,
                            "others_actual": actualOthers.text,
                            "others_discounted": discountedOthers.text,
                            "refund_actual": actualRefund.text,
                            "refund_discounted": discountedRefund.text,
                            "total_actual_amount": actualTotal.text,
                            "total_discounted_amount": discountedTotal.text,
                          };
                          addPaymentDetails(requestBody);
                        }
                      }
                      _tabController.animateTo((_tabController.index + 1) % 6);
                    },
                    text: 'Save',
                    textColor: mSaveButton,
                    borderColor: mSaveButton,
                  ),
                )
            ),
          ),
        // ------- update button --------
        if(isShowButton == false)
          Align(alignment: Alignment.bottomRight,
            child: SizedBox(
                width: 120,
                height: 28,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8),
                  child: OutlinedMButton(
                    onTap: () {
                      if (tabIndex == 2) {
                        if (tabs = true) {
                          Map requestBody = {
                            "dock_pay_det_id": paymentId,
                            "general_id": widget.docketData["general_id"],
                            "docket_id": widget.docketData["docket_id"],
                            "dock_customer_id": "",
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
                            "self_additional_discount": selfAdditionalOffer
                                .text,
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
                            "zero_dep_insurance_discounted": discountedZeroDep
                                .text,
                            "insurance_actual": actualInsurance.text,
                            "insurance_discounted": discountedInsurance.text,
                            "reg_no_actual": actualRegTr.text,
                            "reg_no_discounted": discountedRegTr.text,
                            "warranty_year_actual": actual3Rd4ThWarranty.text,
                            "warranty_year_discounted": discounted3Rd4ThWarranty
                                .text,
                            "accessories_actual": actualAccessories.text,
                            "accessories_discounted": discountedAccessories
                                .text,
                            "others_actual": actualOthers.text,
                            "others_discounted": discountedOthers.text,
                            "refund_actual": actualRefund.text,
                            "refund_discounted": discountedRefund.text,
                            "total_actual_amount": actualTotal.text,
                            "total_discounted_amount": discountedTotal.text,
                          };
                          updatePaymentDetails(requestBody);
                        }
                      }
                      _tabController.animateTo((_tabController.index + 1) % 6);
                    },
                    text: 'Update',
                    textColor: mSaveButton,
                    borderColor: mSaveButton,
                  ),
                )
            ),
          ),
      ],
    );
  }

  buttonWidgetNewPaymentMode() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 120,
        height: 28,
        child: OutlinedMButton(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    content: SizedBox(
                      child: Stack(
                        clipBehavior: Clip.none, children: <Widget>[
                        Container(
                          width: 600,
                          height: 380,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          margin: const EdgeInsets.only(top: 13.0, right: 8.0),
                          child: Padding(
                              padding: const EdgeInsets.all(30),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: mTextFieldBorder),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.grey[100],
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: MaterialButton(
                                        hoverColor: Colors.transparent,
                                        onPressed: () {

                                        },
                                        child: const Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Add Payment',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1,color:mTextFieldBorder),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    const Text("Receipt Date"),
                                                    const SizedBox(height: 6,),
                                                    TextFormField(
                                                      onTap: () {
                                                        _selectDate(context);
                                                      },
                                                      controller: recDate,
                                                      decoration: textFieldDecoration(
                                                          "Receipt Date", false),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text("Select"),
                                                      const SizedBox(height: 6,),
                                                      Focus(
                                                        onFocusChange: (value) {
                                                          setState(() {

                                                          });
                                                        },
                                                        skipTraversal: true,
                                                        descendantsAreFocusable: true,
                                                        child: LayoutBuilder(
                                                            builder: (
                                                                BuildContext context,
                                                                BoxConstraints constraints) {
                                                              return CustomPopupMenuButton(
                                                                elevation: 4,
                                                                decoration: customPopupDecoration(
                                                                    hintText: 'Select type'),
                                                                hintText: currentSelectedValue,
                                                                childWidth: constraints
                                                                    .maxWidth,
                                                                textController: selectTypeController,
                                                                shape: const RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      color: mTextFieldBorder),
                                                                  borderRadius: BorderRadius
                                                                      .all(
                                                                    Radius.circular(
                                                                        5),
                                                                  ),
                                                                ),
                                                                offset: const Offset(
                                                                    1, 40),
                                                                tooltip: '',
                                                                itemBuilder: (
                                                                    BuildContext context) {
                                                                  return currencies
                                                                      .map((value) {
                                                                    return CustomPopupMenuItem(
                                                                      value: value,
                                                                      text: value,
                                                                      child: Container(),
                                                                    );
                                                                  }).toList();
                                                                },

                                                                onSelected: (
                                                                    String value) {
                                                                  setState(() {
                                                                    currentSelectedValue =
                                                                        value;
                                                                    selectTypeController
                                                                        .text = value;
                                                                  });
                                                                },
                                                                onCanceled: () {

                                                                },
                                                                child: Container(),
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    const Text("Note"),
                                                    const SizedBox(height: 6,),
                                                    TextFormField(
                                                      controller: recNote,
                                                      decoration: textFieldDecoration(
                                                          "Note", false),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    const Text("Amount"),
                                                    const SizedBox(height: 6,),
                                                    TextFormField(
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      controller: recAmount,
                                                      decoration: textFieldDecoration(
                                                          "Amount", false),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: 120,
                                                height: 28,
                                                child: OutlinedMButton(
                                                  text: 'Submit',
                                                  buttonColor: mSaveButton,
                                                  textColor: Colors.white,
                                                  borderColor: mSaveButton,
                                                  onTap: () {
                                                    Map requestBody = {
                                                      "dock_customer_id": '',
                                                      "general_id": widget
                                                          .docketData["general_id"],
                                                      "payment_amount": recAmount.text,
                                                      "payment_mode": currentSelectedValue,
                                                      "receipt_date": recDate.text,
                                                      "note": recNote.text,
                                                      "docket_id": docketId,
                                                    };
                                                    addPaymentMode(requestBody)
                                                        .whenComplete(() {
                                                      setState(() {

                                                      });
                                                    });
                                                    recAmount.clear();
                                                    recDate.clear();
                                                    recNote.clear();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                    ),
                  );
                });
          },
          text: 'New',
          textColor: mSaveButton,
          borderColor: mSaveButton,
        ),
      ),

    );
  }

  accessoriesTab() {
    return Row(
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
                  accessoriesList.length + 1,
                      (int index) =>
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            index == accessoriesList.length
                                ? Container()
                                : Text(accessoriesList[index]['accessories']),
                          ),
                          DataCell(
                            index == accessoriesList.length
                                ? const Text("")
                                : Text(
                                accessoriesList[index]['accessories_id']),
                          ),
                          DataCell(
                            index == accessoriesList.length
                                ? const Text("")
                                : Text(
                                accessoriesList[index]['amount'].toString()),
                          ),
                          DataCell(
                            index == accessoriesList.length
                                ? const Text("")
                                : Text(accessoriesList[index]['approved_by']),
                          ),
                          DataCell(
                            index == accessoriesList.length
                                ? accButtonWidget()
                                : Text(
                                "${accessoriesList[index]['signature']}"),
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

  accButtonWidget() {
    return
      Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          width: 120, height: 28,
          child: OutlinedMButton(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      content: SizedBox(
                        child: Stack(
                          clipBehavior: Clip.none, children: <Widget>[
                          Container(
                            width: 600,
                            height: 360,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            margin: const EdgeInsets.only(top: 13.0, right: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: mTextFieldBorder),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.grey[100],
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: MaterialButton(
                                          hoverColor: Colors.transparent,
                                          onPressed: () {

                                          },
                                          child: const Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Add Accessories',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: mTextFieldBorder,
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  const Text("Issued/NotIssued"),
                                                  const SizedBox(height: 6,),
                                                  Focus(
                                                    onFocusChange: (value) {
                                                      setState(() {

                                                      });
                                                    },
                                                    skipTraversal: true,
                                                    descendantsAreFocusable: true,
                                                    child: LayoutBuilder(
                                                        builder: (
                                                            BuildContext context,
                                                            BoxConstraints constraints) {
                                                          return CustomPopupMenuButton(
                                                            elevation: 4,
                                                            decoration: customPopupDecoration(
                                                                hintText: 'Issued/NotIssued'),
                                                            hintText: issuedNotIssued,
                                                            childWidth: constraints
                                                                .maxWidth,
                                                            textController: selectIssueController,
                                                            shape: const RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: mTextFieldBorder),
                                                              borderRadius: BorderRadius
                                                                  .all(
                                                                Radius.circular(5),
                                                              ),
                                                            ),
                                                            offset: const Offset(
                                                                1, 40),
                                                            tooltip: '',
                                                            itemBuilder: (
                                                                BuildContext context) {
                                                              return issue.map((
                                                                  value) {
                                                                return CustomPopupMenuItem(
                                                                  value: value,
                                                                  text: value,
                                                                  child: Container(),
                                                                );
                                                              }).toList();
                                                            },

                                                            onSelected: (
                                                                String value) {
                                                              setState(() {
                                                                issuedNotIssued =
                                                                    value;
                                                                selectIssueController
                                                                    .text = value;
                                                              });
                                                            },
                                                            onCanceled: () {

                                                            },
                                                            child: Container(),
                                                          );
                                                        }
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                const Text("Amount"),
                                                const SizedBox(height: 6,),
                                                TextFormField(
                                                  controller: accessoriesAmount,
                                                  decoration: textFieldDecoration(
                                                      "Amount", false),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  const Text("Approved By"),
                                                  const SizedBox(height: 6,),
                                                  Focus(
                                                    onFocusChange: (value) {
                                                      setState(() {

                                                      });
                                                    },
                                                    skipTraversal: true,
                                                    descendantsAreFocusable: true,
                                                    child: LayoutBuilder(
                                                        builder: (
                                                            BuildContext context,
                                                            BoxConstraints constraints) {
                                                          return CustomPopupMenuButton(
                                                            elevation: 4,
                                                            decoration: customPopupDecoration(
                                                                hintText: 'Approved By'),
                                                            hintText: approvedBy,
                                                            childWidth: constraints
                                                                .maxWidth,
                                                            textController: selectApproveController,
                                                            shape: const RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: mTextFieldBorder),
                                                              borderRadius: BorderRadius
                                                                  .all(
                                                                Radius.circular(5),
                                                              ),
                                                            ),
                                                            offset: const Offset(
                                                                1, 40),
                                                            tooltip: '',
                                                            itemBuilder: (
                                                                BuildContext context) {
                                                              return approve.map((
                                                                  value) {
                                                                return CustomPopupMenuItem(
                                                                  value: value,
                                                                  text: value,
                                                                  child: Container(),
                                                                );
                                                              }).toList();
                                                            },

                                                            onSelected: (
                                                                String value) {
                                                              setState(() {
                                                                approvedBy = value;
                                                                selectApproveController
                                                                    .text = value;
                                                              });
                                                            },
                                                            onCanceled: () {

                                                            },
                                                            child: Container(),
                                                          );
                                                        }
                                                    ),
                                                  ),
                                                  // FormField<String>(
                                                  //   builder: (FormFieldState<String> state) {
                                                  //     return InputDecorator(
                                                  //       decoration: decorationInput3("Approved By",false),
                                                  //
                                                  //       isEmpty: approvedBy == '',
                                                  //       child: DropdownButtonHideUnderline(
                                                  //         child: DropdownButton<String>(
                                                  //           value: approvedBy,
                                                  //           isDense: true,
                                                  //           onChanged: (String? newValue) {
                                                  //             setState(() {
                                                  //               approvedBy = newValue.toString();
                                                  //               state.didChange(newValue);
                                                  //             });
                                                  //           },
                                                  //           items: ["Manager1","Manager2",].map(( value) {
                                                  //             return DropdownMenuItem<String>(
                                                  //               value: value,
                                                  //               child: Text(value),
                                                  //             );
                                                  //           }).toList(),
                                                  //         ),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                ],
                                              )
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  const Text("Signature"),
                                                  const SizedBox(height: 6,),
                                                  Focus(
                                                    onFocusChange: (value) {
                                                      setState(() {

                                                      });
                                                    },
                                                    skipTraversal: true,
                                                    descendantsAreFocusable: true,
                                                    child: LayoutBuilder(
                                                        builder: (
                                                            BuildContext context,
                                                            BoxConstraints constraints) {
                                                          return CustomPopupMenuButton(
                                                            elevation: 4,
                                                            decoration: customPopupDecoration(
                                                                hintText: 'Signature'),
                                                            hintText: accessoriesSign,
                                                            childWidth: constraints
                                                                .maxWidth,
                                                            textController: selectSignatureController,
                                                            shape: const RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: mTextFieldBorder),
                                                              borderRadius: BorderRadius
                                                                  .all(
                                                                Radius.circular(5),
                                                              ),
                                                            ),
                                                            offset: const Offset(
                                                                1, 40),
                                                            tooltip: '',
                                                            itemBuilder: (
                                                                BuildContext context) {
                                                              return signature.map((
                                                                  value) {
                                                                return CustomPopupMenuItem(
                                                                  value: value,
                                                                  text: value,
                                                                  child: Container(),
                                                                );
                                                              }).toList();
                                                            },

                                                            onSelected: (
                                                                String value) {
                                                              setState(() {
                                                                accessoriesSign =
                                                                    value;
                                                                selectSignatureController
                                                                    .text = value;
                                                              });
                                                            },
                                                            onCanceled: () {

                                                            },
                                                            child: Container(),
                                                          );
                                                        }
                                                    ),
                                                  ),
                                                  // FormField<String>(
                                                  //   builder: (FormFieldState<String> state) {
                                                  //     return InputDecorator(
                                                  //       decoration: decorationInput3("Signature",false),
                                                  //
                                                  //       isEmpty: accessoriesSign == '',
                                                  //       child: DropdownButtonHideUnderline(
                                                  //         child: DropdownButton<String>(
                                                  //           value: accessoriesSign,
                                                  //           isDense: true,
                                                  //           onChanged: (String? newValue) {
                                                  //             setState(() {
                                                  //               accessoriesSign = newValue.toString();
                                                  //               state.didChange(newValue);
                                                  //             });
                                                  //           },
                                                  //           items: ["Yes","No",].map(( value) {
                                                  //             return DropdownMenuItem<String>(
                                                  //               value: value,
                                                  //               child: Text(value),
                                                  //             );
                                                  //           }).toList(),
                                                  //         ),
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                ],
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 120,
                                        height: 28,
                                        child: OutlinedMButton(
                                          text: 'Submit',
                                          buttonColor: mSaveButton,
                                          textColor: Colors.white,
                                          borderColor: mSaveButton,
                                          onTap: () {
                                            Map requestBody = {
                                              "dock_customer_id": '',
                                              "general_id": widget
                                                  .docketData["general_id"],
                                              "docket_id": widget
                                                  .docketData["docket_id"],
                                              "accessories": issuedNotIssued,
                                              "amount": accessoriesAmount.text,
                                              "approved_by": approvedBy,
                                              "signature": accessoriesSign,
                                              "bill_no": "",
                                            };
                                            accessoriesAmount.clear();
                                            addAccessories(requestBody)
                                                .whenComplete(() {
                                              getAccessories();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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
                      ),
                    );
                  });
            },
            text: 'New',
            textColor: mSaveButton,
            borderColor: mSaveButton,
          ),
        ),
      );
  }

  bookingDetailsTab() {
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
                    child: Text("VEHICLE DETAILS", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900])),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Model"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingModel,
                      decoration: textFieldDecoration(
                          "Model", bookingModel.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Variant"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingVariant,
                      decoration: textFieldDecoration(
                          "Variant", bookingVariant.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Color"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingColor,
                      decoration: textFieldDecoration(
                          "Color", bookingColor.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Date of Bookings"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1996),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('dd-MM-yyyy')
                              .format(pickedDate);
                          setState(() {
                            bookDetailsDate.text = formattedDate;
                          });
                        } else {

                        }
                      },
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookDetailsDate,
                      decoration: textFieldDecoration("Date of Bookings",
                          bookDetailsDate.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Customer ID"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingCustId,
                      decoration: textFieldDecoration(
                          "Customer ID", bookingCustId.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Booking ID"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingId,
                      decoration: textFieldDecoration(
                          "Booking ID", bookingId.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Chassis No"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingChassisNo,
                      decoration: textFieldDecoration(
                          "Chassis No", bookingChassisNo.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Engine No"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingEngineNo,
                      decoration: textFieldDecoration(
                          "Engine No", bookingEngineNo.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Vehicle Reg No"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingVehicleRegNo,
                      decoration: textFieldDecoration("Vehicle Reg No",
                          bookingVehicleRegNo.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Booking Allotment Date"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1996),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('dd-MM-yyyy')
                              .format(pickedDate);
                          setState(() {
                            bookingAllotmentDate.text = formattedDate;
                          });
                        } else {

                        }
                      },
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingAllotmentDate,
                      decoration: textFieldDecoration("Booking Allotment Date",
                          bookingAllotmentDate.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Allotted By"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingAllottedBy,
                      decoration: textFieldDecoration(
                          "Allotted By", bookingAllottedBy.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Car Status"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingCarStatus,
                      decoration: textFieldDecoration(
                          "Car Status", bookingCarStatus.text.isNotEmpty),),
                  ],
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
                    child: Text("INVOICE DETAILS", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900])),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Inv. No"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingInvNo,
                      decoration: textFieldDecoration(
                          "Inv. No", bookingInvNo.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Inv. Date"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      readOnly: true,
                      showCursor: false,
                      onTap: () {
                        _selectInvoiceDate(context);
                      },
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingInvDate,
                      decoration: textFieldDecoration(
                          "Inv. Date", bookingInvDate.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ins. No"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingInsNo,
                      decoration: textFieldDecoration(
                          "Ins. No", bookingInsNo.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("E/W No"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingEWNo,
                      decoration: textFieldDecoration(
                          "E/W No", bookingEWNo.text.isNotEmpty),),
                  ],
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
                    child: Text("Insurance/Extended Warranty", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900])),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Maruthi Insurance"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingMaruthiInsurance,
                      decoration: textFieldDecoration("Maruthi Insurance",
                          bookingMaruthiInsurance.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Insurance Remarks"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingInsuranceRemarks,
                      decoration: textFieldDecoration("Insurance Remarks",
                          bookingInsuranceRemarks.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 30,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ins.Mgr Remarks for No"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: bookingInsRemarksNo,
                      decoration: textFieldDecoration("Ins.Mgr Remarks for No",
                          bookingInsRemarksNo.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(isBookButton == true)
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 28,
                    child: OutlinedMButton(
                      onTap: () {
                        if (tabIndex == 4) {
                          if (tabs = true) {
                            Map requestBody = {
                              "model": bookingModel.text,
                              "date_of_booking": bookDetailsDate.text,
                              "chassis_no": bookingChassisNo.text,
                              "booking_allotment_date": bookingAllotmentDate
                                  .text,
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
                              "general_id": widget.docketData["general_id"],
                              "docket_id": widget.docketData["docket_id"],
                              "dock_customer_id": '',
                            };
                            addBookDetails(requestBody);
                          }
                          _tabController.animateTo((_tabController.index + 1) %
                              6);
                        }
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>const InvoiceScreen()));
                      },
                      text: 'Save',
                      textColor: mSaveButton,
                      borderColor: mSaveButton,
                    ),
                  ),
                ),
              if(isBookButton == false)
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 28,
                    child: OutlinedMButton(
                      onTap: () {
                        if (tabIndex == 4) {
                          if (tabs = true) {
                            Map requestBody = {
                              "booking_details_id": bookId,
                              "model": bookingModel.text,
                              "date_of_booking": bookDetailsDate.text,
                              "chassis_no": bookingChassisNo.text,
                              "booking_allotment_date": bookingAllotmentDate
                                  .text,
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
                              "general_id": widget.docketData["general_id"],
                              "docket_id": widget.docketData["docket_id"],
                              "dock_customer_id": '',
                            };
                            bookingUpdate(requestBody);
                          }
                        }
                        _tabController.animateTo(
                            (_tabController.index + 1) % 6);
                      },
                      text: 'Update',
                      textColor: mSaveButton,
                      borderColor: mSaveButton,
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

  exchangeDetailsTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Model"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exModel,
                      decoration: textFieldDecoration(
                          "Model", exModel.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Mfg Year"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly
                      ],
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exManufactureYear,
                      decoration: textFieldDecoration(
                          "Mfg Year", exManufactureYear.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Less Per Closing Amount"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly
                      ],
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exLessPerClosAmt,
                      decoration: textFieldDecoration("Less Per Closing Amount",
                          exLessPerClosAmt.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("P.Reg.No"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exRegNo,
                      decoration: textFieldDecoration(
                          "P.Reg.No", exRegNo.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Relationship"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exRelationship,
                      decoration: textFieldDecoration(
                          "Relationship", exRelationship.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Less Traffic Challan"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exLessTrafficChallan,
                      decoration: textFieldDecoration("Less Traffic Challan",
                          exLessTrafficChallan.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Rc Copy"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exRCCopy,
                      decoration: textFieldDecoration(
                          "Rc Copy", exRCCopy.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Vehicle Cost"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly
                      ],
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exVehicleCost,
                      decoration: textFieldDecoration(
                          "Vehicle Cost", exVehicleCost.text.isNotEmpty),),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Less Balance new car"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: exLessBalance,
                      decoration: textFieldDecoration("Less Balance new car",
                          exLessBalance.text.isNotEmpty),),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 2,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Terms And Conditions ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey)),
                            height: 150,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              controller: exTermsAndCond,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 10, top: 18, right: 15),
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
                          child: SizedBox(
                              width: 120,
                              height: 28,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8),
                                child: OutlinedMButton(
                                  onTap: () {
                                    String mfgYearString = exManufactureYear
                                        .text.toString();
                                    String vehicleCostString = exVehicleCost
                                        .text.toString();
                                    String lessPerClosingAmountString = exLessPerClosAmt
                                        .text.toString();
                                    Map requestBody = {
                                      "dock_customer_id": "",
                                      "general_id": widget
                                          .docketData["general_id"],
                                      "docket_id": widget
                                          .docketData["docket_id"],
                                      "model": exModel.text,
                                      "preg_no": exRegNo.text,
                                      "rc_copy": exRCCopy.text,
                                      "mfg_year": mfgYearString,
                                      "relation_ship": exRelationship.text,
                                      "vehicle_cost": vehicleCostString,
                                      "less_per_closing_amount": lessPerClosingAmountString,
                                      "less_trafic_challan": exLessTrafficChallan
                                          .text,
                                      "less_balance_new_car": exLessBalance
                                          .text,
                                      "terms_conditions": exTermsAndCond.text,
                                    };
                                    addExchangeDetails(requestBody);
                                  },
                                  text: 'Save',
                                  textColor: mSaveButton,
                                  borderColor: mSaveButton,
                                ),
                              )),
                        ),
                      if(isExchangeButton == false)
                        Align(alignment: Alignment.bottomRight,
                          child: SizedBox(
                              width: 120,
                              height: 28,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8),
                                child: OutlinedMButton(
                                  onTap: () {
                                    Map requestBody = {
                                      "exchange_details_id": exchangeId,
                                      "general_id": widget
                                          .docketData["general_id"],
                                      "dock_customer_id": '',
                                      "docket_id": widget
                                          .docketData["docket_id"],
                                      "model": exModel.text,
                                      "preg_no": exRegNo.text,
                                      "rc_copy": exRCCopy.text,
                                      "mfg_year": double.parse(
                                          exManufactureYear.text),
                                      "relation_ship": exRelationship.text,
                                      "vehicle_cost": double.parse(
                                          exVehicleCost.text),
                                      "less_per_closing_amount": double.parse(
                                          exLessPerClosAmt.text),
                                      "less_trafic_challan": exLessTrafficChallan
                                          .text,
                                      "less_balance_new_car": exLessBalance
                                          .text,
                                      "terms_conditions": exTermsAndCond.text,
                                    };
                                    exchangeUpdate(requestBody);
                                  },
                                  text: 'Update',
                                  textColor: mSaveButton,
                                  borderColor: mSaveButton,
                                ),
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

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day
        .toString().padLeft(2, "0")}";
  }

  Future<void> _selectBookingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: bookingDate.text.isEmpty ? DateTime.now() : DateTime.parse(
            bookingDate.text),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
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
    if (picked != null) {
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
    if (picked != null) {
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
    if (picked != null) {
      setState(() {
        recDate.text = (picked.toLocal()).toString().split(' ')[0];
      });
    }
  }

  Future<void> updateCustomerDetails(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/update_newcustomer"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final docCusId = responseData['id'];
        docketCustomerId = docCusId;
        dev.log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Successful")));
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

  Future<void> updateOrderDetails(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/customer_vehicle/update_customer_vehicle"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);
        dev.log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Successful")));
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

  Future addPaymentDetails(data) async {
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketpaymentdetails/add_salesdock_pay_details";
    postData(context: context, url: url, requestBody: data).then((value) {
      setState(() {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data Saved")));
          paymentId = value['id'];
        }
      });
    });
  }

  Future fetchPaymentDetails() async {
    dynamic temp;
    final response = await http.get(Uri.parse(
        "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketpaymentdetails/get_salesdock_pay_details_by_docket_id/${widget
            .docketData['docket_id']}"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        temp = jsonDecode(response.body);
        if (temp.isEmpty || temp == null || temp["code"] == 509 ||
            temp["error"] == "user not found" || temp['status'] == "failed") {
          setState(() {
            isShowButton = true;
          });
        } else {
          setState(() {
            isShowButton = false;
            paymentId = temp["dock_pay_det_id"].toString();
            oemConsOffer.text = temp["oem_consumer_offer"].toString();
            selfConsOffer.text = temp['self_consumer_offer'].toString();
            consTotal =
                double.parse(temp['total_consumer_offer'].toString());
            oemCorpOffer.text = temp['oem_corporate_offer'].toString();
            selfCorpOffer.text = temp['self_corporate_offer'].toString();
            corpTotal =
                double.parse(temp['total_corporate_offer'].toString());
            oemExchOffer.text = temp['oem_exchange_bonus'].toString();
            selfExchOffer.text = temp['self_exchange_bonus'].toString();
            exchTotal =
                double.parse(temp['total_exchange_bonus'].toString());
            oemAdditionalOffer.text =
                temp['oem_additional_discount'].toString();
            selfAdditionalOffer.text =
                temp['self_additional_discount'].toString();
            additionalTotal = double.parse(
                temp['total_additional_discount'].toString());
            oemAccesOffer.text = temp['oem_accessories_disc'].toString();
            selfAccesOffer.text =
                temp['self_accessories_disc'].toString();
            accessTotal =
                double.parse(temp['total_accessories_disc'].toString());
            grandTotal = double.parse(temp['overall_amount'].toString());
            actualExShowroom.text = temp['ex_showroom_actual'].toString();
            discountedExShowroom.text =
                temp['ex_showroom_discounted'].toString();
            actualLifeTax.text = temp['life_tax_actual'].toString();
            discountedLifeTax.text =
                temp['life_tax_discounted'].toString();
            actualZeroDep.text =
                temp['zero_dep_insurance_actual'].toString();
            discountedZeroDep.text =
                temp['zero_dep_insurance_discounted'].toString();
            actualInsurance.text = temp['insurance_actual'].toString();
            discountedInsurance.text =
                temp['insurance_discounted'].toString();
            actualRegTr.text = temp['reg_no_actual'].toString();
            discountedRegTr.text = temp['reg_no_discounted'].toString();
            actual3Rd4ThWarranty.text =
                temp['warranty_year_actual'].toString();
            discounted3Rd4ThWarranty.text =
                temp['warranty_year_discounted'].toString();
            actualAccessories.text =
                temp['accessories_actual'].toString();
            discountedAccessories.text =
                temp['accessories_discounted'].toString();
            actualOthers.text = temp['others_actual'].toString();
            discountedOthers.text = temp['others_discounted'].toString();
            actualRefund.text = temp['refund_actual'].toString();
            discountedRefund.text = temp['refund_discounted'].toString();
            actualTotal.text = temp['total_actual_amount'].toString();
            discountedTotal.text =
                temp['total_discounted_amount'].toString();
          });
        }
      });
    } else {
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }

  Future<void> updatePaymentDetails(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketpaymentdetails/update_salesdock_pay_details"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        dev.log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Successful")));
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

  Future addBookDetails(data) async {
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketbookingdetails/add_saldok_booking_details";
    postData(context: context, url: url, requestBody: data).then((value) {
      setState(() {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data Saved")));
        }
      });
    });
  }

  Future fetchBookDetails() async {
    dynamic temp;
    final response = await http.get(
      Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketbookingdetails/get_saldok_booking_details_by_docketid/${widget
              .docketData['docket_id']}"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        temp = jsonDecode(response.body);
        if (temp.isEmpty || temp == null || temp["code"] == 509 ||
            temp["error"] == "user not found" || temp['status'] == "failed") {
          setState(() {
            isBookButton = true;
          });
        } else {
          setState(() {
            isBookButton = false;
            bookId = temp["booking_details_id"] ?? "";
            bookingModel.text = temp["model"] ?? "";
            bookDetailsDate.text = temp["date_of_booking"] ?? "";
            bookingChassisNo.text = temp["chassis_no"] ?? "";
            bookingAllotmentDate.text = temp["booking_allotment_date"] ?? "";
            bookingVariant.text = temp["varient"] ?? "";
            bookingCustId.text = temp["customer_id"] ?? "";
            bookingEngineNo.text = temp["engine_no"] ?? "";
            bookingAllottedBy.text = temp["alloted_by"] ?? "";
            bookingColor.text = temp["color"] ?? "";
            bookingId.text = temp["booking_id"] ?? "";
            bookingCarStatus.text = temp["car_status"] ?? "";
            bookingInvNo.text = temp["invoice_no"] ?? "";
            bookingInvDate.text = temp["invoice_date"] ?? "";
            bookingInsNo.text = temp["ins_no"] ?? "";
            bookingEWNo.text = temp["ew_no"] ?? "";
            bookingMaruthiInsurance.text = temp["maruthi_insurance"] ?? "";
            bookingInsuranceRemarks.text = temp["insurance_remarks"] ?? "";
            bookingInsRemarksNo.text = temp["ins_mgr_remarks"] ?? "";
            bookingVehicleRegNo.text = temp["allotment_no"] ?? "";
          });
        }
      });
    } else {
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }

  Future<void> bookingUpdate(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketbookingdetails/update_saldok_booking_details"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        dev.log(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Successful")));
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

  Future addExchangeDetails(requestBody) async {
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/sales_docket_exchange/add_saldok_exchange_details";
    postData(requestBody: requestBody, url: url, context: context).then((
        value) {
      setState(() {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data Saved")));
          exchangeId = value['id'];
          statusUpdate();
        }
      });
    });
  }

  Future fetchExchangeDetails() async {
    dynamic temp;
    final response = await http.get(
      Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/sales_docket_exchange/get_saldok_exchange_details_by_docketid/${widget
              .docketData['docket_id']}"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        temp = jsonDecode(response.body);
        if (temp.isEmpty || temp == null || temp["code"] == 509 ||
            temp["error"] == "user not found" || temp['status'] == "failed") {
          setState(() {
            isExchangeButton = true;
          });
        } else {
          isExchangeButton = false;
          exchangeId = temp["exchange_details_id"].toString();
          exModel.text = temp["model"].toString();
          exRegNo.text = temp["preg_no"].toString();
          exRCCopy.text = temp["rc_copy"].toString();
          exManufactureYear.text =
              double.parse(temp["mfg_year"].toString()).toString();
          exRelationship.text = temp["relation_ship"].toString();
          exVehicleCost.text =
              double.parse(temp["vehicle_cost"].toString()).toString();
          exLessPerClosAmt.text =
              double.parse(temp["less_per_closing_amount"].toString())
                  .toString();
          exLessTrafficChallan.text =
              temp["less_trafic_challan"].toString();
          exLessBalance.text = temp["less_balance_new_car"].toString();
          exTermsAndCond.text = temp["terms_conditions"].toString();
        }
      });
    } else {
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }

  Future<void> exchangeUpdate(requestBody) async {
    try {
      final response = await http.put(Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/sales_docket_exchange/update_saldok_exchange_details"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode(requestBody)
      );
      if (response.statusCode == 200) {
        dev.log(response.body);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Successful")));
        statusUpdate();
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

  Future<void> statusUpdate() async {
    try {
      final response = await http.patch(Uri.parse(
          "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocket/patch/${widget
              .docketData['docket_id']}"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'
          },
          body: json.encode({
            "status": "Invoiced"
          })
      );
      if (response.statusCode == 200) {
        Map jsonResponse = json.decode(response.body);
        String status = jsonResponse['status'];
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Update Successful")));
        if (status == "Invoiced") {
          // Navigator.of(context).pushNamed(MotowsRoutes.docketList);
        }
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
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketaccessories/add_saldok_accessories";
    postData(requestBody: requestBody, url: url, context: context).then((
        value) =>
    {
      setState(() {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data Saved")));
          getAccessories();
        }
      })
    });
  }

  Future getAccessories() async {
    final response = await http.get(Uri.parse(
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketaccessories/get_saldok_accessories_by_docketid/${widget
            .docketData["docket_id"]}'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        accessoriesList = jsonDecode(response.body);
      });
    } else {
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }

  addPaymentMode(requestBody) async {
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketpayment/add_saldok_payment";
    postData(context: context, url: url, requestBody: requestBody).then((
        value) {
      setState(() {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data Saved")));
          getPayment();
        }
      });
    });
  }

  Future getPayment() async {
    final response = await http
        .get(Uri.parse(
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocketpayment/get_saldok_payment_by_docketid/$docketId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        dynamic parsedResponse = jsonDecode(response.body);
        if (parsedResponse is List<dynamic>) {
          paymentList = parsedResponse;
        } else if (parsedResponse is Map<String, dynamic>) {
          paymentList = [parsedResponse];
        }
      });
    } else {
      dev.log("++++++++++Status Code +++++++++++++++");
      dev.log(response.statusCode.toString());
    }
  }

  textFieldDecoration(String hintText, bool val) {
    return InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(color: val ? Colors.blue : Colors.blue)),
      constraints: BoxConstraints(maxHeight: val == true ? 35 : 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue)),
    );
  }

  textFieldPaymentDecoration(String hintText, bool val) {
    return InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(color: val ? Colors.blue : Colors.blue)),
      constraints: BoxConstraints(maxHeight: val == true ? 35 : 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      contentPadding: const EdgeInsets.fromLTRB(5, 00, 10, 0),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue)),
    );
  }

  textFieldToggleDecoration(String hintText, bool val) {
    return InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: val ? Colors.blue : Colors.blue)
        ),
        constraints: BoxConstraints(maxHeight: val == true ? 35 : 35),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14),
        counterText: '',
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: mTextFieldBorder)
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)
        ),
        filled: val ? false : true,
        fillColor: val ? Colors.white : Colors.grey[200]
    );
  }

  customPopupDecoration(
      {required String hintText, bool? error, bool? isFocused}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(
          Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isFocused == true ? Colors.blue : error == true
                  ? mErrorColor
                  : mTextFieldBorder)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: error == true ? mErrorColor : mTextFieldBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: error == true ? mErrorColor : Colors.blue)),
    );
  }

  editDocketCard(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, setState){
              return SizedBox(child: Stack(children: [
                Container(width: 650,
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),
                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                    child:SingleChildScrollView(
                        child:Form(
                          key:vehicleDataCard,
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                                decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                                child:Column(children: [
                                  // Top container.
                                  Container(color: Colors.grey[100],
                                    child: IgnorePointer(ignoring: true,
                                      child: MaterialButton(
                                        hoverColor: Colors.transparent,
                                        onPressed: () {

                                        },
                                        child: const Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Edit Vehicle Data',
                                                  style: TextStyle(fontWeight: FontWeight.bold,
                                                    fontSize: 16,),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1,color:mTextFieldBorder),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Column(children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Variant")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: variantError ? 60 : 35,
                                                  child:
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          variantError = true;
                                                        });
                                                        return "Enter Variant Name";
                                                      } else {
                                                        setState(() {
                                                          variantError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: variantController,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Variant', error:variantError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                          const SizedBox(width: 35,),
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Type")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: typeError ? 60 : 35,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          typeError = true;
                                                        });
                                                        return "Enter Type";
                                                      } else {
                                                        setState(() {
                                                          typeError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: typeController,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Type', error:typeError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                        ],),
                                      const SizedBox(height:20),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Color")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: colorError ? 60 : 35,
                                                  child:
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          colorError = true;
                                                        });
                                                        return "Enter Color Name";
                                                      } else {
                                                        setState(() {
                                                          colorError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: colorController,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Color Name', error:colorError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                          const SizedBox(width: 35,),
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Vehicle Type Code")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: vehicleCodeError ? 60 : 35,
                                                  child:
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          vehicleCodeError = true;
                                                        });
                                                        return "Enter Vehicle Type Code";
                                                      } else {
                                                        setState(() {
                                                          vehicleCodeError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: vehicleTypeCodeCon,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Vehicle Type Code', error:vehicleCodeError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                        ],),
                                      const SizedBox(height:20),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Transmission")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: transmissionError ? 60 : 35,
                                                  child:
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          transmissionError = true;
                                                        });
                                                        return "Enter Transmission price";
                                                      } else {
                                                        setState(() {
                                                          transmissionError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: transmissionController,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Transmission Price', error:transmissionError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                          const SizedBox(width: 35,),
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Category Code")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: categoryError ? 60 : 35,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          categoryError = true;
                                                        });
                                                        return "Enter Category Code";
                                                      } else {
                                                        setState(() {
                                                          categoryError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: categoryCodeController,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Category Code', error:categoryError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                        ],),
                                      const SizedBox(height:20),
                                      const Align(alignment: Alignment.bottomLeft,
                                        child: Text("Prices", style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 16,),),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Ex-showroom Price")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: exShowroomError ? 60 : 35,
                                                  child:
                                                  TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          exShowroomError = true;
                                                        });
                                                        return "Enter Ex-showroom price";
                                                      } else {
                                                        setState(() {
                                                          exShowroomError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: exShowroomPriceCon,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Ex-showroom Price', error:exShowroomError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                          const SizedBox(width: 35,),
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Model Code")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: modelError ? 60 : 35,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          modelError = true;
                                                        });
                                                        return "Enter Labour Type";
                                                      } else {
                                                        setState(() {
                                                          modelError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: modelController,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Labour Type', error:modelError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                        ],),
                                      const SizedBox(height:20),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child:Text("Labour Type")),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: labourError ? 60 : 35,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          labourError = true;
                                                        });
                                                        return "Enter Labour Type";
                                                      } else {
                                                        setState(() {
                                                          labourError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: labourTypeCon,
                                                    decoration: decorationInput5(
                                                        hintString:'Enter Labour Type', error:labourError),
                                                  ),
                                                ),
                                              ],),
                                          ),
                                          const SizedBox(width: 35,),
                                          Expanded(
                                            child: Column(children: [
                                              Container()
                                            ],),
                                          ),
                                        ],),
                                      const SizedBox(height: 35,),
                                      Align(
                                        alignment: Alignment.center,
                                        child:  SizedBox(
                                          width: 100,
                                          height:30,
                                          child: OutlinedMButton(
                                            text: 'Save',
                                            buttonColor:mSaveButton ,
                                            textColor: Colors.white,
                                            borderColor: mSaveButton,
                                            onTap:(){
                                              loading= true;
                                              if(vehicleDataCard.currentState!.validate()){
                                                customerDetails = {
                                                  "general_id": widget.docketData["general_id"],
                                                  "make": displayDocketDetails["make"],
                                                  "model_name": displayDocketDetails["model_name"],
                                                  "type": typeController.text,
                                                  "transmission": transmissionController.text,
                                                  "color":colorController.text,
                                                  "labour_type": labourTypeCon.text,
                                                  "model_code": modelController.text,
                                                  "ex_showroom_price": exShowroomPriceCon.text,
                                                  "vehicle_category_code": categoryCodeController.text,
                                                  "vehicle_type_code":vehicleTypeCodeCon.text,
                                                  "onroad_price": displayDocketDetails["onroad_price"],
                                                  "varient_name": variantController.text,


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
                                                print("---------------");
                                                print(customerDetails);
                                                updateCustomerDetails(customerDetails);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],),
                                  )
                                ],)
                            ),
                          ),

                        )
                    )
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
              ]),);
            },
          ));
    });
  }
  decorationInput5({required String hintString, bool? error,}) {
    return InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: "",
      contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      hintStyle: const TextStyle(fontSize: 14),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      focusedBorder:   const OutlineInputBorder(
          borderSide:  BorderSide(color:Colors.blue )),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
    );
  }

  Widget buildCustomToggleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 40,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: value ? Colors.green : Colors.grey,
        ),
        child: Stack(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
