import 'package:flutter/material.dart';
import '../../utils/static_data/motows_colors.dart';
class OutlinedMButton extends StatefulWidget {
  final GestureTapCallback? onTap;
  final String text;
  final Color borderColor;
  final Color textColor;
  final Color? buttonColor;
   const OutlinedMButton({Key? key,this.onTap, required this.text, required this.borderColor, required this.textColor, this.buttonColor}) : super(key: key);

  @override
  State<OutlinedMButton> createState() => _OutlinedMButtonState();
}

class _OutlinedMButtonState extends State<OutlinedMButton> {
  bool isHover= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: BoxDecoration(color: widget.buttonColor ?? Colors.white,border: Border.all(color:  widget.borderColor),borderRadius: BorderRadius.circular(4)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(highlightColor: Colors.lightBlueAccent[50],
            onHover: (value) {
            if(value){
              setState(() {
                isHover=true;
              });
            }
            else{
              setState(() {
                isHover=false;
              });
            }
          },
            hoverColor: mHoverColor,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onTap: widget.onTap,
            child:  Center(
              child: Text(widget.text,
                  style: TextStyle(
                      color:isHover? Colors.black: widget.textColor)),
            ),
          ),
        ));
  }
}


class VehicleButton extends StatefulWidget {

  final GestureTapCallback? onTap;
  final Map data;
  final Color borderColor;
  final Color textColor;
  final Color? buttonColor;
  const VehicleButton({Key? key,this.onTap, required this.data, required this.borderColor, required this.textColor, this.buttonColor}) : super(key: key);

  @override
  State<VehicleButton> createState() => _VehicleButtonState();
}

class _VehicleButtonState extends State<VehicleButton> {
  bool isHover= false;
  @override
  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration: BoxDecoration(color: widget.buttonColor ?? Colors.white,border: Border.all(color:  widget.borderColor),borderRadius: BorderRadius.circular(4)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(highlightColor: Colors.lightBlueAccent[50],
            onHover: (value) {
              if(value){
                setState(() {
                  isHover=true;
                });
              }
              else{
                setState(() {
                  isHover=false;
                });
              }
            },
            hoverColor: mHoverColor,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onTap: widget.onTap,
            child:  Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data['orderId'],
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color:isHover? Colors.black: widget.textColor)),
                      const SizedBox(height: 4,),
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bill To: ",
                              style: TextStyle(fontSize: 12,
                                  color:isHover? Colors.black: widget.textColor)),
                          Text(widget.data['searchBIllToName'],
                              style: TextStyle(fontSize: 12,
                                  color:isHover? Colors.black: widget.textColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}





