import 'package:flutter/material.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/bloc.dart';
import '../classes/arguments_classes/arguments_classes.dart';
import '../classes/motows_routes.dart';
import '../main.dart';
import '../pre_sales/parts_order/parts_order_list.dart';
import '../pre_sales/purchase_orders/add_new_vehicles_order.dart';
import '../pre_sales/warranty/warranty.dart';
import 'custom_popup_dropdown/custom_popup_dropdown.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {



  SharedPreferences? prefs ;
  String companyName='';
  Future getInitialData() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      companyName = prefs!.getString("companyName") ?? "";
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialData();
  }
  dynamic size,width,height;
  final search=TextEditingController();
  List <CustomPopupMenuEntry<String>> customerTypes =<CustomPopupMenuEntry<String>>[

    const CustomPopupMenuItem(height: 40,
      value: '1',
      child: Center(child: SizedBox(width: 350,child: Text('New Vehicle Order',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 4)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: '2',
      child: Center(child: SizedBox(width: 350,child: Text('New Parts Order',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: '3',
      child: Center(child: SizedBox(width: 350,child: Text('New Warranty',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    )
  ];
  List <CustomPopupMenuEntry<String>> logoutAppType =<CustomPopupMenuEntry<String>>[

    const CustomPopupMenuItem(height: 40,
      value: 'Logout',
      child: Center(child: Text('Logout',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14))),

    ),
  ];
  String logoutAppTypeName="";


  customPopupDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.add,color: mSaveButton,size: 14),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  logoutAppDecoration({required String hintText, bool? error, bool ? isFocused,}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.account_circle, color:Colors.black),
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
    );
  }


String customerType='Select Customer Type';
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return AppBar(automaticallyImplyLeading: false,
      leadingWidth: 170,
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      // backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      centerTitle: true,
      elevation: 2,
      bottomOpacity: 20,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset('assets/logo/Ikyam_color_logo.png'),
      ),
      title: SizedBox(width: 385,height: 35,
        child: CustomPopupMenuButton<String>( childWidth: 385,position: CustomPopupMenuPosition.under,
          decoration: customPopupDecoration(hintText: 'Create New'),
          hintText: "",
          shape: const RoundedRectangleBorder(
            side: BorderSide(color:Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          offset: const Offset(1, 12),
          tooltip: '',
          itemBuilder: (context) {
            return customerTypes;
          },
          onSelected: (String value)  {
          print(value);
            setState(() {
              customerType= value;
              if(value =="1"){
                Navigator.pushReplacementNamed(
                  context,
                  MotowsRoutes.estimateRoutes,
                  arguments: DisplayEstimateItemsArgs(selectedDestination: 1.1, drawerWidth: 190),
                );
              }
              if(value == "2"){
                Navigator.pushReplacementNamed(
                  context,
                  MotowsRoutes.partsOrderListRoutes,
                  arguments: PartsOrderListArguments(selectedDestination: 1.2, drawerWidth: 190),
                );
              }
              if(value == "3"){
                Navigator.pushReplacementNamed(
                  context,
                  MotowsRoutes.warrantyRoutes,
                  arguments: WarrantyArgs(selectedDestination: 1.3, drawerWidth: 190),
                );
              }

            });
          },
          onCanceled: () {

          },
          child: Container(height: 30,width: 285,
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 150,child: Center(child: Text(customerType,style: TextStyle(color: Colors.grey[700],fontSize: 14,),maxLines: 1))),
                  const Icon(Icons.arrow_drop_down,color: Colors.grey,size: 14,)
                ],
              ),
            ),
          ),
        ),
      ),
      // SizedBox(
      //   width: 300,
      //   height: 40,
      //   child: TextFormField(
      //     controller: search,
      //     keyboardType: TextInputType.text,
      //     decoration:decorationSearch('Search'),
      //   ),
      // ),
      actions: [

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // const SizedBox(width: 180,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                children: [
                  const Row(
                    children:  [
                      // MaterialButton(
                      //   color: Colors.blue,
                      //   onPressed: (){
                      //
                      //   },
                      //   child:const Text('Add Docket',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       decoration: TextDecoration.underline,
                      //       decorationStyle: TextDecorationStyle.dotted,
                      //     ),),
                      // ),
                    ],
                  ),
                  const SizedBox(width: 20,),

                  TooltipTheme(
                    data: const TooltipThemeData(
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.black,
                      ),
                      tooltip: 'Notifications',
                    ),
                  ),
                  // TooltipTheme(
                  //   data: const TooltipThemeData(
                  //     textStyle: TextStyle(
                  //       fontSize: 10,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.white,
                  //     ),
                  //     decoration: BoxDecoration(
                  //         color: Colors.black,
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0))
                  //     ),
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.folder_open_sharp,
                  //       color: Colors.black,
                  //     ),
                  //     tooltip: 'Documents',
                  //   ),
                  // ),
                  // TooltipTheme(
                  //   data: const TooltipThemeData(
                  //     textStyle: TextStyle(
                  //       fontSize: 10,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.white,
                  //     ),
                  //     decoration: BoxDecoration(
                  //         color: Colors.black,
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0))
                  //     ),
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.settings,
                  //       color: Colors.black,
                  //     ),
                  //     tooltip: 'Settings',
                  //   ),
                  // ),
                  // TooltipTheme(
                  //   data: const TooltipThemeData(
                  //     textStyle: TextStyle(
                  //       fontSize: 10,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.white,
                  //     ),
                  //     decoration: BoxDecoration(
                  //         color: Colors.black,
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0))
                  //     ),
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.help_outline_sharp,
                  //       color: Colors.black,
                  //     ),
                  //     tooltip: 'Help & Support',
                  //   ),
                  // ),
                  const SizedBox(width: 15,),
                 // _popMenu(),
                  SizedBox(width: 25,
                    height: 25,
                    child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return CustomPopupMenuButton(elevation: 4,
                            decoration: logoutAppDecoration(hintText:logoutAppTypeName,),
                            hintText: '',
                            childWidth: 150,
                            offset: const Offset(1, 40),
                            tooltip: '',
                            itemBuilder:  (BuildContext context) {
                              return logoutAppType;
                            },

                            onSelected: (String value)async{
                              setState(() {
                                logoutAppTypeName = value;
                                if(logoutAppTypeName=="Logout"){
                                  bloc.setSubRole(false);
                                  bloc.setMangerRole(false);
                                  //   prefs.remove('authToken');
                                  prefs!.setString('authToken', "");
                                  prefs!.setString('companyName', "");
                                  prefs!.setString('role', "");
                                }
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyApp()));

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
            ),
          ],
        ),

      ],
    );
  }
}


class CustomAppBar2 extends StatefulWidget {
  const CustomAppBar2({Key? key}) : super(key: key);

  @override
  State<CustomAppBar2> createState() => _CustomAppBar2State();
}

class _CustomAppBar2State extends State<CustomAppBar2> {

  SharedPreferences? prefs ;
  String companyName='';

  Future getInitialData() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      companyName = prefs!.getString("companyName") ?? "";
    });
  }



  customPopupDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.add,color: mSaveButton,size: 14),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }


  logoutDecoration({required String hintText, bool? error, bool ? isFocused,}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.account_circle, color:Colors.black),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
    );
  }

  String customerType='Select Customer Type';
  String logoutInitial="";

  List <CustomPopupMenuEntry<String>> customerTypes =<CustomPopupMenuEntry<String>>[

    const CustomPopupMenuItem(height: 40,
      value: '1',
      child: Center(child: SizedBox(width: 350,child: Text('New Vehicle Order',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 4)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: '2',
      child: Center(child: SizedBox(width: 350,child: Text('New Parts Order',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: '3',
      child: Center(child: SizedBox(width: 350,child: Text('New Warranty',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    )
  ];
  List <CustomPopupMenuEntry<String>> logout =<CustomPopupMenuEntry<String>>[

    const CustomPopupMenuItem(height: 40,
      value: 'Logout',
      child: Center(child: Text('Logout',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14))),

    ),

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialData();
  }
  dynamic size,width,height;
  final search2=TextEditingController();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return AppBar(automaticallyImplyLeading: false,
      leadingWidth: 170,
      backgroundColor: Colors.white,
     foregroundColor: Colors.white,
     shadowColor: Colors.white,
     surfaceTintColor: Colors.white,
     // backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      centerTitle: true,
      elevation: 2,
      bottomOpacity: 20,
      leading: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Image.asset('assets/logo/Ikyam_color_logo.png'),
      ),
      title:SizedBox(width: 385,height: 35,
        child: CustomPopupMenuButton<String>( childWidth: 385,position: CustomPopupMenuPosition.under,
          decoration: customPopupDecoration(hintText: 'Create New'),
          hintText: "",
          shape: const RoundedRectangleBorder(
            side: BorderSide(color:Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          offset: const Offset(1, 12),
          tooltip: '',
          itemBuilder: (context) {
            return customerTypes;
          },
          onSelected: (String value)  {
          print(value);
            setState(() {
              customerType= value;
              if(value =="1"){
                Navigator.pushReplacementNamed(
                  context,
                  MotowsRoutes.estimateRoutes,
                  arguments: DisplayEstimateItemsArgs(selectedDestination: 1.1, drawerWidth: 190),
                );
              }
              if(value == "2"){
                Navigator.pushReplacementNamed(
                  context,
                  MotowsRoutes.partsOrderListRoutes,
                  arguments: PartsOrderListArguments(selectedDestination: 1.2, drawerWidth: 190),
                );
              }
              if(value == "3"){
                Navigator.pushReplacementNamed(
                  context,
                  MotowsRoutes.warrantyRoutes,
                  arguments: WarrantyArgs(selectedDestination: 1.3, drawerWidth: 190),
                );
              }


            });
          },
          onCanceled: () {

          },
          child: Container(height: 30,width: 285,
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 150,child: Center(child: Text(customerType,style: TextStyle(color: Colors.grey[700],fontSize: 14,),maxLines: 1))),
                  const Icon(Icons.arrow_drop_down,color: Colors.grey,size: 14,)
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // const SizedBox(width: 180,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                children: [

                  const SizedBox(width: 20,),

                  TooltipTheme(
                    data: const TooltipThemeData(
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.black,
                      ),
                      tooltip: 'Notifications',
                    ),
                  ),
                  // TooltipTheme(
                  //   data: const TooltipThemeData(
                  //     textStyle: TextStyle(
                  //       fontSize: 10,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.white,
                  //     ),
                  //     decoration: BoxDecoration(
                  //         color: Colors.black,
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0))
                  //     ),
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.folder_open_sharp,
                  //       color: Colors.black,
                  //     ),
                  //     tooltip: 'Documents',
                  //   ),
                  // ),
                  // TooltipTheme(
                  //   data: const TooltipThemeData(
                  //     textStyle: TextStyle(
                  //       fontSize: 10,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.white,
                  //     ),
                  //     decoration: BoxDecoration(
                  //         color: Colors.black,
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0))
                  //     ),
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.settings,
                  //       color: Colors.black,
                  //     ),
                  //     tooltip: 'Settings',
                  //   ),
                  // ),
                  // TooltipTheme(
                  //   data: const TooltipThemeData(
                  //     textStyle: TextStyle(
                  //       fontSize: 10,
                  //       fontWeight: FontWeight.w400,
                  //       color: Colors.white,
                  //     ),
                  //     decoration: BoxDecoration(
                  //         color: Colors.black,
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0))
                  //     ),
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.help_outline_sharp,
                  //       color: Colors.black,
                  //     ),
                  //     tooltip: 'Help & Support',
                  //   ),
                  // ),
                  const SizedBox(width: 15,),
                 // _popMenu(),

                  SizedBox(width: 25,
                    height: 25,
                    child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return CustomPopupMenuButton(elevation: 4,
                            decoration: logoutDecoration(hintText:logoutInitial,),
                            hintText: '',
                            childWidth: 150,
                            offset: const Offset(1, 40),
                            tooltip: '',
                            itemBuilder:  (BuildContext context) {
                              return logout;
                            },

                            onSelected: (String value)async{
                              setState(() {
                                logoutInitial = value;
                                if(logoutInitial=="Logout"){
                                  bloc.setSubRole(false);
                                  bloc.setMangerRole(false);
                                  prefs!.setString('authToken', "");
                                  prefs!.setString('companyName', "");
                                  prefs!.setString('role', "");
                                }
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyApp()));

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
            ),
          ],
        ),

      ],
    );
  }
}