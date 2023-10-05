import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:new_project/user_mangment/display_user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api/get_api.dart';
import '../utils/api/post_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_loader.dart';
import '../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../utils/static_data/motows_colors.dart';
import 'package:http/http.dart' as http;

import '../widgets/motows_buttons/outlined_border_with_icon.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';

class CompanyDetails extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final String companyName;
  final String dealerID;
  final String companyID;
  const CompanyDetails({
    Key? key,
      required this.companyName,
      required this.selectedDestination,
      required this.drawerWidth,
    required this.companyID,
    required this.dealerID
  }) : super(key: key);

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  String companyName = '';
  String companyID = '';
  String dealerID = '';
  String selectedCompanyID = '';
  String selectedDealerID = '';
  String actualDealerName = '';
  @override


  void initState() {
    // TODO: implement initState
    companyName = widget.companyName;
    companyID = widget.companyID;
    dealerID = widget.dealerID;
    getInitialData().whenComplete(() => {
      fetchSameCompanyCustomers(),
      searchCompanyApi(),
      searchDealerApi(),
      getCompanyList(),
    getDealerList(companyID)
    });
    loading=true;
    super.initState();
  }

  String ?authToken;
  String ?managerId;
  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
    managerId = prefs.getString("managerId");
  }
  List userList = [];
  List displayUserList=[];
  List displayListCompanies=[];
  List displayListDealers=[];
  List<String> items = [
    "Dealer1",
    "Dealer2",
    "Dealer3",
    "Dealer4",
    "Dealer5",
    "Dealer6",
    "Dealer7",
  ];
  var  expandedId="";
  int startVal=0;
  bool loading =false;
  bool companyUsers=false;

  Future fetchSameCompanyCustomers() async {
    dynamic response;
    String url = 'https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/get_all_users_by_dealer_id/$dealerID';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            userList = response;
            // print('----------Inside Get Api-------');
            // print(userList);
            if(userList.isEmpty){
              companyUsers=true;
            }
            if(displayUserList.isEmpty){
              if(userList.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayUserList.add(userList[i]);
                  displayUserList[i]["isExpanded"]=false;
                }
              }
              else{
                for(int i=0;i<userList.length;i++){
                  companyUsers=false;
                  displayUserList.add(userList[i]);
                  displayUserList[i]["isExpanded"]=false;
                }
              }
            }
          }
          loading=false;
        });
      });
    }
    catch (e) {
      if(mounted){
        logOutApi(context: context, exception: e.toString(), response: response);
        setState(() {
          loading=false;
        });
      }
    }
  }
  Future getCompanyList() async{
    dynamic response;
    String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company/get_all_company';
    try{
      await getData(url: url, context: context).then((value){
        setState(() {
          if(value != null){
            response = value;
            displayListCompanies = response;
            // print('-------- display list company -------');
            // print(displayListCompanies);
          }
          loading = false;
        });
      });
    }
    catch(e){
      if(mounted){
        logOutApi(context: context, exception: e.toString(), response: response);
        setState(() {
          loading=false;
        });
      }
    }
  }
  Future getDealerList(selectedCompanyID) async{
    dynamic response;
    String url = 'https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/company_dealer/get_company_dealer_by_company_id/$selectedCompanyID';
    try{
      await getData(url: url, context: context).then((value){
        setState(() {
          if(value != null){
            response = value;
            displayListDealers = response;
            dealerNamesList.clear();
            if(displayListDealers.isNotEmpty){
              for(var dealer in displayListDealers){
                dealerNamesList.add(dealer['dealer_name']);
              }
            }
          }
          loading = false;
        });
      });
    }
    catch(e){
      if(mounted){
        logOutApi(context: context, exception: e.toString(), response: response);
        setState(() {
          loading=false;
        });
      }
    }
  }
  // post api.
  Future userDetails(userData) async {
    String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/add-usermaster';
    postData(context:context ,url:url ,requestBody: userData).then((value) {
      setState(() {
        if(value!=null){
          setState(() {
            String  errorMessage='';
            if(value.containsKey("error")){


              if(value['error']=="email already exist"){
                setState(() {
                  errorMessage="Email Already Exist";
                  log(errorMessage.toString());
                });

              }
              else if(value['error']=="user already exist"){

                setState(() {
                  errorMessage="User Already Exist";
                  log(errorMessage.toString());
                });

              }

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompanyDetails(
                  companyName: companyName,
                  selectedDestination: widget.selectedDestination,
                  drawerWidth: widget.drawerWidth,
                  companyID: companyID,
                  dealerID: dealerID
              ),));

              setState((){
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            height: 200,
                            width: 300,
                            child: Stack(children: [
                              Container(
                                decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0,right: 25),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Icon(
                                        Icons.warning_rounded,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                          child: Text(errorMessage,
                                            style: const TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Align(alignment: Alignment.bottomRight,
                                        child: MaterialButton(
                                          color: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: const Text(
                                            'Ok',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(right: 0.0,

                                child: InkWell(
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color:
                                            const Color.fromRGBO(204, 204, 204, 1),
                                          ),
                                          color: Colors.red),
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
                        },
                      ),
                    );
                  },
                );

              });
            }

            else{
              setState(() {
                Navigator.of(context).pop();
                if(value["status"]=="success"){
               setState(() {

                 displayUserList=[];
                 loading=true;
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Created')));
                 fetchSameCompanyCustomers();
               });
                }

               // Navigator.of(context).pop();
              });
            }

          });
        }
      });
    });

  }

  final editCompanyName=TextEditingController();
  List nameList = [];
  List dealerList = [];
  List companyNamesList=[];
  List dealerNamesList=[];
  //Company Names.
  Future searchCompanyApi() async {
    dynamic response;
    String url =
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company/get_all_company';
    try {
      await getData(url: url, context: context).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            nameList = response;
            // print('-------------get all company names-------------');
            // print(nameList);
            for(int i=0;i<nameList.length;i++){
              companyNamesList.add(nameList[i]['company_name']);
            }
          }
        });
      });
    } catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
    }
  }
  Future searchDealerApi() async {
    dynamic response;
    String url =
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company_dealer/get_all_company_dealer';
    try {
      await getData(url: url, context: context).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            dealerList = response;
            // print('-------------get all company names-------------');
            // print(nameList);
            for(int i=0;i<dealerList.length;i++){
              dealerNamesList.add(dealerList[i]['dealer_name']);
            }
          }
        });
      });
    } catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
    }
  }
  Map updateUserDetailsStore={};
  String errorMessage="";

  //Update.
  Future updateUserDetails(updateRequestBody) async {

    String url =
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/update_user_master';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
      body: json.encode(updateRequestBody),

    );
    if (response.statusCode == 200) {

      updateUserDetailsStore=jsonDecode(response.body);
      // print('-------------------------------------');
      // print(updateUserDetailsStore);
      if(updateUserDetailsStore['error']=='user already exist' || updateUserDetailsStore['error']=="email already exist"){
        if(updateUserDetailsStore['error']=="user already exist"){
          setState(() {
            errorMessage='User Already Exist';
            log(errorMessage);
          });

        }
        else if(updateUserDetailsStore['error']=='email already exist'){
          setState(() {
            errorMessage='Email Already Exist';
            log(errorMessage);
          });

        }
        if(mounted) {
          Navigator.of(context).pop();
        }
        setState((){
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return SizedBox(
                      height: 200,
                      width: 300,
                      child: Stack(children: [
                        Container(
                          decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                          margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0,right: 25),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                  size: 50,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                    child: Text(errorMessage,
                                      style: const TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )),
                                const SizedBox(
                                  height: 35,
                                ),
                                Align(alignment: Alignment.bottomRight,
                                  child: MaterialButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text(
                                      'Ok',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(right: 0.0,

                          child: InkWell(
                            child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color:
                                      const Color.fromRGBO(204, 204, 204, 1),
                                    ),
                                    color: Colors.red),
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
                  },
                ),
              );
            },
          );

        },);
      }
      else{
        if(mounted){
          displayUserList=[];
          Navigator.of(context).pop();
          fetchSameCompanyCustomers();
         // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Details Edited')));
         // Navigator.of(context).pushNamed(MotowsRoutes.companyManagement);
        }


      }


    } else {
      log(response.statusCode.toString());
    }
  }


  List <CustomPopupMenuEntry<String>> userTypes =<CustomPopupMenuEntry<String>>[

    CustomPopupMenuItem(
      height: 35,
      value: 'Edit',
      child: Center(child: SizedBox(width: 150,child: Row(
        children: [ Icon(Icons.edit,size: 15,color: Colors.grey[800],),
          const SizedBox(width: 5,),
          Text('Edit',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey[800],fontSize: 15,),),
        ],
      ))),

    ),
    CustomPopupMenuItem(height: 35,
      value: 'Delete',
      child: Center(child: SizedBox(width: 150,child: Row(
        children: [ Icon(Icons.delete_sharp,size: 15,color: Colors.grey[800],),
          const SizedBox(width: 5,),
          Text('Delete',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey[800],fontSize: 15,),),
        ],
      ))),

    ),
    CustomPopupMenuItem(
      height: 35,
      value: 'Change Password',
      child: Center(child: SizedBox(width: 150,child: Row(
        children: [ Icon(Icons.edit,size: 15,color: Colors.grey[800],),
          const SizedBox(width: 5,),
          Text('Change Password',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey[800],fontSize: 15,),),
        ],
      ))),

    ),
  ];
  String userInitialType = 'Edit Options';

  String? assignUserId;
  //delete api.
  Future deleteUserData(userID) async {
    String url =
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/delete-user/$userID';
    final response = await http.delete(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $authToken'
    },

    );
    if (response.statusCode == 200) {
      setState(() {
        displayUserList=[];
        expandedId="";
        fetchSameCompanyCustomers();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompanyDetails(
            companyName: companyName,
            selectedDestination: widget.selectedDestination,
            drawerWidth: widget.drawerWidth,
            companyID: companyID,
            dealerID: dealerID
        )));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User  Deleted')));
      });

    } else {
      log(response.statusCode.toString());
    }
  }

  String createUserRole="Select User Role";
  String createCompanyName="Select Company Name";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDrawer(widget.drawerWidth, widget.selectedDestination),
            const VerticalDivider(width: 1, thickness: 1,),
            Expanded(
              child:  CustomLoader(
                inAsyncCall: loading,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50,right: 50,top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0),)

                      ),
                      child: Column(
                          children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 18,),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Users",
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0),
                                      child: SizedBox(

                                        width: 150,
                                        height:30,
                                        child: OutlinedMButton(
                                          text: '+ Create User',
                                          buttonColor:mSaveButton ,
                                          textColor: Colors.white,
                                          borderColor: mSaveButton,
                                          onTap:(){
                                            createUserRole="Select User Role";
                                            createCompanyName="Select Company Name";
                                            createNewUser(context,companyNamesList);
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18,),
                              Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                              Container(color: Colors.grey[100],
                                child:  IgnorePointer(
                                  ignoring: true,
                                  child: MaterialButton(
                                    onPressed: (){},
                                    hoverColor: Colors.transparent,
                                    hoverElevation: 0,
                                    child:  Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Row(
                                        children: [
                                          const  Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("User Name")
                                                ),
                                              )),
                                          const   Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("Email")
                                                ),
                                              )),
                                          const Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("Company Name")
                                                ),
                                              )),
                                          const Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: Text("Role"),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 38),
                                            child: Container(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4,),
                        if(companyUsers)
                          Column(
                            children: [
                              const   SizedBox(height: 100,),
                              Text('$companyName has no Users',style: const TextStyle(color: Colors.indigo,
                                  fontSize: 20,fontWeight: FontWeight.bold),),
                              const   SizedBox(height: 100,),
                            ],
                          ),
                        ListView.builder(shrinkWrap: true,
                            itemCount: displayUserList.length+1,
                            itemBuilder: (context,i){
                          if(i<displayUserList.length){
                          return  Column(
                            children: [
                              AnimatedContainer(
                                height:displayUserList[i]['isExpanded']?90:36,
                                duration: const Duration(milliseconds: 500),
                                child: MaterialButton(
                                  hoverColor:Colors.blue[50] ,
                                  onPressed: () {
                                    setState(() {
                                      if(expandedId==""){
                                        setState(() {
                                          expandedId=displayUserList[i]["userid"];
                                          displayUserList[i]["isExpanded"]=true;
                                        });

                                      }
                                      else if(expandedId==displayUserList[i]['userid']){
                                        setState(() {
                                          displayUserList[i]['isExpanded']=false;
                                          expandedId="";
                                        });
                                      }
                                      else if(expandedId.isNotEmpty || expandedId!=""){
                                        setState(() {
                                          for(var userId in displayUserList){
                                            if(userId["userid"]==expandedId){
                                              userId["isExpanded"]=false;
                                              expandedId=displayUserList[i]["userid"];
                                              displayUserList[i]["isExpanded"]=true;
                                            }
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0,bottom: 3,top:4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 4.0,left: 5),
                                                        child: SizedBox(height: 25,
                                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                            child: Text(displayUserList[i]['username']??"")
                                                        ),
                                                      )),
                                                  Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 4,left: 5),
                                                        child: SizedBox(
                                                            height: 25,
                                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                            child: Text(displayUserList[i]['email']?? '')
                                                        ),
                                                      )
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 4),
                                                        child: SizedBox(height: 25,
                                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                            child: Text(displayUserList[i]['company_name']??"")
                                                        ),
                                                      )),
                                                  Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 4),
                                                        child: SizedBox(height: 25,
                                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                            child: Text(displayUserList[i]['role']??"")
                                                        ),
                                                      )),

                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(right:10.0),
                                                  //   child: Center(
                                                  //     child: SizedBox(width: 25,
                                                  //       height: 28,
                                                  //       child:CustomPopupMenuButton<String>(
                                                  //         childWidth: 200,position: CustomPopupMenuPosition.under,
                                                  //         decoration: customPopupDecoration(hintText: 'Create New Service'),
                                                  //         hintText: "",
                                                  //         shape: const RoundedRectangleBorder(
                                                  //           side: BorderSide(color:Color(0xFFE0E0E0)),
                                                  //           borderRadius: BorderRadius.all(
                                                  //             Radius.circular(5),
                                                  //           ),
                                                  //         ),
                                                  //         offset: const Offset(1, 12),
                                                  //         tooltip: '',
                                                  //         itemBuilder: (context,) {
                                                  //           return userTypes;
                                                  //         },
                                                  //         onSelected: (String value,)  {
                                                  //           setState(() {
                                                  //             userInitialType=value;
                                                  //             if(userInitialType=="Edit"){
                                                  //               showDialog(
                                                  //                 context: context,
                                                  //                 builder: (context) {
                                                  //                   //Declaration Is Here.
                                                  //                   final editUserName = TextEditingController();
                                                  //                   bool editUserNameError = false;
                                                  //                   bool editUserEmailError = false;
                                                  //                   final editEmail = TextEditingController();
                                                  //                   bool editFocusedCompany=false;
                                                  //                   bool editCompanyError=false;
                                                  //                   final editCreateCompanyCon=TextEditingController();
                                                  //
                                                  //                   bool editFocusedUser=false;
                                                  //                   bool editUserError=false;
                                                  //                   final editUserController=TextEditingController();
                                                  //                   editUserName.text = displayUserList[i]['username'];
                                                  //                   editEmail.text = displayUserList[i]['email'];
                                                  //                   editUserController.text=displayUserList[i]['role'];
                                                  //                   List <CustomPopupMenuEntry<String>> editTypesOfRole =<CustomPopupMenuEntry<String>>[
                                                  //
                                                  //                     const CustomPopupMenuItem(height: 40,
                                                  //                       value: 'Admin',
                                                  //                       child: Center(child: SizedBox(width: 350,child: Text('Admin',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),
                                                  //
                                                  //                     ),
                                                  //                     const CustomPopupMenuItem(height: 40,
                                                  //                       value: 'User',
                                                  //                       child: Center(child: SizedBox(width: 350,child: Text('User',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),
                                                  //
                                                  //                     ),
                                                  //
                                                  //                   ];
                                                  //                   String hintTextCompanyName="Selected Company Name";
                                                  //                   String hintTextRole='Selected Role Type';
                                                  //                   editCreateCompanyCon.text=displayUserList[i]['company_name'];
                                                  //                   List<String> countryNames = [...companyNamesList];
                                                  //                   // Creating CustomPopupMenuEntry Empty List.
                                                  //                   List<CustomPopupMenuEntry<String>> companyNames = [];
                                                  //                   //Assigning dynamic Country Names To CustomPopupMenuEntry Drop Down.
                                                  //                   companyNames = countryNames.map((value) {
                                                  //                     return CustomPopupMenuItem(
                                                  //                       height: 40,
                                                  //                       value: value,
                                                  //                       child: Center(
                                                  //                         child: SizedBox(
                                                  //                           width: 350,
                                                  //                           child: Text(
                                                  //                             value,
                                                  //                             maxLines: 1,
                                                  //                             overflow: TextOverflow.ellipsis,
                                                  //                             style: const TextStyle(fontSize: 14),
                                                  //                           ),
                                                  //                         ),
                                                  //                       ),
                                                  //                     );
                                                  //                   }).toList();
                                                  //                   final editDetails = GlobalKey<FormState>();
                                                  //                   String capitalizeFirstWord(String value){
                                                  //                     if(value.isNotEmpty){
                                                  //                       var result =value[0].toUpperCase();
                                                  //                       for(int i=1;i<value.length;i++){
                                                  //                         if(value[i-1] == '1'){
                                                  //                           result =result + value[i].toUpperCase();
                                                  //                         }
                                                  //                         else{
                                                  //                           result=result +value[i];
                                                  //                         }
                                                  //                       }
                                                  //                       return result;
                                                  //                     }
                                                  //                     return '';
                                                  //                   }
                                                  //                   return Dialog(
                                                  //                     backgroundColor: Colors.transparent,
                                                  //                     child: StatefulBuilder(
                                                  //                       builder: (context, setState) {
                                                  //                         // Assigning variables.
                                                  //                         return SizedBox(
                                                  //                           width: 500,
                                                  //                           child: Stack(children: [
                                                  //                             Container(
                                                  //                               decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                                  //                               margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                  //                               child: SingleChildScrollView(
                                                  //                                 child: Form(
                                                  //                                   key: editDetails,
                                                  //                                   child: Padding(
                                                  //                                     padding: const EdgeInsets.all(30),
                                                  //                                     child: Container(
                                                  //                                       decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                                                  //                                       child: Column(
                                                  //                                         children: [
                                                  //                                           // Top container.
                                                  //                                           Container(color: Colors.grey[100],
                                                  //                                             child: IgnorePointer(ignoring: true,
                                                  //                                               child: MaterialButton(
                                                  //                                                 hoverColor: Colors.transparent,
                                                  //                                                 onPressed: () {
                                                  //
                                                  //                                                 },
                                                  //                                                 child: const Row(
                                                  //                                                   children: [
                                                  //                                                     Expanded(
                                                  //                                                       child: Padding(
                                                  //                                                         padding: EdgeInsets.all(8.0),
                                                  //                                                         child: Text(
                                                  //                                                           'Edit User Details',
                                                  //                                                           style: TextStyle(fontWeight: FontWeight.bold,
                                                  //                                                             fontSize: 16,),
                                                  //                                                         ),
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   ],
                                                  //                                                 ),
                                                  //                                               ),
                                                  //                                             ),
                                                  //                                           ),
                                                  //                                           const Divider(height: 1,color:mTextFieldBorder),
                                                  //                                           Padding(
                                                  //                                             padding: const EdgeInsets.all(30),
                                                  //                                             child: Column(children: [
                                                  //                                               //user Name.
                                                  //                                               Row(
                                                  //                                                 crossAxisAlignment:
                                                  //                                                 CrossAxisAlignment.start,
                                                  //                                                 children: [
                                                  //                                                   const SizedBox(
                                                  //                                                       width: 130, child: Text('User Name')),
                                                  //                                                   const SizedBox(height: 10),
                                                  //                                                   Expanded(
                                                  //                                                     child: AnimatedContainer(
                                                  //                                                       duration:
                                                  //                                                       const Duration(seconds: 0),
                                                  //                                                       height:
                                                  //                                                       editUserNameError ? 60 : 35,
                                                  //                                                       child: TextFormField(
                                                  //                                                         validator: (value) {
                                                  //                                                           if (value == null ||
                                                  //                                                               value.isEmpty) {
                                                  //                                                             setState(() {
                                                  //                                                               editUserNameError = true;
                                                  //                                                             });
                                                  //                                                             return "Enter User Name";
                                                  //                                                           } else {
                                                  //                                                             setState(() {
                                                  //                                                               editUserNameError = false;
                                                  //                                                             });
                                                  //                                                           }
                                                  //                                                           return null;
                                                  //                                                         },
                                                  //                                                         onChanged: (value) {
                                                  //                                                           editUserName.value=TextEditingValue(
                                                  //                                                             text: capitalizeFirstWord(value),
                                                  //                                                             selection: editUserName.selection,
                                                  //                                                           );
                                                  //                                                         },
                                                  //                                                         controller: editUserName,
                                                  //                                                         decoration: decorationInput5(
                                                  //                                                             'Enter User Name',
                                                  //                                                             editUserName
                                                  //                                                                 .text.isNotEmpty),
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   )
                                                  //                                                 ],
                                                  //                                               ),
                                                  //                                               const SizedBox(
                                                  //                                                 height: 20,
                                                  //                                               ),
                                                  //                                               //Selected Company Name.
                                                  //                                               Row(
                                                  //                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                                                 children: [
                                                  //                                                   const SizedBox(
                                                  //                                                       width: 130,
                                                  //                                                       child: Text('Company Name',)),
                                                  //                                                   Expanded(
                                                  //                                                     child: Focus(
                                                  //                                                       onFocusChange: (value) {
                                                  //                                                         setState(() {
                                                  //                                                           editFocusedCompany = value;
                                                  //                                                         });
                                                  //                                                       },
                                                  //                                                       skipTraversal: true,
                                                  //                                                       descendantsAreFocusable: true,
                                                  //                                                       child: LayoutBuilder(
                                                  //                                                           builder: (BuildContext context, BoxConstraints constraints) {
                                                  //                                                             return CustomPopupMenuButton(childHeight: 200,
                                                  //                                                               elevation: 4,
                                                  //                                                               validator: (value) {
                                                  //                                                                 if(value==null||value.isEmpty){
                                                  //                                                                   setState(() {
                                                  //                                                                     editCompanyError =true;
                                                  //                                                                   });
                                                  //                                                                   return null;
                                                  //                                                                 }
                                                  //                                                                 return null;
                                                  //                                                               },
                                                  //                                                               decoration: customPopupDecoration(hintText:hintTextCompanyName,error: editCompanyError,isFocused: editFocusedCompany),
                                                  //                                                               hintText: '',
                                                  //                                                               textController: editCreateCompanyCon,
                                                  //                                                               childWidth: constraints.maxWidth,
                                                  //                                                               shape:  RoundedRectangleBorder(
                                                  //                                                                 side: BorderSide(color:editCompanyError ? Colors.redAccent :mTextFieldBorder),
                                                  //                                                                 borderRadius: const BorderRadius.all(
                                                  //                                                                   Radius.circular(5),
                                                  //                                                                 ),
                                                  //                                                               ),
                                                  //                                                               offset: const Offset(1, 40),
                                                  //                                                               tooltip: '',
                                                  //                                                               itemBuilder:  (BuildContext context) {
                                                  //                                                                 return companyNames;
                                                  //                                                               },
                                                  //
                                                  //                                                               onSelected: (String value)  {
                                                  //                                                                 setState(() {
                                                  //                                                                   editCreateCompanyCon.text=value;
                                                  //                                                                   editCompanyError=false;
                                                  //                                                                 });
                                                  //
                                                  //                                                               },
                                                  //                                                               onCanceled: () {
                                                  //
                                                  //                                                               },
                                                  //                                                               child: Container(),
                                                  //                                                             );
                                                  //                                                           }
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   ),
                                                  //                                                 ],
                                                  //                                               ),
                                                  //                                               const SizedBox(
                                                  //                                                 height: 20,
                                                  //                                               ),
                                                  //                                               //  user Role.
                                                  //                                               Row(
                                                  //                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                  //                                                 children: [
                                                  //                                                   const SizedBox(
                                                  //                                                       width: 130,
                                                  //                                                       child: Text(
                                                  //                                                         "User Role",
                                                  //                                                       )),
                                                  //                                                   Expanded(
                                                  //                                                     child: Focus(
                                                  //                                                       onFocusChange: (value) {
                                                  //                                                         setState(() {
                                                  //                                                           editFocusedUser = value;
                                                  //                                                         });
                                                  //                                                       },
                                                  //                                                       skipTraversal: true,
                                                  //                                                       descendantsAreFocusable: true,
                                                  //                                                       child: LayoutBuilder(
                                                  //                                                           builder: (BuildContext context, BoxConstraints constraints) {
                                                  //                                                             return CustomPopupMenuButton(elevation: 4,
                                                  //                                                               validator: (value) {
                                                  //                                                                 if(value==null||value.isEmpty){
                                                  //                                                                   setState(() {
                                                  //                                                                     editUserError =true;
                                                  //                                                                   });
                                                  //                                                                   return null;
                                                  //                                                                 }
                                                  //                                                                 return null;
                                                  //                                                               },
                                                  //                                                               decoration: customPopupDecoration(hintText:hintTextRole,error: editUserError,isFocused: editFocusedUser),
                                                  //                                                               hintText: '',
                                                  //                                                               textController: editUserController,
                                                  //                                                               childWidth: constraints.maxWidth,
                                                  //                                                               shape:  RoundedRectangleBorder(
                                                  //                                                                 side: BorderSide(color:editUserError ? Colors.redAccent :mTextFieldBorder),
                                                  //                                                                 borderRadius: const BorderRadius.all(
                                                  //                                                                   Radius.circular(5),
                                                  //                                                                 ),
                                                  //                                                               ),
                                                  //                                                               offset: const Offset(1, 40),
                                                  //                                                               tooltip: '',
                                                  //                                                               itemBuilder:  (BuildContext context) {
                                                  //                                                                 return editTypesOfRole;
                                                  //                                                               },
                                                  //
                                                  //                                                               onSelected: (String value)  {
                                                  //                                                                 setState(() {
                                                  //                                                                   editUserController.text=value;
                                                  //                                                                   editUserError=false;
                                                  //                                                                 });
                                                  //
                                                  //                                                               },
                                                  //                                                               onCanceled: () {
                                                  //
                                                  //                                                               },
                                                  //                                                               child: Container(),
                                                  //                                                             );
                                                  //                                                           }
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   ),
                                                  //                                                 ],
                                                  //                                               ),
                                                  //
                                                  //                                               const SizedBox(
                                                  //                                                 height: 20,
                                                  //                                               ),
                                                  //                                               //User Email.
                                                  //                                               Row(
                                                  //                                                 crossAxisAlignment:
                                                  //                                                 CrossAxisAlignment.start,
                                                  //                                                 children: [
                                                  //                                                   const SizedBox(
                                                  //                                                       width: 130,
                                                  //                                                       child: Text('User Email')),
                                                  //                                                   const SizedBox(height: 10),
                                                  //                                                   Expanded(
                                                  //                                                     child: AnimatedContainer(
                                                  //                                                       duration:
                                                  //                                                       const Duration(seconds: 0),
                                                  //                                                       height:
                                                  //                                                       editUserEmailError ? 60 : 35,
                                                  //                                                       child: TextFormField(
                                                  //                                                         validator: (value) {
                                                  //                                                           if (value == null || value.isEmpty) {
                                                  //                                                             setState(() {
                                                  //                                                               editUserEmailError = true;
                                                  //                                                             });
                                                  //                                                             return "Enter User Email";
                                                  //                                                           }
                                                  //                                                           else if(!EmailValidator.validate(value)){
                                                  //                                                             setState((){
                                                  //                                                               editUserEmailError=true;
                                                  //                                                             });
                                                  //                                                             return 'Please enter a valid email address';
                                                  //                                                           }
                                                  //                                                           else {
                                                  //                                                             setState(() {
                                                  //                                                               editUserEmailError =
                                                  //                                                               false;
                                                  //                                                             });
                                                  //                                                           }
                                                  //                                                           return null;
                                                  //                                                         },
                                                  //                                                         onChanged: (text) {
                                                  //                                                           setState(() {});
                                                  //                                                         },
                                                  //                                                         controller: editEmail,
                                                  //                                                         decoration: decorationInput5(
                                                  //                                                             'Enter User Email',
                                                  //                                                             editEmail.text.isNotEmpty),
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   )
                                                  //                                                 ],
                                                  //                                               ),
                                                  //
                                                  //                                               const SizedBox(
                                                  //                                                 height: 35,
                                                  //                                               ),
                                                  //                                               Align(
                                                  //                                                 alignment: Alignment.center,
                                                  //                                                 child:  SizedBox(
                                                  //                                                   width: 100,
                                                  //                                                   height:30,
                                                  //                                                   child: OutlinedMButton(
                                                  //                                                     text: 'Update',
                                                  //                                                     buttonColor:mSaveButton ,
                                                  //                                                     textColor: Colors.white,
                                                  //                                                     borderColor: mSaveButton,
                                                  //                                                     onTap:(){
                                                  //                                                       if (editDetails.currentState!.validate()) {
                                                  //                                                         Map editUserManagement = {
                                                  //                                                           "userid":displayUserList[i]['userid'],
                                                  //                                                           'username': editUserName.text,
                                                  //                                                           'password':displayUserList[i]['password'],
                                                  //                                                           'active':true,
                                                  //                                                           'role':  editUserController.text,
                                                  //                                                           'email': editEmail.text,
                                                  //                                                           'token':'',
                                                  //                                                           'token_creation_date':'',
                                                  //                                                           'company_name':  editCreateCompanyCon.text,
                                                  //                                                           //editCompanyName.text,
                                                  //                                                         };
                                                  //                                                         // print('-----change-----');
                                                  //                                                         // print(editUserManagement);
                                                  //                                                         updateUserDetails(editUserManagement,);
                                                  //                                                       }
                                                  //                                                     },
                                                  //                                                   ),
                                                  //                                                 ),
                                                  //                                               ),
                                                  //
                                                  //                                             ],),
                                                  //                                           )
                                                  //                                         ],
                                                  //                                       ),
                                                  //                                     ),
                                                  //                                   ),
                                                  //                                 ),
                                                  //                               ),
                                                  //                             ),
                                                  //                             Positioned(right: 0.0,
                                                  //
                                                  //                               child: InkWell(
                                                  //                                 child: Container(
                                                  //                                     width: 30,
                                                  //                                     height: 30,
                                                  //                                     decoration: BoxDecoration(
                                                  //                                         borderRadius: BorderRadius.circular(15),
                                                  //                                         border: Border.all(
                                                  //                                           color:
                                                  //                                           const Color.fromRGBO(204, 204, 204, 1),
                                                  //                                         ),
                                                  //                                         color: Colors.blue),
                                                  //                                     child: const Icon(
                                                  //                                       Icons.close_sharp,
                                                  //                                       color: Colors.white,
                                                  //                                     )),
                                                  //                                 onTap: () {
                                                  //                                   setState(() {
                                                  //                                     Navigator.of(context).pop();
                                                  //                                   });
                                                  //                                 },
                                                  //                               ),
                                                  //                             ),
                                                  //                           ],
                                                  //                           ),
                                                  //                         );
                                                  //                       },
                                                  //                     ),
                                                  //                   );
                                                  //                 },
                                                  //               );
                                                  //             }
                                                  //             else if(userInitialType=="Delete"){
                                                  //               showDialog(
                                                  //                 context: context,
                                                  //                 builder: (context) {
                                                  //                   return Dialog(
                                                  //                     backgroundColor: Colors.transparent,
                                                  //                     child: StatefulBuilder(
                                                  //                       builder: (context, setState) {
                                                  //                         return SizedBox(
                                                  //                           height: 200,
                                                  //                           width: 300,
                                                  //                           child: Stack(children: [
                                                  //                             Container(
                                                  //                               decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                                  //                               margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                  //                               child: Column(
                                                  //                                 children: [
                                                  //
                                                  //                                   const SizedBox(
                                                  //                                     height: 20,
                                                  //                                   ),
                                                  //                                   const Icon(
                                                  //                                     Icons.warning_rounded,
                                                  //                                     color: Colors.red,
                                                  //                                     size: 50,
                                                  //                                   ),
                                                  //                                   const SizedBox(
                                                  //                                     height: 10,
                                                  //                                   ),
                                                  //                                   const Center(
                                                  //                                       child: Text(
                                                  //                                         'Are You Sure, You Want To Delete ?',
                                                  //                                         style: TextStyle(
                                                  //                                             color: Colors.indigo,
                                                  //                                             fontWeight: FontWeight.bold,
                                                  //                                             fontSize: 16),
                                                  //                                       )),
                                                  //                                   const SizedBox(
                                                  //                                     height: 35,
                                                  //                                   ),
                                                  //                                   Row(
                                                  //                                     mainAxisAlignment:
                                                  //                                     MainAxisAlignment.spaceEvenly,
                                                  //                                     children: [
                                                  //                                       SizedBox(
                                                  //                                         width: 50,
                                                  //                                         height:30,
                                                  //                                         child: OutlinedMButton(
                                                  //                                           text: 'Ok',
                                                  //                                           buttonColor:Colors.red ,
                                                  //                                           textColor: Colors.white,
                                                  //                                           borderColor: Colors.red,
                                                  //                                           onTap:(){
                                                  //                                             assignUserId = displayUserList[i]['userid'];
                                                  //                                             // print('--------userid----');
                                                  //                                             // print( assignUserId);
                                                  //                                             deleteUserData();
                                                  //                                           },
                                                  //                                         ),
                                                  //                                       ),
                                                  //                                       SizedBox(
                                                  //
                                                  //                                         width: 100,
                                                  //                                         height:30,
                                                  //                                         child: OutlinedMButton(
                                                  //                                           text: 'Cancel',
                                                  //                                           buttonColor:mSaveButton ,
                                                  //                                           textColor: Colors.white,
                                                  //                                           borderColor: mSaveButton,
                                                  //                                           onTap:(){
                                                  //                                             Navigator.of(context).pop();
                                                  //                                           },
                                                  //                                         ),
                                                  //                                       ),
                                                  //
                                                  //                                     ],
                                                  //                                   )
                                                  //                                 ],
                                                  //                               ),
                                                  //                             ),
                                                  //                             Positioned(right: 0.0,
                                                  //
                                                  //                               child: InkWell(
                                                  //                                 child: Container(
                                                  //                                     width: 30,
                                                  //                                     height: 30,
                                                  //                                     decoration: BoxDecoration(
                                                  //                                         borderRadius: BorderRadius.circular(15),
                                                  //                                         border: Border.all(
                                                  //                                           color:
                                                  //                                           const Color.fromRGBO(204, 204, 204, 1),
                                                  //                                         ),
                                                  //                                         color: Colors.blue),
                                                  //                                     child: const Icon(
                                                  //                                       Icons.close_sharp,
                                                  //                                       color: Colors.white,
                                                  //                                     )),
                                                  //                                 onTap: () {
                                                  //                                   setState(() {
                                                  //                                     Navigator.of(context).pop();
                                                  //                                   });
                                                  //                                 },
                                                  //                               ),
                                                  //                             ),
                                                  //                           ],
                                                  //
                                                  //                           ),
                                                  //                         );
                                                  //                       },
                                                  //                     ),
                                                  //                   );
                                                  //                 },
                                                  //               );
                                                  //             }
                                                  //             else if(userInitialType=="Change Password"){
                                                  //               showDialog(
                                                  //                 context: context,
                                                  //                 builder: (context) {
                                                  //                   bool passwordFirstEnter = true;
                                                  //                   final emailBased = TextEditingController();
                                                  //                   final editPassword = TextEditingController();
                                                  //                   final conformPassword = TextEditingController();
                                                  //                   bool editEmailError = false;
                                                  //                   bool editPasswordError = false;
                                                  //                   bool conformPasswordInitial = true;
                                                  //                   String storeEmail = '';
                                                  //                   String storePassword = '';
                                                  //                   //regular expression to check if string.
                                                  //                   RegExp passValid = RegExp(
                                                  //                       r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
                                                  //                   // a function that validate user enter password.
                                                  //                   bool validatePassword(String pass) {
                                                  //                     String password = pass.trim();
                                                  //                     if (passValid.hasMatch(password)) {
                                                  //                       return true;
                                                  //                     } else {
                                                  //                       return false;
                                                  //                     }
                                                  //                   }
                                                  //
                                                  //                   final changeKey = GlobalKey<FormState>();
                                                  //                   return Dialog(
                                                  //                     backgroundColor: Colors.transparent,
                                                  //                     child: StatefulBuilder(
                                                  //                       builder: (context, setState) {
                                                  //                         void textHideFunc() {
                                                  //                           setState(() {
                                                  //                             passwordFirstEnter = !passwordFirstEnter;
                                                  //                           });
                                                  //                         }
                                                  //
                                                  //                         void textHideConformPassword() {
                                                  //                           setState(() {
                                                  //                             conformPasswordInitial = !conformPasswordInitial;
                                                  //                           });
                                                  //                         }
                                                  //
                                                  //                         emailBased.text = displayUserList[i]['email'];
                                                  //                         storeEmail = displayUserList[i]['email'];
                                                  //                         storePassword = editPassword.text;
                                                  //
                                                  //                         return SizedBox(
                                                  //                           width: 500,
                                                  //                           child: Stack(children: [
                                                  //                             Container(
                                                  //                               decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                                  //                               margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                  //                               child: SingleChildScrollView(
                                                  //                                 child: Form(
                                                  //                                   key: changeKey,
                                                  //                                   child: Padding(
                                                  //                                     padding:  const EdgeInsets.all(30),
                                                  //                                     child: Container(
                                                  //                                       decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                                                  //                                       child: Column(children: [
                                                  //                                         // Top container.
                                                  //                                         Container(color: Colors.grey[100],
                                                  //                                           child: IgnorePointer(ignoring: true,
                                                  //                                             child: MaterialButton(
                                                  //                                               hoverColor: Colors.transparent,
                                                  //                                               onPressed: () {
                                                  //
                                                  //                                               },
                                                  //                                               child: const Row(
                                                  //                                                 children: [
                                                  //                                                   Expanded(
                                                  //                                                     child: Padding(
                                                  //                                                       padding: EdgeInsets.all(8.0),
                                                  //                                                       child: Text(
                                                  //                                                         'Change Password',
                                                  //                                                         style: TextStyle(fontWeight: FontWeight.bold,
                                                  //                                                           fontSize: 16,),
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   ),
                                                  //                                                 ],
                                                  //                                               ),
                                                  //                                             ),
                                                  //                                           ),
                                                  //                                         ),
                                                  //                                         const Divider(height: 1,color:mTextFieldBorder),
                                                  //                                         Padding(
                                                  //                                           padding: const EdgeInsets.all(30),
                                                  //                                           child: Column(children: [
                                                  //                                             //User Email
                                                  //                                             Row(
                                                  //                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                                               children: [
                                                  //                                                 const SizedBox(
                                                  //                                                     width: 140, child: Text('User Email')),
                                                  //                                                 const SizedBox(height: 10),
                                                  //                                                 Expanded(
                                                  //                                                   child: AnimatedContainer(
                                                  //                                                     duration:
                                                  //                                                     const Duration(seconds: 0),
                                                  //                                                     height: editEmailError ? 60 : 35,
                                                  //                                                     child: TextFormField(
                                                  //                                                       readOnly: true,
                                                  //                                                       validator: (value) {
                                                  //                                                         if (value == null ||
                                                  //                                                             value.isEmpty) {
                                                  //                                                           setState(() {
                                                  //                                                             editEmailError = true;
                                                  //                                                           });
                                                  //                                                           return "Enter User Name";
                                                  //                                                         } else {
                                                  //                                                           setState(() {
                                                  //                                                             editEmailError = false;
                                                  //                                                           });
                                                  //                                                         }
                                                  //                                                         return null;
                                                  //                                                       },
                                                  //                                                       controller: emailBased,
                                                  //                                                       decoration: decorationInput5(
                                                  //                                                           'User Email',
                                                  //                                                           emailBased.text.isNotEmpty),
                                                  //                                                     ),
                                                  //                                                   ),
                                                  //                                                 )
                                                  //                                               ],
                                                  //                                             ),
                                                  //                                             const SizedBox(
                                                  //                                               height: 20,
                                                  //                                             ),
                                                  //                                             //User Password.
                                                  //                                             Row(
                                                  //                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                                               children: [
                                                  //                                                 const SizedBox(
                                                  //                                                     width: 140,
                                                  //                                                     child: Text('User Password')),
                                                  //                                                 const SizedBox(height: 10),
                                                  //                                                 Expanded(
                                                  //                                                   child: AnimatedContainer(
                                                  //                                                     duration: const Duration(seconds: 0),
                                                  //                                                     height: editPasswordError ? 60 : 35,
                                                  //                                                     child: TextFormField(onTap: () {
                                                  //                                                       setState((){
                                                  //                                                         conformPasswordInitial=true;
                                                  //                                                       });
                                                  //                                                     },
                                                  //                                                         validator: (value) {
                                                  //                                                           if (value == null ||
                                                  //                                                               value.isEmpty) {
                                                  //                                                             setState(() {
                                                  //                                                               editPasswordError = true;
                                                  //                                                             });
                                                  //                                                             return 'Enter Password';
                                                  //                                                           } else {
                                                  //                                                             // call function to check password
                                                  //                                                             bool result =
                                                  //                                                             validatePassword(value);
                                                  //                                                             if (result) {
                                                  //                                                               setState(() {
                                                  //                                                                 editPasswordError = false;
                                                  //                                                               });
                                                  //                                                               // create account event
                                                  //                                                               return null;
                                                  //                                                             } else {
                                                  //                                                               setState(() {
                                                  //                                                                 editPasswordError = true;
                                                  //                                                               });
                                                  //                                                               return "Password should contain:One Capital Letter & one Small letter & one Number one Special Char& 8 Characters length.";
                                                  //                                                             }
                                                  //                                                           }
                                                  //                                                         },
                                                  //                                                         controller: editPassword,
                                                  //                                                         obscureText: passwordFirstEnter,
                                                  //                                                         decoration: decorationInputPassword(
                                                  //                                                             'Enter Password',
                                                  //                                                             editPassword.text.isNotEmpty,
                                                  //                                                             passwordFirstEnter,
                                                  //                                                             textHideFunc)),
                                                  //                                                   ),
                                                  //                                                 )
                                                  //                                               ],
                                                  //                                             ),
                                                  //                                             const SizedBox(
                                                  //                                               height: 20,
                                                  //                                             ),
                                                  //                                             //conform password.
                                                  //                                             Row(
                                                  //                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                                               children: [
                                                  //                                                 const SizedBox(
                                                  //                                                     width: 140,
                                                  //                                                     child: Text('Conform Password')),
                                                  //                                                 const SizedBox(height: 10),
                                                  //                                                 Expanded(
                                                  //                                                   child: AnimatedContainer(
                                                  //                                                     duration:
                                                  //                                                     const Duration(seconds: 0),
                                                  //                                                     height: editPasswordError ? 60 : 35,
                                                  //                                                     child: TextFormField(onTap: () {
                                                  //                                                       setState((){
                                                  //                                                         passwordFirstEnter=true;
                                                  //                                                       });
                                                  //                                                     },
                                                  //                                                       validator: (value) {
                                                  //                                                         if (value == null ||
                                                  //                                                             value.isEmpty &&
                                                  //                                                                 conformPassword.text ==
                                                  //                                                                     '') {
                                                  //                                                           setState(() {
                                                  //                                                             editPasswordError = true;
                                                  //                                                           });
                                                  //                                                           return "Conform Password";
                                                  //                                                         } else if (conformPassword
                                                  //                                                             .text !=
                                                  //                                                             editPassword.text) {
                                                  //                                                           setState(() {
                                                  //                                                             editPasswordError = true;
                                                  //                                                           });
                                                  //                                                           return 'Password does`t match';
                                                  //                                                         } else {
                                                  //                                                           setState(() {
                                                  //                                                             editPasswordError = false;
                                                  //                                                           });
                                                  //                                                         }
                                                  //                                                         return null;
                                                  //                                                       },
                                                  //                                                       onChanged: (text) {
                                                  //                                                         setState(() {});
                                                  //                                                       },
                                                  //                                                       controller: conformPassword,
                                                  //                                                       decoration:
                                                  //                                                       decorationInputConformPassword(
                                                  //                                                           'Conform Password',
                                                  //                                                           conformPassword
                                                  //                                                               .text.isNotEmpty,
                                                  //                                                           conformPasswordInitial,
                                                  //                                                           textHideConformPassword),
                                                  //                                                       obscureText: conformPasswordInitial,
                                                  //                                                     ),
                                                  //                                                   ),
                                                  //                                                 )
                                                  //                                               ],
                                                  //                                             ),
                                                  //                                             const SizedBox(
                                                  //                                               height: 35,
                                                  //                                             ),
                                                  //                                             Align(
                                                  //                                               alignment: Alignment.center,
                                                  //                                               child:  SizedBox(
                                                  //                                                 width: 100,
                                                  //                                                 height:30,
                                                  //                                                 child: OutlinedMButton(
                                                  //                                                   text: 'Save',
                                                  //                                                   buttonColor:mSaveButton ,
                                                  //                                                   textColor: Colors.white,
                                                  //                                                   borderColor: mSaveButton,
                                                  //                                                   onTap:(){
                                                  //
                                                  //                                                     //Password change.
                                                  //                                                     Future changePasswordFunc(String storeEmail, String storePassword) async {
                                                  //                                                       // print('------------------storepassword------------');
                                                  //                                                       // print(storePassword);
                                                  //                                                       // print('------check-------------');
                                                  //                                                       // print('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/change-password/$storeEmail/$storePassword');
                                                  //
                                                  //                                                       String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/change-password/$storeEmail/$storePassword';
                                                  //                                                       final response = await http.get(Uri.parse(url), headers: {
                                                  //                                                         "Content-Type": "application/json",
                                                  //                                                         'Authorization': 'Bearer $authToken'
                                                  //                                                       });
                                                  //                                                       if (response.statusCode == 200) {
                                                  //                                                         // print('-----------status-code------------');
                                                  //                                                         // print(response.statusCode);
                                                  //                                                         if(mounted) {
                                                  //                                                           Navigator.of(context).pop();
                                                  //                                                         }
                                                  //                                                       } else {
                                                  //                                                         log(response.statusCode.toString());
                                                  //                                                       }
                                                  //                                                     }
                                                  //
                                                  //                                                     setState(() {
                                                  //                                                       if (changeKey.currentState!.validate()) {
                                                  //                                                         changePasswordFunc(storeEmail, storePassword);
                                                  //                                                       }
                                                  //                                                     });
                                                  //                                                   },
                                                  //                                                 ),
                                                  //                                               ),
                                                  //
                                                  //                                             ),
                                                  //                                           ],),
                                                  //                                         )
                                                  //                                       ]),
                                                  //                                     ),
                                                  //                                   ),
                                                  //                                 ),
                                                  //                               ),
                                                  //                             ),
                                                  //                             Positioned(right: 0.0,
                                                  //
                                                  //                               child: InkWell(
                                                  //                                 child: Container(
                                                  //                                     width: 30,
                                                  //                                     height: 30,
                                                  //                                     decoration: BoxDecoration(
                                                  //                                         borderRadius: BorderRadius.circular(15),
                                                  //                                         border: Border.all(
                                                  //                                           color:
                                                  //                                           const Color.fromRGBO(204, 204, 204, 1),
                                                  //                                         ),
                                                  //                                         color: Colors.blue),
                                                  //                                     child: const Icon(
                                                  //                                       Icons.close_sharp,
                                                  //                                       color: Colors.white,
                                                  //                                     )),
                                                  //                                 onTap: () {
                                                  //                                   setState(() {
                                                  //                                     Navigator.of(context).pop();
                                                  //                                   });
                                                  //                                 },
                                                  //                               ),
                                                  //                             ),
                                                  //                           ],
                                                  //                           ),
                                                  //                         );
                                                  //                       },
                                                  //                     ),
                                                  //                   );
                                                  //                 },
                                                  //               );
                                                  //             }
                                                  //           });
                                                  //         },
                                                  //         child: Container(),
                                                  //       ),
                                                  //
                                                  //     ),
                                                  //   ),
                                                  // ),

                                                ],
                                              ),
                                              displayUserList[i]["isExpanded"]?
                                              FutureBuilder (
                                                  future: _show(),
                                                  builder: (context,snapchat) {
                                                    if(!snapchat.hasData){
                                                      return const SizedBox();
                                                    }
                                                    return Column(
                                                      children: [
                                                        const SizedBox(height: 12,),
                                                        Row(mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              height: 28,
                                                              width:80,
                                                              child: OutlinedBorderWithIcon(
                                                                buttonText: 'Edit', iconData: Icons.edit,
                                                                onTap: (){
                                                                  setState(() {
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        //Declaration Is Here.
                                                                        final editUserName = TextEditingController();
                                                                        bool editUserNameError = false;
                                                                        bool editUserEmailError = false;
                                                                        final editEmail = TextEditingController();
                                                                        bool editFocusedCompany=false;
                                                                        bool editFocusedDealer=false;
                                                                        bool editCompanyError=false;
                                                                        bool editDealerError=false;
                                                                        final editCreateCompanyCon=TextEditingController();
                                                                        final editDealerName=TextEditingController();
                                                                        bool editFocusedUser=false;
                                                                        bool editUserError=false;
                                                                        final editUserController=TextEditingController();
                                                                        editUserName.text = displayUserList[i]['username'];
                                                                        editEmail.text = displayUserList[i]['email'];
                                                                        editUserController.text=displayUserList[i]['role'];
                                                                        List <CustomPopupMenuEntry<String>> editTypesOfRole =<CustomPopupMenuEntry<String>>[

                                                                          const CustomPopupMenuItem(height: 40,
                                                                            value: 'Approver',
                                                                            child: Center(child: SizedBox(width: 350,child: Text('Approver',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

                                                                          ),
                                                                          const CustomPopupMenuItem(height: 40,
                                                                            value: 'User',
                                                                            child: Center(child: SizedBox(width: 350,child: Text('User',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

                                                                          ),

                                                                        ];
                                                                        String hintTextCompanyName="Selected Company Name";
                                                                        String hintTextDealerName="Selected Dealer Name";
                                                                        String hintTextRole='Selected Role Type';
                                                                        editCreateCompanyCon.text=displayUserList[i]['company_name'];
                                                                        editDealerName.text = displayListDealers[i]['dealer_name'];
                                                                        List<String> countryNames = [...companyNamesList];
                                                                        List<String> dealerListNames = [...dealerNamesList];
                                                                        // Creating CustomPopupMenuEntry Empty List.
                                                                        List<CustomPopupMenuEntry<String>> companyNames = [];
                                                                        List<CustomPopupMenuEntry<String>> dealerNames = [];
                                                                        //Assigning dynamic Country Names To CustomPopupMenuEntry Drop Down.
                                                                        companyNames = countryNames.map((value) {
                                                                          return CustomPopupMenuItem(
                                                                            height: 40,
                                                                            value: value,
                                                                            child: Center(
                                                                              child: SizedBox(
                                                                                width: 350,
                                                                                child: Text(
                                                                                  value,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(fontSize: 14),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }).toList();
                                                                        // dealerNames = dealerListNames.map((value) {
                                                                        //   return CustomPopupMenuItem(
                                                                        //     height: 40,
                                                                        //     value: value,
                                                                        //     child: Center(
                                                                        //       child: SizedBox(
                                                                        //         width: 350,
                                                                        //         child: Text(
                                                                        //           value,
                                                                        //           maxLines: 1,
                                                                        //           overflow: TextOverflow.ellipsis,
                                                                        //           style: const TextStyle(fontSize: 14),
                                                                        //         ),
                                                                        //       ),
                                                                        //     ),
                                                                        //   );
                                                                        // }).toList();
                                                                        final editDetails = GlobalKey<FormState>();
                                                                        String capitalizeFirstWord(String value){
                                                                          if(value.isNotEmpty){
                                                                            var result =value[0].toUpperCase();
                                                                            for(int i=1;i<value.length;i++){
                                                                              if(value[i-1] == '1'){
                                                                                result =result + value[i].toUpperCase();
                                                                              }
                                                                              else{
                                                                                result=result +value[i];
                                                                              }
                                                                            }
                                                                            return result;
                                                                          }
                                                                          return '';
                                                                        }
                                                                        return Dialog(
                                                                          backgroundColor: Colors.transparent,
                                                                          child: StatefulBuilder(
                                                                            builder: (context, setState) {
                                                                              // Assigning variables.
                                                                              return SizedBox(
                                                                                width: 500,
                                                                                child: Stack(children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                                                                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                                                    child: SingleChildScrollView(
                                                                                      child: Form(
                                                                                        key: editDetails,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(30),
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                // Top container.
                                                                                                Container(color: Colors.grey[100],
                                                                                                  child: IgnorePointer(ignoring: true,
                                                                                                    child: MaterialButton(
                                                                                                      hoverColor: Colors.transparent,
                                                                                                      onPressed: () {

                                                                                                      },
                                                                                                      child: const Row(
                                                                                                        children: [
                                                                                                          Expanded(
                                                                                                            child: Padding(
                                                                                                              padding: EdgeInsets.all(8.0),
                                                                                                              child: Text(
                                                                                                                'Edit User Details',
                                                                                                                style: TextStyle(fontWeight: FontWeight.bold,
                                                                                                                  fontSize: 16,),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                const Divider(height: 1,color:mTextFieldBorder),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.all(30),
                                                                                                  child: Column(children: [
                                                                                                    //user Name.
                                                                                                    Row(
                                                                                                      crossAxisAlignment:
                                                                                                      CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        const SizedBox(
                                                                                                            width: 130, child: Text('User Name')),
                                                                                                        const SizedBox(height: 10),
                                                                                                        Expanded(
                                                                                                          child: AnimatedContainer(
                                                                                                            duration:
                                                                                                            const Duration(seconds: 0),
                                                                                                            height:
                                                                                                            editUserNameError ? 60 : 35,
                                                                                                            child: TextFormField(
                                                                                                              validator: (value) {
                                                                                                                if (value == null ||
                                                                                                                    value.isEmpty) {
                                                                                                                  setState(() {
                                                                                                                    editUserNameError = true;
                                                                                                                  });
                                                                                                                  return "Enter User Name";
                                                                                                                } else {
                                                                                                                  setState(() {
                                                                                                                    editUserNameError = false;
                                                                                                                  });
                                                                                                                }
                                                                                                                return null;
                                                                                                              },
                                                                                                              onChanged: (value) {
                                                                                                                editUserName.value=TextEditingValue(
                                                                                                                  text: capitalizeFirstWord(value),
                                                                                                                  selection: editUserName.selection,
                                                                                                                );
                                                                                                              },
                                                                                                              controller: editUserName,
                                                                                                              decoration: decorationInput5(
                                                                                                                  'Enter User Name',
                                                                                                                  editUserName
                                                                                                                      .text.isNotEmpty),
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      height: 20,
                                                                                                    ),
                                                                                                    //Selected Company Name.
                                                                                                    Row(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        const SizedBox(
                                                                                                            width: 130,
                                                                                                            child: Text('Company Name',)),
                                                                                                        Expanded(
                                                                                                          child: Focus(
                                                                                                            onFocusChange: (value) {
                                                                                                              setState(() {
                                                                                                                editFocusedCompany = value;
                                                                                                              });
                                                                                                            },
                                                                                                            skipTraversal: true,
                                                                                                            descendantsAreFocusable: true,
                                                                                                            child: LayoutBuilder(
                                                                                                                builder: (BuildContext context, BoxConstraints constraints) {
                                                                                                                  return CustomPopupMenuButton(childHeight: 200,
                                                                                                                    elevation: 4,
                                                                                                                    validator: (value) {
                                                                                                                      if(value==null||value.isEmpty){
                                                                                                                        setState(() {
                                                                                                                          editCompanyError =true;
                                                                                                                        });
                                                                                                                        return null;
                                                                                                                      }
                                                                                                                      return null;
                                                                                                                    },
                                                                                                                    decoration: customPopupDecoration(hintText:hintTextCompanyName,error: editCompanyError,isFocused: editFocusedCompany),
                                                                                                                    hintText: '',
                                                                                                                    textController: editCreateCompanyCon,
                                                                                                                    childWidth: constraints.maxWidth,
                                                                                                                    shape:  RoundedRectangleBorder(
                                                                                                                      side: BorderSide(color:editCompanyError ? Colors.redAccent :mTextFieldBorder),
                                                                                                                      borderRadius: const BorderRadius.all(
                                                                                                                        Radius.circular(5),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    offset: const Offset(1, 40),
                                                                                                                    tooltip: '',
                                                                                                                    itemBuilder:  (BuildContext context) {
                                                                                                                      return companyNames;
                                                                                                                    },

                                                                                                                    onSelected: (String value)  {
                                                                                                                        setState(() {
                                                                                                                          editCreateCompanyCon.text = value;
                                                                                                                          editCompanyError = false;

                                                                                                                          // Find and store the selected company ID
                                                                                                                          for (var company in displayListCompanies) {
                                                                                                                            if (company['company_name'] == value) {
                                                                                                                              selectedCompanyID = company['company_id'];
                                                                                                                              break; // Exit the loop once you've found the company
                                                                                                                            }
                                                                                                                          }

                                                                                                                          // Fetch the dealer list based on the selected company ID
                                                                                                                          getDealerList(selectedCompanyID);
                                                                                                                        });
                                                                                                                      },
                                                                                                                    onCanceled: () {

                                                                                                                    },
                                                                                                                    child: Container(),
                                                                                                                  );
                                                                                                                }
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      height: 20,
                                                                                                    ),
                                                                                                    // Dealer Name
                                                                                                    Row(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        const SizedBox(
                                                                                                            width: 130,
                                                                                                            child: Text('Dealer Name',)
                                                                                                        ),
                                                                                                        Expanded(
                                                                                                          child: Focus(
                                                                                                            onFocusChange: (value) {
                                                                                                              setState(() {
                                                                                                                editFocusedDealer = value;
                                                                                                              });
                                                                                                            },
                                                                                                            skipTraversal: true,
                                                                                                            descendantsAreFocusable: true,
                                                                                                            child: LayoutBuilder(
                                                                                                                builder: (BuildContext context, BoxConstraints constraints) {
                                                                                                                  return CustomPopupMenuButton(childHeight: 200,
                                                                                                                    elevation: 4,
                                                                                                                    validator: (value) {
                                                                                                                      if(value==null||value.isEmpty){
                                                                                                                        setState(() {
                                                                                                                          editDealerError =true;
                                                                                                                        });
                                                                                                                        return null;
                                                                                                                      }
                                                                                                                      return null;
                                                                                                                    },
                                                                                                                    decoration: customPopupDecoration(hintText:hintTextDealerName,error: editDealerError,isFocused: editFocusedDealer),
                                                                                                                    hintText: '',
                                                                                                                    textController: editDealerName,
                                                                                                                    childWidth: constraints.maxWidth,
                                                                                                                    shape:  RoundedRectangleBorder(
                                                                                                                      side: BorderSide(color:editDealerError ? Colors.redAccent :mTextFieldBorder),
                                                                                                                      borderRadius: const BorderRadius.all(
                                                                                                                        Radius.circular(5),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    offset: const Offset(1, 40),
                                                                                                                    tooltip: '',
                                                                                                                    itemBuilder:  (BuildContext context) {
                                                                                                                      return displayListDealers.map((value) {
                                                                                                                        return CustomPopupMenuItem(
                                                                                                                          value: value['dealer_name'],
                                                                                                                            child: Text(value['dealer_name'])
                                                                                                                        );
                                                                                                                      }).toList();
                                                                                                                    },

                                                                                                                    onSelected: (value)  {
                                                                                                                      setState(() {
                                                                                                                        editDealerName.text = value.toString();
                                                                                                                        editCompanyError = false;
                                                                                                                      });
                                                                                                                    },
                                                                                                                    onCanceled: () {

                                                                                                                    },
                                                                                                                    child: Container(),
                                                                                                                  );
                                                                                                                }
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      height: 20,
                                                                                                    ),
                                                                                                    //  user Role.
                                                                                                    Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      children: [
                                                                                                        const SizedBox(
                                                                                                            width: 130,
                                                                                                            child: Text(
                                                                                                              "User Role",
                                                                                                            )),
                                                                                                        Expanded(
                                                                                                          child: Focus(
                                                                                                            onFocusChange: (value) {
                                                                                                              setState(() {
                                                                                                                editFocusedUser = value;
                                                                                                              });
                                                                                                            },
                                                                                                            skipTraversal: true,
                                                                                                            descendantsAreFocusable: true,
                                                                                                            child: LayoutBuilder(
                                                                                                                builder: (BuildContext context, BoxConstraints constraints) {
                                                                                                                  return CustomPopupMenuButton(elevation: 4,
                                                                                                                    validator: (value) {
                                                                                                                      if(value==null||value.isEmpty){
                                                                                                                        setState(() {
                                                                                                                          editUserError =true;
                                                                                                                        });
                                                                                                                        return null;
                                                                                                                      }
                                                                                                                      return null;
                                                                                                                    },
                                                                                                                    decoration: customPopupDecoration(hintText:hintTextRole,error: editUserError,isFocused: editFocusedUser),
                                                                                                                    hintText: '',
                                                                                                                    textController: editUserController,
                                                                                                                    childWidth: constraints.maxWidth,
                                                                                                                    shape:  RoundedRectangleBorder(
                                                                                                                      side: BorderSide(color:editUserError ? Colors.redAccent :mTextFieldBorder),
                                                                                                                      borderRadius: const BorderRadius.all(
                                                                                                                        Radius.circular(5),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    offset: const Offset(1, 40),
                                                                                                                    tooltip: '',
                                                                                                                    itemBuilder:  (BuildContext context) {
                                                                                                                      return editTypesOfRole;
                                                                                                                    },

                                                                                                                    onSelected: (String value)  {
                                                                                                                      setState(() {
                                                                                                                        editUserController.text=value;
                                                                                                                        editUserError=false;
                                                                                                                      });

                                                                                                                    },
                                                                                                                    onCanceled: () {

                                                                                                                    },
                                                                                                                    child: Container(),
                                                                                                                  );
                                                                                                                }
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),

                                                                                                    const SizedBox(
                                                                                                      height: 20,
                                                                                                    ),
                                                                                                    //User Email.
                                                                                                    Row(
                                                                                                      crossAxisAlignment:
                                                                                                      CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        const SizedBox(
                                                                                                            width: 130,
                                                                                                            child: Text('User Email')),
                                                                                                        const SizedBox(height: 10),
                                                                                                        Expanded(
                                                                                                          child: AnimatedContainer(
                                                                                                            duration:
                                                                                                            const Duration(seconds: 0),
                                                                                                            height:
                                                                                                            editUserEmailError ? 60 : 35,
                                                                                                            child: TextFormField(
                                                                                                              validator: (value) {
                                                                                                                if (value == null || value.isEmpty) {
                                                                                                                  setState(() {
                                                                                                                    editUserEmailError = true;
                                                                                                                  });
                                                                                                                  return "Enter User Email";
                                                                                                                }
                                                                                                                else if(!EmailValidator.validate(value)){
                                                                                                                  setState((){
                                                                                                                    editUserEmailError=true;
                                                                                                                  });
                                                                                                                  return 'Please enter a valid email address';
                                                                                                                }
                                                                                                                else {
                                                                                                                  setState(() {
                                                                                                                    editUserEmailError =
                                                                                                                    false;
                                                                                                                  });
                                                                                                                }
                                                                                                                return null;
                                                                                                              },
                                                                                                              onChanged: (text) {
                                                                                                                setState(() {});
                                                                                                              },
                                                                                                              controller: editEmail,
                                                                                                              decoration: decorationInput5(
                                                                                                                  'Enter User Email',
                                                                                                                  editEmail.text.isNotEmpty),
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    ),

                                                                                                    const SizedBox(
                                                                                                      height: 35,
                                                                                                    ),
                                                                                                    Align(
                                                                                                      alignment: Alignment.center,
                                                                                                      child:  SizedBox(
                                                                                                        width: 100,
                                                                                                        height:30,
                                                                                                        child: OutlinedMButton(
                                                                                                          text: 'Update',
                                                                                                          buttonColor:mSaveButton ,
                                                                                                          textColor: Colors.white,
                                                                                                          borderColor: mSaveButton,
                                                                                                          onTap:(){
                                                                                                            if (editDetails.currentState!.validate()) {
                                                                                                              Map editUserManagement = {
                                                                                                                "userid":displayUserList[i]['userid'],
                                                                                                                'username': editUserName.text,
                                                                                                                'password':displayUserList[i]['password'],
                                                                                                                'active':true,
                                                                                                                'role':  editUserController.text,
                                                                                                                'email': editEmail.text,
                                                                                                                'token':'',
                                                                                                                'token_creation_date':'',
                                                                                                                'company_name':  editCreateCompanyCon.text,
                                                                                                                'dealer_name':  editDealerName.text,
                                                                                                                "org_id": companyID,
                                                                                                                "dealer_id":displayListDealers[i]['dealer_id']
                                                                                                                //editCompanyName.text,
                                                                                                              };
                                                                                                              updateUserDetails(editUserManagement,);
                                                                                                            }
                                                                                                          },
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),

                                                                                                  ],),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(right: 0.0,

                                                                                    child: InkWell(
                                                                                      child: Container(
                                                                                          width: 30,
                                                                                          height: 30,
                                                                                          decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                              border: Border.all(
                                                                                                color:
                                                                                                const Color.fromRGBO(204, 204, 204, 1),
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
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  });
                                                                },

                                                              ),
                                                            ),
                                                            const SizedBox(width: 20,),
                                                            SizedBox(   height: 28,
                                                              width:100,
                                                              child: OutlinedBorderColorForDelete(
                                                                buttonText: 'Delete', iconData: Icons.delete,
                                                                onTap: (){
                                                                  setState(() {
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return Dialog(
                                                                          backgroundColor: Colors.transparent,
                                                                          child: StatefulBuilder(
                                                                            builder: (context, setState) {
                                                                              return SizedBox(
                                                                                height: 200,
                                                                                width: 300,
                                                                                child: Stack(children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                                                                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                                                    child: Column(
                                                                                      children: [

                                                                                        const SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        const Icon(
                                                                                          Icons.warning_rounded,
                                                                                          color: Colors.red,
                                                                                          size: 50,
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        const Center(
                                                                                            child: Text(
                                                                                              'Are You Sure, You Want To Delete ?',
                                                                                              style: TextStyle(
                                                                                                  color: Colors.indigo,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: 16),
                                                                                            )),
                                                                                        const SizedBox(
                                                                                          height: 35,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment:
                                                                                          MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 50,
                                                                                              height:30,
                                                                                              child: OutlinedMButton(
                                                                                                text: 'Ok',
                                                                                                buttonColor:Colors.red ,
                                                                                                textColor: Colors.white,
                                                                                                borderColor: Colors.red,
                                                                                                onTap:(){
                                                                                                  assignUserId = displayUserList[i]['userid'];
                                                                                                  // print('--------userid----');
                                                                                                  // print( assignUserId);
                                                                                                  deleteUserData(assignUserId);
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(

                                                                                              width: 100,
                                                                                              height:30,
                                                                                              child: OutlinedMButton(
                                                                                                text: 'Cancel',
                                                                                                buttonColor:mSaveButton ,
                                                                                                textColor: Colors.white,
                                                                                                borderColor: mSaveButton,
                                                                                                onTap:(){
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                              ),
                                                                                            ),

                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(right: 0.0,

                                                                                    child: InkWell(
                                                                                      child: Container(
                                                                                          width: 30,
                                                                                          height: 30,
                                                                                          decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                              border: Border.all(
                                                                                                color:
                                                                                                const Color.fromRGBO(204, 204, 204, 1),
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
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  });
                                                                },

                                                              ),
                                                            ),
                                                            const SizedBox(width: 20,),
                                                            SizedBox(  height: 28,
                                                              width:160,
                                                              child: OutlinedBorderWithIcon(
                                                                buttonText: 'Change Password', iconData: Icons.change_circle_sharp,
                                                                onTap: (){
                                                                  setState(() {
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        bool passwordFirstEnter = true;
                                                                        final emailBased = TextEditingController();
                                                                        final editPassword = TextEditingController();
                                                                        final conformPassword = TextEditingController();
                                                                        bool editEmailError = false;
                                                                        bool editPasswordError = false;
                                                                        bool conformPasswordInitial = true;
                                                                        String storeEmail = '';
                                                                        String storePassword = '';
                                                                        //regular expression to check if string.
                                                                        RegExp passValid = RegExp(
                                                                            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
                                                                        // a function that validate user enter password.
                                                                        bool validatePassword(String pass) {
                                                                          String password = pass.trim();
                                                                          if (passValid.hasMatch(password)) {
                                                                            return true;
                                                                          } else {
                                                                            return false;
                                                                          }
                                                                        }

                                                                        final changeKey = GlobalKey<FormState>();
                                                                        return Dialog(
                                                                          backgroundColor: Colors.transparent,
                                                                          child: StatefulBuilder(
                                                                            builder: (context, setState) {
                                                                              void textHideFunc() {
                                                                                setState(() {
                                                                                  passwordFirstEnter = !passwordFirstEnter;
                                                                                });
                                                                              }

                                                                              void textHideConformPassword() {
                                                                                setState(() {
                                                                                  conformPasswordInitial = !conformPasswordInitial;
                                                                                });
                                                                              }

                                                                              emailBased.text = displayUserList[i]['email'];
                                                                              storeEmail = displayUserList[i]['email'];
                                                                              storePassword = editPassword.text;

                                                                              return SizedBox(
                                                                                width: 500,
                                                                                child: Stack(children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                                                                    margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                                                    child: SingleChildScrollView(
                                                                                      child: Form(
                                                                                        key: changeKey,
                                                                                        child: Padding(
                                                                                          padding:  const EdgeInsets.all(30),
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                                                                                            child: Column(children: [
                                                                                              // Top container.
                                                                                              Container(color: Colors.grey[100],
                                                                                                child: IgnorePointer(ignoring: true,
                                                                                                  child: MaterialButton(
                                                                                                    hoverColor: Colors.transparent,
                                                                                                    onPressed: () {

                                                                                                    },
                                                                                                    child: const Row(
                                                                                                      children: [
                                                                                                        Expanded(
                                                                                                          child: Padding(
                                                                                                            padding: EdgeInsets.all(8.0),
                                                                                                            child: Text(
                                                                                                              'Change Password',
                                                                                                              style: TextStyle(fontWeight: FontWeight.bold,
                                                                                                                fontSize: 16,),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              const Divider(height: 1,color:mTextFieldBorder),
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.all(30),
                                                                                                child: Column(children: [
                                                                                                  //User Email
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      const SizedBox(
                                                                                                          width: 140, child: Text('User Email')),
                                                                                                      const SizedBox(height: 10),
                                                                                                      Expanded(
                                                                                                        child: AnimatedContainer(
                                                                                                          duration:
                                                                                                          const Duration(seconds: 0),
                                                                                                          height: editEmailError ? 60 : 35,
                                                                                                          child: TextFormField(
                                                                                                            readOnly: true,
                                                                                                            validator: (value) {
                                                                                                              if (value == null ||
                                                                                                                  value.isEmpty) {
                                                                                                                setState(() {
                                                                                                                  editEmailError = true;
                                                                                                                });
                                                                                                                return "Enter User Name";
                                                                                                              } else {
                                                                                                                setState(() {
                                                                                                                  editEmailError = false;
                                                                                                                });
                                                                                                              }
                                                                                                              return null;
                                                                                                            },
                                                                                                            controller: emailBased,
                                                                                                            decoration: decorationInput5(
                                                                                                                'User Email',
                                                                                                                emailBased.text.isNotEmpty),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                  //User Password.
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      const SizedBox(
                                                                                                          width: 140,
                                                                                                          child: Text('User Password')),
                                                                                                      const SizedBox(height: 10),
                                                                                                      Expanded(
                                                                                                        child: AnimatedContainer(
                                                                                                          duration: const Duration(seconds: 0),
                                                                                                          height: editPasswordError ? 60 : 35,
                                                                                                          child: TextFormField(onTap: () {
                                                                                                            setState((){
                                                                                                              conformPasswordInitial=true;
                                                                                                            });
                                                                                                          },
                                                                                                              validator: (value) {
                                                                                                                if (value == null ||
                                                                                                                    value.isEmpty) {
                                                                                                                  setState(() {
                                                                                                                    editPasswordError = true;
                                                                                                                  });
                                                                                                                  return 'Enter Password';
                                                                                                                } else {
                                                                                                                  // call function to check password
                                                                                                                  bool result =
                                                                                                                  validatePassword(value);
                                                                                                                  if (result) {
                                                                                                                    setState(() {
                                                                                                                      editPasswordError = false;
                                                                                                                    });
                                                                                                                    // create account event
                                                                                                                    return null;
                                                                                                                  } else {
                                                                                                                    setState(() {
                                                                                                                      editPasswordError = true;
                                                                                                                    });
                                                                                                                    return "Password should contain:One Capital Letter & one Small letter & one Number one Special Char& 8 Characters length.";
                                                                                                                  }
                                                                                                                }
                                                                                                              },
                                                                                                              controller: editPassword,
                                                                                                              obscureText: passwordFirstEnter,
                                                                                                              decoration: decorationInputPassword(
                                                                                                                  'Enter Password',
                                                                                                                  editPassword.text.isNotEmpty,
                                                                                                                  passwordFirstEnter,
                                                                                                                  textHideFunc)),
                                                                                                        ),
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                  //conform password.
                                                                                                  Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      const SizedBox(
                                                                                                          width: 140,
                                                                                                          child: Text('Conform Password')),
                                                                                                      const SizedBox(height: 10),
                                                                                                      Expanded(
                                                                                                        child: AnimatedContainer(
                                                                                                          duration:
                                                                                                          const Duration(seconds: 0),
                                                                                                          height: editPasswordError ? 60 : 35,
                                                                                                          child: TextFormField(onTap: () {
                                                                                                            setState((){
                                                                                                              passwordFirstEnter=true;
                                                                                                            });
                                                                                                          },
                                                                                                            validator: (value) {
                                                                                                              if (value == null ||
                                                                                                                  value.isEmpty &&
                                                                                                                      conformPassword.text ==
                                                                                                                          '') {
                                                                                                                setState(() {
                                                                                                                  editPasswordError = true;
                                                                                                                });
                                                                                                                return "Conform Password";
                                                                                                              } else if (conformPassword
                                                                                                                  .text !=
                                                                                                                  editPassword.text) {
                                                                                                                setState(() {
                                                                                                                  editPasswordError = true;
                                                                                                                });
                                                                                                                return 'Password does`t match';
                                                                                                              } else {
                                                                                                                setState(() {
                                                                                                                  editPasswordError = false;
                                                                                                                });
                                                                                                              }
                                                                                                              return null;
                                                                                                            },
                                                                                                            onChanged: (text) {
                                                                                                              setState(() {});
                                                                                                            },
                                                                                                            controller: conformPassword,
                                                                                                            decoration:
                                                                                                            decorationInputConformPassword(
                                                                                                                'Conform Password',
                                                                                                                conformPassword
                                                                                                                    .text.isNotEmpty,
                                                                                                                conformPasswordInitial,
                                                                                                                textHideConformPassword),
                                                                                                            obscureText: conformPasswordInitial,
                                                                                                          ),
                                                                                                        ),
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 35,
                                                                                                  ),
                                                                                                  Align(
                                                                                                    alignment: Alignment.center,
                                                                                                    child:  SizedBox(
                                                                                                      width: 100,
                                                                                                      height:30,
                                                                                                      child: OutlinedMButton(
                                                                                                        text: 'Save',
                                                                                                        buttonColor:mSaveButton ,
                                                                                                        textColor: Colors.white,
                                                                                                        borderColor: mSaveButton,
                                                                                                        onTap:(){

                                                                                                          //Password change.
                                                                                                          Future changePasswordFunc(String storeEmail, String storePassword) async {
                                                                                                            // print('------------------storepassword------------');
                                                                                                            // print(storePassword);
                                                                                                            // print('------check-------------');
                                                                                                            // print('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/change-password/$storeEmail/$storePassword');

                                                                                                            String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/change-password/$storeEmail/$storePassword';
                                                                                                            final response = await http.get(Uri.parse(url), headers: {
                                                                                                              "Content-Type": "application/json",
                                                                                                              'Authorization': 'Bearer $authToken'
                                                                                                            });
                                                                                                            if (response.statusCode == 200) {
                                                                                                              // print('-----------status-code------------');
                                                                                                              // print(response.statusCode);
                                                                                                              if(mounted) {
                                                                                                                Navigator.of(context).pop();
                                                                                                              }
                                                                                                            } else {
                                                                                                              log(response.statusCode.toString());
                                                                                                            }
                                                                                                          }

                                                                                                          setState(() {
                                                                                                            if (changeKey.currentState!.validate()) {
                                                                                                              changePasswordFunc(storeEmail, storePassword);
                                                                                                            }
                                                                                                          });
                                                                                                        },
                                                                                                      ),
                                                                                                    ),

                                                                                                  ),
                                                                                                ],),
                                                                                              )
                                                                                            ]),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(right: 0.0,

                                                                                    child: InkWell(
                                                                                      child: Container(
                                                                                          width: 30,
                                                                                          height: 30,
                                                                                          decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                              border: Border.all(
                                                                                                color:
                                                                                                const Color.fromRGBO(204, 204, 204, 1),
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
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  });
                                                                },

                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 8,),
                                                      ],
                                                    );

                                                  }
                                              ):const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 35,height: 25,
                                          child: MaterialButton(color: Colors.blue[50],
                                            onPressed: () {
                                              setState(() {
                                                if(expandedId==""){
                                                  setState(() {
                                                    expandedId=displayUserList[i]["userid"];
                                                    displayUserList[i]["isExpanded"]=true;
                                                  });

                                                }
                                                else if(expandedId==displayUserList[i]['userid']){
                                                  setState(() {
                                                    displayUserList[i]['isExpanded']=false;
                                                    expandedId="";
                                                  });
                                                }
                                                else if(expandedId.isNotEmpty || expandedId!=""){
                                                  setState(() {
                                                    for(var userId in displayUserList){
                                                      if(userId["userid"]==expandedId){
                                                        userId["isExpanded"]=false;
                                                        expandedId=displayUserList[i]["userid"];
                                                        displayUserList[i]["isExpanded"]=true;
                                                      }
                                                    }
                                                  });
                                                }
                                              });
                                            },
                                            child:   displayUserList[i]['isExpanded']?  const Padding(
                                              padding: EdgeInsets.only(right:10.0),
                                              child: Icon(Icons.arrow_drop_down_outlined,color: Colors.blue),
                                            ):const Padding(
                                              padding: EdgeInsets.only(right:10.0),
                                              child: Icon(Icons.arrow_right_outlined,color: Colors.grey),
                                            ),
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
                                  Text("${startVal+15>userList.length?userList.length:startVal+1}-${startVal+15>userList.length?userList.length:startVal+15} of ${userList.length}",style: const TextStyle(color: Colors.grey)),
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
                                          displayUserList=[];
                                          startVal = startVal-15;
                                          for(int i=startVal;i<startVal+15;i++){
                                            try{
                                              setState(() {
                                                userList[i]["isExpanded"]=false;
                                                displayUserList.add(userList[i]);
                                                expandedId="";
                                              });
                                            }
                                            catch(e){
                                              log(e.toString());
                                            }
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
                                        if(userList.length>startVal+15){
                                          displayUserList=[];
                                          startVal=startVal+15;
                                          for(int i=startVal;i<startVal+15;i++){
                                            try{
                                              setState(() {
                                                userList[i]["isExpanded"]=false;
                                                displayUserList.add(userList[i]);
                                                expandedId="";
                                              });
                                            }
                                            catch(e){
                                              log(e.toString());
                                            }

                                          }
                                        }

                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                ],
                              ),
                            ],);
                          }
                        })


                      ]),
                    ),
                  ),
                ),
            ),
              ),
            )

          ]),
    );
  }
  createNewUser(BuildContext context, List<dynamic> companyNamesList,) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          List <CustomPopupMenuEntry<String>> typesOfRoleCreate =<CustomPopupMenuEntry<String>>[

            const CustomPopupMenuItem(height: 40,
              value: 'Approver',
              child: Center(child: SizedBox(width: 350,child: Text('Approver',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

            ),
            const CustomPopupMenuItem(height: 40,
              value: 'User',
              child: Center(child: SizedBox(width: 350,child: Text('User',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

            ),

          ];
          // List<String> countryNames = [...companyNamesList];
          // // While Creating Company No Need To Change Company Names.
          // List<CustomPopupMenuEntry<String>> createCompanyNames = [];
          // //Assigning dynamic Country Names To CustomPopupMenuEntry Drop Down.
          // createCompanyNames = countryNames.map((value) {
          //   return CustomPopupMenuItem(
          //     height: 40,
          //     value: value,
          //     child: Center(
          //       child: SizedBox(
          //         width: 350,
          //         child: Text(
          //           value,
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //           style: const TextStyle(fontSize: 14),
          //         ),
          //       ),
          //     ),
          //   );
          // }).toList();
          bool firstPasswordInitial = true;
          bool conformPasswordInitial = true;
          final newUserName = TextEditingController();
          final newUserEmail = TextEditingController();
          final newPassword = TextEditingController();
          final newConformPassword = TextEditingController();
          bool newUserNameError = false;
          bool newUserEmailError = false;
          bool newPasswordError = false;
          bool newConformPasswordError = false;
          bool isFocusedUser=false;
          bool userError=false;
          final createUserController=TextEditingController();
          // bool isFocusedCompany=false;
          bool companyError=false;
          final createCompanyCon=TextEditingController();
          createCompanyCon.text=companyName;
          final newUser = GlobalKey<FormState>();
          //regular expression to check if string.
          RegExp passValid = RegExp(
              r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
          // a function that validate user enter password.
          bool validatePassword(String pass) {
            String password = pass.trim();
            if (passValid.hasMatch(password)) {
              return true;
            } else {
              return false;
            }
          }

          Map userData = {};
          String capitalizeFirstWord(String value) {
            if(value.isNotEmpty){
              var result = value[0].toUpperCase();
              for (int i = 1; i < value.length; i++) {
                if (value[i - 1] == "1") {
                  result = result + value[i].toUpperCase();
                }
                else {
                  result = result + value[i];
                }
              }
              return result;
            }
            return '';
          }

          return Dialog(
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setState) {
                textHideFunc() {
                  setState(() {
                    firstPasswordInitial = !firstPasswordInitial;
                  });
                }

                textHideConformPassword() {
                  setState(() {
                    conformPasswordInitial = !conformPasswordInitial;
                  });
                }

                return SizedBox(
                  child: Stack(children: [
                    Container(
                      width: 650,
                      decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                      margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key:newUser,
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  // Top container.
                                  Container(color: Colors.grey[100],
                                    child: IgnorePointer(ignoring: true,
                                      child: MaterialButton(
                                        hoverColor: Colors.transparent,
                                        onPressed: () {
                                        },
                                        child: const Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Create New User',
                                                  style: TextStyle(fontWeight: FontWeight.bold,
                                                    fontSize: 16,),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1,color:mTextFieldBorder),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Column(children: [
                                      //User Name.
                                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child: Text('User Name')),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: newUserNameError ? 60 : 35,
                                                  child: TextFormField(

                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          newUserNameError = true;
                                                        });
                                                        return "Enter User Name";
                                                      } else {
                                                        setState(() {
                                                          newUserNameError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      newUserName.value=TextEditingValue(
                                                        text: capitalizeFirstWord(value),
                                                        selection: newUserName.selection,
                                                      );
                                                    },
                                                    controller: newUserName,
                                                    decoration: decorationInput5(
                                                        'Enter User Name',
                                                        newUserName.text.isNotEmpty),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 35,),
                                          // User Role
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                    child: Text(
                                                      "User Role",
                                                    )),
                                                const SizedBox(height: 5,),
                                                Focus(
                                                  onFocusChange: (value) {
                                                    setState(() {
                                                      isFocusedUser = value;
                                                    });
                                                  },
                                                  skipTraversal: true,
                                                  descendantsAreFocusable: true,
                                                  child: LayoutBuilder(
                                                      builder: (BuildContext context, BoxConstraints constraints) {
                                                        return CustomPopupMenuButton(elevation: 4,
                                                          validator: (value) {
                                                            if(value==null||value.isEmpty){
                                                              setState(() {
                                                                userError =true;
                                                              });
                                                              return null;
                                                            }
                                                            return null;
                                                          },
                                                          decoration: customPopupDecoration(hintText:createUserRole,error: userError,isFocused: isFocusedUser),
                                                          hintText: '',
                                                          textController: createUserController,
                                                          childWidth: constraints.maxWidth,
                                                          shape:  RoundedRectangleBorder(
                                                            side: BorderSide(color:userError ? Colors.redAccent :mTextFieldBorder),
                                                            borderRadius: const BorderRadius.all(
                                                              Radius.circular(5),
                                                            ),
                                                          ),
                                                          offset: const Offset(1, 40),
                                                          tooltip: '',
                                                          itemBuilder:  (BuildContext context) {
                                                            return typesOfRoleCreate;
                                                          },

                                                          onSelected: (String value)  {
                                                            setState(() {
                                                              createUserController.text=value;
                                                              createUserRole = value;
                                                              userError=false;
                                                            });

                                                          },
                                                          onCanceled: () {

                                                          },
                                                          child: Container(),
                                                        );
                                                      }
                                                  ),
                                                ),
                                                const SizedBox(height: 5,),
                                                if(userError)
                                                  const Text("Select User Role",style: TextStyle(fontSize: 12,color: Color(0xffB52F27)),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      //Create Company.
                                      Row( crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                    child: Text('Company Name',)),
                                                const SizedBox(height: 5,),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: companyError ? 60 : 35,
                                                  child: TextFormField(readOnly: true,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          companyError = true;
                                                        });
                                                        return "Company Name";
                                                      } else {
                                                        setState(() {
                                                          companyError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: createCompanyCon,
                                                    decoration: decorationInput5(
                                                        'Company Name',
                                                        createCompanyCon.text.isNotEmpty),
                                                  ),
                                                ),
                                                // Focus(
                                                //   onFocusChange: (value) {
                                                //     setState(() {
                                                //       isFocusedCompany = value;
                                                //     });
                                                //   },
                                                //   skipTraversal: true,
                                                //   descendantsAreFocusable: true,
                                                //   child: LayoutBuilder(
                                                //       builder: (BuildContext context, BoxConstraints constraints) {
                                                //         return CustomPopupMenuButton(childHeight: 200,
                                                //           elevation: 4,
                                                //           validator: (value) {
                                                //             if(value==null||value.isEmpty){
                                                //               setState(() {
                                                //                 companyError =true;
                                                //               });
                                                //               return null;
                                                //             }
                                                //             return null;
                                                //           },
                                                //           decoration: customPopupDecoration(hintText:createCompanyName,error: companyError,isFocused: isFocusedCompany),
                                                //           hintText: '',
                                                //           textController: createCompanyCon,
                                                //           childWidth: constraints.maxWidth,
                                                //           shape:  RoundedRectangleBorder(
                                                //             side: BorderSide(color:userError ? Colors.redAccent :mTextFieldBorder),
                                                //             borderRadius: const BorderRadius.all(
                                                //               Radius.circular(5),
                                                //             ),
                                                //           ),
                                                //           offset: const Offset(1, 40),
                                                //           tooltip: '',
                                                //           itemBuilder:  (BuildContext context) {
                                                //             return createCompanyNames;
                                                //           },
                                                //
                                                //           onSelected: (String value)  {
                                                //             setState(() {
                                                //               createCompanyCon.text=value;
                                                //               createCompanyName = value;
                                                //               companyError=false;
                                                //             });
                                                //
                                                //           },
                                                //           onCanceled: () {
                                                //
                                                //           },
                                                //           child: Container(),
                                                //         );
                                                //       }
                                                //   ),
                                                // ),
                                                const SizedBox(height: 5,),
                                                if(companyError)
                                                  const Text("Select Company Name",style: TextStyle(color: Color(0xffB52F27),fontSize: 12),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 35,),
                                          //User Email
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child: Text('User Email')),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: newUserEmailError ? 60 : 35,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          newUserEmailError = true;
                                                        });
                                                        return "Enter User Email";
                                                      }
                                                      else if(!EmailValidator.validate(value)){
                                                        setState((){
                                                          newUserEmailError=true;
                                                        });
                                                        return 'Please enter a valid email address';
                                                      }
                                                      else {
                                                        setState(() {
                                                          newUserEmailError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller: newUserEmail,
                                                    decoration: decorationInput5(
                                                        'Enter User Email',
                                                        newUserEmail.text.isNotEmpty),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      //User Password.
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child: Text('User Password')),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: newPasswordError ? 60 : 35,
                                                  child: TextFormField(onTap: () {
                                                    setState((){
                                                      conformPasswordInitial=true;
                                                    });
                                                  },
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          setState(() {
                                                            newPasswordError = true;
                                                          });
                                                          return 'Enter Password';
                                                        } else {
                                                          // call function to check password
                                                          bool result = validatePassword(value);
                                                          if (result) {
                                                            setState(() {
                                                              newPasswordError = false;
                                                            });
                                                            // create account event
                                                            return null;
                                                          } else {
                                                            setState(() {
                                                              newPasswordError = true;
                                                            });
                                                            return "Password should contain:One Capital Letter & one Small letter & one Number one Special Char& 8 Characters length.";
                                                          }
                                                        }
                                                      },
                                                      controller: newPassword,
                                                      obscureText: firstPasswordInitial,
                                                      decoration: decorationInputPassword(
                                                          'Enter Password',
                                                          newPassword.text.isNotEmpty,
                                                          firstPasswordInitial,
                                                          textHideFunc)),
                                                )
                                              ],),
                                          ),
                                          const SizedBox(width: 30,),
                                          //Conform Password.
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child: Text('Conform Password')),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: newConformPasswordError ? 60 : 35,
                                                  child: TextFormField(onTap: () {
                                                    setState((){
                                                      firstPasswordInitial=true;
                                                    });
                                                  },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty &&
                                                              newConformPassword.text == '') {
                                                        setState(() {
                                                          newConformPasswordError = true;
                                                        });
                                                        return "Conform Password";
                                                      } else if (newConformPassword.text !=
                                                          newPassword.text) {
                                                        setState(() {
                                                          newConformPasswordError = true;
                                                        });
                                                        return 'Password does`t match';
                                                      } else {
                                                        setState(() {
                                                          newConformPasswordError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },

                                                    onChanged: (text) {
                                                      setState(() {});
                                                    },
                                                    controller: newConformPassword,
                                                    decoration:
                                                    decorationInputConformPassword(
                                                        'Conform Password',
                                                        newPassword.text.isNotEmpty,
                                                        conformPasswordInitial,
                                                        textHideConformPassword),
                                                    obscureText: conformPasswordInitial,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child:  SizedBox(
                                          width: 100,
                                          height:30,
                                          child: OutlinedMButton(
                                            text: 'Save',
                                            buttonColor:mSaveButton ,
                                            textColor: Colors.white,
                                            borderColor: mSaveButton,
                                            onTap:(){
                                              if (newUser.currentState!.validate()) {
                                                userData = {
                                                  "active": true,
                                                  "company_name": createCompanyCon.text,
                                                  "email": newUserEmail.text,
                                                  "password": newPassword.text,
                                                  "role": createUserRole,
                                                  "username":newUserName.text,
                                                  "dealer_id": dealerID,
                                                  "org_id": companyID,
                                                  "manager_id":managerId
                                                };
                                                // print('---check----');
                                                // print(userData);
                                                userDetails(userData);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(right: 0.0,

                      child: InkWell(
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color:
                                  const Color.fromRGBO(204, 204, 204, 1),
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
              },
            ),
          );
        });
  }
  decorationInputPassword(String hintString, bool val, bool newObscureText, textHideFunc,) {return InputDecoration(
    suffixIcon: IconButton(
      icon: Icon(color: mTextFieldBorder,
        newObscureText ? Icons.visibility : Icons.visibility_off,size: 20,
      ),
      onPressed: textHideFunc,
    ),
    filled: true,
    fillColor: Colors.white,
    counterText: "",
    hintStyle: const TextStyle(fontSize: 14),
    contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
    hintText: hintString,
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 0.5)),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: val ? Colors.blue : Colors.blue)),
    enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
  );}
  decorationInputConformPassword(String hintString, bool val, bool conformObscureText, textHideConformPassword,) {
    return InputDecoration(hintText: hintString,
      suffixIcon: IconButton(
        icon: Icon(color: mTextFieldBorder,
          conformObscureText ? Icons.visibility : Icons.visibility_off,size: 20,
        ),
        onPressed: textHideConformPassword,
      ),
      filled: true,
      fillColor: Colors.white,
      counterText: "",
      hintStyle: const TextStyle(fontSize: 14),
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 0.5)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: val ? Colors.blue : Colors.blue)),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
    );
  }
  customPopupDecoration({required String hintText, bool? error, bool ? isFocused,}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,

      hintStyle:  const TextStyle(fontSize: 14,color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isFocused == true ? Colors.blue : error == true ? mErrorColor : mTextFieldBorder)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: error == true ? mErrorColor : mTextFieldBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: error == true ? mErrorColor : Colors.blue)),
    );
  }
  decorationInput5(String hintString, bool val,) {
    return InputDecoration(
      counterText: "",
      contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      hintStyle: const TextStyle(fontSize: 14),
      focusedBorder:   const OutlineInputBorder(
          borderSide:  BorderSide(color:Colors.blue,)),
      border:   const OutlineInputBorder(
          borderSide:  BorderSide(color: Colors.blue)),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
    );
  }
  Future _show() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}

