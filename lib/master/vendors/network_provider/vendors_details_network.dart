import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/vendors_details_model.dart';

class VendorDetailsNetwork{

  Future<VendorModel> fetchVendorData(vendorId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken= prefs.getString("authToken");
    final response = await http.get(Uri.parse("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/new_vendor/get_new_vendor_by_id/$vendorId"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {

      return VendorModel.fromProvider(json.decode(response.body));
      // return AddJobModel.fromProvider(result);
    }
    else {
      //Loader.hide();
      throw (response.statusCode.toString()+response.body);
      // return CustomerCardModel.fromProvider(list);
    }
  }
}