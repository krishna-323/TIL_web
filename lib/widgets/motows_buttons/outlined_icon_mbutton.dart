import 'package:flutter/material.dart';
import '../../utils/static_data/motows_colors.dart';

class OutlinedIconMButton extends StatefulWidget {
  final GestureTapCallback? onTap;
  final String text;
  final Color borderColor;
  final Color textColor;
  final Color? buttonColor;
  final double? borderWidth;
  final Icon icon;
  const OutlinedIconMButton({Key? key,this.onTap, required this.text, required this.borderColor, required this.textColor, this.buttonColor, required this.icon, this.borderWidth}) : super(key: key);

  @override
  State<OutlinedIconMButton> createState() => _OutlinedIconMButtonState();
}

class _OutlinedIconMButtonState extends State<OutlinedIconMButton> {
  late Color textColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(color: widget.buttonColor ?? Colors.white,border: Border.all(color:  widget.borderColor,width: widget.borderWidth ??0),borderRadius: BorderRadius.circular(4)),
      child: Container(
          decoration: BoxDecoration(color: widget.buttonColor ?? Colors.white,border: Border.all(color:  widget.borderColor),borderRadius: BorderRadius.circular(3)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(highlightColor: Colors.lightBlueAccent[50],
              onHover: (value) {
                if(value){
                  setState(() {
                    textColor=Colors.black;
                  });
                }
                else{
                  setState(() {
                    textColor=widget.textColor;
                  });
                }
              },
              hoverColor: mHoverColor,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onTap: widget.onTap,
              child:  Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8),
                child: Row(
                  children: [
                    widget.icon,
                    const SizedBox(width: 10,),
                    Text(widget.text,
                        style: TextStyle(
                            color:  widget.textColor)),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
