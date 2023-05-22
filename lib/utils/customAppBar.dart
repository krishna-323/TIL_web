import 'package:flutter/material.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cart_bloc/cart_items_bloc.dart';
import '../main.dart';
import 'custom_popup_dropdown/custom_popup_dropdown.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  _getPopupMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[

      const PopupMenuItem<String>(
        value: '2',
        child: Center(child: Text('Logout')),

      ),


    ];
  }

  SharedPreferences? prefs ;
  String companyName='';

  Future getInitialData() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      companyName = prefs!.getString("companyName") ?? "";
    });
  }

  Theme _popMenu() {
    return Theme(
      data: Theme.of(context).copyWith(),
      child: PopupMenuButton<String>(elevation: 4,shape: RoundedRectangleBorder(
        side: BorderSide(color:Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
        offset: Offset(-10, 56),
        itemBuilder: (context) => _getPopupMenu(context),
        onSelected: (String value) async {
          if(value=="1"){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=> OrgProfile(orgId,orgName)));
          }
          if(value=="2"){

            setState(() {
              //   prefs.remove('authToken');
              prefs!.setString('authToken', "");
              bloc.setAuthToken("");
              bloc.setLoginStatus(false);
              prefs!.setString('companyName', "");
              prefs!.setString('role', "");
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyApp()));
          }
        },
        onCanceled: () {

        },
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: const Icon(Icons.account_circle,color: Colors.black),

          ),
        ),
      ),
    );
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

    const CustomPopupMenuItem(height: 30,
      value: 'Business Customer',
      child: Center(child: SizedBox(width: 350,child: Text('Business Customer',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 30,
      value: 'Individual Customer',
      child: Center(child: SizedBox(width: 350,child: Text('Individual Customer',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 30,
      value: 'Company Customer',
      child: Center(child: SizedBox(width: 350,child: Text('Company Customer',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    )
  ];



  customPopupDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp,color: mSaveButton,size: 14),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
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
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/logo/motows.png'),
      ),
      title: Container(width: 385,height: 35,
        child: CustomPopupMenuButton<String>( childWidth: 385,position: CustomPopupMenuPosition.under,
          decoration: customPopupDecoration(hintText: 'Create New Service'),
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
            setState(() {
              customerType= value;

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
                  Row(
                    children:  const [
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
                  _popMenu(),
                ],
              ),
            ),
          ],
        ),

      ],
    );
  }
  decorationSearch(String hintString,) {
    return InputDecoration(
      prefixIcon:const Icon(
        Icons.search,
        size: 20,
      ),
      prefixIconColor:Colors.blue,
      fillColor: Colors.white,
      counterText: "",
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(30),
          borderSide:const BorderSide(color: Colors.blue, width: 0.5)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue)),
    );
  }
}


class CustomAppBar2 extends StatefulWidget {
  const CustomAppBar2({Key? key}) : super(key: key);

  @override
  _CustomAppBar2State createState() => _CustomAppBar2State();
}

class _CustomAppBar2State extends State<CustomAppBar2> {

  _getPopupMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[

      const PopupMenuItem<String>(
        value: '2',
        child: Center(child: Text('Logout')),

      ),


    ];
  }

  SharedPreferences? prefs ;
  String companyName='';

  Future getInitialData() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      companyName = prefs!.getString("companyName") ?? "";
    });
  }

  Theme _popMenu() {
    return Theme(
      data: Theme.of(context).copyWith(),
      child: PopupMenuButton<String>(elevation: 4,shape: RoundedRectangleBorder(
        side: BorderSide(color:Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
        offset: Offset(-10, 56),
        itemBuilder: (context) => _getPopupMenu(context),
        onSelected: (String value) async {
          if(value=="1"){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=> OrgProfile(orgId,orgName)));
          }
          if(value=="2"){

            setState(() {
              //   prefs.remove('authToken');
              prefs!.setString('authToken', "");
              bloc.setAuthToken("");
              bloc.setLoginStatus(false);
              prefs!.setString('companyName', "");
              prefs!.setString('role', "");
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyApp()));
          }
        },
        onCanceled: () {

        },
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: const Icon(Icons.account_circle,color: Colors.black),

          ),
        ),
      ),
    );
  }


  customPopupDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp,color: mSaveButton,size: 14),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }



  String customerType='Select Customer Type';

  List <CustomPopupMenuEntry<String>> customerTypes =<CustomPopupMenuEntry<String>>[

    const CustomPopupMenuItem(height: 40,
      value: 'Business Customer',
      child: Center(child: SizedBox(width: 350,child: Text('Business Customer',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'Individual Customer',
      child: Center(child: SizedBox(width: 350,child: Text('Individual Customer',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    ),
    const CustomPopupMenuItem(height: 40,
      value: 'Company Customer',
      child: Center(child: SizedBox(width: 350,child: Text('Company Customer',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

    )
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
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/logo/motows.png'),
      ),
      title:Container(width: 385,height: 35,
        child: CustomPopupMenuButton<String>( childWidth: 385,position: CustomPopupMenuPosition.under,
          decoration: customPopupDecoration(hintText: 'Create New Service'),
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
            setState(() {
              customerType= value;

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
                  Row(
                    children:  const [
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
                  _popMenu(),
                ],
              ),
            ),
          ],
        ),

      ],
    );
  }
  decorationSearch(String hintString,) {
    return InputDecoration(
      prefixIcon:const Icon(
        Icons.search,
        size: 20,
      ),
      prefixIconColor:Colors.blue,
      fillColor: Colors.white,
      counterText: "",
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(30),
          borderSide:const BorderSide(color: Colors.blue, width: 0.5)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue)),
    );
  }
}