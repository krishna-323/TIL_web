//
// import 'package:flutter/material.dart';
// import 'package:motows_web/utils/easy_side_menue/src/side_menu.dart';
// import 'package:motows_web/utils/easy_side_menue/src/side_menu_display_mode.dart';
// import 'package:motows_web/utils/easy_side_menue/src/side_menu_item.dart';
// import 'package:motows_web/utils/easy_side_menue/src/side_menu_style.dart';
//
// class WebSideBarMenu extends StatefulWidget {
//   final PageController page;
//   const WebSideBarMenu(this.page, {Key? key}) : super(key: key);
//
//   @override
//   _WebSideBarMenuState createState() => _WebSideBarMenuState();
// }
//
//
// class _WebSideBarMenuState extends State<WebSideBarMenu> {
//   late double screenWidth;
//   late double screenHeight;
//   @override
//   Widget build(BuildContext context) {
//     screenHeight =MediaQuery.of(context).size.height;
//     screenWidth= MediaQuery.of(context).size.width;
//     return Center(
//       child: SideMenu(
//         title: Container(
//             color:Color(0xff4e4f96),
//             height: 56,
//
//             child: Row(//crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 16),
//                   child: Container(height: 22,
//                     child:Image.asset("assets/logo/IkyamWhite.png",fit: BoxFit.fitHeight,)),
//                 )
//               ],
//             )),
//         controller: widget.page,showToggle: true,
//         // onDisplayModeChanged: (mode) {
//         //   print(mode);
//         // },
//         style: SideMenuStyle(
//           openSideMenuWidth: 150,compactSideMenuWidth: 70,
//           backgroundColor: Color(0xffF2F7FF),
//             displayMode: screenWidth > 1200
//                 ? SideMenuDisplayMode.open
//                 : SideMenuDisplayMode.compact,
//             selectedColor: Color(0xff4e4f96),
//             hoverColor: Colors.lightBlueAccent,
//             selectedTitleTextStyle: const TextStyle(color: Colors.white),
//             selectedIconColor: Colors.white,
//             iconSize: 18
//             //toggleColor: Colors.white
//           // backgroundColor: Colors.blueGrey[700]
//         ),
//
//
//         items: [
//           SideMenuItem(
//             priority: 0,
//             title: 'Home',
//             onTap: () {
//               widget.page.jumpToPage(0);
//             },
//             icon: const Icon(Icons.home),
//             // badgeContent: const Text(
//             //   '3',
//             //   style: TextStyle(color: Colors.white),
//             // ),
//           ),
//           SideMenuItem(
//             priority: 1,
//             title: 'Docket',
//             onTap: () {
//               widget.page.jumpToPage(1);
//             },
//             icon: const Icon(Icons.file_copy_outlined),
//             // badgeContent: const Text(
//             //   '3',
//             //   style: TextStyle(color: Colors.white),
//             // ),
//           ),
//           SideMenuItem(
//             priority: 2,
//             title: 'Invoice',
//             onTap: () {
//               widget.page.jumpToPage(2);
//             },
//             icon: const Icon(Icons.file_present),
//           ),
//
//           // SideMenuItem(
//           //   priority: 2,
//           //   title: 'Files',
//           //   onTap: () {
//           //     page.jumpToPage(2);
//           //   },
//           //   icon: const Icon(Icons.file_copy_rounded),
//           // ),
//           // SideMenuItem(
//           //   priority: 3,
//           //   title: 'Download',
//           //   onTap: () {
//           //     page.jumpToPage(3);
//           //   },
//           //   icon: const Icon(Icons.download),
//           // ),
//           // SideMenuItem(
//           //   priority: 4,
//           //   title: 'Settings',
//           //   onTap: () {
//           //     page.jumpToPage(4);
//           //   },
//           //   icon: const Icon(Icons.settings),
//           // ),
//           // SideMenuItem(
//           //   priority: 6,
//           //   title: 'Exit',
//           //   onTap: () async {},
//           //   icon: const Icon(Icons.exit_to_app),
//           // ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
