// import 'dart:io';
//
//
// import 'package:flutter/material.dart';
//
// import 'package:motows_web/widgets/api/pdf_api.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:http/http.dart' as http;
//
// customStyle(double i,{fontWight}) {
//   if(fontWight ==pw. FontWeight.bold) {
//     return pw.TextStyle(fontSize: i,fontWeight:pw. FontWeight.bold,);
//   } else {
//     return pw.TextStyle(fontSize: i,);
//   }
// }
// class PdfInvoiceApi {
//
//
//   static Future<File> generate(Map<dynamic, dynamic> completedList, String orgName, String orgAddress, String customerName, Map<dynamic, dynamic> vehicleDetails, Map<dynamic, dynamic> customerDetails) async {
//     final pdf = pw.Document();
//     // var response = await http.get(Uri.parse('https://www.withyouhamesha.com/images/mahindra-r.png'));
//     // var data = response.bodyBytes;
//
//     pdf.addPage(pw.MultiPage(
//       build: (context) => [
//         pw.Column(
//           children: [
//             pw.Text("LLLLLLLLLLl");
//           ]
//         )
//       ],
//     ));
//
//     return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
//
//   }
// }
