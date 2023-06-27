
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/item_detail_model.dart';






class ItemDetailsNetwork{
  Future<ItemModel> fetchItemData(itemId, String authToken) async{


    final response = await http.get(Uri.parse("https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/get_newitem_by_id/$itemId"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
// print('----------------');
// print(response.body);
      return ItemModel.fromProvider(json.decode(response.body));
      // return AddJobModel.fromProvider(result);
    }
    else {
      //Loader.hide();
      throw (response.statusCode.toString()+response.body);
      // return CustomerCardModel.fromProvider(list);
    }




  }
}