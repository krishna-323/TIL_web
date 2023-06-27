

import 'package:new_project/master/parts/model/part_detail_model.dart';
import 'package:new_project/master/parts/network_provider/part_details_network.dart';
import 'package:rxdart/subjects.dart';





class PartDetailsBloc{

  final itemDetailsProvider = PartDetailsNetwork();
  final _itemDetailsController = PublishSubject<PartModel>();

  Stream<PartModel> get getItemDetails => _itemDetailsController.stream;

  fetchItemNetwork(itemId, String authToken)async{
    PartModel result = await itemDetailsProvider.fetchItemData(itemId,authToken);
    _itemDetailsController.sink.add(result);
  }

  dispose(){
    _itemDetailsController.close();
  }

}
final partDetailsBloc= PartDetailsBloc();
