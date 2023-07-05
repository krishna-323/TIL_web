import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import '../classes/arguments_classes/arguments_classes.dart';
import '../utils/api/get_api.dart';
import '../utils/api/post_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_loader.dart';
import '../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/alertDialogWidget.dart';
import '../widgets/input_decoration_text_field.dart';

class UserManagement extends StatefulWidget {
  final UserManagementArguments args;

  const UserManagement({Key? key, required this.args,}) : super(key: key);

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {

  String customerType ="Select User Role";
  String companyName ="Select Company Name";

  final userEmail = TextEditingController();

  @override
  initState() {
    getInitialData();
    getUserData();
    searchCompanyApi();
    loading=true;
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  List nameList = [];
  List companyNamesList=[];
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


  List userdata = [];
  List displayUserData=[];
  int startVal=0;
  String? authToken;
  String? assignUserId;
  String userID='';
  String managerId ="";
  String orgId ="";

//Passing token.
  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
    userID = prefs.getString("userId") ??'';
    managerId = prefs.getString("managerId") ??'';
    orgId = prefs.getString("orgId") ??'';
  }

  // post api.
  Future userDetails(userData) async {
    String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/add-usermaster';
    postData(context:context ,url:url ,requestBody: userData).then((value) {
      setState(() {
        if(value!=null){
          // print('-----------------------');
          // print(value);
          String errorMessage='';
          if(value.containsKey("error")){
            if(value['error']=="email already exist"){
              setState(() {
                errorMessage="Email Already Exist";
                log(errorMessage);
              });

            }
            else if(value['error']=="user already exist"){

              setState(() {
                errorMessage="User Already Exist";
                log(errorMessage.toString());
              });

            }

            Navigator.of(context).pop();
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

            });
          }

          else{
            Navigator.of(context).pop();
            //get all user api()


            alertDialogWidget(context: context,fromTop: true, color: Colors.blue,message: 'User Created...');
          }



        }

      });
    });

  }

  bool loading=false;
// get api.
  Future getUserData() async {
    dynamic response;
    String url =
        "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/get_all_users";
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            userdata = response;
            if(displayUserData.isEmpty){
              if(userdata.length>15){
                for(int i=0;i<startVal+15;i++){
                  displayUserData.add(userdata[i]);
                }
              }
              else{
                for(int i=0;i<userdata.length;i++){
                  displayUserData.add(userdata[i]);
                }
              }
            }
          }
          loading=false;
        });
      });
    } catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        loading=false;
      });
    }
  }

//delete api.
  Future deleteUserData() async {
    // print('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/delete-user/$assignUserId');
    // print('-------------barer token-------------');
    // print(authToken);
    String url =
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/delete-user/$assignUserId';
    final response = await http.delete(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $authToken'
    },

    );
    if (response.statusCode == 200) {

      getUserData();
      if(mounted) {
        Navigator.of(context).pop();
      }

    } else {
      log(response.statusCode.toString());
    }
  }
  Map updateUserDetailsStore={};
  String errorMessage='';

  // Update Api().
  Future updateUserDetails(updateRequestBody) async {
    // print('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/patch/$userId');
    String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/update_user_master';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
      body: json.encode(updateRequestBody),
    );
    if (response.statusCode == 200) {
      updateUserDetailsStore=json.decode(response.body);
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
                                      if(mounted){
                                        Navigator.of(context).pop();
                                      }
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

      else if(updateUserDetailsStore.containsKey('status')){
        if(updateUserDetailsStore['status']=="success"){
          if(mounted) {
            Navigator.of(context).pop();
          }
          displayUserData =[];
        }


        getUserData();
        // print('------------------------satuscode-----------');
        // print(response.statusCode);

      }


    } else {
      log(response.statusCode.toString());
    }
  }

  _getPopupMenu(BuildContext context, Type icon,) {
    return [
      PopupMenuItem(value: 1,
          child:  Row(
            children: [

              Icon(Icons.edit,size: 18,color: Colors.grey[800],),
              const SizedBox(width: 10,),
              Text(
                'Edit',
                style: TextStyle(color: Colors.grey[800],fontSize: 15,fontWeight: FontWeight.bold),
              ),

            ],
          )),
      PopupMenuItem(value: 2,
          child:  Center(
            child: Row(
              children: [
                Icon(Icons.delete_sharp,size: 18,color: Colors.grey[800],),
                const SizedBox(width: 10,),
                Text(
                  'Delete',
                  style: TextStyle(color: Colors.grey[800],fontSize: 15,fontWeight: FontWeight.bold),
                ),


              ],
            ),
          )),
      PopupMenuItem(value: 3,
          child:  Center(
            child: Row(
              children: [
                Icon(Icons.change_circle_sharp,color: Colors.grey[800],size: 18,),
                const SizedBox(width: 10,),
                Text(
                  'Change Password',
                  style: TextStyle(color: Colors.grey[800],fontSize: 15,fontWeight: FontWeight.bold),
                ),


              ],
            ),
          )),
    ];
  }

  //popup menu button.
  Theme _popMenu(userData) {
    // print('-----check-------');
    // print(userData);
    return Theme(
        data: Theme.of(context).copyWith(),
        child: PopupMenuButton(
          offset: const Offset(0, 30),
          tooltip: '',
          child:const CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              child:  Icon(
                Icons.more_vert,
                color: Colors.black,
                // CupertinoIcons.chevron_right_circle_fill,
                size: 18,
                //color: Colors.blue,
              ),
            ),
          ),
          itemBuilder: (BuildContext context,) {
            return _getPopupMenu(context,Icon);
          },
          onSelected:(value) {
            //First.
            if(value == 1){
              setState(() {

                showDialog(
                  context: context,
                  builder: (context) {
                    //Declaration Is Here.
                    final editUserName = TextEditingController();
                    bool editUserNameError = false;
                    bool editUserEmailError = false;
                    final editEmail = TextEditingController();
                    editUserName.text = userData['username'];
                    editEmail.text = userData['email'];
                    // Initial Value.
                    String  roleInitial = userData['role'];
                    // Dropdown Values.
                    List <CustomPopupMenuEntry<String>> editRoleTypes =<CustomPopupMenuEntry<String>>[

                      const CustomPopupMenuItem(height: 40,
                        value: 'Admin',
                        child: Center(child: SizedBox(width: 350,child: Text('Admin',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

                      ),
                      const CustomPopupMenuItem(height: 40,
                        value: 'User',
                        child: Center(child: SizedBox(width: 350,child: Text('User',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

                      ),

                    ];
                    var selectedCompanyName =  userData['company_name'];
                    final List<String> editCountryNames = [...companyNamesList];
                    // Creating CustomPopupMenuEntry Empty List.
                    List<CustomPopupMenuEntry<String>> editCompanyNames = [];
                    //Assigning dynamic Country Names To CustomPopupMenuEntry Drop Down.
                    editCompanyNames = editCountryNames.map((value) {
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
                    final editDetails = GlobalKey<FormState>();
                    String capitalizeFirst(String value) {
                      if(value.isNotEmpty){
                        var result = value[0].toUpperCase();
                        for (int i = 1; i < value.length; i++) {
                          if (value[i - 1] == "1") {
                            result = result + value[i].toUpperCase();
                          } else {
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
                          // Assigning variables.
                          return SizedBox(
                            width: 500,
                            child: Stack(children: [
                              Container(
                                decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                child: SingleChildScrollView(
                                  child: Form(
                                    key: editDetails,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 35.0,right: 35),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20,),
                                          const Align(alignment: Alignment.center,
                                            child: Text(
                                              'Edit User Details',
                                              style: TextStyle(
                                                  color: Colors.indigo, fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
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
                                                  editUserNameError ? 55 : 30,
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
                                                        text:capitalizeFirst(value),
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
                                            height: 10,
                                          ),
                                          //Company Name
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                  width: 130,
                                                  child: Text('Company Name',)),
                                              // Container(
                                              //   height: 30,
                                              //   width: 292,
                                              //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                                              //       border: Border.all(width: 0.5,
                                              //           style: BorderStyle.solid,
                                              //           color: Colors.black)),
                                              //   child: DropdownButtonHideUnderline(
                                              //     child: Padding(
                                              //       padding: const EdgeInsets.only(left:10),
                                              //       child: DropdownButton<String>(
                                              //         hint: const Text("Select CompanyName"),
                                              //         value: selectedCompanyName,
                                              //         onChanged: (String ? company){
                                              //           setState((){
                                              //             selectedCompanyName=company!;
                                              //           });
                                              //         },
                                              //         items: countryNames.map((String names){
                                              //           return DropdownMenuItem<String>(
                                              //               value:names,
                                              //               child: Text(names)
                                              //           );
                                              //         }).toList(),
                                              //
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: Container(
                                                  height: 30,
                                                  width: 282,
                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black54,),
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(4),
                                                    ),),
                                                  child: CustomPopupMenuButton<String>(
                                                    childHeight: 200,
                                                    childWidth: 282,position: CustomPopupMenuPosition.under,
                                                    decoration: customPopupEditCompanyName(hintText: selectedCompanyName),
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
                                                      return editCompanyNames ;
                                                    },
                                                    onSelected: (String value)  {
                                                      setState(() {
                                                        selectedCompanyName = value;

                                                      });
                                                    },
                                                    onCanceled: () {

                                                    },
                                                    child: Container(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //user Role.
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                  width: 130,
                                                  child: Text(
                                                    "User Role",
                                                  )),
                                              Expanded(
                                                child: Container(
                                                  height: 30,
                                                  width: 282,
                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black54,),
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(4),
                                                    ),),
                                                  child: CustomPopupMenuButton<String>( childWidth: 282,position: CustomPopupMenuPosition.under,
                                                    decoration: customPopupEditUserRole(hintText: roleInitial),
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
                                                      return editRoleTypes;
                                                    },
                                                    onSelected: (String value)  {
                                                      setState(() {
                                                        roleInitial = value;
                                                      });
                                                    },
                                                    onCanceled: () {

                                                    },
                                                    child: Container(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
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
                                                  editUserEmailError ? 55 : 30,
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
                                                        return 'Please enter valued email address';
                                                      }
                                                      else {
                                                        setState(() {
                                                          editUserEmailError = false;
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
                                            child: MaterialButton(
                                              color: Colors.blue,
                                              onPressed: () {
                                                if (editDetails.currentState!.validate()) {
                                                  Map editUserManagement = {
                                                    'userid':userData['userid'],
                                                    'username': editUserName.text,
                                                    'password':userData['password'],
                                                    'active':true,
                                                    'role': roleInitial,
                                                    'email': editEmail.text,
                                                    'token':'',
                                                    'token_creation_date':'',
                                                    'company_name': selectedCompanyName,
                                                    "manager_id" : managerId ,
                                                    "org_id": orgId
                                                    //editCompanyName.text,
                                                  };
                                                  updateUserDetails(editUserManagement);
                                                }

                                              },
                                              child: const Text(
                                                'Update',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                        ],
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
            }
            //Second.
            if(value ==2){

              if(userID==userData['userid']){
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
                                      const Center(
                                          child: Text(
                                            'You Can Not Delete LoggedIn User',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            color: Colors.blue,
                                            onPressed: () {
                                              setState(() {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )
                                        ],
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
              }
              else{
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
                                      const Center(
                                          child: Text(
                                            'Are You Sure, You Want To Delete ?',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          MaterialButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              // print(userId);
                                              assignUserId = userData['userid'];
                                              deleteUserData();
                                            },
                                            child: const Text(
                                              'Ok',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          MaterialButton(
                                            color: Colors.blue,
                                            onPressed: () {
                                              setState(() {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )
                                        ],
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
              }

            }
            //Third.
            if(value==3){
              showDialog(
                context: context,
                builder: (context) {
                  bool passwordInitial = true;
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
                            passwordInitial = !passwordInitial;
                          });
                        }

                        void textHideConformPassword() {
                          setState(() {
                            conformPasswordInitial = !conformPasswordInitial;
                          });
                        }

                        emailBased.text = userData['email'];
                        storeEmail = userData['email'];
                        storePassword = editPassword.text;
                        return SizedBox(
                          width: 500,
                          child: Stack(children: [
                            Container(
                              decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                              margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: changeKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 35.0,right: 35),
                                    child: Column(children: [

                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Align(alignment: Alignment.center,
                                        child: Text('Change Password',style: TextStyle(fontSize: 16,
                                            fontWeight: FontWeight.bold,color: Colors.indigo),),
                                      ),
                                      const SizedBox(height: 30,),
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
                                              height: editEmailError ? 55 : 30,
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
                                        height: 15,
                                      ),
                                      //User Password.
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     const SizedBox(
                                      //         width: 140,
                                      //         child: Text('User Password')),
                                      //     const SizedBox(height: 10),
                                      //     Expanded(
                                      //       child: AnimatedContainer(
                                      //         duration: const Duration(seconds: 0),
                                      //         height: editPasswordError ? 55 : 30,
                                      //         child: TextFormField(
                                      //             validator: (value) {
                                      //               if (value == null || value.isEmpty) {
                                      //                 setState(() {
                                      //                   editPasswordError = true;
                                      //                 });
                                      //                 return 'Enter Password';
                                      //               } else {
                                      //                 // call function to check password
                                      //                 bool result = validatePassword(value);
                                      //                 if (result) {
                                      //                   setState(() {
                                      //                     editPasswordError = false;
                                      //                   });
                                      //                   // create account event
                                      //                   return null;
                                      //                 } else {
                                      //                   setState(() {
                                      //                     editPasswordError = true;
                                      //                   });
                                      //                   return "Password should contain:One Capital Letter & one Small letter & one Number one Special Char& 8 Characters length.";
                                      //                 }
                                      //               }
                                      //             },
                                      //             controller: editPassword,
                                      //             obscureText: newObscureText,
                                      //             decoration: decorationInputPassword(
                                      //                 'Enter Password',
                                      //                 editPassword.text.isNotEmpty,
                                      //                 newObscureText,
                                      //                 textHideFunc)),
                                      //       ),
                                      //     )
                                      //   ],
                                      // ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                              width: 140, child: Text('User Password')),
                                          const SizedBox(height: 10),
                                          Expanded(

                                            child: AnimatedContainer(
                                              duration: const Duration(seconds: 0),
                                              height: editPasswordError ? 55 : 30,
                                              child: TextFormField(onTap: () {
                                                setState((){
                                                  conformPasswordInitial=true;
                                                });
                                              },
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      setState(() {
                                                        editPasswordError = true;
                                                      });
                                                      return 'Enter Password';
                                                    } else {
                                                      // call function to check password
                                                      bool result = validatePassword(value);
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
                                                  obscureText: passwordInitial,
                                                  decoration: decorationInputPassword('Enter Password', editPassword.text.isNotEmpty, passwordInitial, textHideFunc)),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
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
                                              height: editPasswordError ? 55 : 30,
                                              child: TextFormField(onTap: (){
                                                setState((){
                                                  passwordInitial=true;
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
                                                    'Enter Password',
                                                    conformPassword
                                                        .text.isNotEmpty,
                                                    conformPasswordInitial,
                                                    textHideConformPassword),
                                                // decorationInput5(
                                                //     'Conform Password',
                                                //     conformPassword
                                                //         .text.isNotEmpty),
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
                                        child: MaterialButton(
                                          color: Colors.blue,
                                          onPressed: () {
                                            //Password change.
                                            Future changePasswordFunc(
                                                String storeEmail,
                                                String storePassword) async {
                                              String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/change-password/$storeEmail/$storePassword';
                                              final response = await http.get(Uri.parse(url),
                                                  headers: {
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
                                              if (changeKey.currentState!
                                                  .validate()) {
                                                changePasswordFunc(storeEmail, storePassword);
                                              }
                                            });
                                          },
                                          child: const Text(
                                            'Save',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 35,),
                                    ]),
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
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: CustomLoader(
              inAsyncCall: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 50.0, right: 50, top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0),)

                      ),
                      child: Column(
                        children: [
                          Container(
                            //height: 198,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 18,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "User Management",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      //Post new User dialog box.
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: MaterialButton(
                                          color: Colors.blue,
                                          onPressed: () {
                                            customerType='Select User Role';
                                            companyName="Select Company Name";
                                            createNewUser(context,companyNamesList);
                                          },
                                          child: const Text(
                                            "+ Create user",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
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
                                        child:Row(
                                          children: [
                                            const Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("USER NAME")
                                                  ),
                                                )),
                                            const Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("COMPANY NAME")
                                                  ),
                                                )),
                                            const Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("USER EMAIL")
                                                  ),
                                                )),
                                            const Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: Text("USER ROLE"),
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
                                const SizedBox(height: 4,)
                              ],
                            ),
                          ),
                          for (int i = 0; i <= displayUserData.length; i++)
                            Column(
                              children: [
                                if(i!=displayUserData.length)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0,bottom: 3,top:4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayUserData[i]['username']??"")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4),
                                              child: SizedBox(
                                                  height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayUserData[i]['company_name']?? '')
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayUserData[i]['email']??"")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayUserData[i]['role']??"")
                                              ),
                                            )),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Center(
                                            child: SizedBox(
                                                height: 28,
                                                child: Center(
                                                    child: _popMenu(displayUserData[i],))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if(i!=displayUserData.length)
                                  Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                if(i==displayUserData.length)
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${startVal+15>userdata.length?userdata.length:startVal+1}-${startVal+15>userdata.length?userdata.length:startVal+15} of ${userdata.length}",style: const TextStyle(color: Colors.grey)),
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
                                              displayUserData=[];
                                              startVal = startVal-15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                try{
                                                  setState(() {
                                                    displayUserData.add(userdata[i]);
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
                                            if(userdata.length>startVal+15){
                                              displayUserData=[];
                                              startVal=startVal+15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                try{
                                                  setState(() {
                                                    displayUserData.add(userdata[i]);
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

                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Create New User.
  createNewUser(BuildContext context, List<dynamic> companyNamesList,) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          bool passwordInitialValue = true;
          bool conformPasswordInitialValue = true;
          final newUserName = TextEditingController();
          final newUserEmail = TextEditingController();
          final newPassword = TextEditingController();
          final newConformPassword = TextEditingController();
          bool newUserNameError = false;
          bool newUserEmailError = false;
          bool newPasswordError = false;
          bool newConformPasswordError = false;

          final newUser = GlobalKey<FormState>();
          // final companyName = TextEditingController();

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
          // Types of Role Customer.
          List <CustomPopupMenuEntry<String>> customerTypes =<CustomPopupMenuEntry<String>>[

            const CustomPopupMenuItem(height: 40,
              value: 'Admin',
              child: Center(child: SizedBox(width: 350,child: Text('Admin',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

            ),
            const CustomPopupMenuItem(height: 40,
              value: 'User',
              child: Center(child: SizedBox(width: 350,child: Text('User',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14)))),

            ),

          ];
          // Storing Country Names.
          final List<String> countryNames = [...companyNamesList];
          // Creating CustomPopupMenuEntry Empty List.
          List<CustomPopupMenuEntry<String>> companyNames = [];
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
          Map userData = {};
          String capitalizeFirstWord(String value) {
            if(value.isNotEmpty){
              var result = value[0].toUpperCase();
              for (int i = 1; i < value.length; i++) {
                if (value[i - 1] == "1") {
                  result = result + value[i].toUpperCase();
                } else {
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
                    passwordInitialValue = !passwordInitialValue;
                  });
                }
                textHideConformPassword() {
                  setState(() {
                    conformPasswordInitialValue = !conformPasswordInitialValue;
                  });
                }

                return SizedBox(
                  width: 500,
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                      margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: newUser,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 35.0,right: 35),
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                // Top container.
                                const Align(alignment: Alignment.center,
                                  child: Text(
                                    'Create New User',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                //User Name.
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 140, child: Text('User Name')),
                                    const SizedBox(height: 10),
                                    Expanded(

                                      child: AnimatedContainer(
                                        duration: const Duration(seconds: 0),
                                        height: newUserNameError ? 55 : 30,
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
                                              text:capitalizeFirstWord(value),
                                              selection: newUserName.selection,
                                            );
                                          },
                                          controller: newUserName,
                                          decoration: decorationInput5(
                                              'Enter User Name',
                                              newUserName.text.isNotEmpty),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                               // User Role
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 140,
                                        child: Text(
                                          "User Role",
                                        )),
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                           width: 282,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.black54,),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(4),
                                          ),),
                                        child: CustomPopupMenuButton<String>( childWidth: 282,position: CustomPopupMenuPosition.under,
                                          decoration: customPopupCreateUserRole(hintText: customerType),
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
                                          child: Container(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                //Company Name.
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 140,
                                        child: Text('Company Name',)),
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        width: 282,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.black54,),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(4),
                                          ),),
                                        child: CustomPopupMenuButton<String>(
                                          childHeight: 200,
                                          childWidth: 282,position: CustomPopupMenuPosition.under,
                                          decoration: customPopupCreateCompanyName(hintText: companyName),
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
                                            return companyNames;
                                          },
                                          onSelected: (String value)  {
                                            setState(() {
                                              companyName= value;

                                            });
                                          },
                                          onCanceled: () {

                                          },
                                          child: Container(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 140, child: Text('User Email')),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: AnimatedContainer(
                                        duration: const Duration(seconds: 0),
                                        height: newUserEmailError ? 55 : 30,
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
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                //User Password.
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 140, child: Text('User Password')),
                                    const SizedBox(height: 10),
                                    Expanded(

                                      child: AnimatedContainer(
                                        duration: const Duration(seconds: 0),
                                        height: newPasswordError ? 55 : 30,
                                        child: TextFormField(onTap: () {
                                          setState((){
                                            conformPasswordInitialValue=true;
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
                                            obscureText: passwordInitialValue,
                                            decoration: decorationInputPassword(
                                                'Enter Password',
                                                newPassword.text.isNotEmpty,
                                                passwordInitialValue,
                                                textHideFunc)),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                //Conform Password.
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 140, child: Text('Confirm Password')),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: AnimatedContainer(
                                        duration: const Duration(seconds: 0),
                                        height: newConformPasswordError ? 55 : 30,
                                        child: TextFormField(onTap: (){
                                          setState((){
                                            passwordInitialValue=true;
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
                                          // decoration: decorationInput5(
                                          //     'Conform Password',
                                          //     newConformPassword.text.isNotEmpty),
                                          decoration:
                                          decorationInputConformPassword(
                                              'Confirm Password',
                                              newPassword.text.isNotEmpty,
                                              conformPasswordInitialValue,
                                              textHideConformPassword),
                                          obscureText: conformPasswordInitialValue,
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
                                  child: MaterialButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      setState(() {
                                        loading= true;
                                        if (newUser.currentState!.validate()) {
                                          userData = {
                                            "active": true,
                                            "company_name": companyName,
                                            "email": newUserEmail.text,
                                            "password": newPassword.text,
                                            "role": customerType,
                                            "username": newUserName.text,
                                            "manager_id" : managerId ,
                                            "org_id": orgId
                                          };
                                          // print('---check----');
                                          // print(userData);
                                          userDetails(userData).whenComplete(() {
                                            getUserData();
                                          });

                                        }
                                      });
                                    },
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 35,),
                              ],
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

  decorationInputPassword(String hintString, bool val, bool newObscureText, textHideFunc,) {
    return InputDecoration(
      suffixIcon: IconButton(
        icon: Icon(
          newObscureText ? Icons.visibility : Icons.visibility_off,size: 20,
        ),
        onPressed: textHideFunc,
      ),
      filled: true,
      fillColor: Colors.white,
      counterText: "",
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 0.5)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: val ? Colors.blue : Colors.blue)),
    );
  }
  // Create New User Decoration Function.
  customPopupCreateUserRole ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down,color: Colors.grey,),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: hintText=="Select User Role"? const TextStyle(color: Colors.black54):const TextStyle(color: Colors.black,),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  customPopupCreateCompanyName ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down,color: Colors.grey,),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: hintText=="Select Company Name"? const TextStyle(color: Colors.black54):const TextStyle(color: Colors.black,),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  // Edit User Decoration Function.
  customPopupEditUserRole ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down,color: Colors.grey,),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: hintText=="Select User Role"? const TextStyle(color: Colors.black54):const TextStyle(color: Colors.black,),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  customPopupEditCompanyName ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down,color: Colors.grey,),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: hintText=="Select Company Name"? const TextStyle(color: Colors.black54):const TextStyle(color: Colors.black,),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  decorationInputConformPassword(String hintString, bool val, bool conformObscureText, textHideConformPassword,) {
    return InputDecoration(hintText: hintString,
      suffixIcon: IconButton(
        icon: Icon(
          conformObscureText ? Icons.visibility : Icons.visibility_off,size: 20,
        ),
        onPressed: textHideConformPassword,
      ),
      filled: true,
      fillColor: Colors.white,
      counterText: "",
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 0.5)),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: val ? Colors.blue : Colors.blue)),
    );
  }
}


