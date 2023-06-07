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
              ListTile(
                  hoverColor:mHoverColor,
                  selectedTileColor: Colors.blue,
                  selectedColor: Colors.white,
                  leading: const Icon(Icons.apps_rounded),
                  title: Text(drawerWidth == 60 ? "" : 'Home'),
                  selected: _selectedDestination == 0,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  }),

              //Services
              drawerWidth==60?InkWell(
                hoverColor: mHoverColor,
                onTap: (){
                  setState(() {
                    drawerWidth = 190;
                  });
                },
                child: ListTile(
                  leading: Icon(Icons.person,
                    color: _selectedDestination == 1.1
                        || _selectedDestination ==1.2
                        ? Colors.blue: Colors.black54,),
                ),
              ):
              MouseRegion(
                onHover: (event) {
                  setState(() {
                    if(salesExpanded==false){
                      salesHovered=true;
                    }
                  });
                },
                onExit: (event) {
                  setState(() {
                    salesHovered=false;
                  });
                },
                child: Container(
                  color: salesHovered?mHoverColor:Colors.transparent,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: const Color(0xffe7e4e4)),
                    child: ExpansionTile(
                      onExpansionChanged: (value) {
                        setState(() {
                          if(value){
                            salesExpanded=true;
                            salesHovered=false;
                          }
                          else{
                            salesExpanded=false;
                          }
                        });
                      },
                      initiallyExpanded: _selectedDestination == 1.1 || _selectedDestination ==1.2,
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        color: drawerWidth ==60 ? Colors.transparent: Colors.black87,
                      ),
                      title: Text(drawerWidth ==60 ? '' : "Service",style: const TextStyle(fontSize: 16),),
                      leading: const Icon(Icons.person),
                      children:<Widget> [
                        //New Customer.
                        ListTile(hoverColor: mHoverColor,
                          selectedTileColor: Colors.blue,
                          selectedColor: Colors.white,
                          title: Center(child: Align(alignment: Alignment.topLeft,
                              child: Text(drawerWidth == 60 ? "" : 'New Customer',))),

                          selected: _selectedDestination == 1.1,
                          onTap: (){
                            setState(() {
                              _selectedDestination=1.1;

                            });
                            Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 1.1,drawerWidth: widget.drawerWidth));

                          },
                        ),
                        //Estimate.
                        ListTile(
                            hoverColor: mHoverColor,
                            selectedTileColor: Colors.blue,
                            selectedColor: Colors.white,
                            //  leading: const Icon(Icons.home),
                            title: Text(drawerWidth == 60 ? "" : 'Purchase Order',style: const TextStyle(fontSize: 15),),
                            selected: _selectedDestination == 1.2,
                            onTap: () { setState(() {
                              _selectedDestination=1.2;
                            });
                            Navigator.pushReplacementNamed(context, MotowsRoutes.estimateRoutes,arguments: DisplayEstimateItemsArgs(selectedDestination: 1.2,drawerWidth: widget.drawerWidth));

                              //     Navigator.pushReplacementNamed(context, MotowsRoutes.docketRoute,arguments: DocketArgs(drawerWidth: widget.drawerWidth, selectedDestination: 0.2));
                            }
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
                  child: ListTile(leading: Icon(Icons.settings,color:_selectedDestination ==2.1
                      ||_selectedDestination==2.2
                      ||_selectedDestination==2.3
                      ||_selectedDestination==2.4
                      ? Colors.blue: Colors.black54,),
                  ),
                ):
                MouseRegion(
                  onHover: (event) {
                    setState(() {
                      if(settingsExpanded==false){
                        settingsHover=true;
                      }

                    });
                  },
                  onExit: (event) {
                    setState(() {
                      settingsHover=false;
                    });
                  },
                  child: Container(
                    color: settingsHover?mHoverColor:Colors.transparent,
                    child: ExpansionTile(
                      onExpansionChanged: (value) {

                        setState(() {
                          if(value){
                            settingsExpanded=true;
                            settingsHover=false;
                          }
                          else{
                            setState(() {
                              settingsExpanded=false;
                            });
                          }
                        });

                      },
                      initiallyExpanded:  _selectedDestination == 2.1||
                          _selectedDestination==2.2 ||
                          _selectedDestination==2.3||
                          _selectedDestination==2.4,


                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        color: drawerWidth == 60 ?Colors.transparent : Colors.black87,
                      ),

                      title: Text(drawerWidth == 60 ? "" :"Settings"),
                      leading: const Icon(Icons.settings),
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
                        // ListTile(
                        //     title: Center(child: Align(alignment: Alignment.topLeft,
                        //         child: Text(drawerWidth == 60 ? "" : 'Prices'))),
                        //     selected: _selectedDestination == 2.4,
                        //     hoverColor: mHoverColor,
                        //     selectedTileColor: Colors.blue,
                        //     selectedColor: Colors.white,
                        //     onTap: () {
                        //       setState(() {
                        //         _selectedDestination=2.4;
                        //       });
                        //       Navigator.pushReplacementNamed(context, MotowsRoutes.pricesRoute,arguments: PricesArguments(drawerWidth: widget.drawerWidth, selectedDestination: 2.4));
                        //       // Navigator.pushReplacementNamed(context, MotowsRoutes.listItemRoute,arguments: ListItemsArgs(title: 1, drawerWidth: widget.drawerWidth, selectedDestination: _selectedDestination));
                        //     }
                        // ),
                      ],
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
