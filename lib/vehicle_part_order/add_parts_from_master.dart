import 'dart:developer';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/utils/custom_loader.dart';
import '../../utils/api/get_api.dart';
import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/static_data/motows_colors.dart';
import '../../widgets/custom_dividers/custom_vertical_divider.dart';
import '../../widgets/motows_buttons/outlined_mbutton.dart';
import 'dart:async';

import '../classes/env.dart';

class AddPartsOrderFromMaster extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final List partsOrderList;
  final String pageName;
  const AddPartsOrderFromMaster({super.key,
    required this.drawerWidth,
    required this.selectedDestination,
    required this.partsOrderList,
    required this.pageName
  });

  @override
  State<AddPartsOrderFromMaster> createState() => _AddPartsOrderFromMasterState();
}

class _AddPartsOrderFromMasterState extends State<AddPartsOrderFromMaster> {
  TextStyle fontWeight = const TextStyle(fontWeight: FontWeight.bold);
  final searchByOrderId = TextEditingController();
  final _horizontalScrollController = ScrollController();
  List<TextEditingController> orderQuantityControllers = [];
  List partsStaticData =[];
  List selectedParts = [];
  var units = <TextEditingController>[];
  bool loading = false;
  bool partOrderNotFound = false;
  Future fetchMasterParts()async{
    dynamic response;
    String url='${StaticData.url}parts_master/get_all_partsmaster';
    try{
      await getData(url:url ,context:context ).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            partsStaticData = response;
            loading = false;
          }
        });
      }
      );
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());
    }
  }

  Future partsNotification(notificationDetails) async {
    String url = '${StaticData.url}partsstocknotification/add_partsstocknotification';
    postData(context: context, url: url, requestBody: notificationDetails).then((value) {
      setState(() {
        if (value != null) {
          print('--------Response--------');
          print(value);
        }
      });
    });
  }

  @override
  initState(){
    super.initState();
    // print('----pageName---');
    // print(widget.pageName);
    // print(widget.partsOrderList);

    loading = true;
    fetchMasterParts();
    if(widget.partsOrderList.isNotEmpty){
      // print('-----partsOrderList------');
      // print(widget.partsOrderList);
      if(selectedParts.isEmpty){
        for(int i=0;i<widget.partsOrderList.length;i++){
          selectedParts.add(widget.partsOrderList[i]);
        }
      }
      else{
        // print('-----ISNOTEMPTY----');
      }
    }
    for (var part in selectedParts) {
      orderQuantityControllers.add(TextEditingController(text: part['orderQuantity'].toString()));
    }
  }

  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context,selectedParts);
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const PreferredSize(preferredSize: Size.fromHeight(60),
              child: CustomAppBar()),

          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomDrawer(widget.drawerWidth,widget.selectedDestination),
              const VerticalDivider(
                width: 1,
                thickness: 1,
              ),
              Expanded(child: Scaffold(
                backgroundColor: const Color(0xffF0F4F8),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(88.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: AppBar(
                      elevation: 1,
                      surfaceTintColor: Colors.white,
                      shadowColor: Colors.black,
                      title: const Text("Create Parts Order"),
                      actions: [
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 28,
                              child: OutlinedMButton(
                                text: 'Save',
                                buttonColor: mSaveButton,
                                textColor: Colors.white,
                                borderColor: mSaveButton,
                                onTap: () {
                                  if(widget.pageName=='newPart'){
                                    bool hasZeroOrderQuantity = false;
                                    for (var part in selectedParts) {
                                      if (part['orderQuantity'] == '0' || part['orderQuantity'].isEmpty) {
                                        hasZeroOrderQuantity = true;
                                        break;
                                      }
                                    }
                                    if (hasZeroOrderQuantity) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Order quantity cannot be zero.'),
                                        ),
                                      );
                                    } else {
                                      Navigator.pop(context, selectedParts);
                                    }
                                  }
                                  else if(widget.pageName=='partOrderDetails'){

                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                ),
                body: CustomLoader(
                  inAsyncCall: loading,
                  child: LayoutBuilder(builder: (context, constraints) {
                    if(constraints.maxWidth >= 1140){
                      return buildMain(MediaQuery.of(context).size.width);
                    }
                    else {
                      return AdaptiveScrollbar(
                        position: ScrollbarPosition.bottom,
                        underColor: Colors.blueGrey.withOpacity(0.3),
                        sliderDefaultColor: Colors.grey.withOpacity(0.7),
                        sliderActiveColor: Colors.grey,
                        controller: _horizontalScrollController,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: buildMain(1140),
                        ),
                      );
                    }
                  },),
                ),
              ))
            ],)
      ),
    );
  }

  Widget buildMain(double screenWidth){
    return SingleChildScrollView(
      child: SizedBox(
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0,right: 30),
          child: Column(children: [
            buildSelectedParts(),
            const SizedBox(height: 20,),
            buildSearchParts(),
            const SizedBox(height: 20,),
          ]),
        ),
      ),
    );
  }

  Widget buildSelectedParts(){
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8),
            width: 1,)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius:  BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5)
                ),
              ),
              height: 34,
              child:const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text("Selected Parts",style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ],
              ),
            ),
            Container(
              decoration:  BoxDecoration(
                  color:Colors.grey[100],
                  border: Border(
                      top: BorderSide(color:mTextFieldBorder.withOpacity(0.8),),
                      bottom: BorderSide(color:mTextFieldBorder.withOpacity(0.8),)
                  )
              ),
              height: 34,
              child:  Row(
                children:  [
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(child: Center(child: Text('Part No',style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  // Expanded(child: Center(child: Text("Old No",style:fontWeight,))),
                  // const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 4,child: Center(child: Text("Description",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 1,child: Center(child: Text("Available QTY",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 1,child: Center(child: Text("Order QTY",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Text("Retail Price",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 2,child: Center(child: Text("Dealer Cost",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  Expanded(flex: 1,child: Center(child: Text("Remove",style:fontWeight,))),
                  const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                ],
              ),
            ),

            // if(widget.pageName=="partOrderDetails")...{
            //   ListView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: selectedParts.length,
            //     itemBuilder: (context, index) {
            //       return Column(
            //         children: [
            //           SizedBox(
            //             height: 50,
            //             child: Row(
            //               children: [
            //                 Expanded(
            //                   child: Center(child: Text('${selectedParts[index]['partNo']}')),
            //                 ),
            //                 const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
            //                 Expanded(
            //                   flex: 4,
            //                   child: Center(child: Text("${selectedParts[index]['description']}")),
            //                 ),
            //                 const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
            //                 Expanded(
            //                   flex: 1,
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(4.0),
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         color: const Color(0XFFE8FDEE),
            //                         borderRadius: BorderRadius.circular(4),
            //                       ),
            //                       height: 32,
            //                       child: Center(
            //                         child: Text(
            //                           selectedParts[index]['availableQty'].toString(),
            //                           style: const TextStyle(color: Colors.green),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
            //                 Expanded(
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(4.0),
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         color: const Color(0xffF3F3F3),
            //                         borderRadius: BorderRadius.circular(4),
            //                       ),
            //                       height: 32,
            //                       child: TextField(
            //                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //                         controller: orderQuantityControllers[index], // Using the list of controllers
            //                         textAlign: TextAlign.right,
            //                         style: const TextStyle(fontSize: 14),
            //                         decoration: const InputDecoration(
            //                           contentPadding: EdgeInsets.only(bottom: 12, right: 8, top: 2),
            //                           border: InputBorder.none,
            //                           focusedBorder: OutlineInputBorder(
            //                             borderSide: BorderSide(color: Colors.blue),
            //                           ),
            //                           enabledBorder: OutlineInputBorder(
            //                             borderSide: BorderSide(color: Colors.transparent),
            //                           ),
            //                         ),
            //                         onChanged: (v) {
            //                           try {
            //                             if (v.isNotEmpty) {
            //                               double orderQty = double.parse(v);
            //                               double initialStock = double.parse(selectedParts[index]['initialInStock'].toString());
            //                               double updatedStock = initialStock - orderQty;
            //
            //                               setState(() {
            //                                 selectedParts[index]['inStock'] = updatedStock;
            //                                 selectedParts[index]['orderQuantity'] = v;
            //                               });
            //                             } else {
            //                               setState(() {
            //                                 selectedParts[index]['orderQuantity'] = '';
            //                               });
            //                             }
            //                           } catch (e) {
            //                             print('------Exception-----');
            //                             print(e);
            //                           }
            //
            //                         },
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
            //                 Expanded(
            //                   flex: 2,
            //                   child: Center(child: Text(selectedParts[index]['retailPrice'].toString())),
            //                 ),
            //                 const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
            //                 Expanded(
            //                   flex: 2,
            //                   child: Center(child: Text(selectedParts[index]['dealerCost'].toString())),
            //                 ),
            //                 const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
            //                 Expanded(
            //                   flex: 1,
            //                   child: InkWell(
            //                     onTap: () {
            //                       setState(() {
            //                         selectedParts.removeAt(index);
            //                         orderQuantityControllers.removeAt(index); // Remove the corresponding controller
            //                       });
            //                     },
            //                     hoverColor: mHoverColor,
            //                     child: const SizedBox(
            //                       width: 30,
            //                       height: 30,
            //                       child: Center(
            //                         child: Icon(
            //                           Icons.remove_circle,
            //                           color: Colors.orange,
            //                           size: 18,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // }
            // else if(widget.pageName=="newPart")...{
            if(selectedParts.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedParts.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(child: Text('${selectedParts[index]['itemNo']}')),
                            ),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(
                              flex: 4,
                              child: Center(child: Text("${selectedParts[index]['itemDescription']}")),
                            ),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedParts[index]['inStock']<=0?const Color(0XFFFBF2E6):const Color(0XFFE8FDEE),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  height: 32,
                                  child: Center(
                                    child: Text(
                                      selectedParts[index]['inStock'].toString(),
                                      style:  TextStyle(color:selectedParts[index]['inStock']<=0?const Color(0XFFF38418): Colors.green),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF3F3F3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  height: 32,
                                  child: TextField(
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    controller: orderQuantityControllers[index], // Using the list of controllers
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: 12, right: 8, top: 2),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                      ),
                                    ),
                                    onChanged: (v) {
                                      try {
                                        if (v.isNotEmpty) {
                                          double orderQty = double.parse(v);
                                          double initialStock = double.parse(selectedParts[index]['initialInStock'].toString());
                                          double updatedStock = initialStock - orderQty;

                                          setState(() {
                                            selectedParts[index]['inStock'] = updatedStock;
                                            selectedParts[index]['orderQuantity'] = v;
                                          });
                                        } else {
                                          setState(() {
                                            selectedParts[index]['orderQuantity'] = '';
                                          });
                                        }
                                      } catch (e) {
                                        print('------Exception-----');
                                        print(e);
                                      }

                                    },
                                  ),
                                ),
                              ),
                            ),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(
                              flex: 2,
                              child: Center(child: Text(selectedParts[index]['itemCost'].toString())),
                            ),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(
                              flex: 2,
                              child: Center(child: Text(selectedParts[index]['dealerCost'].toString())),
                            ),
                            const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedParts.removeAt(index);
                                    orderQuantityControllers.removeAt(index); // Remove the corresponding controller
                                  });
                                },
                                hoverColor: mHoverColor,
                                child: const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            // },

            const Divider(height: 1,color: mTextFieldBorder,),
            const SizedBox(height: 30,),
          ]),
    );
  }
  Widget buildSearchParts(){
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8),
            width: 1,)),
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all(true),
          interactive: true,
          thumbColor: MaterialStateProperty.all(Colors.grey),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius:  BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)
                  ),
                ),
                height: 34,
                child:const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text("Search Parts",style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(width: 190,height: 30, child: TextFormField(
                  controller:searchByOrderId,
                  onChanged: (value){
                    if(value.isEmpty || value==""){
                      setState(() {
                        partOrderNotFound = false;
                      });
                      partsStaticData = [];
                      fetchMasterParts();
                    }
                    else{
                      try{
                        fetchByPartMaster(searchByOrderId.text);
                      }
                      catch(e){
                        log(e.toString());
                      }
                    }
                  },
                  onEditingComplete: (){
                    if(partsStaticData.isNotEmpty){
                      print('-------partsStaticData---------');
                      print(partsStaticData);
                      for(int i=0;i<partsStaticData.length;i++){
                        print("----------");
                        print(partsStaticData[i]['inStock'].runtimeType);
                        if(partsStaticData[i]['inStock']==0){
                          String timeNow = "";
                          timeNow = DateTime.now().toString();

                          // Parse the string to a DateTime object
                          DateTime parsedDate = DateTime.parse(timeNow.replaceAll(' ', 'T'));
                          // Convert to UTC format and display in the desired format
                          String formattedDate = parsedDate.toUtc().toIso8601String();
                          print('---------Date Format--------');
                          print(formattedDate); // Output: 2024-10-16T13:05:45.441Z


                          Map notificationDetails = {
                            "itemDescription": partsStaticData[i]['itemDescription']??"",
                            "partsMasterId": partsStaticData[i]['partsMasterId']??"",
                            "time": formattedDate,
                            "userId": "string"
                          };
                          print('------Govinda------');
                          print(notificationDetails);
                          partsNotification(notificationDetails);
                        }
                      }
                    }
                  },
                  style: const TextStyle(fontSize: 14),
                  keyboardType: TextInputType.text,
                  decoration: searchByPartMaster(hintText: 'Search for Parts'),  ),),
              ),
              const SizedBox(height: 10,),
              Container(
                decoration:  BoxDecoration(
                    color:Colors.grey[100],
                    border: Border(
                        top: BorderSide(color:mTextFieldBorder.withOpacity(0.8),),
                        bottom: BorderSide(color:mTextFieldBorder.withOpacity(0.8),)
                    )
                ),
                height: 34,
                child:  Row(
                  children:  [
                    const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    Expanded(child: Center(child: Text('Part No',style:fontWeight,))),
                    const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    // Expanded(child: Center(child: Text("Old No",style:fontWeight,))),
                    // const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    Expanded(flex: 4,child: Center(child: Text("Description",style:fontWeight,))),
                    const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    Expanded(flex: 1,child: Center(child: Text("Available QTY",style:fontWeight,))),
                    const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    Expanded(flex: 1,child: Center(child: Text("Order QTY",style:fontWeight,))),
                    const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    Expanded(flex: 2,child: Center(child: Text("Retail Price",style:fontWeight,))),
                    const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    Expanded(flex: 2,child: Center(child: Text("Dealer Cost",style:fontWeight,))),
                    const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                    Expanded(flex: 1,child: Center(child: Text("Add",style:fontWeight,))),
                    const CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                  ],
                ),
              ),
              if(partOrderNotFound)
                const Center(
                  child: Column(
                    children: [
                      //SizedBox(height: 100,),
                      Text('Part No Not Found Please Check...',style: TextStyle(color: Colors.indigo,
                          fontSize: 20,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: partsStaticData.length,
                  itemBuilder: (context, index) {
                    // print('-----------Runtype----------');
                    // print(partsStaticData[index]['inStock'].runtimeType);
                    // print(partsStaticData[index]['inStock']<=0);

                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            children:  [
                              Expanded(child: Center(child: Text('${partsStaticData[index]['itemNo']}'))),
                              const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                              // Expanded(child: Center(child:
                              //     Text("")
                              // // Text("${partsStaticData[index]['Old No']}")
                              //
                              // )),
                              // const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                              Expanded(flex: 4,child: Center(child: Text("${partsStaticData[index]['itemDescription']}"))),
                              const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                              Expanded(flex: 1,child: Padding(
                                padding: const EdgeInsets.only(left: 12,top: 4,right: 12,bottom: 4),
                                child: Container(
                                    decoration: BoxDecoration(color:
                                     partsStaticData[index]['inStock']<=0?const Color(0XFFFBF2E6):const Color(0XFFE8FDEE),
                                        borderRadius: BorderRadius.circular(4)),
                                    height: 32,
                                    child: Center(child: Text(partsStaticData[index]['inStock'].toString(),
                                      style:  TextStyle(color:partsStaticData[index]['inStock']<=0 ?const Color(0XFFF38418):Colors.green),))),
                              )),
                              const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                              Expanded(flex: 1,child: Center(child: Text(partsStaticData[index]['orderQuantity'].toString()))),
                              const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                              Expanded(flex: 2,child: Center(child: Text(partsStaticData[index]['itemCost'].toString()))),
                              const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                              Expanded(flex: 2,child: Center(child: Text(partsStaticData[index]['dealerCost'].toString()))),
                              const CustomVDivider(height: 80, width: 1, color: mTextFieldBorder),
                              Expanded(flex:1,
                                child: InkWell(onTap: (){
                                  setState(() {
                                    bool matched = false;
                                    // Check if selectedParts is not empty
                                    if (selectedParts.isNotEmpty) {
                                      // Iterate through the selectedParts to find a match
                                      for (var element in selectedParts) {
                                        if (element['partsMasterId'] == partsStaticData[index]['partsMasterId']) {
                                          matched = true;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Selected Part Item Added Please Check..."),
                                                duration: Duration(seconds: 3),
                                              ));

                                          break; // Exit the loop once a match is found
                                        }
                                      }
                                      // Add to selectedParts if no match was found
                                      if (matched==false) {
                                        partsStaticData[index]['initialInStock'] = partsStaticData[index]['inStock'].toString();
                                        // print('--------add--------');
                                        // print(partsStaticData[index]);
                                        selectedParts.add(partsStaticData[index]);
                                        orderQuantityControllers.add(TextEditingController(text: "0"));
                                      }
                                    }
                                    else {
                                      // If selectedParts is empty, directly add the item.
                                      partsStaticData[index]['initialInStock'] = partsStaticData[index]['inStock'].toString();
                                      selectedParts.add(partsStaticData[index]);
                                      orderQuantityControllers.add(TextEditingController(text: "0"));
                                    }
                                    // print('-------matched---------');
                                    // print(matched);

                                  });
                                },
                                    hoverColor: mHoverColor,
                                    child: const SizedBox(width: 30,height: 30,
                                        child: Center(child: Icon(Icons.add_circle_rounded,color: Colors.blue,size: 18,)))),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1,color: mTextFieldBorder,),
                      ],
                    );
                  },),
              ),
              //const Divider(height: 1,color: mTextFieldBorder,),
              const SizedBox(height: 30,),
            ]),
      ),
    );
  }
  //Decoration
  searchByPartMaster ({required String hintText, }){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByOrderId.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              partOrderNotFound = false;
              partsStaticData = [];
              searchByOrderId.clear();
              fetchMasterParts();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder:  const OutlineInputBorder(borderSide: BorderSide(color:mSaveButton)),
    );
  }
  Future fetchByPartMaster(String partNo)async{
    dynamic response;
    String url="${StaticData.url}parts_master/search_by_itemNo/$partNo";
    try{
      await getData(url:url ,context: context).then((statusItems){
        setState(() {
          if(statusItems!=null){
            response = statusItems;
            partsStaticData = response;
            if(partsStaticData.isEmpty){
              partOrderNotFound = true;
            }
            else {
              partOrderNotFound = false;
            }
          }
        });
      });

    }
    catch(e){
      log(e.toString());
    }
  }
}




