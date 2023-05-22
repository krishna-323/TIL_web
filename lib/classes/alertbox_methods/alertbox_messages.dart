import 'package:flutter/material.dart';

void showLoginErrorDialog(context) {
  showDialog(
    context: context, builder: (BuildContext context) {
    return  AlertDialog(
      title:  Column(
        children: const <Widget>[
          Text("Invalid User Name or Password"),
          Icon(
            Icons.error,
            color: Colors.red,
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ],
    ); },
    // return object of type AlertDialog
  );
}


void showLoginServerErrorDialog(context) {
  showDialog(
    context: context, builder: (BuildContext context) {
    return  AlertDialog(
      title:  Column(
        children: const <Widget>[
          Text("Server Error"),
          Icon(
            Icons.error,
            color: Colors.red,
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ],
    ); },
    // return object of type AlertDialog
  );
}

void showLoginUserErrorDialog(context) {
  showDialog(
    context: context, builder: (BuildContext context) {
    return  AlertDialog(
      title:  Column(
        children: const <Widget>[
          Text("Invalid UserName"),
          Icon(
            Icons.error,
            color: Colors.red,
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ],
    ); },
    // return object of type AlertDialog
  );
}

void showPasswordServerErrorDialog(context) {
  showDialog(
    context: context, builder: (BuildContext context) {
    return  AlertDialog(
      title:  Column(
        children: const <Widget>[
          Text("Invalid Password"),
          Icon(
            Icons.error,
            color: Colors.red,
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ],
    ); },
    // return object of type AlertDialog
  );
}