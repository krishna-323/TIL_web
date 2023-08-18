// import 'dart:html';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' ;
import 'dart:io';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf, bool? view,
  }) async {
    final bytes = await pdf.save();

    final dir = (await getExternalStorageDirectories(type: StorageDirectory.downloads))!.first;
    final file = File("${dir.path}/$name");

    await file.writeAsBytes(bytes);
    if(view==true) {
      //  await OpenFile.open(file.path);
    }

    return file;
  }
}

class PdfGenerate{
  static Future<Uint8List> generate({
    required String color,
    required String customerName,
    required String mobile,
    required String emailId,
    required String address,
    required String pan,
    required String make,
    required String model,
    required String variant,
    required String exShowroomPrice,
    required String transmission,
    required String onRoadPrice,
    required String existingCarModel,
    required String evaluationDate,
    required String financeCompany,
    required String financeAmount,
    required String customerNotes,
    required String exchange,
    required String carFinance,
    required String termsAndConditions,
  }) async{
    final pdf = Document();
    final imageA = MemoryImage(
      (await rootBundle.load("assets/logo/img_1.png"))
          .buffer
          .asUint8List(),
    );
    pdf.addPage(
      MultiPage(
        build: (context) => [
          header(imageA),
          customerDetails(customerName, mobile, emailId, pan, address),
          vehicleDetails(model, variant, color, onRoadPrice, transmission, exShowroomPrice),
          if(exchange == "Yes" || carFinance == "Yes")
          orderDetails(exchange, existingCarModel, evaluationDate, carFinance, financeAmount, financeCompany),
          // termsAndConditionDetails(termsAndConditions),
          Text(
            "Terms And Conditions",
            style: TextStyle(
              color: PdfColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Paragraph(
              text: termsAndConditions,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10,)
          ),
          SizedBox(height: 5),
          // customerNotesDetails(customerNotes),
          Text(
            "Customer Notes",
            style: TextStyle(
              color: PdfColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Paragraph(
              text: customerNotes,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10,)
          ),
        ],
      )
    );
    return pdf.save();
  }

  static Widget header(MemoryImage imageA){
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 75,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              color: PdfColor.fromHex("#4C6971FF"),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                      height: 65,
                      child: Image(
                          imageA,
                        height: 50,
                        fit: BoxFit.fitHeight
                      ),
                    )
                )
              ]
            ),
          ),
          Divider(height: 1),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text("Ikyam Solutions Private Limited, 5, 80 Feet Rd, 4th Block, New Friends Colony, Koramangala",
                          style: const TextStyle(
                            fontSize: 10,
                            color: PdfColors.green900,
                          )
                        ),
                        SizedBox(height: 10),
                        Text("Contact Us: +917899726639  E-mail: info@ikyam.com",
                            style:const TextStyle(color: PdfColors.green900, fontSize: 10)
                        )
                      ]
                    )
                  ]
                ),
              )
          )
        ]
      ),
    );
  }
  static Widget customerDetails(String customerName, String mobile, String emailId, String pan, String address) {
    return Container(
        height: 130,
        child: Padding(
            padding: const EdgeInsets.only(left: 10),
          child: Row(
              children: [
                Expanded(
                  child: Container(
                      height: 100,
                      child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 70,
                                    child: Text("Customer Name",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    width: 90,
                                    child: Text(": $customerName",style: const TextStyle(fontSize: 10)),
                                  ),
                                ]
                            ),
                            SizedBox(height: 10),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 70,
                                    child: Text("Mobile Number",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    width: 90,
                                    child: Text(": $mobile",style: const TextStyle(fontSize: 10)),
                                  ),
                                ]
                            ),
                            SizedBox(height: 10),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 70,
                                    child: Text("Address",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    width: 90,
                                    child: Text(": $address",style: const TextStyle(fontSize: 10)),
                                  ),
                                ]
                            ),
                          ]
                      )
                  ),
                ),
                Expanded(
                  child: Container(
                      height: 100,
                      child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    child: Text("Email Id",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Text(": "),
                                  Container(
                                    width: 200,
                                    child: Text(emailId,style: const TextStyle(fontSize: 10)),
                                  ),
                                ]
                            ),
                            SizedBox(height: 10),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    child: Text("PAN Number",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Text(": $pan",style: const TextStyle(fontSize: 10)),
                                  ),
                                ]
                            ),
                          ]
                      )
                  ),
                ),
              ]
          )
        )
    );
  }
  static Widget vehicleDetails(String model, String variant, String color, String onRoadPrice, String transmission, String exShowroomPrice){
    return Container(
        height: 130,
      child: Padding(
          padding: const EdgeInsets.only(left: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    height: 100,
                    child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                              children: [
                                Text(
                                  model,
                                  style: TextStyle(
                                      color: PdfColors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(height: 10),
                          Row(
                              children: [
                                Container(
                                  width: 50,
                                  child: Text("Variant",style: const TextStyle(fontSize: 10)),
                                ),
                                Text(": $variant",style: const TextStyle(fontSize: 10)),
                              ]
                          ),
                          SizedBox(height: 10),
                          Row(
                              children: [
                                Container(
                                  width: 50,
                                  child: Text("Color",style: const TextStyle(fontSize: 10)),
                                ),
                                Text(": $color",style: const TextStyle(fontSize: 10)),
                              ]
                          ),
                        ]
                    )
                ),
              ),
              Expanded(
                child: Container(
                    height: 100,
                    child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 90,
                                  child: Text(
                                    "On Road Price",
                                    style: TextStyle(
                                        color: PdfColors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    ": $onRoadPrice",
                                    style: TextStyle(
                                        color: PdfColors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(height: 10),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 90,
                                  child: Text("Transmission",style: const TextStyle(fontSize: 10)),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(": $transmission",style: const TextStyle(fontSize: 10)),
                                ),
                              ]
                          ),
                          SizedBox(height: 10),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 90,
                                  child: Text("Ex Showroom Price",style: const TextStyle(fontSize: 10)),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(": $exShowroomPrice",style: const TextStyle(fontSize: 10)),
                                ),
                              ]
                          ),
                        ]
                    )
                ),
              ),
            ]
        ),
      )
    );
  }
  static Widget orderDetails(String exchange, String existingCarModel, String evaluationDate, String carFinance, String financeAmount, String financeCompany){
    return Container(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            child: Row(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order Booking",style: TextStyle(fontWeight: FontWeight.bold,color:PdfColors.blue,fontSize: 12)),
                      SizedBox( height: exchange == "Yes" ? 20 : 0,),
                      if(exchange == "Yes")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // height: 10,
                                  width: 90,
                                  child: Text("Existing Car Model",style: const TextStyle(fontSize: 10)),
                                ),
                                Container(
                                  // height: 10,
                                  width: 10,
                                  child: Text(":",style: const TextStyle(fontSize: 10)),
                                ),
                                Container(
                                  // height: 10,
                                  width: 120,
                                  child: Text(existingCarModel,style: const TextStyle(fontSize: 10),overflow: TextOverflow.clip,maxLines: 3),
                                ),
                              ]
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    child: Text("Evaluation Date",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    // height: 10,
                                    width: 10,
                                    child: Text(":",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    // height: 10,
                                    width: 120,
                                    child: Text(evaluationDate,style: const TextStyle(fontSize: 10),overflow: TextOverflow.clip,maxLines: 3),
                                  ),
                                ]
                            )
                          ),
                        ],
                        ),
                      SizedBox( height: carFinance == "Yes" ? 10 : 0,),
                      if(carFinance == "Yes")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 90,
                                  child: Text("Finance Company",style: const TextStyle(fontSize: 10)),
                                ),
                                Container(
                                  // height: 10,
                                  width: 10,
                                  child: Text(":",style: const TextStyle(fontSize: 10)),
                                ),
                                Container(
                                  // height: 10,
                                  width: 120,
                                  child: Text(financeCompany,style: const TextStyle(fontSize: 10),overflow: TextOverflow.clip,maxLines: 3),
                                ),
                              ]
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    child: Text("Finance Amount",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    // height: 10,
                                    width: 10,
                                    child: Text(":",style: const TextStyle(fontSize: 10)),
                                  ),
                                  Container(
                                    // height: 10,
                                    width: 120,
                                    child: Text(financeAmount,style: const TextStyle(fontSize: 10),overflow: TextOverflow.clip,maxLines: 3),
                                  ),
                                ]
                            )
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
    );
  }
  static Widget termsAndConditionDetails(String termsAndConditions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 10),
        //   child: Text(
        //     "Terms And Conditions",
        //     style: TextStyle(
        //       color: PdfColors.blue,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        // SizedBox(height: 10),
        Paragraph(
          text: termsAndConditions,
          style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10,)
        ),// Adjust the spacing between title and content
        // Container(
        //   constraints: const BoxConstraints(maxHeight: double.infinity),
        //   child: Text(
        //     termsAndConditions,
        //     style: TextStyle(
        //       color: PdfColors.black,
        //       fontWeight: FontWeight.normal,
        //       fontSize: 10,
        //     ),
        //   )
        // )
      ],
    );
  }
  static Widget customerNotesDetails(String customerNotes)  {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                    text: "Customer Notes\n",
                    style: TextStyle(
                        color: PdfColors.blue,
                        fontWeight: FontWeight.bold
                    ),
                    children: [
                      const TextSpan(
                          text: '\n',
                          style: TextStyle(
                            fontSize: 10,
                          )
                      ),
                      TextSpan(
                          text: customerNotes,
                          style:  TextStyle(color: PdfColors.black,fontWeight: FontWeight.normal,fontSize: 10,)
                      )
                    ]
                ),
              )
          ),
        ]
    );
  }
}