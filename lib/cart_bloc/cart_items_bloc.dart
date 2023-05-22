
import 'dart:async';

class CartItemsBloc {
  /// The [cartStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final cartStreamController = StreamController.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => cartStreamController.stream;

  int totalCartPrice = 0;

  Map allItems = {
    'cart items': [],
    "voiceCart" : [],
    "partsCart" : [],
    "totalCartPrice" : 0,
    "authToken" :"a",
    'admin':false,
  };


  // setDummyData(){
  //    allItems = {
  //     "cart items": [
  //       {
  //         "jobTemplateId": "JOBTEMP_00157",
  //         "jobTemplateDiscription": "Standard service",
  //         "jobTemplateCaption": null,
  //         "jobTempUi": null,
  //         "modelId": "Innova",
  //         "organisationId": "ORG_00027",
  //         "garageId": "GRG_00072",
  //         "category": "Periodic Service",
  //         "price": 12600
  //       },
  //       {
  //         "jobTemplateId": "JOBTEMP_00173",
  //         "jobTemplateDiscription": "High performance AC service",
  //         "jobTemplateCaption": null,
  //         "jobTempUi": null,
  //         "modelId": "Innova",
  //         "organisationId": "ORG_00027",
  //         "garageId": "GRG_00072",
  //         "category": "ACservice",
  //         "price": 5700
  //       }
  //     ],
  //     "voiceCart": [{"name": "3M car wash", "price": "100"}],
  //     "partsCart": [
  //       {
  //         'partID': 'Part_00074',
  //         'partDescription': 'Racemax 4 T20W40',
  //         'salesPrice': 242,
  //         'Qty': 1
  //       },
  //       {
  //         'partID': 'Part_00081',
  //         'partDescription': "Ball A TrnsFluid",
  //         'salesPrice': 89,
  //         'Qty': 4
  //       }
  //     ],
  //     'totalCartPrice': 18731
  //   };
  //    cartStreamController.sink.add(allItems);
  // }

  // removeDummyData(){
  //   allItems = {
  //     'cart items': [],
  //     "voiceCart" : [],
  //     "partsCart" : [],
  //     "totalCartPrice" : 0
  //   };
  //   cartStreamController.sink.add(allItems);
  // }

  updateJobStatus(index){
    allItems.update("cart items", (list) {
      list[index].update(
          "jobStatus", (value) => "Incomplete");
      return list;
    });
  }

  updateVoiceStatus(index){
    allItems.update("voiceCart", (list) {
      list[index].update(
          "jobStatus", (value) => "Incomplete");
      return list;
    });
  }

  updatePartsStatus(index){
    allItems.update("partsCart", (list) {
      list[index].update(
          "item_status", (value) => "Incomplete");
      return list;
    });
  }


  setTotal(val){
    allItems['totalCartPrice']=0;
    allItems['totalCartPrice'] = val;
    cartStreamController.sink.add(allItems);
    //cartStreamController.sink.add(totalCartPrice);
  }

  setAuthToken(String val){

    allItems['authToken'] = val;
    cartStreamController.sink.add(allItems);
    //cartStreamController.sink.add(totalCartPrice);
  }

  setLoginStatus(bool val){

    allItems['admin'] = val;
    cartStreamController.sink.add(allItems);
    //cartStreamController.sink.add(totalCartPrice);
  }

  void addVoiceCart(item){
    allItems['voiceCart'].add(item);
    cartStreamController.sink.add(allItems);
  }

  void removeAllVoice(){
    allItems['voiceCart'] = [];
    cartStreamController.sink.add(allItems);
  }
  void removeAllParts(){
    allItems['partsCart'] = [];
    cartStreamController.sink.add(allItems);
  }
  void removeAllJobs(){
    allItems['cart items'] = [];
    cartStreamController.sink.add(allItems);
  }

  void removeVoiceCart(item){
    allItems['voiceCart'].remove(item);
    cartStreamController.sink.add(allItems);
  }

  void addToCart(item) {
      allItems['cart items'].add(item);
    cartStreamController.sink.add(allItems);
  }

  void removeFromCart(item, id) {
    allItems['cart items'].removeWhere((element) {
      return element['jobTemplateId'] == id;
    });
    cartStreamController.sink.add(allItems);
  }


  void addPartsToCart(item){
    allItems['partsCart'].add(item);
    cartStreamController.sink.add(allItems);
  }



  void removePartsCart(id){
    allItems['partsCart'].removeWhere((element) {
      return element['partID'] == id;
    });
   // allItems['partsCart'].remove(item);
    cartStreamController.sink.add(allItems);
  }

  /// The [dispose] method is used 
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    cartStreamController.close(); // close our StreamController
  }
}

final bloc = CartItemsBloc();
