import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/utils/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../classes/motows_routes.dart';
import '../utils/api/get_api.dart';
import '../utils/api/post_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/input_decoration_text_field.dart';
import '../widgets/motows_buttons/outlined_border_with_icon.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';
import 'list_users.dart';

class DealerList extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final String companyName;
  final String companyID;
  final List companyIDs;
  const DealerList({
    required this.companyName,
    required this.companyID,
    required this.drawerWidth,
    required this.selectedDestination,
    required this.companyIDs,
    super.key
  });

  @override
  State<DealerList> createState() => _DealerListState();
}

class _DealerListState extends State<DealerList> {
  String companyName = '';
  String companyID = '';
  List companyIDs = [];
  String ?authToken;
  bool loading =false;
  List displayListCompanyDealers=[];
  List listCompanyDealer = [];
  var expandedId="";
  int startVal=0;
  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }
  Future postCompanyDealerDetails(companyDealerList) async {
    String url =
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company_dealer/add_company_dealer';
    postData(context: context, url: url, requestBody: companyDealerList)
        .then((value) {
      setState(() {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Company Dealer Added')));
          setState(() {
            getCompanyDealerList(companyID);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DealerList(
                companyName: companyName,
                companyID: companyID,
                drawerWidth: widget.drawerWidth,
                selectedDestination: widget.selectedDestination,
              companyIDs: companyIDs,
            ),));
          });
        }
      });
    });
  }
  Future editCompanyDealer(requestBody) async {
    String url ='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company_dealer/update_company_dealer';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Company Details Edited')));
        setState(() {
          getCompanyDealerList(companyID);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DealerList(
              companyName: companyName,
              companyID: companyID,
              drawerWidth: widget.drawerWidth,
              selectedDestination: widget.selectedDestination,
            companyIDs: companyIDs,
          ),));
        });
      }
    } else {
      log(response.statusCode.toString());
    }
  }
  Future getCompanyDealerList(companyId) async {
    dynamic response;
    String url =
        'https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/company_dealer/get_company_dealer_by_company_id/$companyId';
    try {
      await getData(url: url, context: context).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            listCompanyDealer = response;
            // print('------Dealer list----');
            // print(listCompanyDealer);
            if(displayListCompanyDealers.isEmpty){
              if(listCompanyDealer.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListCompanyDealers.add(listCompanyDealer[i]);
                  displayListCompanyDealers[i]['isExpanded']=false;
                }
              }
              else{
                for(int i=0;i<listCompanyDealer.length;i++){
                  displayListCompanyDealers.add(listCompanyDealer[i]);
                  displayListCompanyDealers[i]['isExpanded']=false;
                }
              }
            }
          }
          loading=false;
        });
      });
    } catch (e) {
      logOutApi(context: context, exception: e.toString(), response: response);
      setState(() {
        loading=false;
      });
    }
  }
  Future deleteCompany(String dealerID)async{
    String url= 'https://b3tipaz2h6.execute-api.ap-south-1.amazonaws.com/stage1/api/company_dealer/delete_company_dealer_by_id/$dealerID';
    final response=await http.delete(Uri.parse(url),
        //After login token will generate that token passing here.
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken'
        }
    );
    if(response.statusCode==200){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dealer Deleted')));
        setState(() {
          getCompanyDealerList(companyID);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DealerList(
              companyName: companyName,
              companyID: companyID,
              drawerWidth: widget.drawerWidth,
              selectedDestination: widget.selectedDestination,
            companyIDs: companyIDs,
          ),));
        });
      }
    }
    else{
      log(response.statusCode.toString());
    }
  }
  @override
  void initState() {
    companyName = widget.companyName;
    companyID = widget.companyID;
    companyIDs = widget.companyIDs;
    // print('-------- company IDs --------');
    // print(companyIDs);
    getInitialData().whenComplete(()  {
      getCompanyDealerList(companyID);
    });
    super.initState();
    loading=true;
  }
  List <CustomPopupMenuEntry<String>> userTypes =<CustomPopupMenuEntry<String>>[

    CustomPopupMenuItem(
      height: 35,
      value: 'Edit',
      child: Center(child: SizedBox(width: 150,child: Row(
        children: [ Icon(Icons.edit,size: 15,color: Colors.grey[800],),
          const SizedBox(width: 5,),
          Text('Edit',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey[800],fontSize: 15,),),
        ],
      ))),

    ),
    CustomPopupMenuItem(height: 35,
      value: 'Delete',
      child: Center(child: SizedBox(width: 150,child: Row(
        children: [ Icon(Icons.delete_sharp,size: 15,color: Colors.grey[800],),
          const SizedBox(width: 5,),
          Text('Delete',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey[800],fontSize: 15,),),
        ],
      ))),

    ),
    CustomPopupMenuItem(
      height: 35,
      value: 'Change Password',
      child: Center(child: SizedBox(width: 150,child: Row(
        children: [ Icon(Icons.edit,size: 15,color: Colors.grey[800],),
          const SizedBox(width: 5,),
          Text('Change Password',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey[800],fontSize: 15,),),
        ],
      ))),

    ),
  ];
  String userInitialType = 'Edit Options';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(width: 1, thickness: 1,),
          Expanded(
              child: CustomLoader(
                  inAsyncCall: loading,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.grey[50],
                    child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 50,right: 50,top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE0E0E0),)
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 18,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Dealers",
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: SizedBox(

                                              width: 150,
                                              height:30,
                                              child: OutlinedMButton(
                                                text: '+ Create Dealers',
                                                buttonColor:mSaveButton ,
                                                textColor: Colors.white,
                                                borderColor: mSaveButton,
                                                onTap:(){
                                                  createNewDealer(context);
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 18,),
                                    Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                    Container(color: Colors.grey[100],
                                      child:  IgnorePointer(
                                        ignoring: true,
                                        child: MaterialButton(
                                          onPressed: (){},
                                          hoverColor: Colors.transparent,
                                          hoverElevation: 0,
                                          child:  Padding(
                                            padding: const EdgeInsets.only(left: 18.0),
                                            child: Row(
                                              children: [
                                                const  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 4.0),
                                                      child: SizedBox(height: 25,
                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                          child: Text("Dealer ID")
                                                      ),
                                                    )),
                                                const   Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 4.0),
                                                      child: SizedBox(height: 25,
                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                          child: Text("Dealer Name")
                                                      ),
                                                    )),
                                                const Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 4.0),
                                                      child: SizedBox(height: 25,
                                                          //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                          child: Text("Phone Number")
                                                      ),
                                                    )),
                                                const Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 4),
                                                      child: Text("Dealer Address"),
                                                    )),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 38),
                                                  child: Container(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: displayListCompanyDealers.length+1,
                                  itemBuilder: (context,i){
                                    if(i<displayListCompanyDealers.length){
                                      return Column(children: [
                                        AnimatedContainer(
                                          height:  displayListCompanyDealers[i]["isExpanded"]?90:36,
                                          duration: const Duration(milliseconds: 500),
                                          child: MaterialButton(
                                            hoverColor: Colors.blue[50],
                                            onPressed: (){
                                              Navigator.of(context).push(PageRouteBuilder(
                                                pageBuilder: (context,animation1,animation2) => CompanyDetails(
                                                  companyName:companyName,
                                                  selectedDestination: widget.selectedDestination,
                                                  drawerWidth: widget.drawerWidth,
                                                  companyID: companyID,
                                                  dealerID: displayListCompanyDealers[i]['dealer_id'],
                                                ),
                                                transitionDuration: Duration.zero,
                                                reverseTransitionDuration: Duration.zero,
                                              ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 18.0,bottom: 3,top:4),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          //mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 4.0),
                                                                  child: SizedBox(height: 25,
                                                                      child: Text(displayListCompanyDealers[i]['dealer_id']??"")
                                                                  ),
                                                                )),
                                                            Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 4),
                                                                  child: SizedBox(
                                                                      height: 25,
                                                                      child: Text(displayListCompanyDealers[i]['dealer_name']??"")
                                                                  ),
                                                                )
                                                            ),
                                                            Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 4),
                                                                  child: SizedBox(height: 25,
                                                                      child: Text(displayListCompanyDealers[i]['dealer_phone_number']??"")
                                                                  ),
                                                                )),
                                                            Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 4),
                                                                  child: SizedBox(height: 25,
                                                                      child: Text(displayListCompanyDealers[i]['dealer_address']??"")
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                        displayListCompanyDealers[i]['isExpanded']?
                                                        FutureBuilder (
                                                            future: _show(),
                                                            builder: (context,snapchat) {
                                                              if(!snapchat.hasData){
                                                                return const SizedBox();
                                                              }
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(height: 12,),
                                                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 28,
                                                                        width:80,
                                                                        child: OutlinedBorderWithIcon(
                                                                          buttonText: 'Edit', iconData: Icons.edit,
                                                                          onTap: (){
                                                                            List<String> dealerNamesByCompany = [];
                                                                            // for(var company in displayListCompanyDealers){
                                                                            //   List<Map<String, dynamic>> items = (company['items'] as List<dynamic>).cast<Map<String, dynamic>>();
                                                                            //   List<String> dealerNames = items.map((e) => e['dealer_name'].toString()).toList();
                                                                            //   print('-------- dealer name ---------');
                                                                            //   print("These Dealers $dealerNames belongs to ${company['company_name']}");
                                                                            // }
                                                                            setState(() {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) {

                                                                                  Map companyDetails = {};
                                                                                  final editDealerKey = GlobalKey<FormState>();
                                                                                  bool editCompanyError = false;
                                                                                  bool editDealerNameError = false;
                                                                                  bool editDealerPhoneError = false;
                                                                                  bool editDealerAddressError = false;

                                                                                  final editCompanyName = TextEditingController();
                                                                                  editCompanyName.text=companyName??"";
                                                                                  final editDealerName = TextEditingController();
                                                                                  editDealerName.text=displayListCompanyDealers[i]['dealer_name']??"";
                                                                                  final editDealerPhone = TextEditingController();
                                                                                  editDealerPhone.text=displayListCompanyDealers[i]['dealer_phone_number']??"";
                                                                                  final editDealerAddress = TextEditingController();
                                                                                  editDealerAddress.text=displayListCompanyDealers[i]['dealer_address']??"";

                                                                                  String capitalizeFirstWord(String value) {
                                                                                    if(value.isNotEmpty){
                                                                                      var result = value[0].toUpperCase();
                                                                                      for (int i = 1; i < value.length; i++) {
                                                                                        if (value[i - 1] == "1") {
                                                                                          result = result + value[i].toUpperCase();
                                                                                        } else {
                                                                                          result = result + value[i];
                                                                                        }
                                                                                      }
                                                                                      return result;
                                                                                    }
                                                                                    return '';
                                                                                  }
                                                                                  return Dialog(
                                                                                    backgroundColor: Colors.transparent,
                                                                                    child: StatefulBuilder(
                                                                                      builder: (BuildContext context, setState) {

                                                                                        return SizedBox(
                                                                                          child: Stack(children: [
                                                                                            Container(
                                                                                              width: 600,
                                                                                              decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(5)),
                                                                                              margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                                                              child: SingleChildScrollView(
                                                                                                child: Form(
                                                                                                  key: editDealerKey,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(30),
                                                                                                    child: Container(
                                                                                                      decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                                                                                                      child: Column(children: [
                                                                                                        // Top container.
                                                                                                        Container(color: Colors.grey[100],
                                                                                                          child: IgnorePointer(ignoring: true,
                                                                                                            child: MaterialButton(
                                                                                                              hoverColor: Colors.transparent,
                                                                                                              onPressed: () {

                                                                                                              },
                                                                                                              child: const Row(
                                                                                                                children: [
                                                                                                                  Expanded(
                                                                                                                    child: Padding(
                                                                                                                      padding: EdgeInsets.all(8.0),
                                                                                                                      child: Text(
                                                                                                                        'Edit Company Details',
                                                                                                                        style: TextStyle(fontWeight: FontWeight.bold,
                                                                                                                          fontSize: 16,),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        const Divider(height: 1,color:mTextFieldBorder),
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.all(30),
                                                                                                          child: Column(children: [
                                                                                                            //Company Name.
                                                                                                            Row(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Expanded(
                                                                                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    children: [
                                                                                                                      const SizedBox( child: Text('Dealer Name')),
                                                                                                                      const SizedBox(height: 5),
                                                                                                                      AnimatedContainer(
                                                                                                                        duration: const Duration(seconds: 0),
                                                                                                                        height: editDealerNameError ? 60 : 35,
                                                                                                                        child: TextFormField(
                                                                                                                          validator: (value) {
                                                                                                                            if (value == null || value.isEmpty) {
                                                                                                                              setState(() {
                                                                                                                                editDealerNameError = true;
                                                                                                                              });
                                                                                                                              return "Enter Dealer Name";
                                                                                                                            } else {
                                                                                                                              setState(() {
                                                                                                                                editDealerNameError = false;
                                                                                                                              });
                                                                                                                            }
                                                                                                                            return null;
                                                                                                                          },
                                                                                                                          style: const TextStyle(fontSize: 14),
                                                                                                                          onChanged: (value) {
                                                                                                                            editDealerName.value=TextEditingValue(
                                                                                                                              text: capitalizeFirstWord(value),
                                                                                                                              selection: editDealerName.selection,
                                                                                                                            );
                                                                                                                          },
                                                                                                                          controller: editDealerName,
                                                                                                                          decoration: decorationInput5(
                                                                                                                              'Edit Dealer Name',
                                                                                                                              editDealerName.text.isNotEmpty),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],),
                                                                                                                ),
                                                                                                                const SizedBox(width: 35,),
                                                                                                                Expanded(
                                                                                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    children: [
                                                                                                                      const SizedBox( child: Text('Dealer Phone Number')),
                                                                                                                      const SizedBox(height: 5),
                                                                                                                      AnimatedContainer(
                                                                                                                        duration: const Duration(seconds: 0),
                                                                                                                        height: editDealerPhoneError ? 60 : 35,
                                                                                                                        child: TextFormField(
                                                                                                                          keyboardType: TextInputType.number,
                                                                                                                          inputFormatters: [
                                                                                                                            FilteringTextInputFormatter.digitsOnly
                                                                                                                          ],
                                                                                                                          maxLength: 10,
                                                                                                                          validator: (value) {
                                                                                                                            if (value == null || value.isEmpty) {
                                                                                                                              setState(() {
                                                                                                                                editDealerPhoneError = true;
                                                                                                                              });
                                                                                                                              return "Enter Phone Number";
                                                                                                                            } else {
                                                                                                                              setState(() {
                                                                                                                                editDealerPhoneError = false;
                                                                                                                              });
                                                                                                                            }
                                                                                                                            return null;
                                                                                                                          },
                                                                                                                          style: const TextStyle(fontSize: 14),
                                                                                                                          controller: editDealerPhone,
                                                                                                                          decoration: decorationInput5(
                                                                                                                              'Edit Phone Number',
                                                                                                                              editDealerPhone.text.isNotEmpty),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            const SizedBox(
                                                                                                              height:25,
                                                                                                            ),
                                                                                                            // state.
                                                                                                            Row(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Expanded(
                                                                                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    children: [
                                                                                                                      const SizedBox( child: Text('Company Name')),
                                                                                                                      const SizedBox(height: 5),
                                                                                                                      AnimatedContainer(
                                                                                                                        duration: const Duration(seconds: 0),
                                                                                                                        height: editCompanyError ? 60 : 35,
                                                                                                                        child: TextFormField(
                                                                                                                          readOnly: true,
                                                                                                                          validator: (value) {
                                                                                                                            if (value == null || value.isEmpty) {
                                                                                                                              setState(() {
                                                                                                                                editCompanyError = true;
                                                                                                                              });
                                                                                                                              return "Enter Company Name";
                                                                                                                            } else {
                                                                                                                              setState(() {
                                                                                                                                editCompanyError = false;
                                                                                                                              });
                                                                                                                            }
                                                                                                                            return null;
                                                                                                                          },
                                                                                                                          style: const TextStyle(fontSize: 14),
                                                                                                                          // onChanged: (value) {
                                                                                                                          //   editCompanyName.value=TextEditingValue(
                                                                                                                          //     text: capitalizeFirstWord(value),
                                                                                                                          //     selection: editCompanyName.selection,
                                                                                                                          //   );
                                                                                                                          // },
                                                                                                                          controller: editCompanyName,
                                                                                                                          decoration: decorationInput5(
                                                                                                                              'Edit Company Name',
                                                                                                                              editCompanyName.text.isNotEmpty),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],),
                                                                                                                ),
                                                                                                                const SizedBox(width: 35,),
                                                                                                                Expanded(
                                                                                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    children: [
                                                                                                                      const SizedBox( child: Text('Dealer Address')),
                                                                                                                      const SizedBox(height: 5),
                                                                                                                      AnimatedContainer(
                                                                                                                        duration: const Duration(seconds: 0),
                                                                                                                        height: editDealerAddressError ? 60 : 35,
                                                                                                                        child: TextFormField(
                                                                                                                          validator: (value) {
                                                                                                                            if (value == null || value.isEmpty) {
                                                                                                                              setState(() {
                                                                                                                                editDealerAddressError = true;
                                                                                                                              });
                                                                                                                              return "Enter Dealer Address";
                                                                                                                            } else {
                                                                                                                              setState(() {
                                                                                                                                editDealerAddressError = false;
                                                                                                                              });
                                                                                                                            }
                                                                                                                            return null;
                                                                                                                          },
                                                                                                                          style: const TextStyle(fontSize: 14),
                                                                                                                          onChanged: (value) {
                                                                                                                            editDealerAddress.value=TextEditingValue(
                                                                                                                              text: capitalizeFirstWord(value),
                                                                                                                              selection: editDealerAddress.selection,
                                                                                                                            );
                                                                                                                          },
                                                                                                                          controller: editDealerAddress,
                                                                                                                          decoration: decorationInput5(
                                                                                                                              'Edit Dealer Address',
                                                                                                                              editDealerAddress.text.isNotEmpty),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            const SizedBox(
                                                                                                              height:25,
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              width: 100,
                                                                                                              height:30,
                                                                                                              child: OutlinedMButton(
                                                                                                                text: 'Update',
                                                                                                                buttonColor:mSaveButton ,
                                                                                                                textColor: Colors.white,
                                                                                                                borderColor: mSaveButton,
                                                                                                                onTap:(){
                                                                                                                  if (editDealerKey.currentState!.validate()) {
                                                                                                                    companyDetails = {
                                                                                                                      "company_id": companyID,
                                                                                                                      'company_name':editCompanyName.text,
                                                                                                                      'dealer_name':editDealerName.text,
                                                                                                                      'dealer_phone_number':editDealerPhone.text,
                                                                                                                      'dealer_address':editDealerAddress.text,
                                                                                                                      "dealer_id": displayListCompanyDealers[i]['dealer_id'],
                                                                                                                    };
                                                                                                                    editCompanyDealer(companyDetails);
                                                                                                                  }
                                                                                                                },
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],),
                                                                                                        )
                                                                                                      ]),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Positioned(right: 0.0,
                                                                                              child: InkWell(
                                                                                                child: Container(
                                                                                                    width: 30,
                                                                                                    height: 30,
                                                                                                    decoration: BoxDecoration(
                                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                                        border: Border.all(
                                                                                                          color:
                                                                                                          const Color.fromRGBO(204, 204, 204, 1),
                                                                                                        ),
                                                                                                        color: Colors.blue),
                                                                                                    child: const Icon(
                                                                                                      Icons.close_sharp,
                                                                                                      color: Colors.white,
                                                                                                    )),
                                                                                                onTap: () {
                                                                                                  setState(() {
                                                                                                    Navigator.of(context).pop();
                                                                                                  });
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            });
                                                                          },

                                                                        ),
                                                                      ),
                                                                      const SizedBox(width: 20,),
                                                                      SizedBox(   height: 28,
                                                                        width:100,
                                                                        child: OutlinedBorderColorForDelete(
                                                                          buttonText: 'Delete', iconData: Icons.delete,
                                                                          onTap: (){
                                                                            setState(() {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return Dialog(
                                                                                    backgroundColor: Colors.transparent,
                                                                                    child: StatefulBuilder(
                                                                                      builder: (context, setState) {
                                                                                        return SizedBox(
                                                                                          height: 200,
                                                                                          width: 300,
                                                                                          child: Stack(
                                                                                            children: [
                                                                                              Container(
                                                                                                decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(10)),
                                                                                                margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    const SizedBox(height: 20,),
                                                                                                    const Icon(
                                                                                                      Icons.warning_rounded,
                                                                                                      color: Colors.red,
                                                                                                      size: 50,
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      height: 10,
                                                                                                    ),
                                                                                                    const Center(
                                                                                                        child: Text(
                                                                                                          'Are You Sure, You Want To Delete ?',
                                                                                                          style: TextStyle(
                                                                                                              color: Colors.indigo,
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                              fontSize: 16),
                                                                                                        )),
                                                                                                    const SizedBox(
                                                                                                      height: 35,
                                                                                                    ),
                                                                                                    Row(
                                                                                                      mainAxisAlignment:
                                                                                                      MainAxisAlignment.spaceEvenly,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          width: 50,
                                                                                                          height:30,
                                                                                                          child: OutlinedMButton(
                                                                                                            text: 'Ok',
                                                                                                            buttonColor:Colors.red ,
                                                                                                            textColor: Colors.white,
                                                                                                            borderColor: Colors.red,
                                                                                                            onTap:(){
                                                                                                              deleteCompany(displayListCompanyDealers[i]['dealer_id']);
                                                                                                            },
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 100,
                                                                                                          height:30,
                                                                                                          child: OutlinedMButton(
                                                                                                            text: 'Cancel',
                                                                                                            buttonColor:mSaveButton ,
                                                                                                            textColor: Colors.white,
                                                                                                            borderColor: mSaveButton,
                                                                                                            onTap:(){
                                                                                                              Navigator.of(context).pop();
                                                                                                            },
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Positioned(right: 0.0,

                                                                                                child: InkWell(
                                                                                                  child: Container(
                                                                                                      width: 30,
                                                                                                      height: 30,
                                                                                                      decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                                          border: Border.all(
                                                                                                            color:
                                                                                                            const Color.fromRGBO(204, 204, 204, 1),
                                                                                                          ),
                                                                                                          color: Colors.blue),
                                                                                                      child: const Icon(
                                                                                                        Icons.close_sharp,
                                                                                                        color: Colors.white,
                                                                                                      )),
                                                                                                  onTap: () {
                                                                                                    setState(() {
                                                                                                      Navigator.of(context).pop();
                                                                                                    });
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            });
                                                                          },

                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                  const SizedBox(height: 8,),
                                                                ],
                                                              );

                                                            }
                                                        ):const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 35,height: 25,
                                                    child: MaterialButton(color: Colors.blue[50],
                                                        onPressed: () {
                                                          setState(() {
                                                            if(expandedId==""){
                                                              setState(() {
                                                                expandedId=displayListCompanyDealers[i]["company_id"];
                                                                displayListCompanyDealers[i]["isExpanded"]=true;
                                                              });
                                                            }
                                                            else if(expandedId==displayListCompanyDealers[i]["company_id"]){
                                                              setState(() {
                                                                displayListCompanyDealers[i]["isExpanded"]=false;
                                                                expandedId="";
                                                              });
                                                            }
                                                            else if(expandedId.isNotEmpty || expandedId!=""){
                                                              setState(() {
                                                                for(var companyId in displayListCompanyDealers){
                                                                  if(companyId["company_id"]==expandedId){
                                                                    companyId["isExpanded"]=false;
                                                                    expandedId=displayListCompanyDealers[i]["company_id"];
                                                                    displayListCompanyDealers[i]["isExpanded"]=true;
                                                                  }
                                                                }
                                                              });
                                                            }
                                                          });
                                                        },
                                                        child: displayListCompanyDealers[i]['isExpanded']? const Center(child: Icon(Icons.arrow_drop_down_outlined,color: Colors.blue)):
                                                        const Center(child: Icon(Icons.arrow_right_outlined,color: Colors.grey))),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                      ],);
                                    }
                                    else{
                                      return Column(children: [
                                        Divider(height: 0.5, color: Colors.grey[300], thickness: 0.5),
                                        Row(mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text("${startVal+15>listCompanyDealer.length?listCompanyDealer.length:startVal+1}-${startVal+15>listCompanyDealer.length?listCompanyDealer.length:startVal+15} of ${listCompanyDealer.length}",style: const TextStyle(color: Colors.grey)),
                                            const SizedBox(width: 10,),
                                            Material(color: Colors.transparent,
                                              child: InkWell(
                                                hoverColor: mHoverColor,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(18.0),
                                                  child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                                ),
                                                onTap: (){
                                                  if(startVal>14){
                                                    displayListCompanyDealers=[];
                                                    startVal = startVal-15;
                                                    for(int i=startVal;i<startVal+15;i++){
                                                      try{
                                                        setState(() {
                                                          listCompanyDealer[i]['isExpanded']=false;
                                                          displayListCompanyDealers.add(listCompanyDealer[i]);
                                                          expandedId="";
                                                        });
                                                      }
                                                      catch(e){
                                                        log(e.toString());
                                                      }
                                                    }
                                                  }
                                                  else{
                                                    log('else');
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Material(color: Colors.transparent,
                                              child: InkWell(
                                                hoverColor: mHoverColor,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(18.0),
                                                  child: Icon(Icons.arrow_forward_ios,size: 12),
                                                ),
                                                onTap: (){
                                                  if(listCompanyDealer.length>startVal+15){
                                                    displayListCompanyDealers=[];
                                                    startVal=startVal+15;
                                                    for(int i=startVal;i<startVal+15 && i< listCompanyDealer.length;i++){
                                                      try{
                                                        setState(() {
                                                          listCompanyDealer[i]["isExpanded"]=false;
                                                          displayListCompanyDealers.add(listCompanyDealer[i]);
                                                          expandedId="";
                                                        });
                                                      }
                                                      catch(e){
                                                        log(e.toString());
                                                      }

                                                    }
                                                  }

                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 20,),

                                          ],
                                        )
                                      ],);
                                    }
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              )
          )
        ],
      ),
    );
  }

  void createNewDealer(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final dealerName = TextEditingController();
          final dealerPhone = TextEditingController();
          final dealerAddress = TextEditingController();
          bool dealerNameError = false;
          bool dealerPhoneError = false;
          bool dealerAddressError = false;
          bool companyError=false;
          final createCompanyCon=TextEditingController();
          createCompanyCon.text=companyName;
          final newDealer = GlobalKey<FormState>();
          Map userData = {};
          String capitalizeFirstWord(String value) {
            if(value.isNotEmpty){
              var result = value[0].toUpperCase();
              for (int i = 1; i < value.length; i++) {
                if (value[i - 1] == "1") {
                  result = result + value[i].toUpperCase();
                }
                else {
                  result = result + value[i];
                }
              }
              return result;
            }
            return '';
          }
          return Dialog(
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  child: Stack(children: [
                    Container(
                      width: 650,
                      decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                      margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key:newDealer,
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: mTextFieldBorder),borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  // Top container.
                                  Container(color: Colors.grey[100],
                                    child: IgnorePointer(ignoring: true,
                                      child: MaterialButton(
                                        hoverColor: Colors.transparent,
                                        onPressed: () {
                                        },
                                        child: const Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Create New Dealer',
                                                  style: TextStyle(fontWeight: FontWeight.bold,
                                                    fontSize: 16,),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1,color:mTextFieldBorder),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Column(children: [
                                      //dealer Name.
                                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child: Text('Dealer Name')),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: dealerNameError ? 60 : 35,
                                                  child: TextFormField(

                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          dealerNameError = true;
                                                        });
                                                        return "Enter Dealer Name";
                                                      } else {
                                                        setState(() {
                                                          dealerNameError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      dealerName.value=TextEditingValue(
                                                        text: capitalizeFirstWord(value),
                                                        selection: dealerName.selection,
                                                      );
                                                    },
                                                    controller: dealerName,
                                                    decoration: decorationInput5(
                                                        'Enter Dealer Name',
                                                        dealerName.text.isNotEmpty),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 35,),
                                          // dealer Phone
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child: Text('Dealer Phone Number')),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: dealerPhoneError ? 60 : 35,
                                                  child: TextFormField(
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    maxLength: 10,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          dealerPhoneError = true;
                                                        });
                                                        return "Enter Dealer Phone Number";
                                                      } else {
                                                        setState(() {
                                                          dealerPhoneError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                    },
                                                    controller: dealerPhone,
                                                    decoration: decorationInput5(
                                                        'Enter Dealer Phone Number',
                                                        dealerPhone.text.isNotEmpty),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      //Create Company.
                                      Row( crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                    child: Text('Company Name',)),
                                                const SizedBox(height: 5,),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: companyError ? 60 : 35,
                                                  child: TextFormField(readOnly: true,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          companyError = true;
                                                        });
                                                        return "Company Name";
                                                      } else {
                                                        setState(() {
                                                          companyError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {

                                                    },
                                                    controller: createCompanyCon,
                                                    decoration: decorationInput5(
                                                        'Company Name',
                                                        createCompanyCon.text.isNotEmpty),
                                                  ),
                                                ),
                                                // Focus(
                                                //   onFocusChange: (value) {
                                                //     setState(() {
                                                //       isFocusedCompany = value;
                                                //     });
                                                //   },
                                                //   skipTraversal: true,
                                                //   descendantsAreFocusable: true,
                                                //   child: LayoutBuilder(
                                                //       builder: (BuildContext context, BoxConstraints constraints) {
                                                //         return CustomPopupMenuButton(childHeight: 200,
                                                //           elevation: 4,
                                                //           validator: (value) {
                                                //             if(value==null||value.isEmpty){
                                                //               setState(() {
                                                //                 companyError =true;
                                                //               });
                                                //               return null;
                                                //             }
                                                //             return null;
                                                //           },
                                                //           decoration: customPopupDecoration(hintText:createCompanyName,error: companyError,isFocused: isFocusedCompany),
                                                //           hintText: '',
                                                //           textController: createCompanyCon,
                                                //           childWidth: constraints.maxWidth,
                                                //           shape:  RoundedRectangleBorder(
                                                //             side: BorderSide(color:userError ? Colors.redAccent :mTextFieldBorder),
                                                //             borderRadius: const BorderRadius.all(
                                                //               Radius.circular(5),
                                                //             ),
                                                //           ),
                                                //           offset: const Offset(1, 40),
                                                //           tooltip: '',
                                                //           itemBuilder:  (BuildContext context) {
                                                //             return createCompanyNames;
                                                //           },
                                                //
                                                //           onSelected: (String value)  {
                                                //             setState(() {
                                                //               createCompanyCon.text=value;
                                                //               createCompanyName = value;
                                                //               companyError=false;
                                                //             });
                                                //
                                                //           },
                                                //           onCanceled: () {
                                                //
                                                //           },
                                                //           child: Container(),
                                                //         );
                                                //       }
                                                //   ),
                                                // ),
                                                const SizedBox(height: 5,),
                                                if(companyError)
                                                  const Text("Select Company Name",style: TextStyle(color: Color(0xffB52F27),fontSize: 12),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 35,),
                                          //Dealer Address
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(child: Text('Dealer Address')),
                                                const SizedBox(height: 5),
                                                AnimatedContainer(
                                                  duration: const Duration(seconds: 0),
                                                  height: dealerAddressError ? 60 : 35,
                                                  child: TextFormField(

                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        setState(() {
                                                          dealerAddressError = true;
                                                        });
                                                        return "Enter Dealer Address";
                                                      } else {
                                                        setState(() {
                                                          dealerAddressError = false;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      dealerAddress.value=TextEditingValue(
                                                        text: capitalizeFirstWord(value),
                                                        selection: dealerAddress.selection,
                                                      );
                                                    },
                                                    controller: dealerAddress,
                                                    decoration: decorationInput5(
                                                        'Enter Dealer Address',
                                                        dealerAddress.text.isNotEmpty),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child:  SizedBox(
                                          width: 100,
                                          height:30,
                                          child: OutlinedMButton(
                                            text: 'Save',
                                            buttonColor:mSaveButton ,
                                            textColor: Colors.white,
                                            borderColor: mSaveButton,
                                            onTap:(){
                                              if (newDealer.currentState!.validate()) {
                                                userData = {
                                                  "active": true,
                                                  "company_name": createCompanyCon.text,
                                                  "company_id": companyID,
                                                  "dealer_address": dealerAddress.text,
                                                  "dealer_name": dealerName.text,
                                                  "dealer_phone_number": dealerPhone.text
                                                };
                                                // print('---check----');
                                                // print(userData);
                                                postCompanyDealerDetails(userData);
                                              }

                                            },
                                          ),
                                        ),
                                      ),
                                    ],),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(right: 0.0,

                      child: InkWell(
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color:
                                  const Color.fromRGBO(204, 204, 204, 1),
                                ),
                                color: Colors.blue),
                            child: const Icon(
                              Icons.close_sharp,
                              color: Colors.white,
                            )),
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                  ],

                  ),
                );
              },
            ),
          );
        });
  }
  Future _show() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}

