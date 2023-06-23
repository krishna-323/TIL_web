

import 'package:rxdart/subjects.dart';

import '../model/item_detail_model.dart';
import '../network_provider/item_details_network.dart';



class ItemDetailsBloc{

  final itemDetailsProvider = ItemDetailsNetwork();
  final _itemDetailsController = PublishSubject<ItemModel>();

  Stream<ItemModel> get getItemDetails => _itemDetailsController.stream;

  fetchItemNetwork(itemId, String authToken)async{
    ItemModel result = await itemDetailsProvider.fetchItemData(itemId,authToken);
    _itemDetailsController.sink.add(result);
  }

  dispose(){
    _itemDetailsController.close();
  }

}
final itemDetailsBloc= ItemDetailsBloc();
