
import 'package:rxdart/subjects.dart';

import '../model/docket_details_model.dart';
import '../network_provider/docket_network_provider.dart';

class DocketDetailsBloc{

  final docketDetailsProvider = DocketDetailsNetworkProvider();
  final _docketDetailsController = PublishSubject<DocketDetailsModel>();

  Stream<DocketDetailsModel> get getDocketDetails => _docketDetailsController.stream;

  fetchDocketNetwork(docketId)async{
    DocketDetailsModel result = await docketDetailsProvider.fetchCustomerData(docketId);
    _docketDetailsController.sink.add(result);
  }

  dispose(){
    _docketDetailsController.close();
  }

}
final docketDetailsBloc= DocketDetailsBloc();
