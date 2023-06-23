import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'add_new_vehicle_po.dart';
import 'edit_vehicle_po.dart';


class ListVehicleOrders extends StatefulWidget {
  final ListVehicleArguments arg;
  const ListVehicleOrders({Key? key, required this.arg}) : super(key: key);

  @override
  State<ListVehicleOrders> createState() => _ListVehicleOrdersState();
}

class _ListVehicleOrdersState extends State<ListVehicleOrders> {

  List poList =[];
  bool loading = false;


  Future fetchPurchaseData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_all_new_vehi_pur';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            poList = value;
            // print('--------- new get --------');
            // print(poList);
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPurchaseData();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.arg.drawerWidth,widget.arg.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child:  CustomLoader(
              inAsyncCall: loading,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50,top:20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            const Text("All Items",style: TextStyle(color: Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                MaterialButton(onPressed: () {
                                  exportToExcel();
                                },color: Colors.blue,
                                  child: const Icon(Icons.document_scanner_outlined,color: Colors.white),),
                                const SizedBox(width: 10,),
                                MaterialButton(onPressed: () {
                                  Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2,)=>
                                  AddNewVehiclePurchaseOrder(selectedDestination: widget.arg.selectedDestination, drawerWidth: widget.arg.drawerWidth,),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero
                                  )).then((value) => fetchPurchaseData());
                                },color: Colors.blue,
                                  child: const Text("+ New",style: TextStyle(color: Colors.white)),),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Column(
                          children: [
                            Container(
                                height: 40,
                                color: Colors.grey[200],
                                child:
                                const Row(
                                  children: [
                                    Expanded(flex: 4,child: Center(child: Text("PURCHASE ORDER"))),
                                    Expanded(flex: 4,child: Center(child: Text("VENDOR NAME"))),
                                    Expanded(flex: 5,child: Center(child: Text("SHIPPING ADDRESS"))),
                                    Expanded(flex: 5,child: Center(child: Text("PAY-TO ADDRESS"))),
                                    Expanded(flex: 3,child: Center(child: Text("TOTAL"))),
                                    Expanded(child: Center(child: Text(""))),
                                  ],
                                )
                            ),

                            // Align(alignment: Alignment.centerLeft,child: Text("OCT 11, Monday",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900],fontSize: 14),)),
                            // SizedBox(height: 10,),
                            const SizedBox(height: 10,),
                            for(int i=0;i<poList.length;i++)
                              Column(
                                children: [
                                  Card(
                                    child: InkWell(
                                      onTap: (){

                                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>EditVehiclePurchaseOrder(poList: poList[i], selectedDestination: 2.1, drawerWidth: 190,),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero
                                        )).then((value) {
                                          fetchPurchaseData();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(flex: 4,child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(height: 30,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(poList[i]['po_id']??"")
                                              ),
                                            ),
                                          )),
                                          Expanded(flex: 4,child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(height: 30,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(poList[i]['vendor_name'])
                                              ),
                                            ),
                                          )),
                                          Expanded(flex: 5,child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(height: 40,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Align(alignment: Alignment.centerLeft,child: Text(poList[i]['shipping_address']??"",textAlign:TextAlign.left,))
                                            ),
                                          )),
                                          Expanded(flex: 5,child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(height: 40,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Align(alignment: Alignment.centerLeft,child: Text(poList[i]['billing_address']??""))
                                            ),
                                          )),

                                          Expanded(flex: 3,child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SizedBox(height: 30,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(poList[i]['grand_total'].toStringAsFixed(2))
                                              ),
                                            ),
                                          )),

                                          const Expanded(child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 28,
                                              child: Icon(size: 18,CupertinoIcons.chevron_right_circle_fill,color: Colors.blue,),
                                            ),
                                          )),




                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                ],
                              ),
                          ],
                        )
                      ],
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
    cellA1.value="Purchase Order Number";

    // cell1.cellStyle=cellStyle;

    cellB1.cellStyle=cellStyle;
    cellB1.value="Vendor Name";

    cellC1.cellStyle=cellStyle;
    cellC1.value="Shipping Address";

    cellD1.cellStyle=cellStyle;
    cellD1.value="Billing Address";


    for(int i=0;i<poList.length;i++) {
      sheetObject.cell(CellIndex.indexByString("A${i+2}")).value=poList[i]['po_id'].toString();
      sheetObject.cell(CellIndex.indexByString("A${i+2}")).cellStyle=cellStyle1;
      sheetObject.cell(CellIndex.indexByString("B${i+2}")).value=poList[i]['vendor_name'].toString();
      sheetObject.cell(CellIndex.indexByString("C${i+2}")).value=poList[i]['shipping_address'].toString();
      sheetObject.cell(CellIndex.indexByString("D${i+2}")).value=poList[i]['billing_address'].toString();
    }



    sheetObject.setColWidth(0, 20);
    sheetObject.setColWidth(1, 20);
    sheetObject.setColWidth(2, 40.49);
    sheetObject.setColWidth(3, 60);

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
}
