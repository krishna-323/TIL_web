
import 'package:flutter/material.dart';
import 'package:new_project/service/estimate/display_estimate_items.dart';
import 'package:new_project/upload_po/prices.dart';
import 'package:new_project/upload_po/upload_po.dart';
import 'package:new_project/user_mangment/display_user_list.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'classes/arguments_classes/arguments_classes.dart';
import 'classes/motows_routes.dart';
import 'company_management/list_companies.dart';
import 'customer/list_customer.dart';
import 'home_screen.dart';
import 'login_screen.dart';





 main() async {
  setPathUrlStrategy();
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PageController page = PageController();
  @override
  Widget build(BuildContext context) {


    return  MaterialApp(
        title: 'Vendor Management',
        initialRoute: "dashboard",
        onGenerateRoute: (RouteSettings settings){
          Widget newScreen;
          switch (settings.name){
            case  MotowsRoutes.customerListRoute: {
              CustomerArguments customerArg;
              if(settings.arguments!=null){
                 customerArg = settings.arguments as CustomerArguments ;
              }
              else {
                 customerArg = CustomerArguments(
                    drawerWidth: 190, selectedDestination: 1.1);
              }
              newScreen = ViewCustomerList(arg: customerArg);
            }
            break;
            case
            MotowsRoutes.estimateRoutes:{
              DisplayEstimateItemsArgs displayEstimateItemsArgs;
              if(settings.arguments!=null){
                displayEstimateItemsArgs = settings.arguments as DisplayEstimateItemsArgs ;
              }
              else {
                displayEstimateItemsArgs = DisplayEstimateItemsArgs(
                    drawerWidth: 190, selectedDestination: 1.1);
              }
              newScreen=DisplayEstimateItems(args: displayEstimateItemsArgs,);
            }
            break;
            case MotowsRoutes.companyManagement:
              {
                CompanyManagementArguments companyManagementArguments;
                if(settings.arguments!=null){
                  companyManagementArguments = settings.arguments as CompanyManagementArguments ;
                }
                else {
                  companyManagementArguments = CompanyManagementArguments(
                      drawerWidth: 190, selectedDestination: 1.1);
                }

                newScreen = CompanyManagement(args: companyManagementArguments);
              }
                break;
            case MotowsRoutes.userManagement:
              {
                UserManagementArguments userManagement;

                if(settings.arguments!=null){
                  userManagement = settings.arguments as UserManagementArguments ;
                }
                else {
                  userManagement = UserManagementArguments(
                      drawerWidth: 190, selectedDestination: 1.1);
                }

                newScreen = UserManagement(args : userManagement);
              }
              break;

            case MotowsRoutes.uploadData :
              {
                UploadDataArguments uploadDataArguments;

                if(settings.arguments!=null){
                  uploadDataArguments = settings.arguments as UploadDataArguments ;
                }
                else {
                  uploadDataArguments = UploadDataArguments(
                      drawerWidth: 190, selectedDestination: 1.1);
                }

                newScreen = UploadPO(args: uploadDataArguments );
              }
              break;

            case MotowsRoutes.pricesRoute : newScreen = Prices(args: settings.arguments ?? PricesArguments(drawerWidth:190, selectedDestination: 7.1));
            break;
            default: newScreen = MyHomePage();
          }
          return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => newScreen,
              reverseTransitionDuration: Duration.zero,transitionDuration: Duration.zero,settings: settings);
        },
        routes: {
          'home':(context)=> MyHomePage(),
          "dashboard":(context) => const InitialScreen(),
          MotowsRoutes.homeRoute:(context) => MyHomePage(),
        },
        theme: ThemeData(useMaterial3: true,

           // colorScheme: ColorScheme(background:primaryColor, brightness: Brightness.dark, primary: Colors.black, onPrimary: Colors.black, secondary: Colors.blue, onSecondary: Colors.black, error: primaryColor, onError: primaryColor, onBackground: Colors.black, surface: Colors.blue, onSurface: primaryColor),
            fontFamily: 'TitilliumWeb'
        ),
        debugShowCheckedModeBanner: false,
        home:
        //MainPage()
        const InitialScreen()
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {


  String?  authToken;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    getLoginData().whenComplete(() {
      isLoading=false;
    });
  }


   getLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authToken = prefs.getString("authToken")??"";
      isLoading=false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : authToken == ""
          ? const LoginPage(): MyHomePage(),
      //ListPurchaseOrder(drawerWidth: 190,selectedDestination: 4.2, title: 1,)

    );
  }
}
