import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import '../classes/arguments_classes/arguments_classes.dart';
import '../utils/api/getApi.dart';
import '../utils/api/post_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_loader.dart';
import '../widgets/alertDialogWidget.dart';
import '../widgets/input_decoration_text_field.dart';

class UserManagement extends StatefulWidget {
  final UserManagementArguments args;

  const UserManagement({Key? key, required this.args,}) : super(key: key);

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
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
  String? authToken;
  String? assignUserId;
  String userID='';

//Passing token.
  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
    userID = prefs.getString("userId") ??'';
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
                print(errorMessage);
              });

            }
            else if(value['error']=="user already exist"){

              setState(() {
                errorMessage="User Already Exist";
                print(errorMessage);
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

            //get all user api()
            getUserData();
            Navigator.of(context).pop();
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
            // print('----------details-----------');
            // print(userdata);
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
      print('--------response--');
      print(response.body);
      getUserData();
      Navigator.of(context).pop();

    } else {
      print(response.statusCode.toString());
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


      updateUserDetailsStore=jsonDecode(response.body);
      if(updateUserDetailsStore['error']=='user already exist' || updateUserDetailsStore['error']=="email already exist"){
        if(updateUserDetailsStore['error']=="user already exist"){
          setState(() {
            errorMessage='User Already Exist';
            print(errorMessage);
          });

        }
        else if(updateUserDetailsStore['error']=='email already exist'){
          setState(() {
            errorMessage='Email Already Exist';
            print(errorMessage);
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

      else{

        getUserData();
        // print('------------------------satuscode-----------');
        // print(response.statusCode);
        Navigator.of(context).pop();

      }


    } else {
      print(response.statusCode.toString());
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
                    bool editCompanyError = false;
                    bool editUserNameError = false;
                    bool editUserRoleError = false;
                    bool editUserEmailError = false;
                    final editEmail = TextEditingController();
                    editUserName.text = userData['username'];
                    editEmail.text = userData['email'];
                    // Initial Value.
                    String  roleInitial = userData['role'];
                    // Dropdown Values.
                    var roleTypes = ['Admin', 'User'];
                    var selectedCompanyName =  userData['company_name'];
                    final List<String> countryNames = [...companyNamesList];
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
                                              Container(
                                                height: 30,
                                                width: 292,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(width: 0.5,
                                                        style: BorderStyle.solid,
                                                        color: Colors.black)),
                                                child: DropdownButtonHideUnderline(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left:10),
                                                    child: DropdownButton<String>(
                                                      hint: Text("Select CompanyName"),
                                                      value: selectedCompanyName,
                                                      onChanged: (String ? company){
                                                        setState((){
                                                          selectedCompanyName=company!;
                                                        });
                                                      },
                                                      items: countryNames.map((String names){
                                                        return DropdownMenuItem<String>(
                                                            value:names,
                                                            child: Text(names)
                                                        );
                                                      }).toList(),

                                                    ),
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
                                              Container(
                                                height: 30,
                                                width: 292,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(width: 0.5,
                                                        style: BorderStyle.solid,
                                                        color: Colors.black)),
                                                child: DropdownButtonHideUnderline(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left:10),
                                                    child: DropdownButton<String>(
                                                      hint: Text("Select User Role"),
                                                      //Initial Value.
                                                      value:   roleInitial,
                                                      onChanged: (String ? role){
                                                        setState((){
                                                          roleInitial=role!;
                                                        });
                                                      },
                                                      items: roleTypes.map((String names){
                                                        return DropdownMenuItem<String>(
                                                            value:names,
                                                            child: Text(names)
                                                        );
                                                      }).toList(),

                                                    ),
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
                                                    //editCompanyName.text,
                                                  };
                                                  print('-----change-----');
                                                  print(editUserManagement);
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
                                              print('------check-------------');
                                              print('https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/change-password/$storeEmail/$storePassword');

                                              String url = 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/change-password/$storeEmail/$storePassword';
                                              final response = await http.get(Uri.parse(url),
                                                  headers: {
                                                    "Content-Type": "application/json",
                                                    'Authorization': 'Bearer $authToken'
                                                  });
                                              if (response.statusCode == 200) {
                                                // print('-----------status-code------------');
                                                // print(response.statusCode);
                                                Navigator.of(context).pop();
                                              } else {
                                                print(response.statusCode.toString());
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
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 50.0, right: 50, top: 20),
                  child: Column(
                    children: [
                      Row(
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
                          MaterialButton(
                            color: Colors.blue,
                            onPressed: () {
                              createNewUser(context,companyNamesList);
                            },
                            child: const Text(
                              "+ Create user",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 40,
                          color: Colors.grey[200],
                          child: Row(
                            children: const [
                              Expanded(child: Center(child: Text("USER NAME"))),
                              Expanded(
                                  child: Center(child: Text("COMPANY NAME"))),
                              Expanded(
                                  child: Center(child: Text("USER EMAIL"))),
                              Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 50.0),
                                    child: Center(child: Text("USER ROLE")),
                                  )),
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      for (int i = 0; i < userdata.length; i++)
                        Column(
                          children: [
                            Card(
                              child: Material(
                                color: Colors.transparent,
                                child: Row(children: [
                                  Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                              height: 28,
                                              child: Text(
                                                userdata[i]['username'] ?? "",
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ),
                                      )),
                                  Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                              height: 28,
                                              child: Text(
                                                userdata[i]['company_name'] ?? "",
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ),
                                      )),
                                  Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                            height: 28,
                                            child: Text(
                                              userdata[i]['email'] ?? "",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                            height: 28,
                                            child: Text(
                                              userdata[i]['role'] ?? "",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Center(
                                      child: SizedBox(
                                          height: 28,
                                          child: Center(
                                              child: _popMenu(userdata[i],))),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        )
                    ],
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
          bool salutationError = false;
          bool companyError = false;
          final newUser = GlobalKey<FormState>();
          String? role;
          List <String> roleTypes  = ['Admin', 'User'];
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
          String ? selectedCompanyName;
          final List<String> countryNames = [...companyNamesList];
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
                                    Container(
                                      height: 30,
                                      width: 282,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                                          border: Border.all(width: 0.5,
                                              style: BorderStyle.solid,
                                              color: Colors.black)),
                                      child: DropdownButtonHideUnderline(
                                        child: Padding(
                                          padding: EdgeInsets.only(left:10),
                                          child: DropdownButton<String>(
                                            hint: Text("Select User Role"),
                                            //Initial Value.
                                            value:   role,
                                            onChanged: (String ? roleNames){
                                              setState((){
                                                role= roleNames!;
                                              });
                                            },
                                            items: roleTypes.map((String names){
                                              return DropdownMenuItem<String>(
                                                  value:names,
                                                  child: Text(names)
                                              );
                                            }).toList(),

                                          ),
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
                                    Container(
                                      height: 30,
                                      width: 282,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                                          border: Border.all(width: 0.5,
                                              style: BorderStyle.solid,
                                              color: Colors.black)),
                                      child: DropdownButtonHideUnderline(
                                        child: Padding(
                                          padding: EdgeInsets.only(left:10),
                                          child: DropdownButton<String>(
                                            hint: Text("Select User Role"),
                                            //Initial Value.
                                            value:   selectedCompanyName,
                                            onChanged: (String ? company){
                                              setState((){
                                                selectedCompanyName=company!;
                                              });
                                            },
                                            items: countryNames.map((String names){
                                              return DropdownMenuItem<String>(
                                                  value:names,
                                                  child: Text(names)
                                              );
                                            }).toList(),

                                          ),
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
                                        if (newUser.currentState!.validate()) {
                                          userData = {
                                            "active": true,
                                            "company_name": selectedCompanyName,
                                            "email": newUserEmail.text,
                                            "password": newPassword.text,
                                            "role": role,
                                            "username": newUserName.text,
                                          };
                                          // print('---check----');
                                          // print(userData);
                                          userDetails(userData);

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


