import 'dart:developer';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/utils/custom_loader.dart';
import 'package:new_project/utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import 'package:new_project/widgets/custom_dividers/custom_vertical_divider.dart';

import '../utils/api/get_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';

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


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedVehicle = widget.selectedVehicle;
    getAllVehicleVariant();

  }
  @override
  Widget build(BuildContext context)  {
    return  Form(
      key: _formKey,
      child: WillPopScope(
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
                                      if(_formKey.currentState!.validate()){
                                        Navigator.pop(context,  selectedVehicle,);
                                      }

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
                                        selectedVehicle['model'] = value['modelVCDescription1'];
                                        selectedVehicle['vehicleMasterId'] = value['modelVCCode'];
                                        _formKey.currentState!.validate();
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
                                  child: addressTextField(selectedVehicle['location1']['name'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location1']['name'] =v;
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
                                  child: addressTextField(selectedVehicle['location2']['name'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location2']['name'] =v;
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
                                  child: addressTextField(selectedVehicle['location3']['name'].toString(),
                                      maxLines: 1,
                                      onChanged: (v){
                                        selectedVehicle['location3']['name'] =v;
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
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
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
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
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
                                    Expanded(child: Text("Model VC Code")),
                                    Expanded(child: Text("Model")),
                                    Expanded(child: Text("Model Description")),
                                    Expanded(child: Text("Color")),
                                    Expanded(child: Text("Transmission")),
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
                                                print(displayList[i]['modelVCCode']);
                                                setState(() {
                                                  Navigator.pop(context,displayList[i]);
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
                                                          child: Text(displayList[i]['modelVCDescription']??""),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(
                                                              displayList[i]['modelVCDescription1']??""),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['colourName']??''),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 20,
                                                          child: Text(displayList[i]['transmissionTypeCode'].toString()),
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
            "modelVCCode": "SF081338SAFR",
            "modelVCDescription": "LPT 813",
            "modelVCDescription1": "LPT 813/38 E II PS HD 12 V SA",
            "foreignName": "English",
            "colourName": "White",
            "tilSegment": "MCV",
            "brand": "TML",
            "uomGroup": "Sales",
            "fuelType": "Diesel - Diesel",
            "modelCode": "LPT 813",
            "transmissionTypeCode": "Manual",
            "leadTime": 90,
            "fobPrice": 207823,
            "fobCurrency": "ZAR"
          },
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