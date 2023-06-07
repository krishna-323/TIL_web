import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/customer_details_model.dart';

class CustomerDetailsNetwork{
  Future<CustomerModel> fetchCustomerData(customerId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? authToken= prefs.getString("authToken");
    final response = await http.get(Uri.parse("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/get_newcustomer_by_id/$customerId"),
      headers: {
        "Content-Type":"application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      //Loader.hide();
     // print("-----------customer details network----------");
     // print(response.body);
      return CustomerModel.fromProvider(json.decode(response.body));
      // return AddJobModel.fromProvider(result);
    }
    else {
      //Loader.hide();
      throw (response.statusCode.toString()+response.body);
      // return CustomerCardModel.fromProvider(list);
    }
  }
}