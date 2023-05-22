import 'package:flutter/material.dart';


class CustomVDivider extends StatefulWidget {
  final double height;
  final double width;
  final Color color;
  const CustomVDivider({Key? key, required this.height, required this.width, required this.color}) : super(key: key);

  @override
  State<CustomVDivider> createState() => _CustomVDividerState();
}

class _CustomVDividerState extends State<CustomVDivider> {
  @override
  Widget build(BuildContext context) {
    return  Container(height: widget.height, width: widget.width, color: widget.color,);
  }
}
