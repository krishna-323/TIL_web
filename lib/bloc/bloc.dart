
import 'dart:async';

class CartItemsBloc {
  /// The [cartStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final cartStreamController = StreamController.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => cartStreamController.stream;



  Map loginData = {
    'admin':false,
    'manager':false,
  };


  setSubRole(bool val){
    loginData['admin'] = val;
    cartStreamController.sink.add(loginData);
    //cartStreamController.sink.add(totalCartPrice);
  }

  setMangerRole(bool val){
    loginData['manager'] = val;
    cartStreamController.sink.add(loginData);
    //cartStreamController.sink.add(totalCartPrice);
  }


  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    cartStreamController.close(); // close our StreamController
  }
}

final bloc = CartItemsBloc();
