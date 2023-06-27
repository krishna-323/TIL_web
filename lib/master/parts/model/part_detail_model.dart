

class PartModel {

  List<_ItemModel> _list =[];
  PartModel.fromProvider(Map parsedJson) {
    List <_ItemModel> temp =[];
    // for(int i =0; i<parsedJson.length; i++) {
    _ItemModel result = _ItemModel(parsedJson);
    temp.add(result);
    // }
    _list = temp;
  }
  List<_ItemModel> get docketData => _list;
}

class _ItemModel{
  Map _data ={};
  _ItemModel(response){
    _data = {
      'newitem_id':response['newitem_id']??'',
      'description':response['description']??'',
      'exemption_reason':response['exemption_reason']??'',
      'item_code':response['item_code']??'',
      'name':response['name']??'',
      'purchase_account':response['purchase_account']??'',
      'purchase_price':response['purchase_price']??'',
      'sac':response['sac']??'',
      'selling_account':response['selling_account']??'',
      'selling_price':response['selling_price']??'',
      'tax_code':response['tax_code']??'',
      'tax_preference':response['tax_preference']??'',
      'type':response['type']??'',
      'unit':response['unit']??'',
    };




  }
  Map get itemData => _data;
}