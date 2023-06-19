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
    if(_selectedDestination==0){
      homeHovered=true;
    }
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
  bool homeHovered=false;
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
                child: SizedBox(height: 45,
                  child: Icon(Icons.apps_rounded,
                    color: _selectedDestination == 0 ? Colors.blue: Colors.black54,),
                ),
              ):
                Column(
                children: [
                  MouseRegion(
                    onHover: (event){
                      homeHovered=true;
                    },
                    onExit: (event){
                      homeHovered=false;
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/home");
                      },
                      child: Container(
                        height: 45,
                        color: homeHovered ? mHoverColor : Colors.transparent,
                        child: Row(
                          children: [
                            const Expanded(child: Icon(Icons.apps_rounded,)),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Text(
                                drawerWidth == 60 ? '' : 'Home',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                child: SizedBox(height: 40,
                  child: Icon(Icons.person,
                    color: _selectedDestination == 1.1
                        || _selectedDestination ==1.2
                        ? Colors.blue: Colors.black54,),
                ),
              ):
                MouseRegion(
                  onHover: (event) {
                    setState(() {
                      if (salesExpanded == false) {
                        salesHovered = true;
                      }
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      salesHovered = false;
                    });
                  },
                  child: Container(
                    color: salesHovered ? mHoverColor : Colors.transparent,
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                      child: ExpansionTile(
                        onExpansionChanged: (value) {
                          setState(() {
                            if (value) {
                              salesExpanded = true;
                              salesHovered = false;
                            } else {
                              salesExpanded = false;
                            }
                          });
                        },
                        initiallyExpanded: _selectedDestination == 1.1 || _selectedDestination == 1.2,
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                          ),
                        ),
                        title: Text(drawerWidth == 60 ? '' : "Sales", style: const TextStyle(fontSize: 16)),
                        leading: const SizedBox(
                          width: 40, // Set a specific width here, adjust as needed
                          child: Icon(Icons.person,),
                        ),
                        children: <Widget>[
                          // Your list tiles here.
                          ListTile(
                            hoverColor: mHoverColor,
                            selectedTileColor: Colors.blue,
                            selectedColor: Colors.white,
                            title: Center(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(drawerWidth == 60 ? '' : 'New Customer'),
                                ),
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
                            title: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(drawerWidth == 60 ? '' : 'Purchase Order', style: const TextStyle(fontSize: 15)),
                            ),
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
                  ),
                ),

                drawerWidth==60?InkWell(  hoverColor: mHoverColor,
                  onTap: (){
                    setState(() {
                      drawerWidth = 190;
                    });
                  },
                  child: Container(height: 45,
                    child: Icon(Icons.settings,color:_selectedDestination ==2.1
                        ||_selectedDestination==2.2
                        ||_selectedDestination==2.3
                        ||_selectedDestination==2.4
                        ? Colors.blue: Colors.black54,),
                  ),
                ):

              MouseRegion(
                onHover: (event) {
                  setState(() {
                    if (settingsExpanded == false) {
                      settingsHover = true;
                    }
                  });
                },
                onExit: (event) {
                  setState(() {
                    settingsHover = false;
                  });
                },
                child: Container(
                  color: settingsHover ? mHoverColor : Colors.transparent,
                  child: ListTileTheme(
                    contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                    child: ExpansionTile(
                      onExpansionChanged: (value) {
                        setState(() {
                          if (value) {
                            settingsExpanded = true;
                            settingsHover = false;
                          } else {
                            settingsExpanded = false;
                          }
                        });
                      },
                      initiallyExpanded: _selectedDestination == 2.1 || _selectedDestination == 2.2 ||
                          _selectedDestination == 2.3,
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                        ),
                      ),
                      title: Text(drawerWidth == 60 ? '' : "Settings", style: const TextStyle(fontSize: 16)),
                      leading: const SizedBox(
                        width: 40, // Set a specific width here, adjust as needed
                        child: Icon(Icons.settings,),
                      ),
                      children: <Widget>[
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
                ),
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
