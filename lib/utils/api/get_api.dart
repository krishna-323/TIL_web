import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

 getData({context, url}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String authToken = prefs.getString("authToken") ?? "";
  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken"
    },
  );
  if (response.statusCode == 200) {
    dynamic responseBody;
    try {
      responseBody = json.decode(response.body);
      if (responseBody.runtimeType.toString() != "List<dynamic>") {
        log("Its a Map Data");
        log(responseBody);
        if (responseBody.containsKey("error")) {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString('authToken', "");
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => const MyApp()));
          return null;
        } else {
          return json.decode(response.body);
        }
      } else {
        return responseBody;
      }
    } catch (e) {
      return json.decode(response.body);
    }
  } else {
// If the server did not return a 200 OK response,
// then throw an exception.
    log("++++++++++Status Code +++++++++++++++");
    log(response.statusCode.toString());
  }
}

logOutApi({dynamic response, context, exception}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
   if(response==null){
     prefs.setString('authToken', "");
     prefs.setString('company_name', "");
     prefs.setString('role', "");
     Navigator.pushReplacement(
         context, MaterialPageRoute(builder: (context) => const MyApp()));

   }
  else if (response.containsKey("error")) {
    prefs.setString('authToken', "");
    prefs.setString('company_name', "");
    prefs.setString('role', "");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyApp()));
  }
  log(response.toString());
  log(exception);
}
