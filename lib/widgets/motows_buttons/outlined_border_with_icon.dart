import 'package:flutter/material.dart';
import '../../utils/static_data/motows_colors.dart';
//This Class Is For Only For Blue Border Containers.
class OutlinedBorderWithIcon extends StatefulWidget {
  final String buttonText;
  final IconData iconData;
  final Function onTap;
  final Color hoverColor;
  final Color borderColor;
  const OutlinedBorderWithIcon({Key? key,required this.buttonText,this.borderColor=Colors.blue, this.hoverColor=Colors.white,required this.iconData,required this.onTap}) : super(key: key);

  @override
  State<OutlinedBorderWithIcon> createState() => _OutlinedBorderWithIconState();
}

class _OutlinedBorderWithIconState extends State<OutlinedBorderWithIcon> {
  bool isHover= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MouseRegion(
      onEnter: (value) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (value) {
        setState(() {
          isHover = false;
        });
      },
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: isHover ? Colors.blue: Colors.white),
            borderRadius: BorderRadius.circular(5),
            color: isHover ? widget.hoverColor : Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8),
            child: Row(
              children: [
                Icon(
                  widget.iconData,
                  size: 18,
                  color: isHover ? Colors.blue : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.buttonText,
                  style: TextStyle(color: isHover ? Colors.blue : Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//This Class Is For Only initial Red Border Containers.
class OutlinedBorderColorForDelete extends StatefulWidget {
  final String buttonText;
  final IconData iconData;
  final Function onTap;
  final Color hoverColor;
 // final Color borderColor;
  const OutlinedBorderColorForDelete({super.key, required this.buttonText,
    required this.iconData, required this.onTap,  this.hoverColor=Colors.white,});

  @override
  State<OutlinedBorderColorForDelete> createState() => _OutlinedBorderColorForDeleteState();
}

class _OutlinedBorderColorForDeleteState extends State<OutlinedBorderColorForDelete> {
  bool isHover= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MouseRegion(
      onEnter: (value) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (value) {
        setState(() {
          isHover = false;
        });
      },
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: isHover ? Colors.red : Colors.white),
            borderRadius: BorderRadius.circular(5),
            color: isHover ? widget.hoverColor : Colors.red,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8),
            child: Row(
              children: [
                Icon(
                  widget.iconData,
                  size: 18,
                  color: isHover ? Colors.red : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.buttonText,
                  style: TextStyle(color: isHover ? Colors.red : Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
