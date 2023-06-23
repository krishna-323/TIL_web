import 'package:flutter/material.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';
import '../classes/arguments_classes/arguments_classes.dart';
import '../classes/motows_routes.dart';
import '../docket/docket_list.dart';
import '../pre_sales/invoice/invoice.dart';



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
    // Home
    if(_selectedDestination==0){
      homeHovered=true;
    }
   // Services
    if(_selectedDestination == 1.1 || _selectedDestination == 1.21 ){
      serviceHover=false;
      serviceExpanded=true;
    }
    // Pre sales.
    if(_selectedDestination==2.1 || _selectedDestination==2.11 ||_selectedDestination==2.12 || _selectedDestination==2.2 || _selectedDestination==2.3 ||
       _selectedDestination==2.4){
      preSalesHover=false;
      preSalesExpanded=true;
    }
    if(_selectedDestination==3.1 || _selectedDestination==3.2){
      masterHover=false;
      masterExpanded=true;
    }
    //Settings.
    if(_selectedDestination == 4.1 || _selectedDestination ==4.2 ||_selectedDestination ==4.3 ){

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
  bool serviceHover = false;
  bool serviceExpanded=false;

  bool preSalesHover=false;
  bool preSalesExpanded=false;


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
                child: SizedBox(height: 40,
                  child: Icon(Icons.apps_rounded,
                    color: _selectedDestination == 0 ? Colors.blue: Colors.black54,),
                ),
              ): MouseRegion(
                  onHover: (event){
                    setState((){
                      homeHovered=true;
                    });
                  },
                  onExit: (event){
                    setState(() {
                      homeHovered=false;
                    });

                  },
                  child: Container(
                    color: homeHovered?mHoverColor:Colors.transparent,
                    child: ListTileTheme(
                      contentPadding: EdgeInsets.only(left: 0),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "/home");
                        },
                        leading: const SizedBox(width: 40,child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.apps_rounded),
                        ),),
                        title:    Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            drawerWidth == 60 ? '' : 'Home',

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Sales
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
              ): MouseRegion(
                  onHover: (event) {
                    setState(() {
                      if (serviceExpanded == false) {
                        serviceHover = true;
                      }
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      serviceHover = false;
                    });
                  },
                  child: Container(
                    color: serviceHover ? mHoverColor : Colors.transparent,
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                      child: Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            setState(() {
                              if (value) {
                                serviceExpanded = true;
                                serviceHover = false;
                              } else {
                                serviceExpanded = false;
                              }
                            });
                          },
                          initiallyExpanded: _selectedDestination == 1.1 || _selectedDestination==1.2 || _selectedDestination==1.21,
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
                              title: Center(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(drawerWidth == 60 ? '' : 'Purchase Orders'),
                                  ),
                                ),
                              ),
                              selected: _selectedDestination == 1.21,
                              onTap: () {
                                setState(() {
                                  _selectedDestination = 1.21;
                                });
                                Navigator.pushReplacementNamed(
                                  context,
                                  MotowsRoutes.estimateRoutes,
                                  arguments: DisplayEstimateItemsArgs(selectedDestination: 1.21, drawerWidth: widget.drawerWidth),
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Pre Sales.
                drawerWidth==60?InkWell(
                hoverColor: mHoverColor,
                onTap: (){
                  setState(() {
                    drawerWidth = 190;
                  });
                },
                child: SizedBox(height: 40,
                  child: Icon(Icons.money,
                    color: _selectedDestination == 2.1
                        ? Colors.blue: Colors.black54,),
                ),
              ): MouseRegion(
                onHover: (event) {
                  setState(() {
                    if (preSalesExpanded == false) {
                      preSalesHover = true;
                    }
                  });
                },
                onExit: (event) {
                  setState(() {
                    preSalesHover = false;
                  });
                },
                child: Container(
                  color: preSalesHover ? mHoverColor : Colors.transparent,
                  child: ListTileTheme(
                    contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                    child: Theme(
                      data: ThemeData().copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        onExpansionChanged: (value) {
                          setState(() {
                            if (value) {
                              preSalesExpanded = true;
                              preSalesHover = false;
                            } else {
                              preSalesExpanded = false;
                            }
                          });
                        },
                        initiallyExpanded: _selectedDestination == 2.1 ||_selectedDestination == 2.11||_selectedDestination == 2.12 || _selectedDestination==2.2 || _selectedDestination==2.3 ||
                        _selectedDestination==2.4,
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                          ),
                        ),
                        title: Text(drawerWidth == 60 ? '' : "Pre Sales", style: const TextStyle(fontSize: 16)),
                        leading: const SizedBox(
                          width: 40, // Set a specific width here, adjust as needed
                          child: Icon(Icons.money,),
                        ),
                        children: <Widget>[
                          // Your list tiles here.

                          ListTile(
                            hoverColor: mHoverColor,
                            selectedTileColor: Colors.blue,
                            selectedColor: Colors.white,
                            title: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(drawerWidth == 60 ? '' : 'Docket', style: const TextStyle(fontSize: 15)),
                            ),
                            selected: _selectedDestination == 2.11,
                            onTap: () {
                              setState(() {
                                _selectedDestination = 2.11;

                              });
                              Navigator.pushReplacementNamed(
                                context,
                                MotowsRoutes.docketList,
                                arguments: DocketListArgs(selectedDestination: 2.11, drawerWidth: widget.drawerWidth),
                              );
                            },
                          ),


                          ListTile(
                            hoverColor: mHoverColor,
                            selectedTileColor: Colors.blue,
                            selectedColor: Colors.white,
                            title: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(drawerWidth == 60 ? '' : 'Invoice', style: const TextStyle()),
                            ),
                            selected: _selectedDestination == 2.12,
                            onTap: () {
                              setState(() {
                                _selectedDestination = 2.12;

                              });
                              Navigator.pushReplacementNamed(
                                context,
                                MotowsRoutes.invoiceListRoute,
                                arguments: InvoiceArguments(selectedDestination: 2.12, drawerWidth: widget.drawerWidth),
                              );
                            },
                          ),

                          ListTile(
                            hoverColor: mHoverColor,
                            selectedTileColor: Colors.blue,
                            selectedColor: Colors.white,
                            title: Center(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(drawerWidth == 60 ? '' : 'Vehicle Orders'),
                                ),
                              ),
                            ),
                            selected: _selectedDestination == 2.1,
                            onTap: () {
                              setState(() {
                                _selectedDestination = 2.1;
                              });
                              Navigator.pushReplacementNamed(
                                context,
                                MotowsRoutes.listVehicle,
                                arguments: ListVehicleArguments(selectedDestination: 2.1, drawerWidth: widget.drawerWidth),
                              );
                            },
                          ),
                          ListTile(
                            hoverColor: mHoverColor,
                            selectedTileColor: Colors.blue,
                            selectedColor: Colors.white,
                            title: Center(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(drawerWidth == 60 ? '' : 'GRN'),
                                ),
                              ),
                            ),
                            selected: _selectedDestination == 2.2,
                            onTap: () {
                              setState(() {
                                _selectedDestination = 2.2;
                              });
                              Navigator.pushReplacementNamed(
                                context,
                                MotowsRoutes.listGrnItems,
                                arguments: ListGrnArguments(selectedDestination: 2.2, drawerWidth: widget.drawerWidth),
                              );
                            },
                          ),
                          // ListTile(
                          //   hoverColor: mHoverColor,
                          //   selectedTileColor: Colors.blue,
                          //   selectedColor: Colors.white,
                          //   title: Center(
                          //     child: Align(
                          //       alignment: Alignment.topLeft,
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(left: 15.0),
                          //         child: Text(drawerWidth == 60 ? '' : 'Vehicle Invoice'),
                          //       ),
                          //     ),
                          //   ),
                          //   selected: _selectedDestination == 2.3,
                          //   onTap: () {
                          //     setState(() {
                          //       _selectedDestination = 2.3;
                          //     });
                          //     Navigator.pushReplacementNamed(
                          //       context,
                          //       MotowsRoutes.listVehicleInvoice,
                          //       arguments: ListVehicleInvoiceArguments(selectedDestination: 2.3, drawerWidth: widget.drawerWidth),
                          //     );
                          //   },
                          // ),
                          ListTile(
                            hoverColor: mHoverColor,
                            selectedTileColor: Colors.blue,
                            selectedColor: Colors.white,
                            title: Center(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(drawerWidth == 60 ? '' : 'Add Items'),
                                ),
                              ),
                            ),
                            selected: _selectedDestination == 2.4,
                            onTap: () {
                              setState(() {
                                _selectedDestination = 2.4;
                              });
                              Navigator.pushReplacementNamed(
                                context,
                                MotowsRoutes.listAddItems,
                                arguments: ListAddItemsArguments(selectedDestination: 2.4, drawerWidth: widget.drawerWidth),
                              );
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
                // Master.
               drawerWidth ==60 ?InkWell(
                 hoverColor: mHoverColor,
                 onTap: (){
                   setState(() {
                     drawerWidth = 190;
                   });
                 },
                 child: SizedBox(height: 40,
                   child: Icon(Icons.person_search_sharp,
                     color: _selectedDestination == 2.1
                         ? Colors.blue: Colors.black54,),
                 ),
               ): MouseRegion(
                 onHover: (event) {
                   setState(() {
                     if (masterExpanded == false) {
                       masterHover = true;
                     }
                   });
                 },
                 onExit: (event) {
                   setState(() {
                     masterHover = false;
                   });
                 },
                 child: Container(
                   color: masterHover ? mHoverColor : Colors.transparent,
                   child: ListTileTheme(
                     contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                     child: Theme(
                       data: ThemeData().copyWith(dividerColor: Colors.transparent),
                       child: ExpansionTile(
                         onExpansionChanged: (value) {
                           setState(() {
                             if (value) {
                               masterExpanded = true;
                               masterHover = false;
                             } else {
                               masterExpanded = false;
                             }
                           });
                         },
                         initiallyExpanded: _selectedDestination == 3.1 || _selectedDestination==3.2,
                         trailing: Padding(
                           padding: const EdgeInsets.only(right: 10.0),
                           child: Icon(
                             Icons.keyboard_arrow_down,
                             color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                           ),
                         ),
                         title: Text(drawerWidth == 60 ? '' : "Master", style: const TextStyle(fontSize: 16)),
                         leading: const SizedBox(
                           width: 40, // Set a specific width here, adjust as needed
                           child: Icon(Icons.person_search_sharp,),
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
                                   child: Text(drawerWidth == 60 ? '' : 'Vehicle Master'),
                                 ),
                               ),
                             ),
                             selected: _selectedDestination == 3.1,
                             onTap: () {
                               setState(() {
                                 _selectedDestination = 3.1;
                               });
                               Navigator.pushReplacementNamed(
                                 context,
                                 MotowsRoutes.vehicleMaster,
                                 arguments: VehicleMasterArguments(selectedDestination: 3.1, drawerWidth: widget.drawerWidth),
                               );
                             },
                           ),
                           ListTile(
                             hoverColor: mHoverColor,
                             selectedTileColor: Colors.blue,
                             selectedColor: Colors.white,
                             title: Center(
                               child: Align(
                                 alignment: Alignment.topLeft,
                                 child: Padding(
                                   padding: const EdgeInsets.only(left: 15.0),
                                   child: Text(drawerWidth == 60 ? '' : 'TAX'),
                                 ),
                               ),
                             ),
                             selected: _selectedDestination == 3.2,
                             onTap: () {
                               setState(() {
                                 _selectedDestination = 3.2;
                               });
                               Navigator.pushReplacementNamed(
                                 context,
                                 MotowsRoutes.listTaxDetailsRoutes,
                                 arguments: ListTaxDetailsArgs(selectedDestination: 3.2, drawerWidth: widget.drawerWidth),
                               );
                             },
                           ),

                         ],
                       ),
                     ),
                   ),
                 ),
               ),
                //Settings.
                drawerWidth==60?InkWell(  hoverColor: mHoverColor,
                  onTap: (){
                    setState(() {
                      drawerWidth = 190;
                    });
                  },
                  child: SizedBox(height: 45,
                    child: Icon(Icons.settings,color:_selectedDestination ==4.1
                        ||_selectedDestination==4.2
                        ||_selectedDestination==4.3
                        ? Colors.blue: Colors.black54,),
                  ),
                ): MouseRegion(
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
                    child: Theme(
                      data: ThemeData().copyWith(dividerColor: Colors.transparent),
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
                        initiallyExpanded: _selectedDestination == 4.1 || _selectedDestination == 4.2 ||
                            _selectedDestination == 4.3,
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
                              selected: _selectedDestination == 4.1,
                              onTap: () { setState(() {
                                _selectedDestination=4.1;
                              });
                              Navigator.pushReplacementNamed(context, MotowsRoutes.companyManagement,arguments: CompanyManagementArguments(drawerWidth: widget.drawerWidth, selectedDestination: 4.1));
                              }
                          ),
                          ListTile(
                              title: Center(child: Align(alignment: Alignment.topLeft,
                                  child: Text(drawerWidth == 60 ? "" : 'User Management'))),
                              selected: _selectedDestination == 4.2,
                              hoverColor:mHoverColor,
                              selectedTileColor: Colors.blue,
                              selectedColor: Colors.white,
                              onTap: () {
                                setState(() {
                                  _selectedDestination=4.2;
                                });
                                Navigator.pushReplacementNamed(context, MotowsRoutes.userManagement,arguments: UserManagementArguments(drawerWidth: widget.drawerWidth, selectedDestination: 4.2));
                              }
                          ),
                          ListTile(
                              title: Center(child: Align(alignment: Alignment.topLeft,
                                  child: Text(drawerWidth == 60 ? "" : 'Upload'))),
                              selected: _selectedDestination == 4.3,
                              hoverColor:mHoverColor,
                              selectedTileColor: Colors.blue,
                              selectedColor: Colors.white,
                              onTap: () {
                                setState(() {
                                  _selectedDestination=4.3;
                                });
                                Navigator.pushReplacementNamed(context, MotowsRoutes.uploadData,arguments: UploadDataArguments(drawerWidth: widget.drawerWidth, selectedDestination: 4.3));
                                // Navigator.pushReplacementNamed(context, MotowsRoutes.listItemRoute,arguments: ListItemsArgs(title: 1, drawerWidth: widget.drawerWidth, selectedDestination: _selectedDestination));
                              }
                          ),
                        ],
                      ),
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






