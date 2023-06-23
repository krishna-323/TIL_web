
import 'package:flutter/material.dart';
import 'package:new_project/pre_sales/add_items/list_items.dart';
import 'package:new_project/pre_sales/grn/list_grn.dart';
import 'package:new_project/pre_sales/master/vehicle_master.dart';
import 'package:new_project/pre_sales/purchase_orders/purchase_orders_list.dart';
import 'package:new_project/pre_sales/vehicle_invoice/list_vehicle_invoice.dart';
import 'package:new_project/pre_sales/vehicle_orders/list_vechile_orders.dart';
import 'package:new_project/upload_po/upload_po.dart';
import 'package:new_project/user_mangment/display_user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'classes/arguments_classes/arguments_classes.dart';
import 'classes/motows_routes.dart';
import 'company_management/list_companies.dart';
import 'customer/list_customer.dart';
import 'dashboard/home_screen.dart';
import 'docket/docket_list.dart';
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
        initialRoute: "home",
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

            case MotowsRoutes.listVehicle:{
              ListVehicleArguments listVehicleArguments;if(settings.arguments!=null){
                listVehicleArguments =settings.arguments as ListVehicleArguments;
              }
              else{
                listVehicleArguments = ListVehicleArguments(drawerWidth:190 ,selectedDestination:2.1 );
              }
              newScreen = ListVehicleOrders(arg:listVehicleArguments);
            }
            break;
            case MotowsRoutes.listGrnItems:{
              ListGrnArguments listGrn;if(settings.arguments!=null){
                listGrn =settings.arguments as ListGrnArguments;
              }
              else{
                listGrn =ListGrnArguments(drawerWidth: 190, selectedDestination: 2.2);
              }
              newScreen =ListGrnItems(arg:listGrn);
            }
            break;
            // list vehicle.
            case MotowsRoutes.listVehicleInvoice:{
              ListVehicleInvoiceArguments listVehicleInvoiceArguments;if(settings.arguments!=null){
                listVehicleInvoiceArguments =settings.arguments as ListVehicleInvoiceArguments;
              }
              else{
                listVehicleInvoiceArguments =ListVehicleInvoiceArguments(drawerWidth: 190, selectedDestination: 2.3);
              }
              newScreen = ListVehicleInvoice(arg:listVehicleInvoiceArguments);
            }
            break;
            case MotowsRoutes.listAddItems:{
              ListAddItemsArguments listAddItemsArguments;if(settings.arguments!=null){
                listAddItemsArguments = settings.arguments as ListAddItemsArguments;
              }
              else{
                listAddItemsArguments = ListAddItemsArguments(drawerWidth: 190, selectedDestination: 2.4);
              }
              newScreen = ListItems(arg:listAddItemsArguments);
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
                    drawerWidth: 190, selectedDestination: 2.5);
              }
              newScreen= DisplayEstimateItems(args: displayEstimateItemsArgs,);
            }
            break;
            case MotowsRoutes.vehicleMaster:{
              VehicleMasterArguments vehicleMasterArguments;
              if(settings.arguments!=null){
                vehicleMasterArguments =settings.arguments as VehicleMasterArguments;
              }
              else{
                vehicleMasterArguments = VehicleMasterArguments(drawerWidth: 190, selectedDestination: 3.1);
              }
              newScreen = VehicleMaster(arg:vehicleMasterArguments);
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
                      drawerWidth: 190, selectedDestination: 4.1);
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
                      drawerWidth: 190, selectedDestination: 4.2);
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
                      drawerWidth: 190, selectedDestination: 4.3);
                }
                newScreen = UploadPO(args: uploadDataArguments );
              }
              break;
            case MotowsRoutes.docketList :
              {
                DocketListArgs docketListArgs;
                if(settings.arguments!=null){
                  docketListArgs = settings.arguments as DocketListArgs ;
                }
                else {
                  docketListArgs = DocketListArgs(
                      drawerWidth: 190, selectedDestination: 2.11);
                }
                newScreen = DocketList(args: docketListArgs );
              }
              break;
            default: newScreen = const InitialScreen();
          }
          return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => newScreen,
              reverseTransitionDuration: Duration.zero,transitionDuration: Duration.zero,settings: settings);
        },
        routes: {
          'home':(context)=> const InitialScreen(),
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
          ? const Center(child: SizedBox(width: 100,height: 100,child: CircularProgressIndicator()))
          : authToken == ""
          ? const LoginPage(): const MyHomePage(),
      //ListPurchaseOrder(drawerWidth: 190,selectedDestination: 4.2, title: 1,)

    );
  }
}
