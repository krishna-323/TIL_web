import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';
import 'package:new_project/widgets/input_decoration_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'classes/alertbox_methods/alertbox_messages.dart';
import 'classes/motows_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final userName = TextEditingController();
  bool userBool=false;
  final password = TextEditingController();
  bool showError = false;
  bool passWordHindBool=true;
  bool passWordColor = false;
  void passwordHideAndViewFunc() {
    setState(() {
      passWordHindBool = !passWordHindBool;
    });
  }
  String userId='';
  FocusNode _focusNode = FocusNode();
   Color ? _suffixIconColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blueGrey,
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(
            child: Container(height: 220,width: 500,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        decoration:  const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          color: Color(0xff00004d),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Image.asset("assets/logo/Inverse Ikyam White Logo PNG.png"),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 4,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Welcome",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                              SizedBox(height: 30,
                                child: TextField(onTap: () {
                                  setState(() {
                                    passWordHindBool=true;
                                  });
                                },onChanged: (value) {
                                  if(userName.text.isNotEmpty){
                                    setState(() {
                                      userBool =true;
                                    });

                                  }
                                  else{
                                    setState(() {
                                      userBool =false;
                                    });

                                  }
                                },
                                  controller: userName,
                                  style: const TextStyle(fontSize: 12),
                                  decoration: decorationInput3("User Name", userBool),
                                ),
                              ),
                              SizedBox(height: 30,
                                child: TextField(
                                  obscureText: passWordHindBool,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: password,onChanged: (value){
                                    if(password.text.isNotEmpty){
                                      setState(() {
                                        passWordColor=true;
                                      });

                                    }
                                    else{
                                      setState(() {
                                        passWordColor=false;
                                      });
                                    }
                                },
                                  style: const TextStyle(fontSize: 12),
                                  decoration: decorationInputPassword("Password", passWordColor,passWordHindBool,passwordHideAndViewFunc,),
                                  onSubmitted: (v)  async {
                                    int val = await checkLoginCredentials(userName,password);
                                    if(val == 200)
                                    {
                                      if(mounted) {
                                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
                                        Navigator.pushNamed(context, MotowsRoutes.homeRoute);
                                      }
                                    }
                                    else if(val ==500) {
                                      if (mounted) {
                                        showLoginServerErrorDialog(context);
                                      }
                                    }
                                    else if(val ==409) {
                                      if (mounted) {
                                        showPasswordServerErrorDialog(context);
                                      }
                                    }
                                    else if(val ==403) {
                                      if (mounted) {
                                        showLoginUserErrorDialog(context);
                                      }
                                    }
                                    // else {
                                    //   if (mounted) {
                                    //     showLoginErrorDialog(context);
                                    //   }
                                    // }
                                  },
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xff00004d),
                                ),
                                child: TextButton(

                                    onPressed: () async {
                                      int val = await checkLoginCredentials(userName,password);
                                      if(val == 200)
                                      {
                                        if(mounted) {
                                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
                                          Navigator.pushNamed(context, MotowsRoutes.homeRoute);
                                        }
                                      }
                                      else if(val ==500) {
                                        if (mounted) {
                                          showLoginServerErrorDialog(context);
                                        }
                                      }
                                      else if(val ==409) {
                                        if (mounted) {
                                          showPasswordServerErrorDialog(context);
                                        }
                                      }
                                      else if(val ==403) {
                                        if (mounted) {
                                          showLoginUserErrorDialog(context);
                                        }
                                      }
                                    }, child: const Text("Login",style:  TextStyle(color: Colors.white,),)),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Future<int> checkLoginCredentials(TextEditingController userName, TextEditingController password) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // orgId = prefs.get('orgId').toString();

    final response = await http.post(Uri.parse("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/login-authenticate"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "password": password.text,
          "username": userName.text
        })
    );
    if (response.statusCode == 200) {
      Map responseData = jsonDecode(response.body);
      if(responseData.containsKey("token")){
        if(responseData['role'].toString()=="Admin"){
        }

        prefs.setString("authToken", responseData['token'].toString());
        prefs.setString("role", responseData['role'].toString());
        prefs.setString("companyName", responseData['company_name'].toString());
        prefs.setString("userId", responseData['userid'].toString());
        return 200;
      }
      else if (responseData.containsKey("error")){
        if(responseData['status']==403){
          return 403;
        }
        else {
          return 409;
        }
        //return true;
      }
      else {
        return 1;
      }

      //Loader.hide();
      // return AddJobModel.fromProvider(result);


    }
    else {
      //Loader.hide();
      log("+++++++++++++++++++++++++++++ Status Code ++++++++++++++++++++++++++");
      log(response.statusCode.toString());
      setState(() {
        showError == false;
      });
      return 500;

    }


  }
  decorationInputPassword(String hintString, bool val, bool passWordHind,  passwordHideAndView, ) {
    return InputDecoration(
        label: Text(
       hintString,
    ),
        suffixIcon: IconButton(
          icon: Icon(
            passWordHind ? Icons.visibility : Icons.visibility_off,size: 20,
          ),
          onPressed: passwordHideAndView,
        ),suffixIconColor: val?Color(0xff00004d):Colors.grey,
       // suffixIconColor:val?  const Color(0xff00004d):Colors.grey,
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
        hintText: hintString,labelStyle: const TextStyle(fontSize: 12,),

        disabledBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:  Colors.white)),
        enabledBorder:const OutlineInputBorder(borderSide:  BorderSide(color: mTextFieldBorder)),
        focusedBorder:  const OutlineInputBorder(borderSide:  BorderSide(color: Color(0xff00004d))),
        border:   const OutlineInputBorder(borderSide:  BorderSide(color: Color(0xff00004d)))

     );
  }
}

