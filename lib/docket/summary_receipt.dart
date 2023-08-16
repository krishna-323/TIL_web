import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/utils/customAppBar.dart';
import 'package:new_project/utils/customDrawer.dart';
import 'package:new_project/utils/custom_loader.dart';
import 'package:new_project/widgets/motows_buttons/outlined_mbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import '../pdf/report.dart';
import '../utils/static_data/motows_colors.dart';


class SummaryReceipt extends StatefulWidget {
  final Map<dynamic, dynamic> summaryDetails;
  final double drawerWidth;
  final double selectedDestination;
  final String date;
  const SummaryReceipt({
    super.key,
    required this.summaryDetails,
    required this.drawerWidth,
    required this.selectedDestination,
    required this.date
  });

  @override
  State<SummaryReceipt> createState() => _SummaryReceiptState();
}

class _SummaryReceiptState extends State<SummaryReceipt> {

  String? authToken;
  String userId="";
  Map summaryDetails={};
  bool loading = false;
  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
    userId= prefs.getString("userId")??"";
  }
  final customerName = TextEditingController();
  final mobile = TextEditingController();
  final emailId = TextEditingController();
  final pan = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final pinCode = TextEditingController();
  final financeCompany = TextEditingController();
  final financeAmount = TextEditingController();
  final existingCarModel = TextEditingController();
  final evaluationDate = TextEditingController();
  final customerNotes = TextEditingController();
  final termsAndCondition = TextEditingController();

  bool termsAndConditionValidate = false;
  bool customerNotesValidate = false;

  // CollectionReference users = FirebaseFirestore.instance.collection('mail');
  @override
  void initState() {
    getInitialData();
    super.initState();
    summaryDetails = widget.summaryDetails;
    customerName.text = summaryDetails['customer_name'];
    mobile.text = summaryDetails['mobile'];
    emailId.text = summaryDetails['email_id'];
    pan.text = summaryDetails['pan_number'];
    address.text = summaryDetails['street_address'];
    pinCode.text = summaryDetails['pin_code'];
    state.text = summaryDetails['city'];
    pinCode.text = summaryDetails['pin_code'];
    city.text = summaryDetails['location'];
    financeCompany.text = summaryDetails['finance_company'];
    financeAmount.text = summaryDetails['finance_amount'];
    existingCarModel.text = summaryDetails['car_model'];
    evaluationDate.text = summaryDetails['evaluation_date'];
  }
  late double sWidth;
  late double sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Order Booking",style: TextStyle(fontSize: 18,color: Colors.indigo[800],fontWeight: FontWeight.bold),),
                                  Text("Order Booking Date: ${widget.date}",style: TextStyle(fontSize: 14,color: Colors.indigo[900],fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all()
                              ),
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    color: const Color(0xFF4C6971),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: SizedBox(
                                            height: 100,
                                            child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Image(
                                              alignment: Alignment.center,
                                              image: AssetImage("assets/logo/img_1.png"),
                                            height: 70,
                                          ),
                                        )
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(color: Colors.black, height: 1),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10),
                                    child: Row(
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10,),
                                            Text("Ikyam Solutions Private Limited, 5, 80 Feet Rd, 4th Block, New Friends Colony, Koramangala, Bengaluru, Karnataka 560034",style: TextStyle(color: Colors.black54)),
                                            SizedBox(height: 10,),
                                            Text("Contact Us: +917899726639  E-mail: info@ikyam.com",style: TextStyle(color: Colors.black54)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.white10, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 20, left: 18,),
                                            child: Row(
                                              children: [
                                                Expanded(flex: 5,child: Text("${widget.summaryDetails['make']}  ${widget.summaryDetails['model']}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[800],fontSize: 16))),
                                                Expanded(flex: 2,child: Text("On Road Price : Rs ${widget.summaryDetails['onroad_price']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.indigo[800]))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,right: 18,top: 8,bottom: 15),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Varient")),
                                                    Text(": ${widget.summaryDetails['variant']} "),
                                                  ],
                                                ),
                                                const SizedBox( height: 20,),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Color")),
                                                    Text(": ${widget.summaryDetails['color']} "),
                                                  ],
                                                ),
                                                const SizedBox( height: 20,),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Ex- Showroom Price")),
                                                    Text(": ${widget.summaryDetails['ex_showroom_price']} "),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Type")),
                                                    Text(": ${widget.summaryDetails['type']} "),
                                                  ],
                                                ),
                                                const SizedBox( height: 20,),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Labour Type")),
                                                    Text(": Rs ${widget.summaryDetails['labour_type']}"),
                                                  ],
                                                ),
                                                const SizedBox( height: 20,),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Category Code")),
                                                    Text(": ${widget.summaryDetails['vehicle_category_code']}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Transmission")),
                                                    Expanded(child: Text(": ${widget.summaryDetails['transmission']} ")),
                                                  ],
                                                ),
                                                const SizedBox( height: 20,),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Model Code")),
                                                    Text(": ${widget.summaryDetails['model_code']} "),
                                                  ],
                                                ),
                                                const SizedBox( height: 20,),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 150,child: Text("Vehicle Type Code")),
                                                    Text(": ${widget.summaryDetails["vehicle_category_code"]}"),
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
                            ),
                            const SizedBox(height: 50,),
                            Column(
                              children: [
                                Container(
                                  height: 40,color: Colors.grey[200],
                                  child: const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(    left: 20.0),
                                        child: Text("Customer Details ",style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                                customerTab(),
                              ],
                            ),
                            const SizedBox(height: 50,),
                            if(widget.summaryDetails['exchange'] == "Yes" || widget.summaryDetails['car_finance'] == "Yes")
                            Column(
                              children: [
                                Container(
                                  height: 40,color: Colors.grey[200],
                                  child: const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(    left: 20.0),
                                        child: Text("Order Details ",style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                                orderDetails(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8,bottom: 20),
                                    child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Text("Terms and Conditions ",style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width/2.5,
                                            child:          Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Container(
                                                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5),border: Border.all(color: Colors.grey)),
                                                  height: 100,
                                                  child: TextFormField(
                                                    controller: termsAndCondition,
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: 4,minLines: 4,
                                                    validator: (value) {
                                                      if(value == null || value.isEmpty){
                                                        setState(() {
                                                          termsAndConditionValidate = true;
                                                        });
                                                        return "*required";
                                                      }setState(() {
                                                        termsAndConditionValidate = false;
                                                      });
                                                      return null;
                                                    },
                                                    decoration:  const InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder: InputBorder.none,
                                                      enabledBorder: InputBorder.none,
                                                      errorBorder: InputBorder.none,
                                                      disabledBorder: InputBorder.none,
                                                      contentPadding:EdgeInsets.only(left: 15, bottom: 10, top: 11, right: 15),
                                                    ),
                                                  ),
                                                )
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8,bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Text("Customer Notes ",style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width/2.5,
                                            child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: Colors.grey)
                                                  ),
                                                  height: 100,
                                                  child: TextFormField(
                                                    controller: customerNotes,
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: 4,minLines: 4,
                                                    validator: (value) {
                                                      if(value == null || value.isEmpty){
                                                        setState(() {
                                                          customerNotesValidate = true;
                                                        });
                                                        return "*required";
                                                      }setState(() {
                                                        customerNotesValidate = false;
                                                      });
                                                      return null;
                                                    },
                                                    decoration:  const InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder: InputBorder.none,
                                                      enabledBorder: InputBorder.none,
                                                      errorBorder: InputBorder.none,
                                                      disabledBorder: InputBorder.none,
                                                      contentPadding:EdgeInsets.only(left: 15, bottom: 10, top: 11, right: 15),
                                                    ),
                                                  ),
                                                )
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(height: 10,),
                             SizedBox(
                              width: 70,
                              height:30,
                              child: OutlinedMButton(
                                text: 'PDF',
                                buttonColor:mSaveButton ,
                                textColor: Colors.white,
                                borderColor: mSaveButton,
                                onTap:() async{
                                  if(termsAndConditionValidate || termsAndCondition.text.isEmpty && customerNotesValidate || customerNotes.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Please enter valid Terms & Conditions and Customer Notes")
                                        )
                                    );
                                    return;
                                  }
                                  final v =  await PdfGenerate.generate(
                                    color: widget.summaryDetails['color'].toString(),
                                    address: widget.summaryDetails['street_address'].toString(),
                                    customerName: widget.summaryDetails['customer_name'].toString(),
                                    customerNotes: customerNotes.text,
                                    emailId: widget.summaryDetails['email_id'].toString(),
                                    evaluationDate: widget.summaryDetails['evaluation_date'].toString(),
                                    existingCarModel: widget.summaryDetails['car_model'].toString(),
                                    exShowroomPrice: widget.summaryDetails['ex_showroom_price'].toString(),
                                    financeAmount: widget.summaryDetails['finance_amount'].toString(),
                                    financeCompany: widget.summaryDetails['finance_company'].toString(),
                                    make: widget.summaryDetails['make'].toString(),
                                    mobile: widget.summaryDetails['mobile'].toString(),
                                    model: widget.summaryDetails['model'].toString(),
                                    onRoadPrice: widget.summaryDetails['onroad_price'].toString(),
                                    pan: widget.summaryDetails['pan_number'].toString(),
                                    transmission: widget.summaryDetails['transmission'].toString(),
                                    variant: widget.summaryDetails['variant'].toString(),
                                    termsAndConditions: termsAndCondition.text,
                                    exchange: widget.summaryDetails['exchange'],
                                    carFinance: widget.summaryDetails['car_finance'],
                                  );
                                  if(termsAndCondition.text.isNotEmpty && customerNotes.text.isNotEmpty){
                                    html.Blob blob = html.Blob([v], 'application/pdf');
                                    final url = html.Url.createObjectUrlFromBlob(blob);
                                    html.window.open(url, "_blank");
                                    html.Url.revokeObjectUrl(url);
                                  }
                                  // users.add({
                                  //   'to': emailId.text, // John Doe
                                  //   'message': {
                                  //     'subject':"Motows Web Invoice",
                                  //     'text':"This is Email body",
                                  //     "html": 'This is the <code>HTML</code> section of the email body.',
                                  //     "attachments": [{
                                  //       'filename': 'invoice.pdf',
                                  //       "path": "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(v)}"
                                  //     }]
                                  //   } // 42
                                  // })
                                  //     .then((value) {
                                  //   dev.log("User Added");
                                  // })
                                  //     .catchError((error) {
                                  //   dev.log("Failed to add user: $error");
                                  // });
                                },
                              ),
                            ),
                      ],
                        ),
                      ),
                    )
                ),
              )
          )
        ],
      ),
    );
  }
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
                      controller: customerName,
                      decoration: textFieldDecoration("Customer Name", customerName.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
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
                      decoration: textFieldDecoration("Email ID", emailId.text.isNotEmpty),
                    ),
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
                            RegExp(r'^(\d+)?\.?\d{0,2}')
                        )
                      ],
                      maxLength: 10,
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: mobile,
                      decoration: textFieldDecoration("Mobile", mobile.text.isNotEmpty),
                    ),
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
                      controller: pan,
                      decoration: textFieldDecoration("PAN Number", pan.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
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
                      controller: address,
                      decoration: textFieldDecoration("Address  1", address.text.isNotEmpty),
                    ),
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
                      decoration: textFieldDecoration("State", state.text.isNotEmpty),),
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
                      controller: pinCode,
                      decoration: textFieldDecoration("Pin Code", pinCode.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }
  orderDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           SizedBox(height: widget.summaryDetails['exchange'] == "Yes" ? 20 : 0,),
          if(widget.summaryDetails['exchange'] == "Yes")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Existing Car Model"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: existingCarModel,
                      decoration: textFieldDecoration("Existing Car Model", existingCarModel.text.isNotEmpty),),
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
                      controller: evaluationDate,
                      decoration: textFieldDecoration("Evaluation Date", evaluationDate.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(child: Container()),
            ],
          ),
           SizedBox(height: widget.summaryDetails['car_finance'] == "Yes" ? 20 : 0,),
          if(widget.summaryDetails['car_finance'] == "Yes")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Finance Company"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: financeCompany,
                      decoration: textFieldDecoration("Finance Company", financeCompany.text.isNotEmpty),),
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
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 6,
                      style: const TextStyle(fontSize: 14),
                      onChanged: (text) {
                        setState(() {

                        });
                      },
                      controller: financeAmount,
                      decoration: textFieldDecoration("Finance Amount", financeAmount.text.isNotEmpty),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40,),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
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
      enabledBorder:  const OutlineInputBorder(
          borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue)),
    );
  }
}
