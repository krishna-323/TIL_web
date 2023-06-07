import 'dart:convert';
import 'dart:developer';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';

class ExcelTableScreen extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const ExcelTableScreen({Key? key, required this. drawerWidth, required this. selectedDestination}) : super(key: key);
  @override
  State<ExcelTableScreen> createState() => _ExcelTableScreenState();
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

        setState(() {
          // we are assigning excel list data to( "csvData" is a empty list).
          // utf8.decode() is function it will convert bytes to characters as a string.
          csvData = const CsvToListConverter().convert(utf8.decode(bytes));
        });
      }
      else if(typeOfFile.endsWith(".xlsx")){
        csv=false;
        xlsx=true;

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
        log('Unsupported file');
      }
    }
    catch(e){
      log(e.toString());
    }
  }
  @override
  Widget  build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(60),
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
                  child: const Text('Load Excel File'),
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