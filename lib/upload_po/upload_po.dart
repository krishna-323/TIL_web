// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
// import 'package:csv/csv.dart';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../classes/arguments_classes/arguments_classes.dart';
// import '../utils/api/getApi.dart';
// import '../utils/api/post_api.dart';
// import '../utils/customAppBar.dart';
// import '../utils/customDrawer.dart';
// import '../utils/custom_loader.dart';
// import '../utils/static_data/motows_colors.dart';
//
// class UploadPO extends StatefulWidget {
//   final UploadDataArguments args;
//   const UploadPO({Key? key, required this.args}) : super(key: key);
//
//   @override
//   State<UploadPO> createState() => _UploadPOState();
// }
//
// class _UploadPOState extends State<UploadPO> {
//
//
//   List selectedFields =[];
//   bool checkAll = false;
//   bool visibleDelete = false;
//   List poList=[];
//   List newData=[];
//   bool isLoading = true;
//   List displayList=[];
//   int startVal=0;
//   final verticalScroll=ScrollController();
//   final horizontalScroll=ScrollController();
//   // Declarations For XLSX.
//   List firstSheetData=[];
//   List nameOfHeaders=[];
//   List<List<dynamic>> _fileContents=[];
//   bool xlsx=false;
//
//   // Declarations For CSV File.
//   bool csv =false;
//   List<List<dynamic>> csvData = [];
//   final csvVerticalScroll=ScrollController();
//   final csvHorizontalScroll=ScrollController();
//   void _loadCSVorXlSX() async {
//     // Wait Key Word ,For Selecting Type Of Files.(File type picking "csv" or "xlsx")
//     final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['csv',"xlsx"],
//         allowMultiple: true
//     );
//     final typeOfFile =result?.files.single.name;
//     try{
//       if(result==null || result.files.isEmpty){
//         return null;
//       }
//       else if(typeOfFile!.endsWith('.csv')){
//         // excel data it will convert to bytes code.
//         final bytes = result.files.first.bytes!.toList();
//         xlsx=false;
//         csv=true;
//         print('----Selected File Is csv File----');
//         setState(() {
//           // we are assigning excel list data to( "csvData" is a empty list).
//           // utf8.decode() is function it will convert bytes to characters as a string.
//           csvData = const CsvToListConverter().convert(utf8.decode(bytes));
//         });
//       }
//       else if(typeOfFile.endsWith(".xlsx")){
//         csv=false;
//         xlsx=true;
//         print('--------Selected File Is xlsx------');
//         var bytes= result.files.single.bytes;
//         if(bytes !=null){
//           var excel =Excel.decodeBytes(bytes);
//           final headerItems=excel.tables[excel.tables.keys.first];
//           final headerRow=headerItems?.rows.first;
//           for(int firstHeaderName=0;firstHeaderName<headerRow!.length;firstHeaderName++){
//             nameOfHeaders.add(headerRow[firstHeaderName]!.props.first);
//           }
//           //Multiple Sheets Names.
//           firstSheetData= excel.tables.keys.toList();
//           var sheet =excel[firstSheetData[0]];
//           final rows=sheet.rows;
//           setState(() {
//             _fileContents=rows.map((row)=>row.map((cell)=>cell?.value).toList()).toList();
//           });
//         }
//       }
//       else{
//         print('Unsupported file');
//       }
//     }
//     catch(e){
//       print(e.toString());
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchPoData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width=MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar:  const PreferredSize(  preferredSize: Size.fromHeight(60),
//           child: CustomAppBar()),
//       body:Row(crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomDrawer(widget.args.drawerWidth,widget.args.selectedDestination),
//           const VerticalDivider(
//             width: 1,
//             thickness: 1,
//           ),
//           Expanded(
//             child:Container(
//               color: Colors.white,
//               child: Column(
//                 //crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Padding(
//                     padding:  const EdgeInsets.only(top: 8,left: 40,right: 40),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children:  [
//                         SizedBox(  width: 190,height: 30, child: TextFormField(
//                           controller: selectedDateText,
//                           onTap: (){
//                             _selectDate(context);
//                           },
//                           readOnly: true,
//                           style: TextStyle(fontSize: 14),
//                           keyboardType: TextInputType.text,
//                           decoration: customSearchDecoration(hintText: 'Search by date'),
//                         ),
//                         ),
//                         Row(
//                           children: [
//
//                             const SizedBox(width: 10,),
//                             MaterialButton(
//                               onPressed: () {
//                                 exportToExcel();
//                               },
//                               color: Colors.blue,
//                               child: const Icon(Icons.document_scanner_outlined,color: Colors.white),),
//                             const SizedBox(width: 10,),
//                             MaterialButton(onPressed: () async{
//
//                               _loadCSVorXlSX();
//                               // importExcelData().whenComplete(() {
//                               //   saveExcelData(newData).whenComplete(() {
//                               //   });
//                               // });
//                             },
//                               color: Colors.blue,
//                               child: const Text("+ Upload",style: TextStyle(color: Colors.white)),),
//                             if(visibleDelete)
//                               Row(
//                                 children: [
//                                   const SizedBox(width: 10,),
//                                   MaterialButton(minWidth: 20,
//                                     onPressed: () {
//                                       // exportToExcel();
//
//                                       if(selectedFields.isNotEmpty){
//                                         for(int i=0;i<selectedFields.length;i++){
//                                           deletePoData(selectedFields[i]).then((value) {
//                                           });
//                                         }
//                                       }
//                                     },
//                                     color: Colors.red,
//                                     child: const Icon(Icons.delete_forever_sharp,color: Colors.white,size: 18),),
//
//                                 ],
//                               ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   // ElevatedButton(
//                   //   onPressed: _loadCSVorXlSX,
//                   //   child: Text('Load Excel File'),
//                   // ),
//                   if(csvData.isNotEmpty && csv==true )
//                     Expanded(
//                       child: AdaptiveScrollbar(position: ScrollbarPosition.right,
//                         controller: csvVerticalScroll,
//                         sliderDefaultColor: Colors.grey,
//                         sliderActiveColor: Colors.grey,
//                         width: 12,
//                         child: AdaptiveScrollbar(width: 12,
//                           controller: csvHorizontalScroll,
//                           position: ScrollbarPosition.bottom,
//                           sliderActiveColor: Colors.grey,
//                           sliderDefaultColor: Colors.grey,
//                           child: SingleChildScrollView(
//                             controller: csvHorizontalScroll,
//                             scrollDirection: Axis.horizontal,
//                             child: SingleChildScrollView(scrollDirection: Axis.vertical,
//                               controller: csvVerticalScroll,
//                               child: DataTable(
//                                 columns: csvData.isNotEmpty ? csvData.first.map((title) => DataColumn(label: Text(title,style: const TextStyle(fontSize: 15,
//                                     fontWeight: FontWeight.bold),),)).toList() : [],
//                                 rows: csvData.length > 1 ? csvData.skip(1).map((row) => DataRow(cells: row.map((cell) {
//                                   print('-------cell data-------');
//                                   print(cell);
//                                   return DataCell(
//                                     Container(
//                                         child: Text('$cell')));
//                                 }).toList())).toList() : [],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   if(xlsx==true)
//                     if(width>1100)
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: buildTable(),
//                         ),
//                       ),
//                   if(xlsx==true)
//                     if(width<1100)
//                       Expanded(
//                         child: SizedBox(
//                           width: 2340,
//                           child: AdaptiveScrollbar(
//                             controller: verticalScroll,
//                             child: AdaptiveScrollbar(
//                               width: 12,
//                               sliderDefaultColor: Colors.grey,
//                               sliderActiveColor: Colors.grey,
//                               position: ScrollbarPosition.bottom,
//                               controller: horizontalScroll,
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 controller: horizontalScroll,
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.vertical,
//                                   controller: verticalScroll,
//                                   child: Row( children: [
//                                     SizedBox(
//                                       width: 1500,
//                                       child: buildTable(),
//                                     ),
//                                   ], ), ),
//                               ),
//                             ),
//                           ), ),
//                       ),
//                 ],
//               ),
//             ),
//
//             // Container(
//             //   height: MediaQuery.of(context).size.height,
//             //   color:Colors.grey[50],
//             //   child: CustomLoader(
//             //     inAsyncCall: isLoading,
//             //     child: SingleChildScrollView(
//             //       child: Padding(
//             //         padding: const EdgeInsets.only(left: 40.0,right: 40,top:30),
//             //         child: Container(
//             //           decoration: BoxDecoration(
//             //               color: Colors.white,
//             //               borderRadius: BorderRadius.circular(10),
//             //               border: Border.all(color:const Color(0xFFE0E0E0) )
//             //           ),
//             //           child: Column(
//             //             children: [
//             //
//             //
//             //               const SizedBox(height: 18,),
//             //               Padding(
//             //                 padding:  const EdgeInsets.only(top: 8,left: 40,right: 40),
//             //                 child: Row(
//             //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                   children:  [
//             //                     SizedBox(  width: 190,height: 30, child: TextFormField(
//             //                       controller: selectedDateText,
//             //                       onTap: (){
//             //                         _selectDate(context);
//             //                       },
//             //                       readOnly: true,
//             //                       style: TextStyle(fontSize: 14),
//             //                       keyboardType: TextInputType.text,
//             //                       decoration: customSearchDecoration(hintText: 'Search by date'),
//             //                     ),
//             //                     ),
//             //                     Row(
//             //                       children: [
//             //
//             //                         const SizedBox(width: 10,),
//             //                         MaterialButton(
//             //                           onPressed: () {
//             //                             exportToExcel();
//             //                           },
//             //                           color: Colors.blue,
//             //                           child: const Icon(Icons.document_scanner_outlined,color: Colors.white),),
//             //                         const SizedBox(width: 10,),
//             //                         MaterialButton(onPressed: () async{
//             //
//             //                           _loadCSVorXlSX();
//             //                           // importExcelData().whenComplete(() {
//             //                           //   saveExcelData(newData).whenComplete(() {
//             //                           //   });
//             //                           // });
//             //                         },
//             //                           color: Colors.blue,
//             //                           child: const Text("+ Upload",style: TextStyle(color: Colors.white)),),
//             //                         if(visibleDelete)
//             //                           Row(
//             //                             children: [
//             //                               const SizedBox(width: 10,),
//             //                               MaterialButton(minWidth: 20,
//             //                                 onPressed: () {
//             //                                   // exportToExcel();
//             //
//             //                                   if(selectedFields.isNotEmpty){
//             //                                     for(int i=0;i<selectedFields.length;i++){
//             //                                       deletePoData(selectedFields[i]).then((value) {
//             //                                       });
//             //                                     }
//             //                                   }
//             //                                 },
//             //                                 color: Colors.red,
//             //                                 child: const Icon(Icons.delete_forever_sharp,color: Colors.white,size: 18),),
//             //
//             //                             ],
//             //                           ),
//             //                       ],
//             //                     )
//             //                   ],
//             //                 ),
//             //               ),
//             //               const SizedBox(height: 18,),
//             //              Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
//             //               Container(color: Colors.grey[200],
//             //                 child: Padding(
//             //                   padding: const EdgeInsetsDirectional.only(start: 26.0, end: 10.0,bottom: 4,top: 4),
//             //                   child: Row(
//             //                     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                     children: [
//             //
//             //                       Expanded(
//             //                         child: SizedBox(width: 30,height: 30,
//             //                           child: Transform.scale(
//             //                             scale: 0.8,
//             //                             child: Checkbox(
//             //                               value: visibleDelete==false?false:checkAll,
//             //                               onChanged: ( value)  {
//             //                                 setState(() {
//             //                                   selectedFields=[];
//             //                                   checkAll = value!;
//             //                                   for(int i=0;i<poList.length;i++){
//             //                                     if(value==true){
//             //                                       selectedFields.add(poList[i]['excel_id']);
//             //                                     }
//             //                                     else{
//             //                                       selectedFields=[];
//             //                                     }
//             //                                     if(selectedFields.isEmpty) {
//             //                                       visibleDelete =false;
//             //                                     } else{
//             //                                       visibleDelete = true;
//             //                                     }
//             //                                   }
//             //                                 });
//             //                               },
//             //
//             //                             ),
//             //                           ),
//             //                         ),
//             //                       ),
//             //                       //Expanded(child: Text(displayList[i]['make'].toString(),overflow: TextOverflow.ellipsis,)),
//             //                       const Expanded(
//             //                           child: Padding(
//             //                             padding: EdgeInsets.only(top: 4.0),
//             //                             child: SizedBox(height: 25,
//             //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                 child: Text("Make",overflow: TextOverflow.ellipsis,)
//             //                             ),
//             //                           )),
//             //                       const Expanded(
//             //                           child: Padding(
//             //                             padding: EdgeInsets.only(top: 4.0),
//             //                             child: SizedBox(height: 25,
//             //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                 child: Text("Model",overflow: TextOverflow.ellipsis,)
//             //                             ),
//             //                           )),
//             //                       const Expanded(
//             //                           child: Padding(
//             //                             padding: EdgeInsets.only(top: 4.0),
//             //                             child: SizedBox(height: 25,
//             //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                 child: Text("Varient",overflow: TextOverflow.ellipsis,)
//             //                             ),
//             //                           )),
//             //                       const Expanded(
//             //                           child: Padding(
//             //                             padding: EdgeInsets.only(top: 4.0),
//             //                             child: SizedBox(height: 25,
//             //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                 child:Text("Date",overflow: TextOverflow.ellipsis,)
//             //                             ),
//             //                           )),
//             //                       const Expanded(
//             //                           child: Padding(
//             //                             padding: EdgeInsets.only(top: 4.0),
//             //                             child: SizedBox(height: 25,
//             //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                 child:Text("On-Road Price",overflow: TextOverflow.ellipsis,)
//             //                             ),
//             //                           )),
//             //                       const Expanded(
//             //                           child: Padding(
//             //                             padding: EdgeInsets.only(top: 4.0),
//             //                             child: SizedBox(height: 25,
//             //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                 child:Text("Color",overflow: TextOverflow.ellipsis,)
//             //                             ),
//             //                           )),
//             //                       const Expanded(
//             //                           child: Padding(
//             //                             padding: EdgeInsets.only(top: 4.0),
//             //                             child: SizedBox(height: 25,
//             //                                 //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                 child:Text("Year of Manufacture",overflow: TextOverflow.ellipsis,)
//             //                             ),
//             //                           )),
//             //
//             //                     ],
//             //                   ),
//             //                 ),
//             //               ),
//             //               Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
//             //               for(int i=0;i<=displayList.length;i++)
//             //                 Column(
//             //                   children: [
//             //
//             //                     if(i!=displayList.length)
//             //                       MaterialButton(
//             //                         onPressed: () {  },
//             //                         hoverColor: Colors.blue[50],
//             //                         child: Padding(
//             //                           padding: const EdgeInsets.only(left:18.0,top:4,bottom: 3),
//             //                           child: Row(
//             //                             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //                             children: [
//             //
//             //                               Expanded(
//             //                                 child: SizedBox(width: 30,height: 30,
//             //                                   child: Transform.scale(
//             //                                     scale: 0.8,
//             //                                     child: Checkbox(
//             //                                       value: selectedFields.contains(displayList[i]['excel_id']),
//             //                                       onChanged: ( value) {
//             //                                         // print('-------------');
//             //                                         // print(fieldValues[i]);
//             //                                         // print('-------value------');
//             //                                         // print(i);
//             //                                         // print(value);
//             //                                         setState(() {
//             //                                           if(value==true){
//             //                                             selectedFields.add(displayList[i]['excel_id']);
//             //                                           }
//             //                                           else
//             //                                           {
//             //                                             checkAll=false;
//             //                                             selectedFields.remove(displayList[i]['excel_id']);
//             //                                           }
//             //                                           if(selectedFields.isEmpty) {
//             //                                             visibleDelete =false;
//             //                                           }
//             //                                           else{
//             //                                             visibleDelete = true;
//             //                                           }
//             //                                         });
//             //                                       },
//             //
//             //                                     ),
//             //                                   ),
//             //                                 ),
//             //                               ),
//             //                               //Expanded(child: Text(displayList[i]['make'].toString(),overflow: TextOverflow.ellipsis,)),
//             //                               Expanded(
//             //                                   child: Padding(
//             //                                     padding: const EdgeInsets.only(top: 4.0),
//             //                                     child: SizedBox(height: 25,
//             //                                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                         child: Text(displayList[i]['make'].toString(),overflow: TextOverflow.ellipsis,)
//             //                                     ),
//             //                                   )),
//             //                               Expanded(
//             //                                   child: Padding(
//             //                                     padding: const EdgeInsets.only(top: 4.0),
//             //                                     child: SizedBox(height: 25,
//             //                                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                         child: Text(displayList[i]['model'].toString(),overflow: TextOverflow.ellipsis,)
//             //                                     ),
//             //                                   )),
//             //                               Expanded(
//             //                                   child: Padding(
//             //                                     padding: const EdgeInsets.only(top: 4.0),
//             //                                     child: SizedBox(height: 25,
//             //                                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                         child: Text(displayList[i]['varient'].toString(),overflow: TextOverflow.ellipsis,)
//             //                                     ),
//             //                                   )),
//             //                               Expanded(
//             //                                   child: Padding(
//             //                                     padding: const EdgeInsets.only(top: 4.0),
//             //                                     child: SizedBox(height: 25,
//             //                                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                         child:Text(displayList[i]['date'].toString(),overflow: TextOverflow.ellipsis,)
//             //                                     ),
//             //                                   )),
//             //                               Expanded(
//             //                                   child: Padding(
//             //                                     padding: const EdgeInsets.only(top: 4.0),
//             //                                     child: SizedBox(height: 25,
//             //                                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                         child:Text(displayList[i]['on_road_price'].toString(),overflow: TextOverflow.ellipsis,)
//             //                                     ),
//             //                                   )),
//             //                               Expanded(
//             //                                   child: Padding(
//             //                                     padding: const EdgeInsets.only(top: 4.0),
//             //                                     child: SizedBox(height: 25,
//             //                                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                         child:Text(displayList[i]['color'].toString(),overflow: TextOverflow.ellipsis,)
//             //                                     ),
//             //                                   )),
//             //                               Expanded(
//             //                                   child: Padding(
//             //                                     padding: const EdgeInsets.only(top: 4.0),
//             //                                     child: SizedBox(height: 25,
//             //                                         //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//             //                                         child:Text(displayList[i]['year_of_manufacture'].toString(),overflow: TextOverflow.ellipsis,)
//             //                                     ),
//             //                                   )),
//             //
//             //                             ],
//             //                           ),
//             //                         ),
//             //                       ),
//             //                     if(i!=displayList.length)
//             //                       Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
//             //                     if(i==displayList.length)
//             //                       Row(mainAxisAlignment: MainAxisAlignment.end,
//             //                         children: [
//             //                           Builder(
//             //                             builder: (context) {
//             //                               return Text("${startVal+15>poList.length?poList.length:startVal+1}-${startVal+15>poList.length?poList.length:startVal+15} of ${poList.length}",style: const TextStyle(color: Colors.grey));
//             //                             }
//             //                           ),
//             //                           const SizedBox(width: 10,),
//             //                           Material(color: Colors.transparent,
//             //                             child: InkWell(
//             //                               hoverColor: mHoverColor,
//             //                               child: const Padding(
//             //                                 padding: EdgeInsets.all(18.0),
//             //                                 child: Icon(Icons.arrow_back_ios_sharp,size: 12),
//             //                               ),
//             //                               onTap: (){
//             //                                 if(startVal>14){
//             //                                   displayList=[];
//             //                                   startVal = startVal-15;
//             //                                   for(int i=startVal;i<startVal+15;i++){
//             //                                     setState(() {
//             //                                       displayList.add(poList[i]);
//             //                                     });
//             //                                   }
//             //                                 }
//             //                                 else{
//             //                                   print('else');
//             //                                 }
//             //
//             //                               },
//             //                             ),
//             //                           ),
//             //                           const SizedBox(width: 10,),
//             //                           Material(color: Colors.transparent,
//             //                             child: InkWell(
//             //                               hoverColor: mHoverColor,
//             //                               child: const Padding(
//             //                                 padding: EdgeInsets.all(18.0),
//             //                                 child: Icon(Icons.arrow_forward_ios,size: 12),
//             //                               ),
//             //                               onTap: (){
//             //                                 if(startVal+1+5>poList.length){
//             //                                   log("$startVal is > 5");
//             //                                 }
//             //                                 else
//             //                                 if(poList.length>startVal+15){
//             //                                   displayList=[];
//             //                                   startVal=startVal+15;
//             //                                   for(int i=startVal;i<startVal+15;i++){
//             //                                     setState(() {
//             //                                       try{
//             //                                         displayList.add(poList[i]);
//             //                                       }
//             //                                       catch(e){
//             //                                         log("$i out of bound");
//             //                                       }
//             //
//             //                                     });
//             //                                   }
//             //                                 }
//             //
//             //                               },
//             //                             ),
//             //                           ),
//             //                           const SizedBox(width: 20,),
//             //
//             //                         ],
//             //                       )
//             //                   ],
//             //                 ),
//             //
//             //             ],
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//
//           ),
//         ],
//       ) ,
//     );
//   }
//
//
//   void exportToExcel() async {
//     var excel = Excel.createExcel();
//     Sheet sheetObject = excel['Sheet1'];
//
//
//
//     CellStyle cellStyle = CellStyle(backgroundColorHex: "#000000", fontFamily : getFontFamily(FontFamily.Calibri),fontColorHex:'#FFFFFF' ,horizontalAlign: HorizontalAlign.Center);
//     CellStyle cellStyle1 = CellStyle(textWrapping:TextWrapping.WrapText, );
//
//     // cellStyle.underline = Underline.Single; // or Underline.Double
//     var cellA1 =  sheetObject.cell(CellIndex.indexByString("A1"));
//     // var cell1 =  sheetObject.;
//     var cellB1 =  sheetObject.cell(CellIndex.indexByString("B1"));
//     var cellC1 =  sheetObject.cell(CellIndex.indexByString("C1"));
//     var cellD1 =  sheetObject.cell(CellIndex.indexByString("D1"));
//
//     cellA1.cellStyle=cellStyle;
//     cellA1.value="Make";
//
//     // cell1.cellStyle=cellStyle;
//
//     cellB1.cellStyle=cellStyle;
//     cellB1.value="Model";
//
//     cellC1.cellStyle=cellStyle;
//     cellC1.value="Varient";
//
//
//
//
//     for(int i=0;i<poList.length;i++) {
//       sheetObject.cell(CellIndex.indexByString("A${i+2}")).value=poList[i]['make'].toString();
//       sheetObject.cell(CellIndex.indexByString("A${i+2}")).cellStyle=cellStyle1;
//       sheetObject.cell(CellIndex.indexByString("B${i+2}")).value=poList[i]['model'].toString();
//       sheetObject.cell(CellIndex.indexByString("C${i+2}")).value=poList[i]['varient'].toString();
//       // sheetObject.cell(CellIndex.indexByString("D${i+2}")).value=poList[i]['billing_address'].toString();
//     }
//
//
//
//     sheetObject.setColWidth(0, 20);
//     sheetObject.setColWidth(1, 20);
//     sheetObject.setColWidth(2, 40.49);
//
//     ///
//     /// Inserting and removing column and rows
//     //
//     // // insert column at index = 8
//     // sheetObject.insertColumn(8);
//     //
//     // // remove column at index = 18
//     // sheetObject.removeColumn(18);
//     //
//     // // insert row at index = 82
//     // sheetObject.removeRow(82);
//     //
//     // // remove row at index = 80
//     // sheetObject.removeRow(80);
//     var fileBytes = excel.save(fileName: "My_Excel_File_Name.xlsx");
//
//
// // // Create a new Workbook
// //     final Workbook workbook = Workbook();
// //     final Worksheet worksheet = workbook.worksheets[0];
// // // Add data to cells
// // //
// //     worksheet.getRangeByName('A1').setText('Address');
// //     worksheet.getRangeByName('B1').setText('Name');
// //     worksheet.getRangeByName('C1').setText('Age');
// //     //
// //     // for(int i=0;i<jsonData.length;i++) {
// //     //   worksheet.getRangeByName('A${i+2}').setValue(10);
// //     //   worksheet.getRangeByName('B${i+2}').setValue(20);
// //     //   worksheet.getRangeByName('C${i+2}').setValue(30);
// //     //
// //     // }
// //
// // // Save the workbook to a file
// //     // Save and dispose workbook.
// //     final bytes = workbook.saveAsStream();
// //    // await saveAndLaunchFile(bytes, 'JanuaryData');
// //     dynamic decodeData =(base64.encode(bytes));
// //     print("+++++++++++++++++++000000000000000000000");
// //     print(bytes);
// //     var excel = Excel.decodeBytes(bytes);
// //     var fileBytes = excel.save(fileName: "My_Excel_File_Name.xlsx");
// //     // AnchorElement(
// //     //     href: 'data:application/octet-stream;charset=utf-16le;base64,$decodeData')
// //     //   ..setAttribute('download', '1.xlsx')
// //     //   ..click();
//   }
//
//
//   Future importExcelData() async {
//     FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx'],
//       allowMultiple: false,
//     );
//
//     /// file might be picked
//
//     if (pickedFile != null) {
//
//       var bytes = pickedFile.files.single.bytes;
//       // print("picked file bytes");
//       // print(bytes);
//       //  parseExcelFile(bytes);
//
//       if(bytes!=null){
//
//         var excel = Excel.decodeBytes(bytes);
//         newData=[];
//         for (var table in excel.tables.keys) {
//           // print(table); //sheet Name
//           //  print(excel.tables[table]!.maxCols);
//           // print(excel.tables[table]!.maxRows);
//           for(int i=1;i<excel.tables[table]!.rows.length;i++){
//             DateTime tempDate =  DateFormat("yyyy-MM-dd").parse(excel.tables[table]!.rows[i][3]!.props.first.toString());
//             String excelDate = "${tempDate.day.toString()}-${tempDate.month.toString()}-${tempDate.year.toString()}";
//             Map tempMap =
//
//             {
//               'make':excel.tables[table]!.rows[i][0]!.props.first.toString(),
//               'model':excel.tables[table]!.rows[i][1]!.props.first.toString(),
//               'varient':excel.tables[table]!.rows[i][2]!.props.first.toString(),
//               'date':excelDate,
//               'on_road_price':int.parse(excel.tables[table]!.rows[i][4]!.props.first.toString()),
//               'color':excel.tables[table]!.rows[i][5]!.props.first.toString(),
//               'year_of_manufacture':excel.tables[table]!.rows[i][6]!.props.first.toString(),
//
//             };
//             setState(() {
//
//               newData.add(tempMap);
//             });
//           }
//         }
//
//       }
//
//
//     }
//   }
//
//
//
//   Future saveExcelData(List data) async {
//     String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/add_excel";
//     for(int i=0; i< data.length; i++) {
//       postData(requestBody:data[i],url: url,context: context).then((value) {
//         setState(() {
//           if(value!=null){
//             // data = value;
//             // print('-------addTableAPI value---------');
//             displayList=[];
//            // startVal=0;
//             fetchPoData();
//           }
//         });
//       });
//     }
//   }
//
//   Future fetchPoData() async{
//     dynamic response;
//     String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_mod_general";
//     try {
//       await getData(context: context, url: url).then((value) {
//         // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["general_id"]}");
//         // print(value);
//         setState(() {
//           //fieldValues =[];
//           if(value!=null){
//             response = value;
//             poList = value;
//             if(displayList.isEmpty){
//               if(poList.length>15){
//                 for(int i=startVal;i<startVal+15;i++){
//                   displayList.add(poList[i]);
//                 }
//               }
//               else{
//                 for(int i=startVal;i<poList.length;i++){
//                   displayList.add(poList[i]);
//                 }
//               }
//             }
//
//           }
//           isLoading = false;
//         });
//       });
//     }
//     catch (e) {
//       logOutApi(context: context, response: response, exception: e.toString());
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//   Future getPoByCate(poDate) async{
//     dynamic response;
//     String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_by_date/$poDate";
//     try {
//       await getData(context: context, url: url).then((value) {
//         // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["general_id"]}");
//         // print(value);
//         setState(() {
//           if(value!=null){
//             response = value;
//             poList = value;
//             print(poList);
//             try{
//             if(displayList.isEmpty){
//               if(poList.length>15){
//                 for(int i=startVal;i<startVal+15;i++){
//                   displayList.add(poList[i]);
//                 }
//               }
//               else{
//                 for(int i=startVal;i<poList.length;i++){
//                   displayList.add(poList[i]);
//                 }
//               }
//             }
//           } catch (e){
//               log(e.toString());
//             }
//           }
//
//           isLoading = false;
//         });
//       });
//     }
//     catch (e) {
//       logOutApi(context: context, response: response, exception: e.toString());
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   String selectedDate ='';
//   DateTime selectedDateTime = DateTime.now();
//   final selectedDateText = TextEditingController();
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDateTime,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null) {
//       setState(() {
//         selectedDateTime = picked;
//         selectedDate = "${picked.day.toString()}-${picked.month.toString()}-${picked.year.toString()}";
//         selectedDateText.text=selectedDate;
//         displayList=[];
//         getPoByCate(selectedDate);
//       });
//     }
//   }
//
//   Future deletePoData(selectedField) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String authToken = prefs.getString("authToken") ?? "";
//     String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/delete_excel/$selectedField';
//     final response = await http.delete(Uri.parse(url), headers: {
//       "Content-Type": "application/json",
//       'Authorization': 'Bearer $authToken'
//     });
//     if (response.statusCode == 200) {
//       setState(() {
//         try{
//           displayList.removeWhere((element) =>element['excel_id']==selectedField);
//           poList.removeWhere((element) => element['excel_id']==selectedField);
//           displayList=[];
//           fetchPoData();
//
//           visibleDelete=false;
//         }
//         catch (e){
//           log(e.toString());
//         }
//
//      });
//     } else {
//       print(response.statusCode.toString());
//     }
//   }
//
//   customSearchDecoration ({required String hintText, bool? error}){
//     return InputDecoration(hoverColor: mHoverColor,
//       suffixIcon: selectedDateText.text.isEmpty? const Icon(Icons.search,size: 18):InkWell(hoverColor: mHoverColor,onTap: (){
//         setState(() {
//           startVal=0;
//           displayList=[];
//           selectedDateText.clear();
//           fetchPoData();
//         });
//       },child:const SizedBox(height: 40,width: 30,child: Icon(Icons.close,size: 14,)), ),
//       border: const OutlineInputBorder(
//           borderSide: BorderSide(color:  Colors.blue)),
//       constraints:  const BoxConstraints(maxHeight:35),
//       hintText: hintText,
//       hintStyle: const TextStyle(fontSize: 14),
//       counterText: '',
//       contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 8),
//       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
//       focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
//     );
//   }
//   Widget buildTable(){
//     return Column(
//       // accessing rows in first sheet table data, taking list of tables data.
//       children: _fileContents.map((row) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(crossAxisAlignment: CrossAxisAlignment.start,
//             // accessing cell data.
//             children: row.map((cell) {
//               bool headerTextBool=false;
//               if(cell!=null && nameOfHeaders.isNotEmpty){
//                 for(int i=0;i<nameOfHeaders.length;i++){
//                   // Comparing both Header names.
//                   if(cell==nameOfHeaders[i]){
//                     headerTextBool=true;
//                   }
//                 }
//               }
//               return Expanded(child:   headerTextBool==true? Text(
//                 cell==null?"":cell.toString(),
//                 style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
//               ):
//               Text(
//                 cell==null?"":cell.toString(),
//                 style: const TextStyle(fontSize: 15),
//               ));
//             }).toList(),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }


import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../classes/arguments_classes/arguments_classes.dart';
import '../utils/api/getApi.dart';
import '../utils/api/post_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_loader.dart';
import '../utils/static_data/motows_colors.dart';

class UploadPO extends StatefulWidget {
  final UploadDataArguments args;
  const UploadPO({Key? key, required this.args}) : super(key: key);

  @override
  State<UploadPO> createState() => _UploadPOState();
}

class _UploadPOState extends State<UploadPO> {

  List fieldValues = [];
  List selectedFields =[];
  bool checkAll = false;
  bool visibleDelete = false;
  List poList=[];
  List newData=[];
  bool isLoading = true;
  List displayList=[];
  int startVal=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body:Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.args.drawerWidth,widget.args.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Container(
             // height: MediaQuery.of(context).size.height,
              color:Colors.grey[50],
              child: CustomLoader(
                inAsyncCall: isLoading,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40,top:30),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color:Color(0xFFE0E0E0) )
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:  const EdgeInsets.only(top: 8,left: 40,right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                const Text(" ",style: TextStyle(color: Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: 'Search by date'
                                        ),
                                        onTap: (){
                                          _selectDate(context);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    MaterialButton(
                                      onPressed: () {
                                        exportToExcel();
                                      },
                                      color: Colors.blue,
                                      child: const Icon(Icons.document_scanner_outlined,color: Colors.white),),
                                    const SizedBox(width: 10,),
                                    MaterialButton(onPressed: () async{


                                      importExcelData().whenComplete(() {
                                        saveExcelData(newData).whenComplete(() {
                                        });
                                      });
                                    },
                                      color: Colors.blue,
                                      child: const Text("+ Upload",style: TextStyle(color: Colors.white)),),
                                    if(visibleDelete)
                                      Row(
                                        children: [
                                          const SizedBox(width: 10,),
                                          MaterialButton(minWidth: 20,
                                            onPressed: () {
                                              // exportToExcel();
                                              print(selectedFields);
                                              for(int i=0;i<selectedFields.length;i++) {
                                                deletePoData(selectedFields[i]).then((value) {

                                                });
                                              }
                                            },
                                            color: Colors.red,
                                            child: const Icon(Icons.delete_forever_sharp,color: Colors.white,size: 18),),

                                        ],
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Container(color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10,top: 10,right: 4,left: 8),
                              child: Column(
                                children: [
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:25.0),
                                          child: SizedBox(width: 30,height: 30,
                                            child: Transform.scale(
                                              scale: 0.8,
                                              child: Checkbox(
                                                value: checkAll,
                                                onChanged: ( value) {
                                                  setState(() {
                                                    selectedFields=[];
                                                    checkAll = value!;
                                                    for(int i=0;i<poList.length;i++){
                                                      fieldValues[i]=value;
                                                      if(value==true){
                                                        selectedFields.add(poList[i]['excel_id']);
                                                      }
                                                      else{
                                                        selectedFields=[];
                                                      }
                                                      if(selectedFields.isEmpty) {
                                                        visibleDelete =false;
                                                      } else{
                                                        visibleDelete = true;
                                                      }
                                                    }
                                                  });
                                                },

                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0,),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text('Make')
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text('Model',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('Varient',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('Date',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('On-Road Price',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('Color',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('Manufacture Year',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),

                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),

                          for(int i=0;i<=displayList.length;i++)
                            Column(
                              children: [
                                if(i!=displayList.length)
                                  MaterialButton(
                                    onPressed: () {  },
                                    hoverColor: Colors.blue[50],
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:18.0,top:4,bottom: 3),
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(width: 30,height: 30,
                                              child: Transform.scale(
                                                scale: 0.8,
                                                child: Checkbox(
                                                  value: fieldValues[i],
                                                  onChanged: ( value) {
                                                    print(value);
                                                    setState(() {
                                                      fieldValues[i] = value;
                                                      if(value==true){
                                                        selectedFields.add(poList[i]['excel_id']);
                                                      }
                                                      else
                                                      {
                                                        checkAll=false;
                                                        selectedFields.remove(poList[i]['excel_id']);
                                                      }
                                                      if(selectedFields.isEmpty) {
                                                        visibleDelete =false;
                                                      } else{
                                                        visibleDelete = true;
                                                      }
                                                    });
                                                  },

                                                ),
                                              ),
                                            ),
                                          ),
                                          //Expanded(child: Text(displayList[i]['make'].toString(),overflow: TextOverflow.ellipsis,)),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayList[i]['make'].toString(),overflow: TextOverflow.ellipsis,)
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayList[i]['model'].toString(),overflow: TextOverflow.ellipsis,)
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayList[i]['varient'].toString(),overflow: TextOverflow.ellipsis,)
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayList[i]['date'].toString(),overflow: TextOverflow.ellipsis,)
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayList[i]['on_road_price'].toString(),overflow: TextOverflow.ellipsis,)
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayList[i]['color'].toString(),overflow: TextOverflow.ellipsis,)
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child:Text(displayList[i]['year_of_manufacture'].toString(),overflow: TextOverflow.ellipsis,)
                                                ),
                                              )),

                                        ],
                                      ),
                                    ),
                                  ),
                                if(i!=displayList.length)
                                  Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                if(i==displayList.length)
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("${startVal+5>poList.length?poList.length:startVal+1}-${startVal+5>poList.length?poList.length:startVal+5} of ${poList.length}",style: TextStyle(color: Colors.grey)),
                                      const SizedBox(width: 10,),
                                      Material(color: Colors.transparent,
                                        child: InkWell(
                                          hoverColor: mHoverColor,
                                          child: const Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                          ),
                                          onTap: (){
                                            if(startVal>4){
                                              displayList=[];
                                              startVal = startVal-5;
                                              for(int i=startVal;i<startVal+5;i++){
                                                setState(() {
                                                  displayList.add(poList[i]);
                                                });
                                              }
                                            }
                                            else{
                                              print('else');
                                            }

                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Material(color: Colors.transparent,
                                        child: InkWell(
                                          hoverColor: mHoverColor,
                                          child: const Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Icon(Icons.arrow_forward_ios,size: 12),
                                          ),
                                          onTap: (){
                                            if(startVal+1+5>poList.length){
                                              print("Block");
                                            }
                                            else
                                            if(poList.length>startVal+5){
                                              displayList=[];
                                              startVal=startVal+5;
                                              for(int i=startVal;i<startVal+5;i++){
                                                setState(() {
                                                  try{
                                                    displayList.add(poList[i]);
                                                  }
                                                  catch(e){
                                                    print(e);
                                                  }

                                                });
                                              }
                                            }

                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 20,),

                                    ],
                                  )
                              ],
                            ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ) ,
    );
  }


  void exportToExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];



    CellStyle cellStyle = CellStyle(backgroundColorHex: "#000000", fontFamily : getFontFamily(FontFamily.Calibri),fontColorHex:'#FFFFFF' ,horizontalAlign: HorizontalAlign.Center);
    CellStyle cellStyle1 = CellStyle(textWrapping:TextWrapping.WrapText, );

    // cellStyle.underline = Underline.Single; // or Underline.Double
    var cellA1 =  sheetObject.cell(CellIndex.indexByString("A1"));
    // var cell1 =  sheetObject.;
    var cellB1 =  sheetObject.cell(CellIndex.indexByString("B1"));
    var cellC1 =  sheetObject.cell(CellIndex.indexByString("C1"));
    var cellD1 =  sheetObject.cell(CellIndex.indexByString("D1"));

    cellA1.cellStyle=cellStyle;
    cellA1.value="Make";

    // cell1.cellStyle=cellStyle;

    cellB1.cellStyle=cellStyle;
    cellB1.value="Model";

    cellC1.cellStyle=cellStyle;
    cellC1.value="Varient";




    for(int i=0;i<poList.length;i++) {
      sheetObject.cell(CellIndex.indexByString("A${i+2}")).value=poList[i]['make'].toString();
      sheetObject.cell(CellIndex.indexByString("A${i+2}")).cellStyle=cellStyle1;
      sheetObject.cell(CellIndex.indexByString("B${i+2}")).value=poList[i]['model'].toString();
      sheetObject.cell(CellIndex.indexByString("C${i+2}")).value=poList[i]['varient'].toString();
      // sheetObject.cell(CellIndex.indexByString("D${i+2}")).value=poList[i]['billing_address'].toString();
    }



    sheetObject.setColWidth(0, 20);
    sheetObject.setColWidth(1, 20);
    sheetObject.setColWidth(2, 40.49);

    ///
    /// Inserting and removing column and rows
    //
    // // insert column at index = 8
    // sheetObject.insertColumn(8);
    //
    // // remove column at index = 18
    // sheetObject.removeColumn(18);
    //
    // // insert row at index = 82
    // sheetObject.removeRow(82);
    //
    // // remove row at index = 80
    // sheetObject.removeRow(80);
    var fileBytes = excel.save(fileName: "My_Excel_File_Name.xlsx");


// // Create a new Workbook
//     final Workbook workbook = Workbook();
//     final Worksheet worksheet = workbook.worksheets[0];
// // Add data to cells
// //
//     worksheet.getRangeByName('A1').setText('Address');
//     worksheet.getRangeByName('B1').setText('Name');
//     worksheet.getRangeByName('C1').setText('Age');
//     //
//     // for(int i=0;i<jsonData.length;i++) {
//     //   worksheet.getRangeByName('A${i+2}').setValue(10);
//     //   worksheet.getRangeByName('B${i+2}').setValue(20);
//     //   worksheet.getRangeByName('C${i+2}').setValue(30);
//     //
//     // }
//
// // Save the workbook to a file
//     // Save and dispose workbook.
//     final bytes = workbook.saveAsStream();
//    // await saveAndLaunchFile(bytes, 'JanuaryData');
//     dynamic decodeData =(base64.encode(bytes));
//     print("+++++++++++++++++++000000000000000000000");
//     print(bytes);
//     var excel = Excel.decodeBytes(bytes);
//     var fileBytes = excel.save(fileName: "My_Excel_File_Name.xlsx");
//     // AnchorElement(
//     //     href: 'data:application/octet-stream;charset=utf-16le;base64,$decodeData')
//     //   ..setAttribute('download', '1.xlsx')
//     //   ..click();
  }


  Future importExcelData() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    /// file might be picked

    if (pickedFile != null) {

      var bytes = pickedFile.files.single.bytes;
      print("picked file bytes");
      // print(bytes);
      //  parseExcelFile(bytes);

      if(bytes!=null){

        var excel = Excel.decodeBytes(bytes);
        newData=[];
        for (var table in excel.tables.keys) {

          print(table); //sheet Name
          //  print(excel.tables[table]!.maxCols);
          // print(excel.tables[table]!.maxRows);
          for(int i=1;i<excel.tables[table]!.rows.length;i++){
            DateTime tempDate =  DateFormat("yyyy-MM-dd").parse(excel.tables[table]!.rows[i][3]!.props.first.toString());
            String excelDate = "${tempDate.day.toString()}-${tempDate.month.toString()}-${tempDate.year.toString()}";
            Map tempMap =

            {
              'make':excel.tables[table]!.rows[i][0]!.props.first.toString(),
              'model':excel.tables[table]!.rows[i][1]!.props.first.toString(),
              'varient':excel.tables[table]!.rows[i][2]!.props.first.toString(),
              'date':excelDate,
              'on_road_price':int.parse(excel.tables[table]!.rows[i][4]!.props.first.toString()),
              'color':excel.tables[table]!.rows[i][5]!.props.first.toString(),
              'year_of_manufacture':excel.tables[table]!.rows[i][6]!.props.first.toString(),

            };
            setState(() {

              newData.add(tempMap);
            });
          }
        }

      }


    }
  }



  Future saveExcelData(List data) async {
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/add_excel";
    for(int i=0; i< data.length; i++) {
      postData(requestBody:data[i],url: url,context: context).then((value) {
        setState(() {
          if(value!=null){
            // data = value;
            // print('-------addTableAPI value---------');
            fetchPoData();
          }
        });
      });
    }
  }

  Future fetchPoData() async{
    dynamic response;
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_mod_general";
    try {
      await getData(context: context, url: url).then((value) {
        // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["general_id"]}");
        // print(value);
        setState(() {
          fieldValues =[];
          if(value!=null){
            response = value;

            for(int i=0;i<value.length;i++) {
              fieldValues.add(false);
            }
            poList = value;
            if(displayList.isEmpty){
              if(poList.length>5){
                for(int i=0;i<5;i++){
                  displayList.add(poList[i]);
                }
              }
              else{
                for(int i=0;i<poList.length;i++){
                  displayList.add(poList[i]);
                }
              }
            }
            // print('------new get all docket data ----------');
            // print(docketData);
            // print(total);
          }
          isLoading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
  Future getPoByCate(poDate) async{
    dynamic response;
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_by_date/$poDate";
    try {
      await getData(context: context, url: url).then((value) {
        // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["general_id"]}");
        // print(value);
        setState(() {
          if(value!=null){
            response = value;
            poList = value;
            // print('------new get all docket data ----------');
            // print(docketData);
            // print(total);
          }
          isLoading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  String selectedDate ='';
  DateTime selectedDateTime = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDateTime = picked;

        selectedDate = "${picked.day.toString()}-${picked.month.toString()}-${picked.year.toString()}";
        print(selectedDate);
        getPoByCate(selectedDate);
      });
    }
  }

  Future deletePoData(selectedField) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString("authToken") ?? "";
    String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/delete_excel/$selectedField';
    final response = await http.delete(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $authToken'
    });
    if (response.statusCode == 200) {
      setState(() {
        selectedFields.remove(selectedField);
      });
      if(selectedFields.isEmpty){
        setState(() {
          visibleDelete=false;
        });
      }
      print('--------response--');
      print(selectedField);
      fetchPoData();
    } else {
      print(response.statusCode.toString());
    }
  }
}
