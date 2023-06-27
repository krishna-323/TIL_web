import 'package:rxdart/subjects.dart';

import '../model/vendors_details_model.dart';
import '../network_provider/vendors_details_network.dart';




class VendorDetailsBloc{

  final vendorDetailsProvider = VendorDetailsNetwork();
  final _vendorDetailsController = PublishSubject<VendorModel>();

  Stream<VendorModel> get getVendorDetails => _vendorDetailsController.stream;

  fetchVendorNetwork(vendorId)async{
    VendorModel result = await vendorDetailsProvider.fetchVendorData(vendorId);
    _vendorDetailsController.sink.add(result);
  }
  dispose(){
    _vendorDetailsController.close();
  }
}
final vendorDetailsBloc = VendorDetailsBloc();