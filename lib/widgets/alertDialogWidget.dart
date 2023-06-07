
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';


  alertDialogWidget({required MaterialColor color,required context,required fromTop,required String message}){
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black12,
      transitionDuration: const Duration(milliseconds: 800),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return GestureDetector(

          onTap: (){
            Navigator.of(context).pop();
          },
          onVerticalDragUpdate: (dragUpdateDetails) {
            Navigator.of(context).pop();
          },
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Container(
                      margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(message,style: TextStyle(color:color)),
                    ),
                  ),
                  const Card(
                    margin:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Icon(Icons.clear),
                  )
                ],
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: anim1.drive(Tween(
              begin: Offset(0, fromTop ? -1 : 1), end: const Offset(0, 0))
              .chain(CurveTween(curve: Sprung()))),
          child: child,
        );
      },
    );
  }



class Sprung extends Curve {
  factory Sprung([double damping = 20]) => Sprung.custom(damping: damping);

  Sprung.custom({
    double damping = 20,
    double stiffness = 180,
    double mass = 1.0,
    double velocity = 0.0,
  }) : _sim = SpringSimulation(
    SpringDescription(
      damping: damping,
      mass: mass,
      stiffness: stiffness,
    ),
    0.0,
    1.0,
    velocity,
  );

  final SpringSimulation _sim;

  @override
  double transform(double t) => _sim.x(t) + t * (1 - _sim.x(1.0));
}