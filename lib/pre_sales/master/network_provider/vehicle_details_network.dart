import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/vehicle_details_model.dart';



class VehicleDetailsNetwork{

  Future<VehicleModel> fetchVehicleData(vehicleId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken= prefs.getString("authToken");
    final response = await http.get(
      Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehicle/get_new_vehicle_by_id/$vehicleId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if(response.statusCode == 200){
      return VehicleModel.fromProvider(json.decode(response.body));
    }
    else{
      throw(response.statusCode.toString()+response.body);
    }
  }
}