import 'package:flutter/material.dart';
import 'package:new_project/utils/customAppBar.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_bloc/cart_items_bloc.dart';
import 'classes/arguments_classes/arguments_classes.dart';
import 'classes/motows_routes.dart';
import 'dashboard/kpi_card.dart';
import 'home_screen/charts_views.dart';
import 'utils/customDrawer.dart';


class MyHomePage extends StatefulWidget {


  MyHomePage({Key? key,}) : super(key: key);
  // static String homeRoute = "/home";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double drawerWidth =190;

  Future getInitialData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getString('role')=="Admin") {
        bloc.setLoginStatus(true);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialData();
  }
  Map snap ={};

  @override
  Widget build(BuildContext context) {
    //return AddNewPurchaseOrder(drawerWidth: 180,selectedDestination: 4.2,);
    return StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.allItems,
      builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
           print(snapshot.data['admin']);
          }

        return Scaffold(
          appBar: const PreferredSize(    preferredSize: Size.fromHeight(60),
              child: CustomAppBar2()),
          body: Row(
            children: [
              CustomDrawer(drawerWidth,0),
              const VerticalDivider(
                width: 1,
                thickness: 1,
              ),
              const Expanded(child: HomeScreen()),
            ],
          ),
        );
      }
    );
  }


}

class HomeScreen extends StatefulWidget {

  const HomeScreen( {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late double screenWidth;
  late double screenHeight;
  String imageUrl = "";


  @override
  void initState() {
    super.initState();
    if(customersList.length>5){
      for(int i=0;i<5;i++){
        setState(() {
          // taking five data's and adding to another list(this list).
          displayList.add(customersList[i]);
        });

      }
    }

    if(grnList.length>5){
      for(int i=0;i<5;i++){
        setState(() {
          fiveGrnList.add(grnList[i]);
        });
      }
    }
  }














  List customersList=[
    {
      "newcustomer_id": "NWCUS_01075",
      "customer_type": "Individual",
      "primary_contact": "Ms.",
      "first_name": "Rahul",
      "last_name": "N C",
      "company_name": "Ikyam",
      "customer_display_name": "Rahul N C",
      "customer_email": "rahul@gmail.com",
      "customer_phone": "7868768768",
      "website": "www.rahul.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "prakash",
      "email_address": "",
      "work_phone": "",
      "mobile": "8768767",
      "currency": "Indian Rupee",
      "opening_balance": "323",
      "exchange_rate": "",
      "payment_terms": "Net 45",
      "price_list": "Price book3[1% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "attention",
      "billing_country": "India",
      "billing_address_street1": "addreass",
      "billing_address_street2": "addreess",
      "billing_city": "city",
      "billing_state": "state",
      "billing_zipcode": "87687",
      "billing_phone": "87687",
      "billing_fax": "faa",
      "shipping_attention": "attention",
      "shipping_country": "India",
      "shipping_address_street1": "addreass",
      "shipping_address_street2": "addreess",
      "shipping_city": "city",
      "shipping_state": "state",
      "shipping_zipcode": "87687",
      "shipping_phone": "87687",
      "shipping_fax": "faa",
      "exemption_reason": "",
      "gst_treatment": "Registred Business",
      "place_of_supply": "[AR] Arunachal Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_01157",
      "customer_type": "Individual",
      "primary_contact": "Mr.",
      "first_name": "Joy",
      "last_name": "Roy",
      "company_name": "Ikyam",
      "customer_display_name": "Joy",
      "customer_email": "joy@roy.com",
      "customer_phone": "5464646234",
      "website": "www.joy.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "prakash",
      "email_address": "",
      "work_phone": "",
      "mobile": "4564523423",
      "currency": "Indian Rupee",
      "opening_balance": "4343",
      "exchange_rate": "",
      "payment_terms": "Due on Recipt ",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "atten",
      "billing_country": "India",
      "billing_address_street1": "addressd",
      "billing_address_street2": "dsfds",
      "billing_city": "sdfsd",
      "billing_state": "sdfasd",
      "billing_zipcode": "3434",
      "billing_phone": "43434",
      "billing_fax": "433443",
      "shipping_attention": "atten",
      "shipping_country": "India",
      "shipping_address_street1": "addressd",
      "shipping_address_street2": "dsfds",
      "shipping_city": "sdfsd",
      "shipping_state": "sdfasd",
      "shipping_zipcode": "3434",
      "shipping_phone": "43434",
      "shipping_fax": "433443",
      "exemption_reason": "",
      "gst_treatment": "Registred Business",
      "place_of_supply": "[AR] Arunachal Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_02730",
      "customer_type": "Individual",
      "primary_contact": "Mr.",
      "first_name": "Babu",
      "last_name": "M R",
      "company_name": "Ikyam",
      "customer_display_name": "Babu M R",
      "customer_email": "babu@email.com",
      "customer_phone": "9033449223",
      "website": "www.babu.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "prakash",
      "email_address": "",
      "work_phone": "",
      "mobile": "8801334345",
      "currency": "INR",
      "opening_balance": "3000",
      "exchange_rate": "",
      "payment_terms": "Due on Receipt ",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "Krishna",
      "billing_country": "India",
      "billing_address_street1": "Hoskote",
      "billing_address_street2": "Hoskote Toll",
      "billing_city": "Bangalore",
      "billing_state": "karnataka",
      "billing_zipcode": "560023",
      "billing_phone": "8830202020",
      "billing_fax": "bababa",
      "shipping_attention": "Krishna",
      "shipping_country": "India",
      "shipping_address_street1": "Hoskote",
      "shipping_address_street2": "Hoskote Toll",
      "shipping_city": "Bangalore",
      "shipping_state": "karnataka",
      "shipping_zipcode": "560023",
      "shipping_phone": "8830202020",
      "shipping_fax": "bababa",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AD] Andhra Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_02731",
      "customer_type": "Individual",
      "primary_contact": "Mr.",
      "first_name": "Ajay",
      "last_name": "Malya",
      "company_name": "RCB",
      "customer_display_name": "King",
      "customer_email": "ajay@malya.com",
      "customer_phone": "238971",
      "website": "www.rcb.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "prakash",
      "email_address": "",
      "work_phone": "",
      "mobile": "9934032823",
      "currency": "INR",
      "opening_balance": "202000",
      "exchange_rate": "",
      "payment_terms": "Due on Receipt ",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "ajay",
      "billing_country": "India",
      "billing_address_street1": "UB city",
      "billing_address_street2": "MG Road",
      "billing_city": "Bangalore",
      "billing_state": "Karnataka",
      "billing_zipcode": "560023",
      "billing_phone": "54533",
      "billing_fax": "232332",
      "shipping_attention": "ajay",
      "shipping_country": "India",
      "shipping_address_street1": "UB city",
      "shipping_address_street2": "MG Road",
      "shipping_city": "Bangalore",
      "shipping_state": "Karnataka",
      "shipping_zipcode": "560023",
      "shipping_phone": "54533",
      "shipping_fax": "232332",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[KA] Karnataka",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_02732",
      "customer_type": "Individual",
      "primary_contact": "Mr.",
      "first_name": "Tejas",
      "last_name": "J",
      "company_name": "Ikyam",
      "customer_display_name": "TJ",
      "customer_email": "tejas@email.com",
      "customer_phone": "8839202020",
      "website": "www.tejas.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "prakash",
      "email_address": "",
      "work_phone": "",
      "mobile": "9900122232",
      "currency": "INR",
      "opening_balance": "300000",
      "exchange_rate": "",
      "payment_terms": "Net 45",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "Tejas",
      "billing_country": "India",
      "billing_address_street1": "Koramangala",
      "billing_address_street2": "Bannerughatta Road",
      "billing_city": "Bengalore",
      "billing_state": "Karnataka",
      "billing_zipcode": "560023",
      "billing_phone": "8867698345",
      "billing_fax": "343434",
      "shipping_attention": "Tejas",
      "shipping_country": "India",
      "shipping_address_street1": "Koramangala",
      "shipping_address_street2": "Bannerughatta Road",
      "shipping_city": "Bengalore",
      "shipping_state": "Karnataka",
      "shipping_zipcode": "560023",
      "shipping_phone": "8867698345",
      "shipping_fax": "343434",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[BO] Bombay",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_02733",
      "customer_type": "yes",
      "primary_contact": "Mr.",
      "first_name": "Sathya",
      "last_name": "Prakash",
      "company_name": "Ikyam",
      "customer_display_name": "Sathya",
      "customer_email": "sathya@email.com",
      "customer_phone": "33456",
      "website": "www.sathya.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "",
      "email_address": "",
      "work_phone": "",
      "mobile": "9883249234",
      "currency": "INR",
      "opening_balance": "34534",
      "exchange_rate": "",
      "payment_terms": "Due on Receipt ",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "Sathya",
      "billing_country": "India",
      "billing_address_street1": "Hoskote",
      "billing_address_street2": "Eejipura",
      "billing_city": "Bengalore",
      "billing_state": "Karnataka",
      "billing_zipcode": "560045",
      "billing_phone": "9034395000",
      "billing_fax": "343422",
      "shipping_attention": "Sathya",
      "shipping_country": "India",
      "shipping_address_street1": "Hoskote",
      "shipping_address_street2": "Eejipura",
      "shipping_city": "Bengalore",
      "shipping_state": "Karnataka",
      "shipping_zipcode": "560045",
      "shipping_phone": "9034395000",
      "shipping_fax": "343422",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AD] Andhra Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_02735",
      "customer_type": "yes",
      "primary_contact": "Mr.",
      "first_name": "Rishab",
      "last_name": "Panth",
      "company_name": "DC",
      "customer_display_name": "Panda",
      "customer_email": "panth@rishab.com",
      "customer_phone": "235678",
      "website": "www.rishab.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "",
      "email_address": "",
      "work_phone": "",
      "mobile": "8967678905",
      "currency": "INR",
      "opening_balance": "500000",
      "exchange_rate": "",
      "payment_terms": "Due on Receipt ",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "SpiderMan",
      "billing_country": "India",
      "billing_address_street1": "Dehradun",
      "billing_address_street2": "Haridwar",
      "billing_city": "Haridwar",
      "billing_state": "Delhi",
      "billing_zipcode": "458833",
      "billing_phone": "8967664564",
      "billing_fax": "4534",
      "shipping_attention": "SpiderMan",
      "shipping_country": "India",
      "shipping_address_street1": "Dehradun",
      "shipping_address_street2": "Haridwar",
      "shipping_city": "Haridwar",
      "shipping_state": "Delhi",
      "shipping_zipcode": "458833",
      "shipping_phone": "8967664564",
      "shipping_fax": "4534",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AD] Andhra Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03314",
      "customer_type": "Individual",
      "primary_contact": "Miss",
      "first_name": "Joy",
      "last_name": "Nc",
      "company_name": "ikyam",
      "customer_display_name": "d",
      "customer_email": "rahul@gmail.com",
      "customer_phone": "9877678887",
      "website": "rahul",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "prakash",
      "email_address": "",
      "work_phone": "",
      "mobile": "8787658687",
      "currency": "Australia dollar",
      "opening_balance": "5555",
      "exchange_rate": "",
      "payment_terms": "Net 45",
      "price_list": "Price book3[1% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "a",
      "billing_country": "Afghanistan",
      "billing_address_street1": "bng",
      "billing_address_street2": "bng",
      "billing_city": "bng",
      "billing_state": "kar",
      "billing_zipcode": "556006",
      "billing_phone": "876867",
      "billing_fax": "f",
      "shipping_attention": "a",
      "shipping_country": "Afghanistan",
      "shipping_address_street1": "bng",
      "shipping_address_street2": "bng",
      "shipping_city": "bng",
      "shipping_state": "kar",
      "shipping_zipcode": "556006",
      "shipping_phone": "876867",
      "shipping_fax": "f",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AS] Assam",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03315",
      "customer_type": "Individual",
      "primary_contact": "Mr.",
      "first_name": "Tejas",
      "last_name": "Rao",
      "company_name": "ikyam",
      "customer_display_name": "ikaym",
      "customer_email": "tejas@gmail.com",
      "customer_phone": "8768776576",
      "website": "tejas.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "prakash",
      "email_address": "",
      "work_phone": "",
      "mobile": "8658768968",
      "currency": "Australia dollar",
      "opening_balance": "4444444",
      "exchange_rate": "",
      "payment_terms": "Net 45",
      "price_list": "Price book3[1% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "bng",
      "billing_country": "Afghanistan",
      "billing_address_street1": "bng",
      "billing_address_street2": "bng",
      "billing_city": "bng",
      "billing_state": "karna",
      "billing_zipcode": "876587",
      "billing_phone": "9887",
      "billing_fax": "f",
      "shipping_attention": "bng",
      "shipping_country": "Afghanistan",
      "shipping_address_street1": "bng",
      "shipping_address_street2": "bng",
      "shipping_city": "bng",
      "shipping_state": "karna",
      "shipping_zipcode": "876587",
      "shipping_phone": "9887",
      "shipping_fax": "f",
      "exemption_reason": "",
      "gst_treatment": "Registered Business Composition",
      "place_of_supply": "[GO] Goa",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03316",
      "customer_type": "Individual",
      "primary_contact": "Mr.",
      "first_name": "Rahul",
      "last_name": "NC",
      "company_name": "NCR",
      "customer_display_name": "Rahul",
      "customer_email": "rahul.nc@ikyam.com",
      "customer_phone": "8989929292",
      "website": "www.ncr.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "prakash",
      "email_address": "",
      "work_phone": "",
      "mobile": "238971",
      "currency": "INR",
      "opening_balance": "55000",
      "exchange_rate": "",
      "payment_terms": "Due on Receipt ",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "a",
      "billing_country": "India",
      "billing_address_street1": "Kolar",
      "billing_address_street2": "koramangala",
      "billing_city": "Bangalore",
      "billing_state": "Karnataka",
      "billing_zipcode": "563101",
      "billing_phone": "232323",
      "billing_fax": "32323",
      "shipping_attention": "a",
      "shipping_country": "India",
      "shipping_address_street1": "Kolar",
      "shipping_address_street2": "koramangala",
      "shipping_city": "Bangalore",
      "shipping_state": "Karnataka",
      "shipping_zipcode": "563101",
      "shipping_phone": "232323",
      "shipping_fax": "32323",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AD] Andhra Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03317",
      "customer_type": "yes",
      "primary_contact": "Mr.",
      "first_name": "Manohar",
      "last_name": "Rao",
      "company_name": "ikyam",
      "customer_display_name": "manohar",
      "customer_email": "manohar@gmail.com",
      "customer_phone": "9988767687",
      "website": "man",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "",
      "email_address": "",
      "work_phone": "",
      "mobile": "7867677876",
      "currency": "Australia dollar",
      "opening_balance": "75776567",
      "exchange_rate": "",
      "payment_terms": "Net 45",
      "price_list": "Price book3[1% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "a",
      "billing_country": "India",
      "billing_address_street1": "bng",
      "billing_address_street2": "bng",
      "billing_city": "bng",
      "billing_state": "bng",
      "billing_zipcode": "560055",
      "billing_phone": "9998766444",
      "billing_fax": "d",
      "shipping_attention": "a",
      "shipping_country": "India",
      "shipping_address_street1": "bng",
      "shipping_address_street2": "bng",
      "shipping_city": "bng",
      "shipping_state": "bng",
      "shipping_zipcode": "560055",
      "shipping_phone": "9998766444",
      "shipping_fax": "d",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AR] Arunachal Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03318",
      "customer_type": "yes",
      "primary_contact": "Mr.",
      "first_name": "Navaneeth",
      "last_name": "narashima",
      "company_name": "ikaym",
      "customer_display_name": "ikyam",
      "customer_email": "navaneeth@gmail.com",
      "customer_phone": "9998855757",
      "website": "nava",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "",
      "email_address": "",
      "work_phone": "",
      "mobile": "989687867",
      "currency": "INR",
      "opening_balance": "44444",
      "exchange_rate": "",
      "payment_terms": "Net 45",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "a",
      "billing_country": "India",
      "billing_address_street1": "bng",
      "billing_address_street2": "bng",
      "billing_city": "bng",
      "billing_state": "bng",
      "billing_zipcode": "564404",
      "billing_phone": "9776778",
      "billing_fax": "d",
      "shipping_attention": "a",
      "shipping_country": "India",
      "shipping_address_street1": "bng",
      "shipping_address_street2": "bng",
      "shipping_city": "bng",
      "shipping_state": "bng",
      "shipping_zipcode": "564404",
      "shipping_phone": "9776778",
      "shipping_fax": "d",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AR] Arunachal Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03319",
      "customer_type": "yes",
      "primary_contact": "Mr.",
      "first_name": "sampath sir",
      "last_name": "sir",
      "company_name": "ikaym",
      "customer_display_name": "ikaym",
      "customer_email": "sampath@gmail.com",
      "customer_phone": "5660875567",
      "website": "sampath",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "",
      "email_address": "",
      "work_phone": "",
      "mobile": "7",
      "currency": "INR",
      "opening_balance": "3456546546",
      "exchange_rate": "",
      "payment_terms": "Net 45",
      "price_list": "Price book3[1% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "a",
      "billing_country": "India",
      "billing_address_street1": "bng",
      "billing_address_street2": "bng",
      "billing_city": "bng",
      "billing_state": "bng",
      "billing_zipcode": "565444",
      "billing_phone": "4555343333",
      "billing_fax": "a",
      "shipping_attention": "a",
      "shipping_country": "India",
      "shipping_address_street1": "bng",
      "shipping_address_street2": "bng",
      "shipping_city": "bng",
      "shipping_state": "bng",
      "shipping_zipcode": "565444",
      "shipping_phone": "4555343333",
      "shipping_fax": "a",
      "exemption_reason": "",
      "gst_treatment": "Registered Business Composition",
      "place_of_supply": "[AD] Andhra Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03320",
      "customer_type": "yes",
      "primary_contact": "Ms.",
      "first_name": "Spwan",
      "last_name": "Dutt",
      "company_name": "Media Factory",
      "customer_display_name": "Swapna",
      "customer_email": "swapna@gmail.com",
      "customer_phone": "8923092332",
      "website": "www.media.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "",
      "email_address": "",
      "work_phone": "",
      "mobile": "8899929227",
      "currency": "INR",
      "opening_balance": "21221",
      "exchange_rate": "",
      "payment_terms": "Due on Receipt ",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "aa",
      "billing_country": "India",
      "billing_address_street1": "Malur",
      "billing_address_street2": "Guntur",
      "billing_city": "Kolar",
      "billing_state": "Karnataka",
      "billing_zipcode": "563101",
      "billing_phone": "8839393939",
      "billing_fax": "232323",
      "shipping_attention": "aa",
      "shipping_country": "India",
      "shipping_address_street1": "Malur",
      "shipping_address_street2": "Guntur",
      "shipping_city": "Kolar",
      "shipping_state": "Karnataka",
      "shipping_zipcode": "563101",
      "shipping_phone": "8839393939",
      "shipping_fax": "232323",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AD] Andhra Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03321",
      "customer_type": "yes",
      "primary_contact": "Mr.",
      "first_name": "sivam",
      "last_name": "reddy",
      "company_name": "ikyam",
      "customer_display_name": "sivam",
      "customer_email": "sivam@gamil.com",
      "customer_phone": "8998689696",
      "website": "sivam@gamil.coom",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "",
      "email_address": "",
      "work_phone": "",
      "mobile": "8768768687",
      "currency": "Australia dollar",
      "opening_balance": "433223",
      "exchange_rate": "",
      "payment_terms": "Net 45",
      "price_list": "Price Book2[17% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "a",
      "billing_country": "Afghanistan",
      "billing_address_street1": "bng",
      "billing_address_street2": "bng",
      "billing_city": "bng",
      "billing_state": "bng",
      "billing_zipcode": "544444",
      "billing_phone": "9987657678",
      "billing_fax": "a",
      "shipping_attention": "a",
      "shipping_country": "Afghanistan",
      "shipping_address_street1": "bng",
      "shipping_address_street2": "bng",
      "shipping_city": "bng",
      "shipping_state": "bng",
      "shipping_zipcode": "544444",
      "shipping_phone": "9987657678",
      "shipping_fax": "a",
      "exemption_reason": "",
      "gst_treatment": "Registered Business",
      "place_of_supply": "[AR] Arunachal Pradesh",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    },
    {
      "newcustomer_id": "NWCUS_03334",
      "customer_type": "yes",
      "primary_contact": "Mr.",
      "first_name": "kesava",
      "last_name": "reddy",
      "company_name": "ikyam",
      "customer_display_name": "kesava",
      "customer_email": "kesava@gmail.com",
      "customer_phone": "9987689686",
      "website": "kesavareddy@school.com",
      "salutation": "yes",
      "contact_first_name": "",
      "contact_last_name": "",
      "email_address": "",
      "work_phone": "",
      "mobile": "9988767576",
      "currency": "INR",
      "opening_balance": "4333",
      "exchange_rate": "",
      "payment_terms": "Due end of the month",
      "price_list": "Price book3[1% Markup]",
      "facebook": "",
      "twitter": "",
      "billing_attention": "a",
      "billing_country": "Afghanistan",
      "billing_address_street1": "bng",
      "billing_address_street2": "bng",
      "billing_city": "bng",
      "billing_state": "bng",
      "billing_zipcode": "554444",
      "billing_phone": "4448768768",
      "billing_fax": "d",
      "shipping_attention": "a",
      "shipping_country": "Afghanistan",
      "shipping_address_street1": "bng",
      "shipping_address_street2": "bng",
      "shipping_city": "bng",
      "shipping_state": "bng",
      "shipping_zipcode": "554444",
      "shipping_phone": "4448768768",
      "shipping_fax": "d",
      "exemption_reason": "",
      "gst_treatment": "Special EconomicZone",
      "place_of_supply": "[KA] Karnataka",
      "tax_preferences": "yes",
      "enable_portal": "false",
      "portal_language": ""
    }
  ];
  List displayList=[];

  List grnList=[
    {
      "newvehi_grn_id": "GRN02525",
      "new_vendor_id": "NWVND_02479",
      "vendor_name": "Shobu",
      "purchase_order_number": "PO1912221003",
      "purchase_order_date": "19-12-2022",
      "grn_number": "grn",
      "grn_ref": "ok",
      "grn_date": "2022-12-19",
      "vehicle_name": "make",
      "updated_recieved_quantity": "0",
      "ordered_quantity": "16",
      "recieved_quantity": "2",
      "short_quantity": "14",
      "amount": "101010",
      "varient_color": "color",
      "tax_percent": "12",
      "freight_amount": 0.0,
      "terms_conditions": "ko",
      "customer_notes": "ok",
      "status": ""
    },
    {
      "newvehi_grn_id": "GRN02537",
      "new_vendor_id": "NWVND_02534",
      "vendor_name": "Ganesh",
      "purchase_order_number": "PO1912221004",
      "purchase_order_date": "19-12-2022",
      "grn_number": "GRN123124",
      "grn_ref": "123123",
      "grn_date": "2022-12-19",
      "vehicle_name": "Ather",
      "updated_recieved_quantity": "0",
      "ordered_quantity": "8",
      "recieved_quantity": "2",
      "short_quantity": "6",
      "amount": "150",
      "varient_color": "Grey",
      "tax_percent": "7",
      "freight_amount": 0.0,
      "terms_conditions": "Terms and Conditions",
      "customer_notes": "Cust Notes",
      "status": "Invoiced"
    },
    {
      "newvehi_grn_id": "GRN02544",
      "new_vendor_id": "NWVND_02534",
      "vendor_name": "Ganesh",
      "purchase_order_number": "PO2012221005",
      "purchase_order_date": "20-12-2022",
      "grn_number": "GRN123124",
      "grn_ref": "123123",
      "grn_date": "2022-12-21",
      "vehicle_name": "Mahindra",
      "updated_recieved_quantity": "0",
      "ordered_quantity": "2",
      "recieved_quantity": "2",
      "short_quantity": "0",
      "amount": "120000",
      "varient_color": "Blue",
      "tax_percent": "7",
      "freight_amount": 0.0,
      "terms_conditions": "Terms",
      "customer_notes": "Notes",
      "status": ""
    },
    {
      "newvehi_grn_id": "GRN02545",
      "new_vendor_id": "NWVND_02534",
      "vendor_name": "Ganesh",
      "purchase_order_number": "PO2012221005",
      "purchase_order_date": "20-12-2022",
      "grn_number": "GRN123124",
      "grn_ref": "123123",
      "grn_date": "2022-12-21",
      "vehicle_name": "Mahindra",
      "updated_recieved_quantity": "0",
      "ordered_quantity": "2",
      "recieved_quantity": "2",
      "short_quantity": "0",
      "amount": "120000",
      "varient_color": "Blue",
      "tax_percent": "7",
      "freight_amount": 0.0,
      "terms_conditions": "Terms",
      "customer_notes": "Notes",
      "status": "Invoiced"
    },
    {
      "newvehi_grn_id": "GRN02550",
      "new_vendor_id": "NWVND_02490",
      "vendor_name": "Nani",
      "purchase_order_number": "PO1912221005",
      "purchase_order_date": "19-12-2022",
      "grn_number": "Grn76576",
      "grn_ref": "babu",
      "grn_date": "2022-12-20",
      "vehicle_name": "Ather",
      "updated_recieved_quantity": "0",
      "ordered_quantity": "15",
      "recieved_quantity": "1",
      "short_quantity": "14",
      "amount": "150",
      "varient_color": "Grey",
      "tax_percent": "5",
      "freight_amount": 15.0,
      "terms_conditions": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws.",
      "customer_notes": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.",
      "status": ""
    },
    {
      "newvehi_grn_id": "GRN02557",
      "new_vendor_id": "NWVND_02534",
      "vendor_name": "Ganesh",
      "purchase_order_number": "PO1912221004",
      "purchase_order_date": "19-12-2022",
      "grn_number": "GRN5454",
      "grn_ref": "dfdf",
      "grn_date": "2022-12-20",
      "vehicle_name": "Ather",
      "updated_recieved_quantity": "2",
      "ordered_quantity": "8",
      "recieved_quantity": "1",
      "short_quantity": "5",
      "amount": "150",
      "varient_color": "Grey",
      "tax_percent": "7",
      "freight_amount": 0.0,
      "terms_conditions": "Terms and Conditions",
      "customer_notes": "Cust Notes",
      "status": ""
    },
    {
      "newvehi_grn_id": "GRN02569",
      "new_vendor_id": "NWVND_02479",
      "vendor_name": "Shobu",
      "purchase_order_number": "PO1912221003",
      "purchase_order_date": "19-12-2022",
      "grn_number": "GRN556",
      "grn_ref": "rahul",
      "grn_date": "2022-12-20",
      "vehicle_name": "make",
      "updated_recieved_quantity": "2",
      "ordered_quantity": "16",
      "recieved_quantity": "1",
      "short_quantity": "13",
      "amount": "101010",
      "varient_color": "color",
      "tax_percent": "12",
      "freight_amount": 0.0,
      "terms_conditions": "ko",
      "customer_notes": "ok",
      "status": ""
    },
    {
      "newvehi_grn_id": "GRN02577",
      "new_vendor_id": "NWVND_02490",
      "vendor_name": "Nani",
      "purchase_order_number": "PO1912221005",
      "purchase_order_date": "19-12-2022",
      "grn_number": "GRN34534",
      "grn_ref": "babu",
      "grn_date": "2022-12-21",
      "vehicle_name": "Ather",
      "updated_recieved_quantity": "1",
      "ordered_quantity": "15",
      "recieved_quantity": "1",
      "short_quantity": "13",
      "amount": "150",
      "varient_color": "Grey",
      "tax_percent": "5",
      "freight_amount": 15.0,
      "terms_conditions": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws.",
      "customer_notes": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.",
      "status": ""
    },
    {
      "newvehi_grn_id": "GRN02583",
      "new_vendor_id": "NWVND_02534",
      "vendor_name": "Ganesh",
      "purchase_order_number": "PO1912221004",
      "purchase_order_date": "19-12-2022",
      "grn_number": "GRN4545654",
      "grn_ref": "babu",
      "grn_date": "2022-12-07",
      "vehicle_name": "Ather",
      "updated_recieved_quantity": "3",
      "ordered_quantity": "8",
      "recieved_quantity": "1",
      "short_quantity": "4",
      "amount": "150",
      "varient_color": "Grey",
      "tax_percent": "7",
      "freight_amount": 0.0,
      "terms_conditions": "Terms and Conditions",
      "customer_notes": "Cust Notes",
      "status": ""
    },
    {
      "newvehi_grn_id": "GRN02611",
      "new_vendor_id": "NWVND_02490",
      "vendor_name": "Nani",
      "purchase_order_number": "PO1912221005",
      "purchase_order_date": "19-12-2022",
      "grn_number": "grn",
      "grn_ref": "babu",
      "grn_date": "2022-12-23",
      "vehicle_name": "Ather",
      "updated_recieved_quantity": "2",
      "ordered_quantity": "15",
      "recieved_quantity": "1",
      "short_quantity": "12",
      "amount": "150",
      "varient_color": "Grey",
      "tax_percent": "5",
      "freight_amount": 15.0,
      "terms_conditions": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws.",
      "customer_notes": "Terms and conditions are part of a that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.",
      "status": ""
    }
  ];
  List fiveGrnList=[];

  int endVal=0;
  int second=0;




  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.only(left: 40,right: 40),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Email Button.
            //   InkWell(
            //
            //     onTap: () async {
            //       twilioFlutter.sendSMS(
            //           toNumber : '+91 9620247042',
            //           messageBody : 'Invoice is Ready',);
            //       // final v =  await generateReport();
            //       // html.Blob blob = html.Blob([v], 'application/pdf');
            //       // final url = html.Url.createObjectUrlFromBlob(blob);
            //       // html.window.open(url, "_blank");
            //       // html.Url.revokeObjectUrl(url);
            //
            //
            //
            //       // users.add({
            //       //   'to': emailId.text, // John Doe
            //       //   'message': {
            //       //     'subject':"Motows Web Invoice",
            //       //     'text':"This is Email body",
            //       //     "html": 'This is the <code>HTML</code> section of the email body.',
            //       //     "attachments": [{
            //       //       'filename': 'invoice.pdf',
            //       //       "path": "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(v)}"
            //       //     }]
            //       //   } // 42
            //       // })
            //       //     .then((value) {
            //       //   dev.log("User Added");
            //       //
            //       // })
            //       //     .catchError((error) {
            //       //   dev.log("Failed to add user: $error");
            //       // });
            //
            //
            //     },
            //     child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color(
            //         0xff2f4295)),width: 80,height: 30,child: const Center(
            //       child: Text("Send sms",style: TextStyle(color: Colors.white
            //       ),),
            //     )),
            //   ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Dashboard",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12,),
              Row(
                children:  [
                  Expanded(child: InkWell(
                    //mouseCursor: MouseCursor.,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: (){
                      Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 1.1,drawerWidth: 190));
                    },
                    child: const KpiCard(title: "Customers",subTitle:'300',subTitle2: "134",icon:Icons.account_balance_wallet_outlined)

                  )),
                  const SizedBox(width: 30),
                  Expanded(child: Card(
                      color: Colors.transparent,
                      elevation: 4,
                      child:  Container(
                        height: 130,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,top: 20),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 55,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: const Icon(Icons.account_balance_wallet_outlined,color: Colors.white,size: 30),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(child: Text(" Dockets",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Flexible(child: Text("1,300",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),
                                              Flexible(
                                                child: Row(
                                                  children: [
                                                    const Flexible(child: const Icon(Icons.arrow_upward_sharp,color: Colors.green,size: 16)),
                                                    const Flexible(child: const Text("134",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.green,fontSize: 12,))),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            Container(
                              height: 40,decoration: BoxDecoration(
                              color: const Color(0xffF9FAFB),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border.all(
                                width: 3,
                                color: Colors.transparent,
                                style: BorderStyle.solid,
                              ),
                            ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                    child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(fontWeight: FontWeight.bold,)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))),
                  const SizedBox(width: 30),
                  Expanded(child: Card(
                      color: Colors.transparent,
                      elevation: 4,
                      child:  Container(
                        height: 130,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,top: 20),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 55,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration( color: Colors.blue,borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: const Icon(IconData(0xef6f, fontFamily: 'MaterialIcons'),color: Colors.white,size: 30),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(child: Text("Vehicles Sold",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800]))),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Flexible(child: Text("300",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey[800],fontSize: 20,fontWeight: FontWeight.bold))),
                                              Flexible(
                                                child: Row(
                                                  children: const [
                                                    Flexible(child: Icon(Icons.arrow_upward_sharp,color: Colors.green,size: 16)),
                                                    Flexible(child: Text("134",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.green,fontSize: 12,))),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            Container(
                              height: 40,decoration: BoxDecoration(
                              color: const Color(0xffF9FAFB),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border.all(
                                width: 3,
                                color: Colors.transparent,
                                style: BorderStyle.solid,
                              ),
                            ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16,top: 8,bottom: 4),
                                    child: Text("View all",overflow:TextOverflow.ellipsis,maxLines: 1 ,style: const TextStyle(fontWeight: FontWeight.bold,)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))),
                  const SizedBox(width: 30),
                  Expanded(child: InkWell(
                    //mouseCursor: MouseCursor.,
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: (){
                        Navigator.pushReplacementNamed(context, MotowsRoutes.customerListRoute,arguments: CustomerArguments(selectedDestination: 1.1,drawerWidth: 190));
                      },
                      child: const KpiCard(title: "Customers",subTitle:'300',subTitle2: "134",icon:Icons.account_balance_wallet_outlined)

                  )),
                ],
              ),
              const SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Card(elevation: 8,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                        height: 400,
                        child:
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 14,),
                            const Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text("Bar Chart"),
                            ),
                            SizedBox(height: 350,child: SimpleBarChart(vertical: true,)),
                          ],
                        ),
                      ),
                    ),
                  ),
                   const SizedBox(width: 20,),
                   Expanded(
                    child: Card(
                      elevation: 8,
                      child: Container(
                        height: 400,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 14,),
                            Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text("Pie Chart"),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              height: 300,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30,top: 8,right: 8),
                                child: PieChart(
                                dataMap: {
                                  "Data 1": 5,
                                  "Data 2": 5,
                                  "Data 3": 3,
                                },
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 32,
                                centerText: "HYBRID",
                                legendOptions: LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: true,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                                // gradientList: ---To add gradient colors---
                                // emptyColorGradient: ---Empty Color gradient---
                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                   Expanded(
                    child: Card(elevation: 8,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(height: 14,),
                            Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text("Line Chart"),
                            ),
                            SizedBox(height: 350,child: SimpleLineChart()),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 30,),

              Row(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0),)
                        ),
                        child: Column(children: [
                      const  Padding(
                          padding:  EdgeInsets.all(15.0),
                          child:   Align(alignment: Alignment.topLeft,child: Text("Customer List ", style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold))),
                        ),
                          Container(
                              height: 32,
                             color: Colors.grey[100],
                              child:
                              IgnorePointer(ignoring: true,
                                child: MaterialButton(
                                  hoverColor:mHoverColor,
                                  hoverElevation: 0,
                                  onPressed: () {  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15.0),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Name",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Company Name",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Phone No",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),
                          for(int i=0;i<=displayList.length;i++)
                            Column(children: [
                              if(i!=displayList.length)
                                MaterialButton(
                                  hoverColor: Colors.blue[50],
                                  onPressed: () {  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child:Text(displayList[i]['first_name'])
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayList[i]['company_name']??"")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayList[i]['customer_phone']??"")
                                              ),
                                            )),


                                        const Center(child: Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(size: 18,
                                            Icons.more_vert,
                                            color: Colors.black,
                                          ),
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),
                              if(i!=displayList.length)
                                Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                              if(i==displayList.length)
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text("${endVal+5>customersList.length?customersList.length:endVal+1}-${endVal+5>customersList.length?customersList.length:endVal+5} of ${customersList.length}",style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(width: 10,),
                                    //First backward arrow.
                                    InkWell(
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                      ),
                                      onTap: (){
                                        //endval initial 0.
                                        if(endVal>4){
                                          displayList=[];
                                          endVal = endVal-5;
                                          for(int i=endVal;i<endVal+5;i++){
                                            setState(() {
                                              displayList.add(customersList[i]);
                                            });
                                          }
                                        }
                                        else{
                                          print('else');
                                        }

                                      },
                                    ),
                                    const SizedBox(width: 10,),
                                    //second forward arrow
                                    InkWell(
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Icon(Icons.arrow_forward_ios,size: 12),
                                      ),
                                      onTap: (){
                                        if(customersList.length>endVal+6){
                                          displayList=[];
                                          endVal=endVal+i;
                                          for(int i=endVal;i<endVal+5;i++){
                                            setState(() {
                                              displayList.add(customersList[i]);
                                            });
                                          }
                                        }
                                        else{
                                          displayList=[];
                                          endVal=endVal+i;
                                          for(int i=endVal;i<customersList.length;i++){
                                            setState(() {
                                              displayList.add(customersList[i]);
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 20,)
                                  ],
                                )
                            ],)

                        ]),
                      )
                    ]),
                  ),
                  const SizedBox(width: 50,),
                  Expanded(
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0),)
                        ),
                        child: Column(children: [
                          const  Padding(
                            padding:  EdgeInsets.all(15.0),
                            child:   Align(alignment: Alignment.topLeft,child: Text("Grn List", style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold))),
                          ),
                          Container(
                              height: 32,
                              color: Colors.grey[100],
                              child:
                              IgnorePointer(ignoring: true,
                                child: MaterialButton(
                                  hoverColor:mHoverColor,
                                  hoverElevation: 0,
                                  onPressed: () {  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15.0),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Vendor Name",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Company Name",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text("Grn Number",style: TextStyle(color: Colors.black),)
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ),

                          for(int i=0;i<=fiveGrnList.length;i++)
                            Column(children: [
                              if(i!=fiveGrnList.length)
                                MaterialButton(
                                  hoverColor: Colors.blue[50],
                                  onPressed: () {  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:15.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(fiveGrnList[i]['vendor_name'])
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child:  Text(fiveGrnList[i]['vehicle_name'])
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:10,top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child:Text(fiveGrnList[i]['grn_number'])
                                              ),
                                            )),
                                        const Center(child: Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(size: 18,
                                            Icons.more_vert,
                                            color: Colors.black,
                                          ),
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),

                              if(i!=fiveGrnList.length)
                                Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                              if(i==fiveGrnList.length)
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text("${second+5>grnList.length?grnList.length:second+1}-${second+5>grnList.length?grnList.length:second+5} of ${grnList.length}",style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(width: 10,),
                                    //First backward arrow.
                                    InkWell(
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                      ),
                                      onTap: (){
                                        //endval initial 0.
                                        if(second>4){
                                          fiveGrnList=[];
                                          second = second-5;
                                          for(int i=second;i<second+5;i++){
                                            setState(() {
                                              fiveGrnList.add(grnList[i]);
                                            });
                                          }
                                        }
                                        else{
                                          print('else');
                                        }

                                      },
                                    ),
                                    const SizedBox(width: 10,),
                                    //second forward arrow
                                    InkWell(
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Icon(Icons.arrow_forward_ios,size: 12),
                                      ),
                                      onTap: (){
                                        if(grnList.length>second+6){
                                          fiveGrnList=[];
                                          second=second+i;
                                          for(int i=second;i<second+5;i++){
                                            setState(() {
                                              fiveGrnList.add(grnList[i]);
                                            });
                                          }
                                        }
                                        else{
                                          fiveGrnList=[];
                                          second=second+i;
                                          for(int i=second;i<grnList.length;i++){
                                            setState(() {
                                              fiveGrnList.add(grnList[i]);
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 20,)
                                  ],
                                )
                            ],)

                        ]),
                      )
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 30,),


              // Column(
              //   children: [
              //     const Padding(
              //       padding: EdgeInsets.only(top: 20, left: 40.0, right: 40.0),
              //       child: Align(alignment: Alignment.topLeft,
              //           child: Text("Brands", style: TextStyle(fontSize: 24,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.indigo))),
              //     ),
              //     // Padding(
              //     //   padding: const EdgeInsets.only(
              //     //       left: 40.0, right: 40.0, top: 10, bottom: 10),
              //     //   child: GridView.count(
              //     //     crossAxisCount: screenWidth > 1100 ? 5 : screenWidth > 700
              //     //         ? 3
              //     //         : screenWidth > 600 ? 2 : 1,
              //     //     physics: const NeverScrollableScrollPhysics(),
              //     //     shrinkWrap: true,
              //     //     crossAxisSpacing: 10,
              //     //     mainAxisSpacing: 10,
              //     //     children: List.generate(vehicleList.length, (index) {
              //     //       return Card(elevation: 4, color: Colors.grey[200],
              //     //         child: Material(
              //     //           color: Colors.transparent,
              //     //           child: InkWell(splashColor: Colors.red, key: const Key(
              //     //               "vehicleBtn"),
              //     //             onTap: () {
              //     //             Navigator.of(context).push(
              //     //                 PageRouteBuilder(
              //     //                   pageBuilder: (context, animation1, animation2) =>SelectColorVariant(vehicleList[index]["name"],vehicleList[index]['url']),
              //     //                   transitionDuration: Duration.zero,
              //     //                   reverseTransitionDuration: Duration.zero,
              //     //                 ),
              //     //             );
              //     //             },
              //     //             child: Column(
              //     //               mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     //               children: [
              //     //                 Expanded(flex: 8,
              //     //                   child: Image.asset(vehicleList[index]['url'],
              //     //                     height: screenHeight / 6,),
              //     //                 ),
              //     //                 Expanded(flex: 2,
              //     //                     child: Card(color: Colors.white,
              //     //                         child: Row(
              //     //                           mainAxisAlignment: MainAxisAlignment
              //     //                               .center,
              //     //                           children: [
              //     //                             Text(vehicleList[index]["name"],
              //     //                               style: const TextStyle(fontSize: 16,
              //     //                                   color: Color(0xff131d48)),),
              //     //                           ],
              //     //                         )))
              //     //               ],
              //     //             ),
              //     //           ),
              //     //         ),
              //     //       );
              //     //     }),
              //     //   ),
              //     // ),
              //     Padding(
              //       padding: const EdgeInsets.only(
              //           left: 40.0, right: 40.0, top: 10, bottom: 10),
              //       child: GridView.count(
              //         crossAxisCount: screenWidth > 1100 ? 5 : screenWidth > 700
              //             ? 3
              //             : screenWidth > 600 ? 2 : 1,
              //         physics: const NeverScrollableScrollPhysics(),
              //         shrinkWrap: true,
              //         crossAxisSpacing: 10,
              //         mainAxisSpacing: 10,
              //         children: List.generate(brands.length, (index) {
              //           return Card(elevation: 4, color: Colors.grey[200],
              //             child: Material(
              //               color: Colors.transparent,
              //               child: InkWell(splashColor: Colors.red,
              //                 onTap: () {
              //                 Navigator.of(context).push(
              //                     PageRouteBuilder(
              //                       pageBuilder: (context, animation1, animation2) => SelectModel(selectedDestination: 0,drawerWidth:190,brandName:brands[index]["name"] ),
              //                       transitionDuration: Duration.zero,
              //                       reverseTransitionDuration: Duration.zero,
              //                     ),
              //                   );
              //                 },
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                   children: [
              //
              //                     Expanded(flex: 2,
              //                         child: Card(color: Colors.white,
              //                             child: Row(
              //                               mainAxisAlignment: MainAxisAlignment
              //                                   .center,
              //                               children: [
              //                                 Text(brands[index]["name"],
              //                                   style: const TextStyle(fontSize: 16,
              //                                       color: Color(0xff131d48)),),
              //                               ],
              //                             )))
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           );
              //         }),
              //       ),
              //     )
              //
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }


}



