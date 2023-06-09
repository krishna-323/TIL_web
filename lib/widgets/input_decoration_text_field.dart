import 'package:flutter/material.dart';

decorationInput(String hintString, bool val,) {
  return  InputDecoration(label: Text(
        hintString,
        style: TextStyle(color: val ?Colors.blue :Colors.grey[800]),
      ),
      counterText: '',
      contentPadding:  const EdgeInsets.fromLTRB(26, 00, 0, 0),
      hintText: hintString,
      suffixIconColor: const Color(0xfff26442),
      disabledBorder:  const OutlineInputBorder(
          borderSide:  BorderSide(color:  Colors.white)),
      enabledBorder:OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  const Color(0xFFEEEEEE))),
      focusedBorder:  OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.grey)),
      border:   OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.blue))
  );
}

decorationInput2(String hintString, bool val,) {
  return  InputDecoration(label: Text(
    hintString,
    style: TextStyle(color: val ?Colors.blue :Colors.grey[800]),
  ),
      counterText: '',
      contentPadding:  const EdgeInsets.fromLTRB(6, 00, 0, 0),
      hintText: hintString,
      suffixIconColor: const Color(0xfff26442),
      disabledBorder:  const OutlineInputBorder(
          borderSide:  BorderSide(color:  Colors.white)),
      enabledBorder:OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  const Color(0xFFEEEEEE))),
      focusedBorder:  OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.grey)),
      border:   OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.blue))
  );
}

decorationInput3(String hintString, bool val,) {
  return  InputDecoration(label: Text(
    hintString,
    style: TextStyle(color: val ?Colors.blue :Colors.grey[800]),
  ),
      counterText: '',labelStyle: TextStyle(fontSize: 12),
      contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      suffixIconColor: const Color(0xfff26442),
      disabledBorder:  const OutlineInputBorder(
          borderSide:  BorderSide(color:  Colors.white)),
      enabledBorder:OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.grey)),
      focusedBorder:  OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.grey)),
      border:   OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.blue))
  );
}

decorationInput4(String hintString, bool val, bool isDisabled,) {
  return  InputDecoration(label: Text(
    hintString,
    style: TextStyle(color: Colors.grey[800]),
  ),
      counterText: '',
      contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      suffixIconColor: const Color(0xfff26442),
      disabledBorder:   const OutlineInputBorder(
          borderSide:  BorderSide(color: Colors.grey)),
      enabledBorder:const OutlineInputBorder(
          borderSide:  BorderSide(color:Colors.blue )),
      focusedBorder:  OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.grey)),
      border:   OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.blue))
  );
}

decorationInput5(String hintString, bool val,) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    counterText: "",
    contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      // suffixIconColor: const Color(0xfff26442),
      // disabledBorder:  const OutlineInputBorder(
      //     borderSide:  BorderSide(color:  Colors.white)),
      // enabledBorder:OutlineInputBorder(
      //     borderSide:  BorderSide(color: val ?Colors.blue :  Colors.grey)),
      focusedBorder:   const OutlineInputBorder(
          borderSide:  BorderSide(color:Colors.blue,width:0.5 )),
      border:   OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.blue)),
  );
}

decorationInput6(String hintString, bool val,) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding:  const EdgeInsets.symmetric(vertical:10.0 ,horizontal: 12.0),
    hintText: hintString,
    focusedBorder:   const OutlineInputBorder(
        borderSide:  BorderSide(color:Colors.blue,width:0.5 )),
    border:   OutlineInputBorder(
        borderSide:  BorderSide(color: val ?Colors.blue :  Colors.blue)),
  );
}

dropdownDecorationSearch(bool val) {
  return InputDecoration(
    border: OutlineInputBorder(
        borderSide: BorderSide(
            color: val ? Colors.blue : Colors.blue
        )
    ),
    constraints: const BoxConstraints(maxHeight: 35),
    counterText: '',
    contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
    focusedBorder:
    const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  );
}

loginDecoration(String hintString, bool val,) {
  return  InputDecoration(label: Text(
    hintString,
    style: TextStyle(color: val ?Colors.blue :Colors.grey[800]),
  ),
      counterText: '',
      contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
      hintText: hintString,
      suffixIconColor: const Color(0xfff26442),
      disabledBorder:  const OutlineInputBorder(
          borderSide:  BorderSide(color:  Colors.white)),
      enabledBorder:OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.grey)),
      focusedBorder:  OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.grey)),
      border:   OutlineInputBorder(
          borderSide:  BorderSide(color: val ?Colors.blue :  Colors.blue))
  );
}