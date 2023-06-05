import 'package:flutter/material.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatefulWidget {
  final Widget child;
  final bool inAsyncCall;
  const CustomLoader({Key? key, required this.child, required this.inAsyncCall}) : super(key: key);

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {

    return BlurryModalProgressHUD(

      color: Colors.white,
      dismissible: true,
      progressIndicator: SpinKitThreeBounce(size: 58.0,
       itemBuilder: (context, index) => Container(
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient:  const LinearGradient(
            colors: [
              Colors.blue,
              Colors.blue,
            ]
        ),
      )
        ),
        // size: loaderWidth ,
      ),
      inAsyncCall: widget.inAsyncCall,
      child: widget.child,
    );
  }
}
