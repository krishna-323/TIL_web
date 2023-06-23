
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_project/docket/model/docket_details_model.dart';

import 'package:shared_preferences/shared_preferences.dart';




class DocketDetailsNetworkProvider{
  Future<DocketDetailsModel> fetchCustomerData(docketId) async{
    String orgId = '';
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    // orgId = prefs.get('orgId').toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken= prefs.getString("authToken")!;

    final response = await http.get(Uri.parse("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_dock_customer_details_by_id/$docketId"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      //Loader.hide();
      return DocketDetailsModel.fromProvider(json.decode(response.body));
      // return AddJobModel.fromProvider(result);
    }
    else {
      //Loader.hide();
      throw (response.statusCode.toString()+response.body);
      // return CustomerCardModel.fromProvider(list);
    }




  }
}