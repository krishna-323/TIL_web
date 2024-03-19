import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_project/utils/custom_loader.dart';
import 'package:new_project/utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import 'package:new_project/widgets/custom_dividers/custom_vertical_divider.dart';

import '../utils/api/get_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';

class AddVehicleToForm extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const AddVehicleToForm({Key? key,  required this.selectedDestination, required this.drawerWidth }) : super(key: key);

  @override
  State<AddVehicleToForm> createState() => _AddVehicleToFormState();
}

class _AddVehicleToFormState extends State<AddVehicleToForm> {

  bool loading = false;
  bool checkBool=false;
  Map selectedVehicle ={
    "model": "",
    "qty": "",
    "chassisCab": "",
    "bodyBuildType": "",
    "noOfDeliveryLoc": "",
    "bodybuilder": "",
    "location1": {"type": "", "loc": "", "details": ""},
    "location2": {"type": "", "loc": "", "details": ""},
    "location3": {"type": "", "loc": "", "details": ""}
  };
  final brandNameController=TextEditingController();
  var modelNameController = TextEditingController();
  var variantController=TextEditingController();
  String storeGeneralId="";
  int startVal=0;
  List vehicleList = [];
  List displayList=[];
  List selectedVehicles=[];
  List<String> generalIdMatch = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllVehicleVariant();

  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Your logic goes here
        // For example:
        Navigator.pop(context,  selectedVehicle,);
        // If you want to allow navigation back, return true
        return true;

        // If you want to prevent navigation back, return false
        // return false;
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
            child: CustomAppBar()),
        body: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomDrawer(widget.drawerWidth,widget.selectedDestination),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(
              child:
              Scaffold(
                backgroundColor: const Color(0xffF0F4F8),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(88.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: AppBar(
                      elevation: 1,
                      surfaceTintColor: Colors.white,
                      shadowColor: Colors.black,
                      title: const Text("Add Vehicle"),
                      actions: [
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,height: 28,
                              child: OutlinedMButton(
                                text: 'Save',
                                buttonColor:mSaveButton ,
                                textColor: Colors.white,
                                borderColor: mSaveButton,
                                onTap: (){
                                  Navigator.pop(context,  selectedVehicle,);
                                }

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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10,left: 68,bottom: 30,right: 68),
                      child: Column(
                        children: [
                          buildLineCard(),
                          const SizedBox(height: 20,),
                          buildDeliveryInstructionCard(),
                        ],
                      )

                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLineCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.white,),
        child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
          children: [

            ///-----------------------------Table Header-------------------------

            Container(color: const Color(0xffffffff),
              height: 76,
              child:  const Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text('VEHICLE DETAILS',style: TextStyle(fontWeight: FontWeight.bold,)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 4, child: Center(child: Text("Model"))),
                            CustomVDivider(height: 35, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Qty"))),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomVDivider(height: 76, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text('Vehicle required DSLB or Chassis Cab',style: TextStyle(fontWeight: FontWeight.bold,)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            Expanded(child: Center(child: Text("Chassis Cab"))),
                            CustomVDivider(height: 35, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Body Build"))),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomVDivider(height: 76, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text('Delivery',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            Expanded(flex: 3,child: Center(child: Text('Delivery Location'))),
                            CustomVDivider(height: 35, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 3, child: Center(child: Text("Bodybuilder"))),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: mTextFieldBorder,height: 1),
            ///-----------------------------Table Line-------------------------
            Container(color: Colors.white,
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 4, child: Padding(
                              padding: const EdgeInsets.only(left: 18.0,right: 18),
                              child: SizedBox(height: 46,
                                child: lineText(selectedVehicle['model'],onTap: (){
                                  showDialog(
                                    context: context,
                                    builder: (context) => showDialogBox()
                                  ).then((value) {
                                    if(value != null && value.isNotEmpty) {
                                      setState(() {
                                        selectedVehicle['model'] = value;
                                      });
                                    }
                                  });

                                }),
                              ),
                            )),
                            const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: lineTextField(selectedVehicle['qty'].toString(),
                                onChanged: (v){
                                  setState(() {
                                    selectedVehicle['qty'] =v;
                                  });
                                }
                            ))),
                          ],
                        )
                      ],
                    ),
                  ),
                  const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Expanded( child:  Padding(
                              padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: 24,width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: mTextFieldBorder),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                          return CustomPopupMenuButton<String>(
                                            hintText: '',
                                            decoration: lineCustomPopupDecoration(hintText:  selectedVehicle['chassisCab']),
                                            childWidth: constraints.maxWidth,
                                            offset: const Offset(1, 40),
                                            itemBuilder:  (BuildContext context) {
                                              return ['Yes','No'].map((String choice) {
                                                return CustomPopupMenuItem<String>(
                                                    value: choice,
                                                    text: choice,
                                                    child: Container()
                                                );
                                              }).toList();
                                            },

                                            onSelected: (String value)  {
                                              setState(() {
                                                selectedVehicle['chassisCab'] = value;
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
                              ),
                            ),),
                            const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                            Expanded( child:  Padding(
                              padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                              child: Container(height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: mTextFieldBorder),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return CustomPopupMenuButton<String>(
                                        hintText: '',
                                        decoration: lineCustomPopupDecoration(hintText:  selectedVehicle['bodyBuildType']),
                                        childWidth: constraints.maxWidth,
                                        offset: const Offset(1, 40),
                                        itemBuilder:  (BuildContext context) {
                                          return ["Dropside", "VAN body", "Tipper", "Tautliner", "Flat deck"].map((String choice) {
                                            return CustomPopupMenuItem<String>(
                                                value: choice,
                                                text: choice,
                                                child: Container()
                                            );
                                          }).toList();
                                        },

                                        onSelected: (String value)  {
                                          setState(() {
                                            selectedVehicle['bodyBuildType'] = value;
                                          });
                                        },
                                        onCanceled: () {

                                        },
                                        child: Container(),
                                      );
                                    }
                                ),
                              ),
                            ),),
                          ],
                        )
                      ],
                    ),
                  ),
                  const CustomVDivider(height: 69, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 3,child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: SizedBox(width: 100,
                                  child: lineTextField(selectedVehicle['noOfDeliveryLoc'].toString(),
                                      onChanged: (v){
                                        setState(() {
                                          selectedVehicle['noOfDeliveryLoc'] =v;
                                        });
                                      }
                                  ),
                                )),
                              ],
                            )),
                            const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 3, child:  Padding(
                              padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                              child: Container(height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: mTextFieldBorder),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return CustomPopupMenuButton<String>(
                                        hintText: '',
                                        decoration: lineCustomPopupDecoration(hintText:  selectedVehicle['bodybuilder']),
                                        childWidth: constraints.maxWidth,
                                        offset: const Offset(1, 40),
                                        itemBuilder:  (BuildContext context) {
                                          return ["Yes","No"].map((String choice) {
                                            return CustomPopupMenuItem<String>(
                                                value: choice,
                                                text: choice,
                                                child: Container()
                                            );
                                          }).toList();
                                        },

                                        onSelected: (String value)  {
                                          setState(() {
                                            selectedVehicle['bodybuilder'] = value;
                                          });
                                        },
                                        onCanceled: () {

                                        },
                                        child: Container(),
                                      );
                                    }
                                ),
                              ),
                            ),),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: mTextFieldBorder,height: 1),
            ///-----------------------------Table Location-------------------------



          ],
        ),
      ),
    );
  }

  Widget buildDeliveryInstructionCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Container(color: Colors.white,
        child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            ///-----------------------------Table Location-------------------------
            const Padding(
              padding: EdgeInsets.only(left: 18.0,top: 8,bottom: 8),
              child: Text("Deliver Instructions",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            ),
            const Divider(color: mTextFieldBorder,height: 1),
            Container(color: Colors.white,
              height: 330,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Location One"),
                        ),
                        const Divider(color: mTextFieldBorder,height: 1),
                        const SizedBox(height: 4,),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0,left: 18,top: 8,bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded( child:  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                    child: Container(height: 28,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: mTextFieldBorder),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints) {
                                            return CustomPopupMenuButton<String>(
                                              hintText: '',
                                              decoration: customPopupDecoration(hintText:  selectedVehicle['location1']['type']),
                                              childWidth: constraints.maxWidth,
                                              offset: const Offset(1, 40),
                                              itemBuilder:  (BuildContext context) {
                                                return ['Bodybuilder','Dealer',"Customer"].map((String choice) {
                                                  return CustomPopupMenuItem<String>(
                                                      value: choice,
                                                      text: choice,
                                                      child: Container()
                                                  );
                                                }).toList();
                                              },

                                              onSelected: (String value)  {
                                                setState(() {
                                                  selectedVehicle['location1']['type'] = value;
                                                });
                                              },
                                              onCanceled: () {

                                              },
                                              child: Container(),
                                            );
                                          }
                                      ),
                                    ),
                                  ),),

                                ],
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 30,
                                  child: addressTextField(selectedVehicle['location1']['loc'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location1']['loc'] =v;
                                      }
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 140,
                                  child: addressTextField(selectedVehicle['location1']['details'].toString(),
                                      maxLines: 7,
                                      onChanged: (v){
                                        selectedVehicle['location1']['details'] =v;
                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomVDivider(height: 330, width: 1, color: mTextFieldBorder),



                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Location Two"),
                        ),
                        const Divider(color: mTextFieldBorder,height: 1),
                        const SizedBox(height: 4,),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0,left: 18,top: 8,bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded( child:  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                    child: Container(height: 28,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: mTextFieldBorder),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints) {
                                            return CustomPopupMenuButton<String>(
                                              hintText: '',
                                              decoration: customPopupDecoration(hintText:  selectedVehicle['location2']['type']),
                                              childWidth: constraints.maxWidth,
                                              offset: const Offset(1, 40),
                                              itemBuilder:  (BuildContext context) {
                                                return ['Bodybuilder','Dealer',"Customer"].map((String choice) {
                                                  return CustomPopupMenuItem<String>(
                                                      value: choice,
                                                      text: choice,
                                                      child: Container()
                                                  );
                                                }).toList();
                                              },

                                              onSelected: (String value)  {
                                                setState(() {
                                                  selectedVehicle['location2']['type'] = value;
                                                });
                                              },
                                              onCanceled: () {

                                              },
                                              child: Container(),
                                            );
                                          }
                                      ),
                                    ),
                                  ),),

                                ],
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 30,
                                  child: addressTextField(selectedVehicle['location2']['loc'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location2']['loc'] =v;
                                      }
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 140,
                                  child: addressTextField(selectedVehicle['location2']['details'].toString(),
                                      maxLines: 7,
                                      onChanged: (v){
                                        selectedVehicle['location2']['details'] =v;
                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const CustomVDivider(height: 330, width: 1, color: mTextFieldBorder),



                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Location Three"),
                        ),
                        const Divider(color: mTextFieldBorder,height: 1),
                        const SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0,left: 18,top: 8,bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded( child:  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                    child: Container(height: 28,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: mTextFieldBorder),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints) {
                                            return CustomPopupMenuButton<String>(
                                              hintText: '',
                                              decoration: customPopupDecoration(hintText:  selectedVehicle['location3']['type']),
                                              childWidth: constraints.maxWidth,
                                              offset: const Offset(1, 40),
                                              itemBuilder:  (BuildContext context) {
                                                return ['Bodybuilder','Dealer',"Customer"].map((String choice) {
                                                  return CustomPopupMenuItem<String>(
                                                      value: choice,
                                                      text: choice,
                                                      child: Container()
                                                  );
                                                }).toList();
                                              },

                                              onSelected: (String value)  {
                                                setState(() {
                                                  selectedVehicle['location3']['type'] = value;
                                                });
                                              },
                                              onCanceled: () {

                                              },
                                              child: Container(),
                                            );
                                          }
                                      ),
                                    ),
                                  ),),

                                ],
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 30,
                                  child: addressTextField(selectedVehicle['location3']['loc'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location3']['loc'] =v;
                                      }
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 140,
                                  child: addressTextField(selectedVehicle['location3']['details'].toString(),
                                      maxLines: 7,
                                      onChanged: (v){
                                        selectedVehicle['location3']['details'] =v;
                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget lineText(String text,{GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: mTextFieldBorder),
              borderRadius: BorderRadius.circular(4)),
          child: Center(
              child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))),
    );
  }

  Widget lineTextField(text,{required ValueChanged onChanged}) {
    var t1 = TextEditingController(text: '$text');
    t1.selection = TextSelection.fromPosition(TextPosition(offset: t1.text.length));
    return Container(
      height: 24,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child:  Center(
        child: TextField(
            textAlign: TextAlign.center,controller: t1,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 2,top: 4,bottom: 8,right: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
            ),
            style: const TextStyle(fontSize: 13, overflow: TextOverflow.visible),
            onChanged:onChanged
        ),
      ),
    );
  }

  Widget addressTextField(text,{required ValueChanged onChanged, required int maxLines}) {
    var t1 = TextEditingController(text: '$text');
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child:  Center(
        child: TextField(maxLines: maxLines,
            textAlign: TextAlign.left,controller: t1,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 12,top: 6,bottom: 8,right: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
            ),
            style: const TextStyle(fontSize: 13, overflow: TextOverflow.visible),
            onChanged:onChanged
        ),
      ),
    );
  }

  customPopupDecoration({required String hintText}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 0, 0, 18),

    );

  }
  lineCustomPopupDecoration({required String hintText}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      constraints: const BoxConstraints(maxHeight: 30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
      counterText: '',
      contentPadding: const EdgeInsets.only(left: 8,top: 1,bottom: 16),

    );

  }

  Widget showDialogBox(){
    return Dialog(
      backgroundColor: Colors.transparent,
      child:StatefulBuilder(
          builder: (context,  setState) {
            return SizedBox(
              // width: MediaQuery.of(context).size.width/1.5,
              //height: MediaQuery.of(context).size.height/1.1,
              child: Stack(
                children: [
                  Container(
                    width: 950,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(top: 13.0, right: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0,right:20,bottom: 10,top:10),
                      child: Card(surfaceTintColor: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            ///search Fields
                            Row(
                              children: [
                                const SizedBox(width: 10,),
                                SizedBox(width: 250,height: 35,
                                  child: TextFormField(
                                    controller: brandNameController,
                                    decoration: textFieldBrandNameField(hintText: 'Search Brand',
                                        onTap:()async{
                                          if(brandNameController.text.isEmpty || brandNameController.text==""){
                                            await getAllVehicleVariant().whenComplete(() => setState((){}));
                                          }
                                        }
                                    ),
                                    onChanged: (value) async{
                                      if(value.isNotEmpty || value!=""){
                                        await fetchBrandName(brandNameController.text).whenComplete(()=>setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    decoration:  textFieldModelNameField(hintText: 'Search Model',onTap: ()async{
                                      if(modelNameController.text.isEmpty || modelNameController.text==""){
                                        await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    }),
                                    controller: modelNameController,
                                    onChanged: (value)async {
                                      if(value.isNotEmpty || value!=""){
                                        await  fetchModelName(modelNameController.text).whenComplete(() =>setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        await getAllVehicleVariant().whenComplete(()=> setState((){}));
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(width: 10,),
                                SizedBox(width: 250,
                                  child: TextFormField(
                                    controller: variantController,
                                    decoration: textFieldVariantNameField(hintText: 'Search Variant',onTap:()async{
                                      if(variantController.text.isEmpty || variantController.text==""){
                                        await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    }),
                                    onChanged: (value) async{
                                      if(value.isNotEmpty || value!=""){
                                        await fetchVariantName(variantController.text).whenComplete(() => setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            ///Table Header
                            Container(
                              height: 40,
                              color: Colors.grey[200],
                              child: const Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text("Brand")),
                                    Expanded(child: Text("Model")),
                                    Expanded(child: Text("Variant")),
                                    Expanded(child: Text("On road price")),
                                    Expanded(child: Text("Year of Manufacture")),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4,),
                            Expanded(
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: displayList.length+1,
                                    itemBuilder: (context,int i){
                                      if(i<displayList.length){
                                        return   Column(
                                          children: [
                                            MaterialButton(
                                              hoverColor: mHoverColor,
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context,displayList[i]['model']);
                                                  storeGeneralId=displayList[i]["excel_id"];
                                                  for(var tempValue in generalIdMatch){
                                                    if(tempValue == storeGeneralId){
                                                      setState((){
                                                        checkBool=true;
                                                      });
                                                    }
                                                  }
                                                });

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 18.0),
                                                child: SizedBox(height: 30,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['make']??""),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(
                                                              displayList[i]['model']??""),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['varient']??''),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['on_road_price'].toString()),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['year_of_manufacture']??""),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                          ],
                                        );
                                      }
                                      else{
                                        return Column(children: [
                                          Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                          Row(mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("${startVal+15>vehicleList.length?vehicleList.length:startVal+1}-${startVal+15>vehicleList.length?vehicleList.length:startVal+15} of ${vehicleList.length}",style: const TextStyle(color: Colors.grey)),
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
                                                        try{
                                                          setState(() {
                                                            displayList.add(vehicleList[i]);
                                                          });
                                                        }
                                                        catch(e){
                                                          print(e.toString());
                                                        }
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
                                                    setState(() {
                                                      if(vehicleList.length>startVal+15){
                                                        displayList=[];
                                                        startVal=startVal+15;
                                                        for(int i=startVal;i<startVal+15;i++){
                                                          try{
                                                            setState(() {
                                                              displayList.add(vehicleList[i]);
                                                            });
                                                          }
                                                          catch(e){
                                                            print("Expected Type Error $e ");
                                                            print(e.toString());
                                                          }

                                                        }
                                                      }
                                                    });


                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                            ],
                                          ),
                                          Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                        ],);
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: InkWell(
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromRGBO(204, 204, 204, 1),
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
            );
          }
      ),
    );
  }

  textFieldDecoration({required String hintText, required bool error}) {
    return  InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldVendorAndWarehouse({required String hintText, required bool error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.search,size: 18),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:  OutlineInputBorder(borderSide: BorderSide(color:error? Colors.red:mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldBrandNameField( {required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      suffixIcon:  brandNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          brandNameController.clear();
          onTap!();
        });
      },
          child: const Icon(Icons.close,size: 18,)
      ),

      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldModelNameField({required String hintText, bool? error,Function ? onTap}) {
    return  InputDecoration(
      suffixIcon:  modelNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          modelNameController.clear();
          onTap!();
        });
      },
          child: const Icon(Icons.close,size: 18,)
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldVariantNameField({required String hintText, bool? error,Function ? onTap}) {
    return  InputDecoration(
      suffixIcon:  variantController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        variantController.clear();
        onTap!();
      },
          child: const Icon(Icons.close,size: 18,)
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }


  Future getAllVehicleVariant() async {
    dynamic response;
   // String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_mod_general";
    try {
      {
        response = [
          {
            "excel_id": "EXC_20869",
            "make": "CV-FML",
            "model": "T1 AMB",
            "varient": "T006860023434",
            "date": "16-7-34",
            "on_road_price": 7700000.0,
            "color": "Grey",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20870",
            "make": "CV-TDCV",
            "model": "KC3C1",
            "varient": "KC3C1",
            "date": "16-7-35",
            "on_road_price": 6800000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20871",
            "make": "CV-TDCV",
            "model": "F8C6F",
            "varient": "F8C6F",
            "date": "15-7-36",
            "on_road_price": 8651500.0,
            "color": "Black",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20872",
            "make": "CV-TML",
            "model": "LPO 1316",
            "varient": "27500855000R",
            "date": "16-8-6",
            "on_road_price": 7100000.0,
            "color": "White",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20873",
            "make": "CV-FML",
            "model": "T1 MB",
            "varient": "T006860016733",
            "date": "15-7-33",
            "on_road_price": 4200000.0,
            "color": "Grey",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20874",
            "make": "CV-TML",
            "model": "YODHA",
            "varient": "28985631ABFR",
            "date": "16-7-34",
            "on_road_price": 2725000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20875",
            "make": "CV-TML",
            "model": "XENON DC",
            "varient": "55025831ABFR",
            "date": "16-7-35",
            "on_road_price": 3800000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20876",
            "make": "CV-TML",
            "model": "INTRA V20",
            "varient": "55461223AKOR",
            "date": "15-7-36",
            "on_road_price": 2325000.0,
            "color": "Black",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20877",
            "make": "CV-TDCV",
            "model": "V3T6F",
            "varient": "V3T6F",
            "date": "16-8-6",
            "on_road_price": 1.153724E7,
            "color": "White",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20878",
            "make": "CV-TML",
            "model": "LPK 2518",
            "varient": "41061262000RZK22",
            "date": "16-8-7",
            "on_road_price": 8875000.0,
            "color": "Grey",
            "year_of_manufacture": "2023"
          },
          {
            "excel_id": "EXC_20879",
            "make": "CV-TML",
            "model": "LPK 2516",
            "varient": "21715238000RBP20",
            "date": "15-7-32",
            "on_road_price": 7875000.0,
            "color": "Grey",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20880",
            "make": "CV-TML",
            "model": "SIGNA 1618",
            "varient": "21827336000RBH31",
            "date": "15-7-33",
            "on_road_price": 6075000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20881",
            "make": "CV-TML",
            "model": "SIGNA 2823",
            "varient": "50971038000R",
            "date": "16-7-34",
            "on_road_price": 1.0E7,
            "color": "Black",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20882",
            "make": "CV-TML",
            "model": "LPT 810",
            "varient": "26426438000R",
            "date": "16-7-35",
            "on_road_price": 3300000.0,
            "color": "White",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20883",
            "make": "CV-TML",
            "model": "SFC 407",
            "varient": "26522731000R",
            "date": "15-7-36",
            "on_road_price": 2750000.0,
            "color": "Grey",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20884",
            "make": "CV-TML",
            "model": "SIGNA 2518",
            "varient": "50302148000R",
            "date": "16-8-6",
            "on_road_price": 6580000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20885",
            "make": "CV-TML",
            "model": "LPT 809",
            "varient": "KB080938KENR",
            "date": "16-8-7",
            "on_road_price": 3225000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20886",
            "make": "CV-TML",
            "model": "LPT 1216",
            "varient": "KY111648KENR",
            "date": "15-7-36",
            "on_road_price": 4000000.0,
            "color": "Black",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20887",
            "make": "CV-TML",
            "model": "ULTRA T9",
            "varient": "55069139000R",
            "date": "16-8-6",
            "on_road_price": 3875000.0,
            "color": "White",
            "year_of_manufacture": "2022"
          }
        ];
        vehicleList = response;
        startVal=0;
        displayList=[];
        if(displayList.isEmpty){
          if(vehicleList.length>15){
            for(int i=startVal;i<startVal+15;i++){
              displayList.add(vehicleList[i]);
            }
          }
          else{
            for(int i=startVal;i<vehicleList.length;i++){
              displayList.add(vehicleList[i]);
            }
          }
        }
      }
      // await getData(context: context, url: url).then((value) {
      //   setState(() {
      //     if (value != null) {
      //       response = value;
      //       vehicleList = response;
      //       startVal=0;
      //       displayList=[];
      //       if(displayList.isEmpty){
      //         if(vehicleList.length>15){
      //           for(int i=startVal;i<startVal+15;i++){
      //             displayList.add(vehicleList[i]);
      //           }
      //         }
      //         else{
      //           for(int i=startVal;i<vehicleList.length;i++){
      //             displayList.add(vehicleList[i]);
      //           }
      //         }
      //       }
      //     }
      //     loading = false;
      //   });
      // });
    } catch (e) {
      logOutApi(context: context, exception: e.toString(), response: response);
      setState(() {
        loading = false;
      });
    }
  }
  Future fetchModelName(String modelName)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_model_name/$modelName';
    try{
      await getData(url:url ,context:context ).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            vehicleList=response;
            displayList=[];
            startVal=0;
            try{
              if(displayList.isEmpty){
                if(vehicleList.length>15){
                  for(int i=startVal;i<startVal+15;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
                else{
                  for(int i=startVal;i<vehicleList.length;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
              }
            }
            catch(e){
              print("Excepted Type $e");
            }
          }
        });
      }
      );
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());

    }
  }
  Future fetchBrandName(String brandName)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_brand_name/$brandName';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            vehicleList=response;
            displayList=[];
            startVal=0;
            try{
              if(displayList.isEmpty){
                if(vehicleList.length>15){
                  for(int i=startVal;i<startVal+15;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
                else{
                  for(int i=startVal;i<vehicleList.length;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
              }
            }
            catch(e){
              print("Excepted Type $e");
            }
          }
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
    }
  }

  Future fetchVariantName(String variantName)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_variant_name/$variantName';
    try{
      await getData(context:context ,url: url).then((value) {
        setState((){
          if(value!=null){
            response=value;
            vehicleList=response;
            displayList=[];
            startVal=0;
            try{
              if(displayList.isEmpty){
                if(vehicleList.length>15){
                  for(int i=startVal;i<startVal+15;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
                else{
                  for(int i=startVal;i<vehicleList.length;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
              }
            }
            catch(e){
              print("Excepted Type $e");
            }
          }
        });
      });
    }
    catch(e){
      logOutApi(context:context ,response: response,exception: e.toString());
    }
  }

}


class EditVehicleToForm extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final Map selectedVehicle ;

  const EditVehicleToForm({super.key, required this.drawerWidth, required this.selectedDestination, required this.selectedVehicle});

  @override
  State<EditVehicleToForm> createState() => _EditVehicleToFormState();
}

class _EditVehicleToFormState extends State<EditVehicleToForm> {

  bool loading = false;
  bool checkBool=false;
  Map selectedVehicle ={};
  final brandNameController=TextEditingController();
  var modelNameController = TextEditingController();
  var variantController=TextEditingController();
  String storeGeneralId="";
  int startVal=0;
  List vehicleList = [];
  List displayList=[];
  List selectedVehicles=[];
  List<String> generalIdMatch = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedVehicle = widget.selectedVehicle;
    getAllVehicleVariant();

  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Your logic goes here
        // For example:
        Navigator.pop(context,  selectedVehicle,);
        // If you want to allow navigation back, return true
        return true;

        // If you want to prevent navigation back, return false
        // return false;
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
            child: CustomAppBar()),
        body: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomDrawer(widget.drawerWidth,widget.selectedDestination),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(
              child:
              Scaffold(
                backgroundColor: const Color(0xffF0F4F8),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(88.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: AppBar(
                      elevation: 1,
                      surfaceTintColor: Colors.white,
                      shadowColor: Colors.black,
                      title: const Text("Add Vehicle"),
                      actions: [
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,height: 28,
                              child: OutlinedMButton(
                                  text: 'Save',
                                  buttonColor:mSaveButton ,
                                  textColor: Colors.white,
                                  borderColor: mSaveButton,
                                  onTap: (){
                                    Navigator.pop(context,  selectedVehicle,);
                                  }

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
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: const  EdgeInsets.only(top: 10,left: 68,bottom: 30,right: 68),
                        child: Column(
                          children: [
                            buildLineCard(),
                            const SizedBox(height: 20,),
                            buildDeliveryInstructionCard()
                          ],
                        )

                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLineCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Colors.white,),
        child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
          children: [

            ///-----------------------------Table Header-------------------------

            Container(color: const Color(0xffffffff),
              height: 76,
              child:  const Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text('VEHICLE DETAILS',style: TextStyle(fontWeight: FontWeight.bold,)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            CustomVDivider(height: 34, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 4, child: Center(child: Text("Model"))),
                            CustomVDivider(height: 35, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Qty"))),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomVDivider(height: 65, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text('Vehicle required DSLB or Chassis Cab',style: TextStyle(fontWeight: FontWeight.bold,)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            Expanded(child: Center(child: Text("Chassis Cab"))),
                            CustomVDivider(height: 35, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: Text("Body Build"))),
                          ],
                        )
                      ],
                    ),
                  ),
                  CustomVDivider(height: 68, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text('Delivery',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Divider(color: mTextFieldBorder,height: 1),
                        Row(
                          children: [
                            Expanded(flex: 3,child: Center(child: Text('Delivery Location'))),
                            CustomVDivider(height: 35, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 3, child: Center(child: Text("Bodybuilder"))),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: mTextFieldBorder,height: 1),
            ///-----------------------------Table Line-------------------------
            Container(color: Colors.white,
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 4, child: Padding(
                              padding: const EdgeInsets.only(left: 18.0,right: 18),
                              child: SizedBox(height: 46,
                                child: lineText(selectedVehicle['model'],onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (context) => showDialogBox()
                                  ).then((value) {
                                    if(value != null && value.isNotEmpty) {
                                      setState(() {
                                        selectedVehicle['model'] = value;
                                      });
                                    }
                                  });

                                }),
                              ),
                            )),
                            const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                            Expanded(child: Center(child: lineTextField(selectedVehicle['qty'].toString(),
                                onChanged: (v){
                                  setState(() {
                                    selectedVehicle['qty'] =v;
                                  });
                                }
                            ))),
                          ],
                        )
                      ],
                    ),
                  ),
                  const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Expanded( child:  Padding(
                              padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: 24,width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: mTextFieldBorder),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                          return CustomPopupMenuButton<String>(
                                            hintText: '',
                                            decoration: lineCustomPopupDecoration(hintText:  selectedVehicle['chassisCab']),
                                            childWidth: constraints.maxWidth,
                                            offset: const Offset(1, 40),
                                            itemBuilder:  (BuildContext context) {
                                              return ['Yes','No'].map((String choice) {
                                                return CustomPopupMenuItem<String>(
                                                    value: choice,
                                                    text: choice,
                                                    child: Container()
                                                );
                                              }).toList();
                                            },

                                            onSelected: (String value)  {
                                              setState(() {
                                                selectedVehicle['chassisCab'] = value;
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
                              ),
                            ),),
                            const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                            Expanded( child:  Padding(
                              padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                              child: Container(height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: mTextFieldBorder),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return CustomPopupMenuButton<String>(
                                        hintText: '',
                                        decoration: lineCustomPopupDecoration(hintText:  selectedVehicle['bodyBuildType']),
                                        childWidth: constraints.maxWidth,
                                        offset: const Offset(1, 40),
                                        itemBuilder:  (BuildContext context) {
                                          return ["Dropside", "VAN body", "Tipper", "Tautliner", "Flat deck"].map((String choice) {
                                            return CustomPopupMenuItem<String>(
                                                value: choice,
                                                text: choice,
                                                child: Container()
                                            );
                                          }).toList();
                                        },

                                        onSelected: (String value)  {
                                          setState(() {
                                            selectedVehicle['bodyBuildType'] = value;
                                          });
                                        },
                                        onCanceled: () {

                                        },
                                        child: Container(),
                                      );
                                    }
                                ),
                              ),
                            ),),
                          ],
                        )
                      ],
                    ),
                  ),
                  const CustomVDivider(height: 69, width: 1, color: mTextFieldBorder),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 3,child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: SizedBox(width: 100,
                                  child: lineTextField(selectedVehicle['noOfDeliveryLoc'].toString(),
                                      onChanged: (v){
                                        setState(() {
                                          selectedVehicle['noOfDeliveryLoc'] =v;
                                        });
                                      }
                                  ),
                                )),
                              ],
                            )),
                            const CustomVDivider(height: 70, width: 1, color: mTextFieldBorder),
                            Expanded(flex: 3, child:  Padding(
                              padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                              child: Container(height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: mTextFieldBorder),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return CustomPopupMenuButton<String>(
                                        hintText: '',
                                        decoration: lineCustomPopupDecoration(hintText:  selectedVehicle['bodybuilder']),
                                        childWidth: constraints.maxWidth,
                                        offset: const Offset(1, 40),
                                        itemBuilder:  (BuildContext context) {
                                          return ["Yes","No"].map((String choice) {
                                            return CustomPopupMenuItem<String>(
                                                value: choice,
                                                text: choice,
                                                child: Container()
                                            );
                                          }).toList();
                                        },

                                        onSelected: (String value)  {
                                          setState(() {
                                            selectedVehicle['bodybuilder'] = value;
                                          });
                                        },
                                        onCanceled: () {

                                        },
                                        child: Container(),
                                      );
                                    }
                                ),
                              ),
                            ),),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: mTextFieldBorder,height: 1),
            ///-----------------------------Table Location-------------------------



          ],
        ),
      ),
    );
  }

  Widget buildDeliveryInstructionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
          side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
      child: Container(color: Colors.white,
        child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            ///-----------------------------Table Location-------------------------
            const Padding(
              padding: EdgeInsets.only(left: 18.0,top: 8,bottom: 8),
              child: Text("Deliver Instructions",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            ),
            const Divider(color: mTextFieldBorder,height: 1),
            Container(color: Colors.white,
              height: 330,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Location One"),
                        ),
                        const Divider(color: mTextFieldBorder,height: 1),
                        const SizedBox(height: 4,),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0,left: 18,top: 8,bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded( child:  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                    child: Container(height: 28,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: mTextFieldBorder),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints) {
                                            return CustomPopupMenuButton<String>(
                                              hintText: '',
                                              decoration: customPopupDecoration(hintText:  selectedVehicle['location1']['type']),
                                              childWidth: constraints.maxWidth,
                                              offset: const Offset(1, 40),
                                              itemBuilder:  (BuildContext context) {
                                                return ['Bodybuilder','Dealer',"Customer"].map((String choice) {
                                                  return CustomPopupMenuItem<String>(
                                                      value: choice,
                                                      text: choice,
                                                      child: Container()
                                                  );
                                                }).toList();
                                              },

                                              onSelected: (String value)  {
                                                setState(() {
                                                  selectedVehicle['location1']['type'] = value;
                                                });
                                              },
                                              onCanceled: () {

                                              },
                                              child: Container(),
                                            );
                                          }
                                      ),
                                    ),
                                  ),),

                                ],
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 30,
                                  child: addressTextField(selectedVehicle['location1']['loc'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location1']['loc'] =v;
                                      }
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 140,
                                  child: addressTextField(selectedVehicle['location1']['details'].toString(),
                                      maxLines: 7,
                                      onChanged: (v){
                                        selectedVehicle['location1']['details'] =v;
                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomVDivider(height: 330, width: 1, color: mTextFieldBorder),



                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Location Two"),
                        ),
                        const Divider(color: mTextFieldBorder,height: 1),
                        const SizedBox(height: 4,),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0,left: 18,top: 8,bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded( child:  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                    child: Container(height: 28,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: mTextFieldBorder),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints) {
                                            return CustomPopupMenuButton<String>(
                                              hintText: '',
                                              decoration: customPopupDecoration(hintText:  selectedVehicle['location2']['type']),
                                              childWidth: constraints.maxWidth,
                                              offset: const Offset(1, 40),
                                              itemBuilder:  (BuildContext context) {
                                                return ['Bodybuilder','Dealer',"Customer"].map((String choice) {
                                                  return CustomPopupMenuItem<String>(
                                                      value: choice,
                                                      text: choice,
                                                      child: Container()
                                                  );
                                                }).toList();
                                              },

                                              onSelected: (String value)  {
                                                setState(() {
                                                  selectedVehicle['location2']['type'] = value;
                                                });
                                              },
                                              onCanceled: () {

                                              },
                                              child: Container(),
                                            );
                                          }
                                      ),
                                    ),
                                  ),),

                                ],
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 30,
                                  child: addressTextField(selectedVehicle['location2']['loc'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location2']['loc'] =v;
                                      }
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 140,
                                  child: addressTextField(selectedVehicle['location2']['details'].toString(),
                                      maxLines: 7,
                                      onChanged: (v){
                                        selectedVehicle['location2']['details'] =v;
                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const CustomVDivider(height: 330, width: 1, color: mTextFieldBorder),



                  Expanded(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Location Three"),
                        ),
                        const Divider(color: mTextFieldBorder,height: 1),
                        const SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0,left: 18,top: 8,bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded( child:  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 18,right: 18),
                                    child: Container(height: 28,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: mTextFieldBorder),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints) {
                                            return CustomPopupMenuButton<String>(
                                              hintText: '',
                                              decoration: customPopupDecoration(hintText:  selectedVehicle['location3']['type']),
                                              childWidth: constraints.maxWidth,
                                              offset: const Offset(1, 40),
                                              itemBuilder:  (BuildContext context) {
                                                return ['Bodybuilder','Dealer',"Customer"].map((String choice) {
                                                  return CustomPopupMenuItem<String>(
                                                      value: choice,
                                                      text: choice,
                                                      child: Container()
                                                  );
                                                }).toList();
                                              },

                                              onSelected: (String value)  {
                                                setState(() {
                                                  selectedVehicle['location3']['type'] = value;
                                                });
                                              },
                                              onCanceled: () {

                                              },
                                              child: Container(),
                                            );
                                          }
                                      ),
                                    ),
                                  ),),

                                ],
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 30,
                                  child: addressTextField(selectedVehicle['location3']['loc'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location3']['loc'] =v;
                                      }
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 140,
                                  child: addressTextField(selectedVehicle['location3']['details'].toString(),
                                      maxLines: 7,
                                      onChanged: (v){
                                        selectedVehicle['location3']['details'] =v;
                                      }
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget lineText(String text,{GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: mTextFieldBorder),
              borderRadius: BorderRadius.circular(4)),
          child: Center(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))),
    );
  }

  Widget lineTextField(text,{required ValueChanged onChanged}) {
    var t1 = TextEditingController(text: '$text');
    t1.selection = TextSelection.fromPosition(TextPosition(offset: t1.text.length));
    return Container(
      height: 24,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child:  Center(
        child: TextField(
            textAlign: TextAlign.center,controller: t1,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 2,top: 4,bottom: 8,right: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
            ),
            style: const TextStyle(fontSize: 13, overflow: TextOverflow.visible),
            onChanged:onChanged
        ),
      ),
    );
  }

  Widget addressTextField(text,{required ValueChanged onChanged, required int maxLines}) {
    var t1 = TextEditingController(text: '$text');
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child:  Center(
        child: TextField(maxLines: maxLines,
            textAlign: TextAlign.left,controller: t1,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 12,top: 6,bottom: 8,right: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mTextFieldBorder),
              ),
            ),
            style: const TextStyle(fontSize: 13, overflow: TextOverflow.visible),
            onChanged:onChanged
        ),
      ),
    );
  }

  customPopupDecoration({required String hintText}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 0, 0, 18),

    );

  }
  lineCustomPopupDecoration({required String hintText}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      constraints: const BoxConstraints(maxHeight: 30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
      counterText: '',
      contentPadding: const EdgeInsets.only(left: 8,top: 1,bottom: 16),

    );

  }

  Widget showDialogBox(){
    return Dialog(
      backgroundColor: Colors.transparent,
      child:StatefulBuilder(
          builder: (context,  setState) {
            return SizedBox(
              // width: MediaQuery.of(context).size.width/1.5,
              //height: MediaQuery.of(context).size.height/1.1,
              child: Stack(
                children: [
                  Container(
                    width: 950,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(top: 13.0, right: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0,right:20,bottom: 10,top:10),
                      child: Card(surfaceTintColor: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            ///search Fields
                            Row(
                              children: [
                                const SizedBox(width: 10,),
                                SizedBox(width: 250,height: 35,
                                  child: TextFormField(
                                    controller: brandNameController,
                                    decoration: textFieldBrandNameField(hintText: 'Search Brand',
                                        onTap:()async{
                                          if(brandNameController.text.isEmpty || brandNameController.text==""){
                                            await getAllVehicleVariant().whenComplete(() => setState((){}));
                                          }
                                        }
                                    ),
                                    onChanged: (value) async{
                                      if(value.isNotEmpty || value!=""){
                                        await fetchBrandName(brandNameController.text).whenComplete(()=>setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    decoration:  textFieldModelNameField(hintText: 'Search Model',onTap: ()async{
                                      if(modelNameController.text.isEmpty || modelNameController.text==""){
                                        await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    }),
                                    controller: modelNameController,
                                    onChanged: (value)async {
                                      if(value.isNotEmpty || value!=""){
                                        await  fetchModelName(modelNameController.text).whenComplete(() =>setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        await getAllVehicleVariant().whenComplete(()=> setState((){}));
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(width: 10,),
                                SizedBox(width: 250,
                                  child: TextFormField(
                                    controller: variantController,
                                    decoration: textFieldVariantNameField(hintText: 'Search Variant',onTap:()async{
                                      if(variantController.text.isEmpty || variantController.text==""){
                                        await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    }),
                                    onChanged: (value) async{
                                      if(value.isNotEmpty || value!=""){
                                        await fetchVariantName(variantController.text).whenComplete(() => setState((){}));
                                      }
                                      else if(value.isEmpty || value==""){
                                        await getAllVehicleVariant().whenComplete(() => setState((){}));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            ///Table Header
                            Container(
                              height: 40,
                              color: Colors.grey[200],
                              child: const Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text("Brand")),
                                    Expanded(child: Text("Model")),
                                    Expanded(child: Text("Variant")),
                                    Expanded(child: Text("On road price")),
                                    Expanded(child: Text("Year of Manufacture")),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4,),
                            Expanded(
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: displayList.length+1,
                                    itemBuilder: (context,int i){
                                      if(i<displayList.length){
                                        return   Column(
                                          children: [
                                            MaterialButton(
                                              hoverColor: mHoverColor,
                                              onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context,displayList[i]['model']);
                                                  storeGeneralId=displayList[i]["excel_id"];
                                                  for(var tempValue in generalIdMatch){
                                                    if(tempValue == storeGeneralId){
                                                      setState((){
                                                        checkBool=true;
                                                      });
                                                    }
                                                  }
                                                });

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 18.0),
                                                child: SizedBox(height: 30,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['make']??""),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(
                                                              displayList[i]['model']??""),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['varient']??''),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['on_road_price'].toString()),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['year_of_manufacture']??""),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                          ],
                                        );
                                      }
                                      else{
                                        return Column(children: [
                                          Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                          Row(mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("${startVal+15>vehicleList.length?vehicleList.length:startVal+1}-${startVal+15>vehicleList.length?vehicleList.length:startVal+15} of ${vehicleList.length}",style: const TextStyle(color: Colors.grey)),
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
                                                        try{
                                                          setState(() {
                                                            displayList.add(vehicleList[i]);
                                                          });
                                                        }
                                                        catch(e){
                                                          print(e.toString());
                                                        }
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
                                                    setState(() {
                                                      if(vehicleList.length>startVal+15){
                                                        displayList=[];
                                                        startVal=startVal+15;
                                                        for(int i=startVal;i<startVal+15;i++){
                                                          try{
                                                            setState(() {
                                                              displayList.add(vehicleList[i]);
                                                            });
                                                          }
                                                          catch(e){
                                                            print("Expected Type Error $e ");
                                                            print(e.toString());
                                                          }

                                                        }
                                                      }
                                                    });


                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                            ],
                                          ),
                                          Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                        ],);
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: InkWell(
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromRGBO(204, 204, 204, 1),
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
            );
          }
      ),
    );
  }

  textFieldDecoration({required String hintText, required bool error}) {
    return  InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldVendorAndWarehouse({required String hintText, required bool error}) {
    return  InputDecoration(
      suffixIcon: const Icon(Icons.search,size: 18),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:  OutlineInputBorder(borderSide: BorderSide(color:error? Colors.red:mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldBrandNameField( {required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      suffixIcon:  brandNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          brandNameController.clear();
          onTap!();
        });
      },
          child: const Icon(Icons.close,size: 18,)
      ),

      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldModelNameField({required String hintText, bool? error,Function ? onTap}) {
    return  InputDecoration(
      suffixIcon:  modelNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        setState(() {
          modelNameController.clear();
          onTap!();
        });
      },
          child: const Icon(Icons.close,size: 18,)
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldVariantNameField({required String hintText, bool? error,Function ? onTap}) {
    return  InputDecoration(
      suffixIcon:  variantController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(onTap:(){
        variantController.clear();
        onTap!();
      },
          child: const Icon(Icons.close,size: 18,)
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }


  Future getAllVehicleVariant() async {
    dynamic response;
   // String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_mod_general";
    try {
      {
        response = [
          {
            "excel_id": "EXC_20869",
            "make": "CV-FML",
            "model": "T1 AMB",
            "varient": "T006860023434",
            "date": "16-7-34",
            "on_road_price": 7700000.0,
            "color": "Grey",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20870",
            "make": "CV-TDCV",
            "model": "KC3C1",
            "varient": "KC3C1",
            "date": "16-7-35",
            "on_road_price": 6800000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20871",
            "make": "CV-TDCV",
            "model": "F8C6F",
            "varient": "F8C6F",
            "date": "15-7-36",
            "on_road_price": 8651500.0,
            "color": "Black",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20872",
            "make": "CV-TML",
            "model": "LPO 1316",
            "varient": "27500855000R",
            "date": "16-8-6",
            "on_road_price": 7100000.0,
            "color": "White",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20873",
            "make": "CV-FML",
            "model": "T1 MB",
            "varient": "T006860016733",
            "date": "15-7-33",
            "on_road_price": 4200000.0,
            "color": "Grey",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20874",
            "make": "CV-TML",
            "model": "YODHA",
            "varient": "28985631ABFR",
            "date": "16-7-34",
            "on_road_price": 2725000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20875",
            "make": "CV-TML",
            "model": "XENON DC",
            "varient": "55025831ABFR",
            "date": "16-7-35",
            "on_road_price": 3800000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20876",
            "make": "CV-TML",
            "model": "INTRA V20",
            "varient": "55461223AKOR",
            "date": "15-7-36",
            "on_road_price": 2325000.0,
            "color": "Black",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20877",
            "make": "CV-TDCV",
            "model": "V3T6F",
            "varient": "V3T6F",
            "date": "16-8-6",
            "on_road_price": 1.153724E7,
            "color": "White",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20878",
            "make": "CV-TML",
            "model": "LPK 2518",
            "varient": "41061262000RZK22",
            "date": "16-8-7",
            "on_road_price": 8875000.0,
            "color": "Grey",
            "year_of_manufacture": "2023"
          },
          {
            "excel_id": "EXC_20879",
            "make": "CV-TML",
            "model": "LPK 2516",
            "varient": "21715238000RBP20",
            "date": "15-7-32",
            "on_road_price": 7875000.0,
            "color": "Grey",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20880",
            "make": "CV-TML",
            "model": "SIGNA 1618",
            "varient": "21827336000RBH31",
            "date": "15-7-33",
            "on_road_price": 6075000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20881",
            "make": "CV-TML",
            "model": "SIGNA 2823",
            "varient": "50971038000R",
            "date": "16-7-34",
            "on_road_price": 1.0E7,
            "color": "Black",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20882",
            "make": "CV-TML",
            "model": "LPT 810",
            "varient": "26426438000R",
            "date": "16-7-35",
            "on_road_price": 3300000.0,
            "color": "White",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20883",
            "make": "CV-TML",
            "model": "SFC 407",
            "varient": "26522731000R",
            "date": "15-7-36",
            "on_road_price": 2750000.0,
            "color": "Grey",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20884",
            "make": "CV-TML",
            "model": "SIGNA 2518",
            "varient": "50302148000R",
            "date": "16-8-6",
            "on_road_price": 6580000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20885",
            "make": "CV-TML",
            "model": "LPT 809",
            "varient": "KB080938KENR",
            "date": "16-8-7",
            "on_road_price": 3225000.0,
            "color": "Red",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20886",
            "make": "CV-TML",
            "model": "LPT 1216",
            "varient": "KY111648KENR",
            "date": "15-7-36",
            "on_road_price": 4000000.0,
            "color": "Black",
            "year_of_manufacture": "2022"
          },
          {
            "excel_id": "EXC_20887",
            "make": "CV-TML",
            "model": "ULTRA T9",
            "varient": "55069139000R",
            "date": "16-8-6",
            "on_road_price": 3875000.0,
            "color": "White",
            "year_of_manufacture": "2022"
          }
        ];
        vehicleList = response;
        startVal=0;
        displayList=[];
        if(displayList.isEmpty){
          if(vehicleList.length>15){
            for(int i=startVal;i<startVal+15;i++){
              displayList.add(vehicleList[i]);
            }
          }
          else{
            for(int i=startVal;i<vehicleList.length;i++){
              displayList.add(vehicleList[i]);
            }
          }
        }
      }
      // await getData(context: context, url: url).then((value) {
      //   setState(() {
      //     if (value != null) {
      //       response = value;
      //       vehicleList = response;
      //       startVal=0;
      //       displayList=[];
      //       if(displayList.isEmpty){
      //         if(vehicleList.length>15){
      //           for(int i=startVal;i<startVal+15;i++){
      //             displayList.add(vehicleList[i]);
      //           }
      //         }
      //         else{
      //           for(int i=startVal;i<vehicleList.length;i++){
      //             displayList.add(vehicleList[i]);
      //           }
      //         }
      //       }
      //     }
      //     loading = false;
      //   });
      // });
    } catch (e) {
      logOutApi(context: context, exception: e.toString(), response: response);
      setState(() {
        loading = false;
      });
    }
  }
  Future fetchModelName(String modelName)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_model_name/$modelName';
    try{
      await getData(url:url ,context:context ).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            vehicleList=response;
            displayList=[];
            startVal=0;
            try{
              if(displayList.isEmpty){
                if(vehicleList.length>15){
                  for(int i=startVal;i<startVal+15;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
                else{
                  for(int i=startVal;i<vehicleList.length;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
              }
            }
            catch(e){
              print("Excepted Type $e");
            }
          }
        });
      }
      );
    }
    catch(e){
      logOutApi(context: context,response: response,exception: e.toString());

    }
  }
  Future fetchBrandName(String brandName)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_brand_name/$brandName';
    try{
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            vehicleList=response;
            displayList=[];
            startVal=0;
            try{
              if(displayList.isEmpty){
                if(vehicleList.length>15){
                  for(int i=startVal;i<startVal+15;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
                else{
                  for(int i=startVal;i<vehicleList.length;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
              }
            }
            catch(e){
              print("Excepted Type $e");
            }
          }
        });
      });
    }
    catch(e){
      logOutApi(context: context,exception: e.toString(),response: response);
    }
  }

  Future fetchVariantName(String variantName)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/search_by_variant_name/$variantName';
    try{
      await getData(context:context ,url: url).then((value) {
        setState((){
          if(value!=null){
            response=value;
            vehicleList=response;
            displayList=[];
            startVal=0;
            try{
              if(displayList.isEmpty){
                if(vehicleList.length>15){
                  for(int i=startVal;i<startVal+15;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
                else{
                  for(int i=startVal;i<vehicleList.length;i++){
                    displayList.add(vehicleList[i]);
                  }
                }
              }
            }
            catch(e){
              log("Excepted Type $e");
            }
          }
        });
      });
    }
    catch(e){
      logOutApi(context:context ,response: response,exception: e.toString());
    }
  }

}


