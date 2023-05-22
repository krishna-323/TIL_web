import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';

// class DisplayExcelData extends StatefulWidget {
//   final double drawerWidth;
//   final double selectedDestination;
//   const DisplayExcelData({Key? key,
//     required this.drawerWidth,
//     required this.selectedDestination,
//   }) : super(key: key);
//
//   @override
//   State<DisplayExcelData> createState() => _DisplayExcelDataState();
// }
//
// class _DisplayExcelDataState extends State<DisplayExcelData> {
//   List<dynamic> excelData= [];
//   List storeData=[];
//   Future importEmployData() async {
//     FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['xlsx'],
//       allowMultiple: false,
//     );
//
//     /// file might be picked
//
//     if (pickedFile != null) {
//       var bytes = pickedFile.files.single.bytes;
//
//       if(bytes!=null){
//         var excel = Excel.decodeBytes(bytes);
//         storeData=[];
//
//         for (var table in excel.tables.keys) {
//           for(int i=1;i<excel.tables[table]!.rows.length;i++){
//
//             print('----------phone number----------');
//             print(excel.tables[table]!.rows.length );
//             Map empData =
//             {
//               'name':excel.tables[table]!.rows[i][0] ==null? "": excel.tables[table]!.rows[i][0]!.props.first.toString(),
//               'age':excel.tables[table]!.rows[i][1] == null? "": excel.tables[table]!.rows[i][1]!.props.first.toString(),
//                "dob":excel.tables[table]!.rows[i][2] == null? "":  excel.tables[table]!.rows[i][2]!.props.first.toString(),
//               'designation':excel.tables[table]!.rows[i][3] ==null?"": excel.tables[table]!.rows[i][3]!.props.first.toString(),
//               'address':excel.tables[table]!.rows[i][4] == null?"": excel.tables[table]!.rows[i][4]!.props.first.toString(),
//               'phoneNumber':excel.tables[table]!.rows[i][5] == null?"": excel.tables[table]!.rows[i][5]!.props.first.toString(),
//             };
//
//             setState(() {
//               storeData.add(empData);
//             });
//
//           }
//           print('------check stracture of -----');
//           print(storeData);
//         }
//
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(preferredSize: Size.fromHeight(60),
//         child: CustomAppBar(),),
//        body: Row(children: [
//          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
//          VerticalDivider(width: 1,
//          thickness: 1,
//          ),
//          Expanded(child:  Container(
//            height: MediaQuery.of(context).size.height,
//            child: SingleChildScrollView(
//              child: Padding(
//                padding: const EdgeInsets.only(left: 40,right: 40,top: 30),
//                child: Container(
//                  decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(10),
//                      border: Border.all(color: Color(0xFFE0E0E0),)
//
//                  ),
//                  child: Column(
//                    children: [
//                      Container(
//                          decoration: const BoxDecoration(
//                            color: Colors.white,
//                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
//                          ),
//                          child:
//                          Column(
//                            children: [
//                              Padding(
//                                padding: const EdgeInsets.only(left: 18.0,top: 18,right: 18,bottom: 18),
//                                child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children:   [
//                                    Text("Display List ", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
//                                    ),
//                                    MaterialButton(onPressed: (){
//                                      importEmployData();
//                                    },
//                                    child: Text("Upload"),
//                                      color: Colors.blue,
//                                    )
//                                  ],
//                                ),
//                              ),
//
//                              Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
//                              Container(color: Colors.grey[100],height: 32,
//                                child:  IgnorePointer(
//                                  ignoring: true,
//                                  child: MaterialButton(
//                                    onPressed: (){},
//                                    hoverColor: Colors.transparent,
//                                    hoverElevation: 0,
//                                    child: Padding(
//                                      padding: const EdgeInsets.only(left: 18.0),
//                                      child: Row(
//                                        children: const [
//                                          Expanded(
//                                              child: Padding(
//                                                padding: EdgeInsets.only(top: 4.0),
//                                                child: SizedBox(height: 25,
//                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                    child: Text("Name")
//                                                ),
//                                              )),
//                                          Expanded(
//                                              child: Padding(
//                                                padding: EdgeInsets.only(top: 4),
//                                                child: SizedBox(
//                                                    height: 25,
//                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                    child: Text('Age')
//                                                ),
//                                              )
//                                          ),
//                                          Expanded(
//                                              child: Padding(
//                                                padding: EdgeInsets.only(top: 4),
//                                                child: SizedBox(height: 25,
//                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                    child: Text("Dob")
//                                                ),
//                                              )),
//                                          Expanded(
//                                              child: Padding(
//                                                padding: EdgeInsets.only(top: 4),
//                                                child: SizedBox(height: 25,
//                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                    child: Text("Designation")
//                                                ),
//                                              )),
//                                          Expanded(
//                                              child: Padding(
//                                                padding: EdgeInsets.only(top: 4),
//                                                child: SizedBox(height: 25,
//                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                    child: Text("Address")
//                                                ),
//                                              )),
//                                          Expanded(
//                                              child: Padding(
//                                                padding: EdgeInsets.only(top: 4),
//                                                child: SizedBox(height: 25,
//                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                    child: Text("Phone Number")
//                                                ),
//                                              )),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
//                            ],
//                          )
//                      ),
//
//                      for(int i=0;i<storeData.length;i++)
//                        Column(
//                          children: [
//                              MaterialButton(
//                                hoverColor: Colors.blue[50],
//                                onPressed: (){
//
//                                },
//                                child: Padding(
//                                  padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
//                                  child: Row(
//                                    children: [
//                                      Expanded(
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(top: 4.0),
//                                            child: SizedBox(height: 25,
//                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                child: Text(storeData[i]['name']??"")
//                                            ),
//                                          )),
//                                      Expanded(
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(top: 4),
//                                            child: SizedBox(
//                                                height: 25,
//                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                child: Text(storeData[i]['age']?? '')
//                                            ),
//                                          )
//                                      ),
//                                      Expanded(
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(top: 4),
//                                            child: SizedBox(height: 25,
//                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                child: Text(storeData[i]['dob']??"")
//                                            ),
//                                          )),
//                                      Expanded(
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(top: 4),
//                                            child: SizedBox(height: 25,
//                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                child: Text(storeData[i]['designation'] ?? "")
//                                            ),
//                                          )),
//                                      Expanded(
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(top: 4),
//                                            child: SizedBox(height: 25,
//                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                child: Text(storeData[i]['address']??"")
//                                            ),
//                                          )),
//                                      Expanded(
//                                          child: Padding(
//                                            padding: const EdgeInsets.only(top: 4),
//                                            child: SizedBox(height: 25,
//                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
//                                                child: Text(storeData[i]['phoneNumber']??"")
//                                            ),
//                                          )),
//                                    ],
//                                  ),
//                                ),
//                              ),
//
//                          ],
//                        ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ),)
//        ]),
//     );
//   }
// }

class ExcelTableScreen extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const ExcelTableScreen({Key? key, required this. drawerWidth, required this. selectedDestination}) : super(key: key);
  @override
  _ExcelTableScreenState createState() => _ExcelTableScreenState();
}
class _ExcelTableScreenState extends State<ExcelTableScreen> {
  final verticalScroll=ScrollController();
  final horizontalScroll=ScrollController();
  // Declarations For XLSX.
  List firstSheetData=[];
  List nameOfHeaders=[];
  List<List<dynamic>> _fileContents=[];
  bool xlsx=false;

  // Declarations For CSV File.
  bool csv =false;
  List<List<dynamic>> csvData = [];
  final csvVerticalScroll=ScrollController();
  final csvHorizontalScroll=ScrollController();
  List nameOfHeadersCsvList=[];

  // File picker function.
  void _loadCSVorXlSX() async {
    // Wait Key Word ,For Selecting Type Of Files.(File type picking "csv" or "xlsx")
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv',"xlsx"],
        allowMultiple: true
    );
    final typeOfFile =result?.files.single.name;
    try{
      if(result==null || result.files.isEmpty){
        return null;
      }
      else if(typeOfFile!.endsWith('.csv')){

        // excel data it will convert to bytes code.
        final bytes = result.files.first.bytes!.toList();
        xlsx=false;
        csv=true;
        print('----Selected File Is csv File----');
        setState(() {
          // we are assigning excel list data to( "csvData" is a empty list).
          // utf8.decode() is function it will convert bytes to characters as a string.
          csvData = const CsvToListConverter().convert(utf8.decode(bytes));
        });
      }
      else if(typeOfFile.endsWith(".xlsx")){
        csv=false;
        xlsx=true;
        print('--------Selected File Is xlsx------');
        var bytes= result.files.single.bytes;
        if(bytes !=null){
          var excel =Excel.decodeBytes(bytes);

          final headerItems=excel.tables[excel.tables.keys.first];
          final headerRow=headerItems?.rows.first;
          for(int firstHeaderName=0;firstHeaderName<headerRow!.length;firstHeaderName++){
            nameOfHeaders.add(headerRow[firstHeaderName]!.props.first);
          }
          //Multiple Sheets Names.
          firstSheetData= excel.tables.keys.toList();
          var sheet =excel[firstSheetData[0]];
          final rows=sheet.rows;
          setState(() {
            _fileContents=rows.map((row)=>row.map((cell)=>cell?.value).toList()).toList();
          });
        }
      }
      else{
        print('Unsupported file');
      }
    }
    catch(e){
      print(e.toString());
    }
  }
  @override
  Widget  build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(60),
      child: CustomAppBar(),

      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          Expanded(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _loadCSVorXlSX,
                  child: Text('Load Excel File'),
                ),
                if(csvData.isNotEmpty && csv==true )
                  // Expanded(
                  //   child: AdaptiveScrollbar(position: ScrollbarPosition.right,
                  //     controller: csvVerticalScroll,
                  //     sliderDefaultColor: Colors.grey,
                  //     sliderActiveColor: Colors.grey,
                  //     width: 12,
                  //     child: AdaptiveScrollbar(width: 12,
                  //       controller: csvHorizontalScroll,
                  //       position: ScrollbarPosition.bottom,
                  //       sliderActiveColor: Colors.grey,
                  //       sliderDefaultColor: Colors.grey,
                  //       child: SingleChildScrollView(
                  //         controller: csvHorizontalScroll,
                  //         scrollDirection: Axis.horizontal,
                  //         child: SingleChildScrollView(scrollDirection: Axis.vertical,
                  //           controller: csvVerticalScroll,
                  //           child: Column(
                  //             children: csvData.map((row) {
                  //               return Row(
                  //                 children: row.map((cell) {
                  //                   return Expanded(
                  //                     child: Text(
                  //                       '$cell',
                  //                       style: const TextStyle(
                  //                         fontSize: 15,
                  //                         fontWeight: FontWeight.bold,
                  //                       ),
                  //                     ),
                  //                   );
                  //                 }).toList(),
                  //               );
                  //             }).toList(),
                  //           ),
                  //
                  //           // DataTable(
                  //           //   columns: csvData.isNotEmpty ? csvData.first.map((title) => DataColumn(label: Text(title,style: const TextStyle(fontSize: 15,
                  //           //       fontWeight: FontWeight.bold),),)).toList() : [],
                  //           //   rows: csvData.length > 1 ? csvData.skip(1).map((row) => DataRow(cells: row.map((cell) => DataCell(
                  //           //       Container(
                  //           //           child: Text('$cell')))).toList())).toList() : [],
                  //           // ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: csvData.map((row) {
                          return Row(
                            children: row.map((cell) {
                              return Expanded(
                                child: Text(
                                  '$cell',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                if(xlsx==true)
                  if(width>1100)
                    Expanded(
                      child: SingleChildScrollView(
                        child: buildTable(),
                      ),
                    ),
                if(xlsx==true)
                  if(width<1100)
                    Expanded(
                      child: SizedBox(
                        width: 2340,
                        child: AdaptiveScrollbar(
                          controller: verticalScroll,
                          child: AdaptiveScrollbar(
                            width: 12,
                            sliderDefaultColor: Colors.grey,
                            sliderActiveColor: Colors.grey,
                            position: ScrollbarPosition.bottom,
                            controller: horizontalScroll,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: horizontalScroll,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                controller: verticalScroll,
                                child: Row( children: [
                                  SizedBox(
                                    width: 1500,
                                    child: buildTable(),
                                  ),
                                ], ), ),
                            ),
                          ),
                        ), ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTable(){
    return Column(
      // accessing rows in first sheet table data, taking list of tables data.
      children: _fileContents.map((row) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            // accessing cell data.
            children: row.map((cell) {
              bool headerTextBool=false;
              if(cell!=null && nameOfHeaders.isNotEmpty){
                for(int i=0;i<nameOfHeaders.length;i++){
                  // Comparing both Header names.
                  if(cell==nameOfHeaders[i]){
                    headerTextBool=true;
                  }
                }
              }
              return Expanded(child:   headerTextBool==true? Text(
                cell==null?"":cell.toString(),
                style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
              ):
              Text(
                cell==null?"":cell.toString(),
                style: const TextStyle(fontSize: 15),
              ));
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}