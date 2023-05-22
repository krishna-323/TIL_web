// @dart=2.9

import 'package:flutter/material.dart';
import 'package:new_project/service/estimate/display_estimate_items.dart';
import 'package:new_project/upload_po/prices.dart';
import 'package:new_project/upload_po/upload_po.dart';
import 'package:new_project/user_mangment/display_user_list.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'classes/arguments_classes/arguments_classes.dart';
import 'classes/motows_routes.dart';
import 'company_management/list_companies.dart';
import 'customer/list_customer.dart';
import 'home_screen.dart';
import 'login_screen.dart';




// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// //   await Firebase.initializeApp(
// //     options: FirebaseOptions(
// //     apiKey: "AIzaSyCMUDeQQpWJ5XpyaRVB_VxEzBPqtblMpc4",
// //     appId: "1:825678600993:web:de4c711605da1df53f3c60",
// //     messagingSenderId: "825678600993",
// //     projectId: "motowsweb",
// //   ),);
// //
// // // Ideal time to initialize
// //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//   //setPathUrlStrategy();
//   runApp(const MyApp());
// }

main(){
  runApp(MaterialApp(home:MyApp() ,debugShowCheckedModeBanner: false,));
}
class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PageController page = PageController();
  @override
  Widget build(BuildContext context) {


    return  MaterialApp(
        title: 'Motows Web',
        initialRoute: "dashboard",
        onGenerateRoute: (settings){
          Widget newScreen;
          switch (settings.name){
            case  MotowsRoutes.customerListRoute: newScreen = ViewCustomerList(arg: settings.arguments ?? CustomerArguments(drawerWidth: 190, selectedDestination: 0.1),);
            break;
            case MotowsRoutes.estimateRoutes:newScreen=DisplayEstimateItems(args:settings.arguments?? DisplayEstimateItemsArgs(drawerWidth: 190,selectedDestination: 0.2));
            break;
            case MotowsRoutes.companyManagement:newScreen= CompanyManagement(args:settings.arguments ?? CompanyManagementArguments(drawerWidth: 190, selectedDestination: 7.1));
            break;
            case MotowsRoutes.userManagement:newScreen = UserManagement(args : settings.arguments ?? UserManagementArguments(drawerWidth:190,selectedDestination:7.1));
            break;
            case MotowsRoutes.uploadData : newScreen = UploadPO(args: settings.arguments ?? UploadDataArguments(drawerWidth:190, selectedDestination: 5.4));
            break;
            case MotowsRoutes.pricesRoute : newScreen = Prices(args: settings.arguments ?? PricesArguments(drawerWidth:190, selectedDestination: 7.1));
            break;
            default: newScreen = MyHomePage();
          }
          return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => newScreen,
              reverseTransitionDuration: Duration.zero,transitionDuration: Duration.zero,settings: settings);
        },
        routes: {
          "dashboard":(context) => const InitialScreen(),
          MotowsRoutes.homeRoute:(context) => MyHomePage(),
        },
        theme: ThemeData(useMaterial3: true,
            backgroundColor: primaryColor,
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
  const InitialScreen({Key key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {


  String  authToken;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    getLoginData().whenComplete(() {
      isLoading=false;
    });
    // fireStore.collection('registeredUser').get().then((snapshot) {
    //   for (DocumentSnapshot ds in snapshot.docs){
    //     ds.reference.delete();
    //   }});
  }


  Future getLoginData() async {
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
          ? const LoginPage():
      MyHomePage(),
      //ListPurchaseOrder(drawerWidth: 190,selectedDestination: 4.2, title: 1,)

    );
  }
}
