import 'package:flutter/material.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';
import '../classes/arguments_classes/arguments_classes.dart';
import '../classes/motows_routes.dart';



class CustomDrawer extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CustomDrawer(this.drawerWidth, this.selectedDestination, {Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late double drawerWidth;

  late double _selectedDestination;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    drawerWidth = widget.drawerWidth;
    _selectedDestination = widget.selectedDestination;
   // Customer
    if(_selectedDestination == 1.1 || _selectedDestination ==1.2 ){
      salesHovered=false;
      salesExpanded=true;
    }
    //Settings.
    if(_selectedDestination == 2.1 || _selectedDestination ==2.2 ||_selectedDestination ==2.3|| _selectedDestination ==2.4 ){
      settingsHover=false;
      settingsExpanded=true;
    }

  }

  @override
  dispose(){
    super.dispose();
  }
  //
  bool salesHovered = false;
  bool salesExpanded=false;

 bool customerHovered=false;
  bool customerExpanded=false;
 //vehicle.
 bool purchaseHover=false;
 bool purchaseExpanded=false;
 //items.
  bool itemsHover=false;
  bool itemsExpanded=false;
 //master.
  bool masterHover=false;
  bool masterExpanded=false;
 //settings.
  bool settingsHover=false;
  bool settingsExpanded=false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: drawerWidth,
      child: Scaffold(
        //  backgroundColor: Colors.white,
        body: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            controller: ScrollController(),
            shrinkWrap: true,
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(height: 10,),
                //Home.
                drawerWidth==60?InkWell(
                  hoverColor: mHoverColor,
                  onTap: (){
                    setState(() {
                      drawerWidth = 190;
                    });
                  },
                  child:Icon(Icons.apps_rounded,color: _selectedDestination==0? Colors.blue: Colors.black54,)
                ):
                Column(
                children: [
                  ListTile(
                      hoverColor:mHoverColor,
                      selectedTileColor: Colors.blue,
                      selectedColor: Colors.white,
                     // leading: Container(child:  Icon(Icons.apps_rounded)),
                      title:Container(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(child: Icon(Icons.apps_rounded)),
                            const SizedBox(width: 5),
                               Expanded(
                                child: Text(drawerWidth==60?"":'Home'),
                              ),
                            const Spacer(),
                          ],
                        ),
                      ),

                      selected: _selectedDestination == 0,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/home");
                      }),
                ],
              ),

                //Services
                drawerWidth==60?InkWell(
                hoverColor: mHoverColor,
                onTap: (){
                  setState(() {
                    drawerWidth = 190;
                  });
                },
                child: Container(height: 40,
                  child: Icon(Icons.person,
                    color: _selectedDestination == 1.1
                        || _selectedDestination ==1.2
                        ? Colors.blue: Colors.black54,),
                ),
              ):
                Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onHover: (event) {
                setState(() {
                  if (!salesExpanded) {
                    salesHovered = true;
                  }
                });
              },
              onExit: (event) {
                setState(() {
                  salesHovered = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    salesExpanded = !salesExpanded;
                  });
                },
                child: Container(
                  height: 40,
                  color: salesHovered ? mHoverColor : Colors.transparent,
                  child: Row(
                    children: [
                       const Expanded(child: Icon(Icons.person,)),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: Text(
                          drawerWidth == 60 ? '' : 'Service',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          salesExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: salesExpanded,
              child: Column(
                children: [
                  ListTile(
                    hoverColor: mHoverColor,
                    selectedTileColor: Colors.blue,
                    selectedColor: Colors.white,
                    title: Center(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(drawerWidth == 60 ? '' : 'New Customer'),
                      ),
                    ),
                    selected: _selectedDestination == 1.1,
                    onTap: () {
                      setState(() {
                        _selectedDestination = 1.1;
                      });
                      Navigator.pushReplacementNamed(
                        context,
                        MotowsRoutes.customerListRoute,
                        arguments: CustomerArguments(selectedDestination: 1.1, drawerWidth: widget.drawerWidth),
                      );
                    },
                  ),
                  ListTile(
                    hoverColor: mHoverColor,
                    selectedTileColor: Colors.blue,
                    selectedColor: Colors.white,
                    title: Text(drawerWidth == 60 ? '' : 'Purchase Order', style: const TextStyle(fontSize: 15)),
                    selected: _selectedDestination == 1.2,
                    onTap: () {
                      setState(() {
                        _selectedDestination = 1.2;
                      });
                      Navigator.pushReplacementNamed(
                        context,
                        MotowsRoutes.estimateRoutes,
                        arguments: DisplayEstimateItemsArgs(selectedDestination: 1.2, drawerWidth: widget.drawerWidth),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

                   //Settings
                drawerWidth==60?InkWell(  hoverColor: mHoverColor,
                  onTap: (){
                    setState(() {
                      drawerWidth = 190;
                    });
                  },
                  child: Container(height: 40,
                    child: Icon(Icons.settings,color:_selectedDestination ==2.1
                        ||_selectedDestination==2.2
                        ||_selectedDestination==2.3
                        ||_selectedDestination==2.4
                        ? Colors.blue: Colors.black54,),
                  ),
                ):
                Column(
                  children: [
                    MouseRegion(
                      onHover: (event) {
                        setState(() {
                          if (!settingsExpanded) {
                            settingsHover = true;
                          }
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          settingsHover = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            settingsExpanded = !settingsExpanded;
                          });
                        },
                        child: Container(
                          height: 40,
                          color: settingsHover ? mHoverColor : Colors.transparent,
                          child: Row(
                            children: [
                              const Expanded(child: Icon(Icons.settings,)),
                              const SizedBox(width: 5,),
                              Expanded(
                                child: Text(
                                  drawerWidth == 60 ? '' : 'Settings',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Icon(
                                  settingsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: settingsExpanded,
                      child: Column(
                        children: [
                          ListTile(
                              hoverColor: mHoverColor,
                              selectedTileColor: Colors.blue,
                              selectedColor: Colors.white,
                              title: Align
                                (alignment: Alignment.topLeft,
                                  child: Text(drawerWidth == 60 ? "" : 'Company Management')),
                              selected: _selectedDestination == 2.1,
                              onTap: () { setState(() {
                                _selectedDestination=2.1;
                              });

                              // Navigator.of(context).pushReplacement(
                              //   PageRouteBuilder(
                              //     pageBuilder: (context, animation1, animation2) =>CompanyManagement(selectedDestination: _selectedDestination,drawerWidth: widget.drawerWidth,),
                              //     transitionDuration: Duration.zero,
                              //     reverseTransitionDuration: Duration.zero,
                              //   ),
                              // );
                              Navigator.pushReplacementNamed(context, MotowsRoutes.companyManagement,arguments: CompanyManagementArguments(drawerWidth: widget.drawerWidth, selectedDestination: 2.1));
                              }
                          ),
                          ListTile(
                              title: Center(child: Align(alignment: Alignment.topLeft,
                                  child: Text(drawerWidth == 60 ? "" : 'User Management'))),
                              selected: _selectedDestination == 2.2,
                              hoverColor:mHoverColor,
                              selectedTileColor: Colors.blue,
                              selectedColor: Colors.white,
                              onTap: () {
                                setState(() {
                                  _selectedDestination=2.2;
                                });
                                // Navigator.of(context).pushReplacement(
                                //   PageRouteBuilder(
                                //     pageBuilder: (context, animation1, animation2) => UserManagement( drawerWidth: drawerWidth, selectedDestination: _selectedDestination,),
                                //     transitionDuration: Duration.zero,
                                //     reverseTransitionDuration: Duration.zero,
                                //   ),
                                // );
                                Navigator.pushReplacementNamed(context, MotowsRoutes.userManagement,arguments: UserManagementArguments(drawerWidth: widget.drawerWidth, selectedDestination: 2.2));
                              }
                          ),
                          ListTile(
                              title: Center(child: Align(alignment: Alignment.topLeft,
                                  child: Text(drawerWidth == 60 ? "" : 'Upload'))),
                              selected: _selectedDestination == 2.3,
                              hoverColor:mHoverColor,
                              selectedTileColor: Colors.blue,
                              selectedColor: Colors.white,
                              onTap: () {
                                setState(() {
                                  _selectedDestination=2.3;
                                });
                                Navigator.pushReplacementNamed(context, MotowsRoutes.uploadData,arguments: UploadDataArguments(drawerWidth: widget.drawerWidth, selectedDestination: 2.3));
                                // Navigator.pushReplacementNamed(context, MotowsRoutes.listItemRoute,arguments: ListItemsArgs(title: 1, drawerWidth: widget.drawerWidth, selectedDestination: _selectedDestination));
                              }
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 30,
          width: 50,
          child: InkWell(
              onTap: () {
                setState(() {
                  if (drawerWidth == 60) {
                    drawerWidth = 190;
                  } else {
                    drawerWidth = 60;
                  }
                });
              },
              child:
              Align(alignment:Alignment.center,child: Text(drawerWidth == 60 ? ">" : "<"))),
        ),

      ),
    );
  }

  void selectDestination(double index) {
    setState(() {
      _selectedDestination = index;
    });
  }
}




// MouseRegion(
//   onHover: (event) {
//     setState(() {
//       if (!salesExpanded) {
//         salesHovered = true;
//       }
//     });
//   },
//   onExit: (event) {
//     setState(() {
//       salesHovered = false;
//     });
//   },
//   child: Container(
//     color: salesHovered ? mHoverColor : Colors.transparent,
//     child: Theme(
//       data: Theme.of(context).copyWith(dividerColor: const Color(0xffe7e4e4)),
//       child: CustomAccordion(
//         title: drawerWidth == 60 ? '' : "Service",
//         child: Column(
//           children: [
//             ListTile(
//               hoverColor: mHoverColor,
//               selectedTileColor: Colors.blue,
//               selectedColor: Colors.white,
//               title: Center(
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(drawerWidth == 60 ? '' : 'New Customer'),
//                 ),
//               ),
//               selected: _selectedDestination == 1.1,
//               onTap: () {
//                 setState(() {
//                   _selectedDestination = 1.1;
//                 });
//                 Navigator.pushReplacementNamed(
//                   context,
//                   MotowsRoutes.customerListRoute,
//                   arguments: CustomerArguments(selectedDestination: 1.1, drawerWidth: widget.drawerWidth),
//                 );
//               },
//             ),
//             ListTile(
//               hoverColor: mHoverColor,
//               selectedTileColor: Colors.blue,
//               selectedColor: Colors.white,
//               title: Text(drawerWidth == 60 ? '' : 'Purchase Order', style: const TextStyle(fontSize: 15)),
//               selected: _selectedDestination == 1.2,
//               onTap: () {
//                 setState(() {
//                   _selectedDestination = 1.2;
//                 });
//                 Navigator.pushReplacementNamed(
//                   context,
//                   MotowsRoutes.estimateRoutes,
//                   arguments: DisplayEstimateItemsArgs(selectedDestination: 1.2, drawerWidth: widget.drawerWidth),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// ),
class CustomAccordion extends StatefulWidget {
  final String title;
  final Widget child;

  const CustomAccordion({required this.title, required this.child});

  @override
  _CustomAccordionState createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Container(
            color: expanded ? Colors.grey.shade300 : Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Icon(
                    expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: expanded ? null : 0,
          child: SingleChildScrollView(
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
