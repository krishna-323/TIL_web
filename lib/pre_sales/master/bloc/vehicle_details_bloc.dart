

import 'package:rxdart/subjects.dart';

import '../model/vehicle_details_model.dart';
import '../network_provider/vehicle_details_network.dart';

class VehicleDetailsBloc{

  final vehicleDetailsProvider = VehicleDetailsNetwork();
  final _vehicleDetailsController = PublishSubject<VehicleModel>();

  Stream<VehicleModel> get getVehicleDetails => _vehicleDetailsController.stream;

  fetchVehicleNetwork(vehicleId)async{
    VehicleModel result = await vehicleDetailsProvider.fetchVehicleData(vehicleId);
    _vehicleDetailsController.sink.add(result);
  }
  dispose(){
    _vehicleDetailsController.close();
  }
}

final vehicleDetailsBloc = VehicleDetailsBloc();