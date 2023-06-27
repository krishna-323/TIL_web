
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_project/master/parts/model/part_detail_model.dart';






class PartDetailsNetwork{
  Future<PartModel> fetchItemData(itemId, String authToken) async{


    final response = await http.get(Uri.parse("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/get_newitem_by_id/$itemId"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
// print('----------------');
// print(response.body);
      return PartModel.fromProvider(json.decode(response.body));
      // return AddJobModel.fromProvider(result);
    }
    else {
      //Loader.hide();
      throw (response.statusCode.toString()+response.body);
      // return CustomerCardModel.fromProvider(list);
    }




  }
}