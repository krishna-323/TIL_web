import 'package:rxdart/subjects.dart';
import '../model/customer_details_model.dart';
import '../network_provider/customer_details_network.dart';
class CustomerDetailsBloc{

  final customerDetailsProvider = CustomerDetailsNetwork();
  final _customerDetailsController = PublishSubject<CustomerModel>();

  Stream<CustomerModel> get getCustomerDetails => _customerDetailsController.stream;

  fetchCustomerNetwork(customerId)async{
    CustomerModel result = await customerDetailsProvider.fetchCustomerData(customerId);
    _customerDetailsController.sink.add(result);
  }
  dispose(){
    _customerDetailsController.close();
  }
}
final customerDetailsBloc = CustomerDetailsBloc();