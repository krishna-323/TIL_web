
class VehicleModel{
  List<_VehicleModel> _vehicleList = [];
  VehicleModel.fromProvider(Map parsedJson){
    List<_VehicleModel> vehicleTemp = [];
    _VehicleModel vehicleResult = _VehicleModel(parsedJson);
    vehicleTemp.add(vehicleResult);
    _vehicleList = vehicleTemp;
  }
  List<_VehicleModel> get vehicleDocketData => _vehicleList;
}



class _VehicleModel {
  Map _vehicleData = {};
  _VehicleModel(response){
    _vehicleData = {
      "new_vehicle_id":response["new_vehicle_id"]?? "",
      "brand":response["brand"]??"",
      "name":response["name"]??"",
      "color1":response["color1"]??"",
      "color2":response["color2"]??"",
      "color3":response["color3"]??"",
      "color4":response["color4"]??"",
      "color5":response["color5"]??"",
      "engine_1":response["engine_1"]??"",
      "engine_2":response["engine_2"]??"",
      "engine_3":response["engine_3"]??"",
      "engine_4":response["engine_4"]??"",
      "transmission_1":response["transmission_1"]??"",
      "transmission_2":response["transmission_2"]??"",
      "transmission_3":response["transmission_3"]??"",
      "transmission_4":response["transmission_4"]??"",
    };
  }
  Map get vehicleData => _vehicleData;
}