// import 'package:motows_web/utils/easy_side_menue/src/global/global.dart';
// import 'package:motows_web/utils/easy_side_menue/src/side_menu_display_mode.dart';
// import 'package:flutter/material.dart';
//
// class SideMenuToggle extends StatefulWidget {
//   final Function? onTap;
//   const SideMenuToggle({
//     Key? key,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   State<SideMenuToggle> createState() => _SideMenuToggleState();
// }
//
// class _SideMenuToggleState extends State<SideMenuToggle> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//           ),
//       child: IconButton(
//         color: Global.style.toggleColor,
//         icon: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             transitionBuilder: (child, anim) => RotationTransition(
//                   turns: child.key == const ValueKey('Sidemenu_icon1')
//                       ? Tween<double>(begin: 1, end: 0.5).animate(anim)
//                       : Tween<double>(begin: 0.5, end: 1).animate(anim),
//                   child: FadeTransition(opacity: anim, child: child),
//                 ),
//             child: Global.style.displayMode == SideMenuDisplayMode.open
//                 ? const Icon(
//                     Icons.navigate_next,color: Colors.white,
//                     key: ValueKey('Sidemenu_icon1'),
//                     size: 30,
//                   )
//                 : const Icon(
//                     Icons.apps_rounded,color: Colors.white,
//                     key: ValueKey('Sidemenu_icon2'),
//                     size: 30,
//                   )),
//         onPressed: () {
//           if (widget.onTap != null) {
//             widget.onTap!();
//           }
//         },
//       ),
//     );
//   }
// }
