
import 'dart:convert';
import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as xl;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../classes/arguments_classes/arguments_classes.dart';
import '../utils/api/get_api.dart';
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
  final selectedDateText = TextEditingController();
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
            child: CustomLoader(
              inAsyncCall: isLoading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color:Colors.grey[50],
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40,top:30),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                         // border: Border.all(color:const Color(0xFFE0E0E0) )
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:  const EdgeInsets.only(top: 8,left: 40,right: 40),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                SizedBox(  width: 190,height: 30, child: TextFormField(
                                  controller: selectedDateText,
                                  onTap: (){
                                    _selectDate(context);
                                  },
                                  readOnly: true,
                                  style: const TextStyle(fontSize: 14),
                                  keyboardType: TextInputType.text,
                                  decoration: customSearchDecoration(hintText: 'Search by date'),
                                ),
                                ),
                                Row(
                                  children: [

                                    const SizedBox(width: 10,),
                                    MaterialButton(
                                      onPressed: () {
                                        print('-------');
                                        print("check here");
                                        exportToExcel();
                                      },
                                      color: Colors.blue,
                                      child: const Icon(Icons.document_scanner_outlined,color: Colors.white),),
                                    const SizedBox(width: 10,),
                                    MaterialButton(onPressed: () async{


                                      _loadCSVorXlSX().whenComplete(() {
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

                                              if(selectedFields.isNotEmpty){
                                                for(int i=0;i<selectedFields.length;i++){
                                                  deletePoData(selectedFields[i]).then((value) {
                                                  });
                                                }
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
                                                value: visibleDelete==false?false:checkAll,
                                                onChanged: ( value) {
                                                  setState(() {
                                                    selectedFields=[];
                                                    checkAll = value!;
                                                    for(int i=0;i<poList.length;i++){
                                                     // fieldValues[i]=value;
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
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0,),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text('Make')
                                            ),
                                          )),
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text('Model',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('Varient',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('Date',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('On-Road Price',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text('Color',maxLines: 1,overflow: TextOverflow.ellipsis,)
                                            ),
                                          )),
                                      const Expanded(
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
                                            child: SizedBox(width: 30,height: 30,
                                              child: Transform.scale(
                                                scale: 0.8,
                                                child: Checkbox(
                                                  value: selectedFields.contains(displayList[i]['excel_id']),
                                                  onChanged: ( value) {

                                                    setState(() {
                                                     // fieldValues[i] = value;
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

                                      Text("${startVal+15>poList.length?poList.length:startVal+1}-${startVal+15>poList.length?poList.length:startVal+15} of ${poList.length}",style: const TextStyle(color: Colors.grey)),
                                      const SizedBox(width: 10,),
                                      Material(color: Colors.transparent,
                                        child: InkWell(
                                          hoverColor: mHoverColor,
                                          child: const Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                          ),
                                          onTap: (){
                                            if(startVal>14){
                                              displayList=[];
                                              startVal = startVal-15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                setState(() {
                                                  displayList.add(poList[i]);
                                                });
                                              }
                                            }
                                            else{
                                              log('else');
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
                                            if(startVal+1+15>poList.length){
                                              log("Block");
                                            }
                                            else
                                            if(poList.length>startVal+15){
                                              displayList=[];
                                              startVal=startVal+15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                setState(() {
                                                  try{
                                                    displayList.add(poList[i]);
                                                  }
                                                  catch(e){
                                                    log(e.toString());
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
    var excel = xl.Excel.createExcel();
    xl.Sheet sheetObject = excel['Sheet1'];



    xl.CellStyle cellStyle = xl.CellStyle(backgroundColorHex: "#000000", fontFamily : xl.getFontFamily(xl.FontFamily.Calibri),fontColorHex:'#FFFFFF' ,horizontalAlign: xl.HorizontalAlign.Center);
    xl.CellStyle cellStyle1 = xl.CellStyle(textWrapping:xl.TextWrapping.WrapText, );

    // cellStyle.underline = Underline.Single; // or Underline.Double
    var cellA1 =  sheetObject.cell(xl.CellIndex.indexByString("A1"));
    // var cell1 =  sheetObject.;
    var cellB1 =  sheetObject.cell(xl.CellIndex.indexByString("B1"));
    var cellC1 =  sheetObject.cell(xl.CellIndex.indexByString("C1"));
    //var cellD1 =  sheetObject.cell(xl.CellIndex.indexByString("D1"));

    cellA1.cellStyle=cellStyle;
    cellA1.value="Make";

    // cell1.cellStyle=cellStyle;

    cellB1.cellStyle=cellStyle;
    cellB1.value="Model";

    cellC1.cellStyle=cellStyle;
    cellC1.value="Varient";




    for(int i=0;i<poList.length;i++) {
      sheetObject.cell(xl.CellIndex.indexByString("A${i+2}")).value=poList[i]['make'].toString();
      sheetObject.cell(xl.CellIndex.indexByString("A${i+2}")).cellStyle=cellStyle1;
      sheetObject.cell(xl.CellIndex.indexByString("B${i+2}")).value=poList[i]['model'].toString();
      sheetObject.cell(xl.CellIndex.indexByString("C${i+2}")).value=poList[i]['varient'].toString();
      // sheetObject.cell(CellIndex.indexByString("D${i+2}")).value=poList[i]['billing_address'].toString();
    }



    sheetObject.setColWidth(0, 20);
    sheetObject.setColWidth(1, 20);
    sheetObject.setColWidth(2, 40.49);




  }

  Future _loadCSVorXlSX() async {
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
      else if (typeOfFile!.endsWith(".csv")) {
        print('--------Selected File Is CSV------');
        // This Line iS Converting bytes to characters. by using utf8.decode() function.
        var fileContent = utf8.decode(result.files.single.bytes!);
        var csvConverter = const CsvToListConverter();
        // This Will Convert Characters to List.
        var rows = csvConverter.convert(fileContent);
        newData = [];
        for (var i = 1; i < rows.length; i++) {
          DateTime tempDate = DateFormat("dd-MM-yyyy").parse(rows[i][3]);
          String formattedDate = "${tempDate.day.toString()}-${tempDate.month.toString()}-${tempDate.year.toString()}";

          Map<String, dynamic> tempMap = {
            'make': rows[i][0].toString(),
            'model': rows[i][1].toString(),
            'varient': rows[i][2].toString(),
            'date': formattedDate,
            'on_road_price': int.parse(rows[i][4].toString()),
            'color': rows[i][5].toString(),
            'year_of_manufacture': rows[i][6].toString(),
          };
          setState(() {
            newData.add(tempMap);
          });
        }
      }

      else if(typeOfFile.endsWith(".xlsx")){

        print('--------Selected File Is xlsx------');
          var bytes = result.files.single.bytes;
          log("picked file bytes");
          if(bytes!=null){

            var excel = xl.Excel.decodeBytes(bytes);
            newData=[];
            for (var table in excel.tables.keys) {

              log(table); //sheet Name
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
      else{
        print('Unsupported file');
      }
    }
    catch(e){
      print(e.toString());
    }
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
      log("picked file bytes");
      // print(bytes);
      //  parseExcelFile(bytes);

      if(bytes!=null){

        var excel = xl.Excel.decodeBytes(bytes);
        newData=[];
        for (var table in excel.tables.keys) {

          log(table); //sheet Name
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
              if(poList.length>15){
                for(int i=startVal;i<15;i++){
                  displayList.add(poList[i]);
                }
              }
              else{
                for(int i=startVal;i<poList.length;i++){
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
    print('-----selected po date');
    print(poDate);
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
            try{
              if(displayList.isEmpty){
                if(poList.length>15){
                  for(int i=startVal;i<startVal+15;i++){
                    displayList.add(poList[i]);
                  }
                }
                else{
                  for(int i=startVal;i<poList.length;i++){
                    displayList.add(poList[i]);
                  }
                }
              }
            } catch (e){
              log(e.toString());
            }
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
        selectedDateText.text=selectedDate;
        displayList=[];
       // log(selectedDate);
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
        try{
          displayList.removeWhere((element) => element["excel_id"]==selectedField);
          poList.removeWhere((element) => element["excel_id"]==selectedField);
          displayList=[];
          fetchPoData();
          visibleDelete=false;
        }
        catch(e){
          log(e.toString());
        }
      });


    } else {
      log(response.statusCode.toString());
    }
  }
  customSearchDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: selectedDateText.text.isEmpty? const Icon(Icons.search,size: 18):InkWell(hoverColor: mHoverColor,onTap: (){
        setState(() {
          startVal=0;
          displayList=[];
          selectedDateText.clear();
          fetchPoData();
        });
      },child:const SizedBox(height: 40,width: 30,child: Icon(Icons.close,size: 14,)), ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 8),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
}
