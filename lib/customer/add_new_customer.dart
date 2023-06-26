import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/utils/static_data/lists.dart';
import '../../classes/motows_routes.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../utils/api/get_api.dart';
import '../utils/api/post_api.dart';
import '../utils/custom_popup_dropdown/custom_popup_dropdown.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/custom_search_textfield/custom_search_field.dart';
import '../widgets/motows_buttons/outlined_icon_mbutton.dart';
import '../widgets/motows_buttons/outlined_mbutton.dart';


class AddNewCustomer extends StatefulWidget {
  final int title;
  final double drawerWidth;
  final double selectedDestination;

  const AddNewCustomer(
      {Key? key,
      required this.title,
      required this.drawerWidth,
      required this.selectedDestination})
      : super(key: key);


  @override
  AddNewCustomerState createState() => AddNewCustomerState();
 }

class AddNewCustomerState extends State<AddNewCustomer> with SingleTickerProviderStateMixin {



  @override
  void initState() {
    super.initState();
    loading= true;
   // _tabController=TabController(length: 2, vsync: this);
    //_tabController.addListener(_handleTabSelection);
     getMakeData();
  }

  Future getMakeData() async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/get_all_once_by_brand_name';
    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            print(value);
            makeList=value;
          }
          loading=false;
        });
      });
    }
    catch(e){
      // logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }

  Future getModelList(String makeName) async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/get_all_once_by_model_name/$makeName';
    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            print(value);
            modelList=value;
          }
          loading=false;
        });
      });
    }
    catch(e){
      // logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }

  Future getVariantList(String make, String model) async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/get_all_once_brand_model/$make/$model';
    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            variantList=value;
            print(value);
          }
          loading=false;
        });
      });
    }
    catch(e){
      // logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }

  Future getColorList(String make, String model, String variant) async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/model_general/get_all_brand_model_variant/$make/$model/$variant';
    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            //choices=value;
            generalId =value[0]['general_id'];
            choices.add(value[0]['varient_color1']);
            if(value[0]['varient_color2']!=''){
              choices.add(value[0]['varient_color2']);
            }
            print(url);
            print(value);
          }
          loading=false;
        });
      });
    }
    catch(e){
      // logOutApi(context: context,exception:e.toString() ,response: response);
      setState(() {
        loading=false;
      });
    }
  }


 dynamic  size;
  dynamic width;
  dynamic height;

  String? authToken;
  Map vehicleDetails={};


  bool loading =false;


  int _selectedIndex = 0;
  bool isCustFormFilled= false;

  textFieldDecoration({required String hintText, bool? error}) {
    return  InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldStateName({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: stateContainer.text.isEmpty?const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.search,),
      ):
      InkWell(onTap: (){
        setState(() {
          stateContainer.clear();
          distController.clear();
        });

      },
          child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.close,color: Colors.grey,),
      )),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  textFieldDistSelect({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: distController.text.isEmpty?const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.search,),
      ):InkWell(onTap: (){
        setState(() {
          distController.clear();
        });

      },child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.close,color: Colors.grey,),
      )),

      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: BoxConstraints(maxHeight: error==true ? 60:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color:mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  customPopupDecoration({required String hintText, bool? error, bool? isFocused}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isFocused == true ? Colors.blue : error == true ? mErrorColor : mTextFieldBorder)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: error == true ? mErrorColor : mTextFieldBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: error == true ? mErrorColor : Colors.blue)),
    );
  }

  popupFieldDecoration({bool? error}) {
    return   InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: const BoxConstraints(maxHeight:35),
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:OutlineInputBorder(borderSide: BorderSide(color: error==true ? Colors.redAccent: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }

  var customerId = "";
  var vehicleID = "";
  // var customerError = "";

  String selectedType='Select Type';
  String selectedStatusType='Select Type';
  String selectedCity='Select City';
  String selectLocation='Select Location';
  String vehicleColor='Select Color';
  String selectExchange='Select';
  String selectFinance='Select';

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var panController = TextEditingController();
  var mobileController = TextEditingController();
  var gstController = TextEditingController();
  var addressController = TextEditingController();
  var pinCodeController = TextEditingController();
  var customerTypeController =  TextEditingController();
  var statusTypeController =  TextEditingController(text: "Create New Customer");
  var customerCityController =  TextEditingController();
  var customerLocationController =  TextEditingController();
  var vehicleController =  TextEditingController();
  var exchangeController =  TextEditingController();
  var financeController =  TextEditingController();
  var makeController =  TextEditingController();
  var modelController =  TextEditingController();
  var variantController =  TextEditingController();
  var carModelController =  TextEditingController();
  var evaluationDateController =  TextEditingController();
  var financeCompanyController =  TextEditingController();
  var financeAmountController =  TextEditingController();

  bool  _invalidName = false;
  bool _invalidEmail = false;
  bool _invalidPan = false;
  bool _invalidMobile = false;
  bool _invalidGST = false;
  bool _invalidType = false;
  bool _invalidStatusType = false;
  bool _invalidPin = false;
  bool _invalidAddress = false;
  bool _isTypeFocused = false;
  bool _invalidMake = false;
  bool _invalidModel = false;
  bool _invalidVariant = false;
  bool _invalidColor = false;
  bool _invalidExchange = false;
  bool _invalidCarModel = false;
  bool _invalidEvaluationDate = false;
  bool stateError=false;
  bool distError=false;

  bool _invalidFinanceCompany = false;
  bool _invalidFinanceAmount = false;

  final List<Widget> myTabs=[
    const Tab(text:'Customer Details'),
    const Tab(text:"Vehicle"),
  ];

  final _formKey = GlobalKey<FormState>();

  List choices =[];
  String generalId= "";

  List <String> yesNo =[
    'Yes',
    'No'
  ];
  List <String> selectType =[
    'Individual',
    'Company'
  ];

  List <String> selectStatusType =[
    'Create New Docket',
    'Create New Customer'
  ];


  //This  declaration for state.
 final stateContainer=TextEditingController();
  final distController=TextEditingController();

  List storeDist=[];
  List makeList =[];
  List modelList =[];
  List variantList =[];
 final vehicleDetailsForm=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;


    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child:
            Scaffold(backgroundColor: const Color(0xffF0F4F8),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(88.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: AppBar(
                    elevation: 1,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text("Customer"),
                    actions: [
                      Row(
                        children: [
                          SizedBox(
                            width: 120,height: 28,
                            child: OutlinedMButton(
                              text: 'Save',
                              textColor: mSaveButton,
                              borderColor: mSaveButton,
                              onTap: (){
                                setState(() {
                                  if(_selectedIndex==0){
                                    if(_formKey.currentState!.validate()){
                                     // loading=true;
                                        Map customerDetails = {
                                          "customer_name" : nameController.text,
                                         // "city" : selectedCity,
                                          "city":stateContainer.text,
                                          "email_id" : emailController.text,
                                          "gstin" : gstController.text,
                                          //"location" : selectLocation,
                                          "location":distController.text,
                                          "mobile" :mobileController.text,
                                          "pan_number" : panController.text,
                                          "pin_code" : pinCodeController.text,
                                          "street_address" : addressController.text,
                                          "type" : selectedType
                                        };
                                        // print('-------- customer details --------');
                                        // print(customerDetails);
                                        saveCustomer(customerDetails);
                                    }
                                    // print('-----index is --------');
                                    // print(_selectedIndex);
                                  }
                                   if(_selectedIndex==1){
                                     if(vehicleDetailsForm.currentState!.validate()){
                                       vehicleDetails = {
                                        "car_finance": financeController.text,
                                        "car_model": carModelController.text,
                                        "color": vehicleColor,
                                        "customer_id": customerId.toString(),
                                        "evaluation_date": evaluationDateController.text,
                                        "exchange": selectExchange == "Select" ? "No" : selectExchange,
                                        "finance_amount": financeAmountController.text,
                                        "finance_company": financeCompanyController.text,
                                        "make": makeController.text,
                                        "model": modelController.text,
                                        "variant": variantController.text,
                                         "general_id":generalId,
                                      };
                                      // print('------- vehicle details ---------');
                                      // print(vehicleDetails);
                                      saveVehicle(vehicleDetails);
                                      // print('-----------------index is-------------');
                                      // print(_selectedIndex);
                                    }


                                  }
                                });


                              },

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: 100,height: 28,
                      //       child: _selectedIndex == 0?
                      //       OutlinedMButton(
                      //         text: 'Next',
                      //         buttonColor:mSaveButton ,
                      //         textColor: Colors.white,
                      //         borderColor: mSaveButton,
                      //         onTap: (){
                      //           setState(() {
                      //             _selectedIndex=1;
                      //           });
                      //         },
                      //
                      //       ):
                      //       OutlinedMButton(
                      //         text: 'Back',
                      //         buttonColor:mSaveButton ,
                      //         textColor: Colors.white,
                      //         borderColor: mSaveButton,
                      //         onTap: (){
                      //           setState(() {
                      //             _selectedIndex=0;
                      //           });
                      //         },
                      //
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ),
              body: CustomLoader(
                inAsyncCall: loading,
                child: SingleChildScrollView(
                  child: Column(
                    children:  [
                      const Row(children: [
                        SizedBox(height: 10,),
                      ]),
                       Padding(
                        padding: const EdgeInsets.only(top: 10,left: 8,bottom: 30,right: 68),
                        child: SizedBox(width: 1000,child: buildCard()),
                      ),
                      const SizedBox(height: 50,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isFocused =false;

  Future saveCustomer(Map<dynamic, dynamic> topList) async {
    String url='https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/add_newcustomer';
    postData(context:context,requestBody:topList,url: url).then((value){
      setState(() {
        if(value!=null){
          loading = false;
          if(value.containsKey("error")){
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(value["error"],)));
          }
          else if(value.containsKey("status")){
            if(value["status"] == "success"){
              _selectedIndex = 1;
              customerId = value["id"];
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Customer Data Saved'),));
            }
          }
        }
      });
    });
  }

  Future saveVehicle(Map<dynamic, dynamic> topList) async {
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/customer_vehicle/add_customer_vehicle';
    postData(context:context,requestBody:topList,url: url).then((value){
      setState(() {
        if(value!=null){
          loading=false;
          // print('-----------addNew Vehicle New Post api----------------');
          // print(value);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Saved'),));
          if(statusTypeController.text == "Create New Docket"){
            vehicleID = value["id"];
            Map docketData = {
              "cust_vehi_id": vehicleID,
              "customer_id": customerId,
              'general_id':generalId,
              "status": "Created"
            };
            addDocket(docketData);
          }
          else{
            Navigator.of(context).pushNamed(MotowsRoutes.customerListRoute);
          }

        }
      });
    });
  }

  Future addDocket(Map<dynamic, dynamic> docketData) async {
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/salesdocket/add_sales_docket';
    postData(context:context,requestBody:docketData,url: url).then((value){
      setState(() {
        if(value!=null){
          loading = false;
          if(value.containsKey("error")){
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(value["error"],)));
          }
          else if(value.containsKey("status")){
            if(value["status"] == "success"){

            //  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Customer Data Saved'),));
            }
          }
        }
      });
    });
  }



  Widget buildCard() {
    return Form(
      key: _formKey,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              Card(
                surfaceTintColor: Colors.white,
                child: SizedBox(width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  const EdgeInsets.only(left: 8,bottom: 5,right: 16,top: 10),
                          child:  Text("Step ${_selectedIndex+1} of 2",style: const TextStyle(fontSize: 18)),
                        ),
                        _selectedIndex==0 ?
                        const Padding(
                          padding:  EdgeInsets.only(left: 8,bottom: 10,right: 16,top: 10),
                          child: SizedBox(height: 30,
                            child:  OutlinedMButton(
                              text: 'Customer Details',
                              textColor: mSaveButton,
                              borderColor: mSaveButton,
                            ),
                          ),
                        ):
                        const Padding(
                          padding: EdgeInsets.only(left: 8,bottom: 10,right: 16,top: 10),
                          child: SizedBox(height: 30,
                            child: OutlinedIconMButton(
                              icon:  Icon( Icons.check,size: 14,
                                color:  Colors.white,
                              ),
                              borderColor:mSaveButton,
                              buttonColor:mSaveButton ,
                              textColor: Colors.white,
                              text: 'Customer Details',

                            ),
                          ),
                        ),


                         Padding(
                          padding:  const EdgeInsets.only(left: 8,bottom: 14,right: 16,top: 10),
                          child: SizedBox(height: 32,
                            child:  OutlinedMButton(
                              text: "Vehicle Details",
                              textColor: _selectedIndex ==1? mSaveButton :Colors.black,
                              borderColor: _selectedIndex ==1? mSaveButton:Colors.transparent,
                              buttonColor:_selectedIndex ==1? Colors.transparent: Colors.grey[50],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              _selectedIndex == 0?
              Card( surfaceTintColor: Colors.white,
                child: SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 10,right: 16,top: 10),
                    child: SizedBox(
                      height: 30,
                      child: OutlinedMButton(
                        text: 'Next',
                        buttonColor:mSaveButton ,
                        textColor: Colors.white,
                        borderColor: mSaveButton,
                        onTap: (){
                          setState(() {
                            _selectedIndex=1;
                          });
                        },

                      ),
                    ),
                  ),
                ),
              ):
              Card(surfaceTintColor: Colors.white,
                child: SizedBox(width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 10,right: 16,top: 10),
                    child: SizedBox(
                      height: 30,
                      child: OutlinedMButton(
                        text: 'Back',
                        buttonColor:mSaveButton ,
                        textColor: Colors.white,
                        borderColor: mSaveButton,
                        onTap: (){
                          setState(() {
                            _selectedIndex=0;
                          });
                        },

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 30,),

          // This is the main content.
          Expanded(
            child: Card(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                  side:  BorderSide(color: mTextFieldBorder.withOpacity(0.8), width: 1,)),
              child: SizedBox(
                width: 1000,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if(_selectedIndex==0)
                      buildCustomerCard(),
                    if(_selectedIndex==1)
                      buildVehicleCard(),

                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
}
//This two are async function (state,dist).
  Future getStateNames()async{
    List list=[];
    for(int i=0;i<states.length;i++){
      list.add(SearchState.fromJson(states[i]));
    }
    return list;
  }
  Future getDistName()async{
    List storeDistNames=[];

    for(int i=0;i<storeDist.length;i++){
      //Here adding each and every name.
      storeDistNames.add(SearchDist.fromJson(storeDist[i]));
    }
    return storeDistNames;
  }

  Future getMakeNames()async{
    List tempList =[];
    for(int i=0 ;i< makeList.length;i++){
      tempList.add(SearchMake.fromJson(makeList[i]));
    }
    return tempList;
  }

  Future getModelNames()async{
    List tempList =[];
    for(int i=0 ;i< modelList.length;i++){
      tempList.add(SearchModel.fromJson(modelList[i]));
    }
    return tempList;
  }


  Future getVariantNames()async{
    List tempList =[];
    for(int i=0 ;i< variantList.length;i++){
      tempList.add(SearchVariant.fromJson(variantList[i]));
    }
    return tempList;
  }

  String capitalizeFirstWord(String value){
    if(value.isNotEmpty){
      var result =value[0].toUpperCase();
      for(int i=1;i<value.length;i++){
        if(value[i-1]=='1'){
          result=result+value[i].toUpperCase();
        }
        else{
          result=result+value[i];
        }
      }
      return result;
    }
    return "";
  }
  Widget buildCustomerCard(){
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Customer Details
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///header
               const SizedBox(
                height: 42,
                child: Padding(
                  padding: EdgeInsets.only(left: 20,),
                  child: Row(children: [Text("Customer Details"),],
                  ),
                ),
              ),
              const Divider(height: 1,color: mTextFieldBorder),
              Padding(
                padding: const EdgeInsets.only(left: 60,top: 10,right: 60),
                child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Left Field
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Customer Name"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              autofocus: true,
                              controller: nameController,
                              validator:checkNameError,
                             decoration: textFieldDecoration(hintText: 'Enter Name',error:_invalidName),
                              onChanged: (value){
                                nameController.value=TextEditingValue(
                                  text:capitalizeFirstWord(value),
                                  selection: nameController.selection,
                                );
                              },
                            ),
                            const SizedBox(height: 20,),


                            const Text("Email"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              inputFormatters: [LowerCaseTextFormatter()],
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              validator: checkEmailError,
                              decoration: textFieldDecoration(hintText: 'Enter Email',error: _invalidEmail),
                            ),
                            const SizedBox(height: 20,),


                            const Text("Status Type"),
                            const SizedBox(height: 6,),
                            Focus(
                              onFocusChange: (value) {
                                setState(() {
                                  _isTypeFocused = value;
                                });
                              },
                              skipTraversal: true,
                              descendantsAreFocusable: true,
                              child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return CustomPopupMenuButton(elevation: 4,
                                      validator: (value) {
                                        if(value==null||value.isEmpty){
                                          setState(() {
                                            _invalidStatusType=true;
                                          });
                                          return null;
                                        }
                                        return null;
                                      },
                                      decoration: customPopupDecoration(hintText: 'Select type',error: _invalidStatusType,isFocused: _isTypeFocused),
                                      hintText: selectedStatusType,
                                      textController: statusTypeController,
                                      childWidth: constraints.maxWidth,
                                      shape:  RoundedRectangleBorder(
                                        side: BorderSide(color:_invalidStatusType? Colors.redAccent :mTextFieldBorder),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      offset: const Offset(1, 40),
                                      tooltip: '',
                                      itemBuilder:  (BuildContext context) {
                                        return selectStatusType.map((value) {
                                          return CustomPopupMenuItem(
                                            value: value,
                                            text:value,
                                            child: Container(),
                                          );
                                        }).toList();
                                      },

                                      onSelected: (String value)  {
                                        setState(() {
                                          statusTypeController.text=value;
                                          selectedStatusType= value;
                                          _invalidStatusType=false;
                                        });

                                      },
                                      onCanceled: () {

                                      },
                                      child: Container(),
                                    );
                                  }
                              ),
                            ),
                            const SizedBox(height: 20,),


                            const Text("PAN"),
                            const SizedBox(height: 6,),
                            TextFormField(
                              controller: panController,
                              validator: checkPanError,
                              decoration: textFieldDecoration(hintText: 'Enter Pan Number',error: _invalidPan),
                            )

                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 30,),
                    ///Right Fields
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mobile Number"),
                        const SizedBox(height: 6,),
                        TextFormField(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          controller: mobileController,
                          validator: checkMobileError,
                          decoration: textFieldDecoration(hintText: 'Enter Mobile Number',error: _invalidMobile),),
                        const SizedBox(height: 20,),
                        const Text("Type"),
                        const SizedBox(height: 6,),
                        Focus(
                          onFocusChange: (value) {
                            setState(() {
                              _isTypeFocused = value;
                            });
                          },
                          skipTraversal: true,
                          descendantsAreFocusable: true,
                          child: LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                return CustomPopupMenuButton(elevation: 4,
                                  validator: (value) {
                                    if(value==null||value.isEmpty){
                                      setState(() {
                                        _invalidType=true;
                                      });
                                      return null;
                                    }
                                    return null;
                                  },
                                  decoration: customPopupDecoration(hintText: 'Select type',error: _invalidType,isFocused: _isTypeFocused),
                                  hintText: selectedType,
                                  textController: customerTypeController,
                                  childWidth: constraints.maxWidth,
                                  shape:  RoundedRectangleBorder(
                                    side: BorderSide(color:_invalidType? Colors.redAccent :mTextFieldBorder),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  offset: const Offset(1, 40),
                                  tooltip: '',
                                  itemBuilder:  (BuildContext context) {
                                    return selectType.map((value) {
                                      return CustomPopupMenuItem(
                                        value: value,
                                        text:value,
                                        child: Container(),
                                      );
                                    }).toList();
                                  },

                                  onSelected: (String value)  {
                                    setState(() {
                                      customerTypeController.text=value;
                                      selectedType= value;
                                      _invalidType=false;
                                    });

                                  },
                                  onCanceled: () {

                                  },
                                  child: Container(),
                                );
                              }
                          ),
                        ),

                        if(_invalidType)
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                SizedBox(height: 6,),
                                Text("Please Select Type",style: TextStyle(color:mErrorColor,fontSize: 12)),
                                SizedBox(height: 6,),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20,),
                        const Text("GST"),
                        const SizedBox(height: 6,),
                        TextFormField(
                          controller: gstController,
                          validator: checkGSTError,
                          decoration: textFieldDecoration(hintText: 'Enter GST',error: _invalidGST),),

                      ],
                        ),
                      ),
                    )
                  ],
                ),
              )

            ],
          ),
          const SizedBox(height: 40,),

          ///Address Details
          const Divider(height: 1,color: mTextFieldBorder),
          Column(
            children: [
              ///Address Header
              const SizedBox(
                height: 42,
                child: Row(children: [Padding(padding: EdgeInsets.only(left: 20), child: Text("Address Details"),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1,color: mTextFieldBorder),
              Padding(
                padding: const EdgeInsets.only(left: 68,top: 20,right: 68),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Street Address"),
                    const SizedBox(height: 6,),
                    TextFormField(
                      onTap: (){
                        setState(() {
                          isFocused=true;
                        });
                      },
                      validator: checkAddressError,
                      controller: addressController,
                      decoration: textFieldDecoration(hintText: 'Enter Your  Address',error: _invalidAddress),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60,top: 12,right: 60),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Pin Code"),
                              const SizedBox(height: 6,),
                              TextFormField(
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                validator: checkPinError,
                                controller: pinCodeController,
                                decoration: textFieldDecoration(hintText: 'Enter Pin Code',error: _invalidPin),
                              ),
                              const SizedBox(height: 20,),
                              const Text("Dist"),
                              const SizedBox(height: 6,),
                              CustomTextFieldSearch(
                                validator: distCheck,
                                showAdd: false,
                                getSelectedValue: (SearchDist dist){
                                  setState(() {
                                    distController.text=distController.text;
                                  });
                                },
                                decoration: textFieldDistSelect(hintText: 'Search Dist',error: distError),
                                future: (){
                                  return getDistName();
                                },
                                controller: distController,
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(width: 30,),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("State"),
                          const SizedBox(height: 6,),
                          CustomTextFieldSearch(
                            validator: stateCheck,
                            showAdd: false,
                            decoration: textFieldStateName(hintText: 'Search State',error: stateError),
                            // initialList: states,
                            future: (){
                              return getStateNames();
                            },
                            controller: stateContainer,
                            getSelectedValue: (SearchState value){
                              setState(() {
                                storeDist=distName[stateContainer.text];
                              });
                              // print('------------inside-----');
                              // print(storeDist);
                            },

                          ),
                          const SizedBox(height: 20,),

                        ],
                      ),
                    ))
                  ],
                ),
              )

            ],
          ),
          const SizedBox(height: 50,),
          //Customer TextFields
        ],
      ),
    );
}

  Widget buildVehicleCard(){

    return Form(
      key:vehicleDetailsForm,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Vehicle Details
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 42,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Vehicle Details"),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: mTextFieldBorder),
                  Padding(
                    padding: const EdgeInsets.only(left: 60,top: 10,right: 60),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Make"),
                                const SizedBox(height: 6,),
                                CustomTextFieldSearch(
                                  validator: checkMake,
                                  showAdd: false,
                                  decoration: textFieldStateName(hintText: 'Search Make',error: _invalidMake),
                                  // initialList: states,
                                  future: (){
                                    return getMakeNames();
                                  },
                                  controller: makeController,
                                  getSelectedValue: (SearchMake value){
                                    makeController.text = value.value;
                                    getModelList(value.value);
                                  },

                                ),
                                const SizedBox(height: 20,),

                                const Text("Variant"),
                                const SizedBox(height: 6,),
                                CustomTextFieldSearch(
                                  validator: checkVariant,
                                  showAdd: false,
                                  decoration: textFieldStateName(hintText: 'Search Variant',error: _invalidVariant),
                                  future: (){
                                    return getVariantNames();
                                  },
                                  controller: variantController,
                                  getSelectedValue: (SearchVariant value){


                                    getColorList(makeController.text,modelController.text,value.label);


                                  },

                                ),



                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 30,),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Model"),
                              const SizedBox(height: 6,),
                              CustomTextFieldSearch(
                                validator: checkModel,
                                showAdd: false,
                                decoration: textFieldStateName(hintText: 'Search Model',error: _invalidModel),

                                future: (){
                                  return getModelNames();
                                },
                                controller: modelController,
                                getSelectedValue: (SearchModel value){
                                  getVariantList(makeController.text,value.value);
                                },

                              ),

                              const SizedBox(height: 20,),
                              const Text("Color"),
                              const SizedBox(height: 6,),
                              LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return CustomPopupMenuButton(elevation: 4,
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          setState(() {
                                            _invalidColor = true;
                                          });
                                          return null;
                                        }
                                        return null;
                                      },
                                      textController: vehicleController,
                                      decoration: customPopupDecoration(hintText: 'Select Vehicle Color',error: _invalidColor),
                                      childWidth: constraints.maxWidth,
                                      hintText: vehicleColor,
                                      shape: const RoundedRectangleBorder(
                                        side: BorderSide(color:mTextFieldBorder),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      offset: const Offset(1, 40),
                                      tooltip: '',
                                      itemBuilder:  (BuildContext context) {
                                        return choices.map((choice) {
                                          return CustomPopupMenuItem(
                                            value: choice,
                                            text: choice,
                                            child: Container(),
                                          );
                                        }).toList();
                                      },
                                      onSelected: (value)  {
                                        setState(() {
                                           vehicleColor= value.toString();
                                           vehicleController.text=value.toString();
                                          _invalidColor=false;
                                        });
                                      },
                                      onCanceled: () {

                                      },

                                      child: Container(),
                                    );
                                  }
                              ),



                            ],
                          ),
                        ))
                      ],
                    ),
                  )

                ],
              ),
            ),
            const SizedBox(height: 30,),
            const Divider(height: 1,color: mTextFieldBorder),
            ///Car Exchange Details
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 42,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Car Exchange Details"),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: mTextFieldBorder),
                  Padding(
                    padding: const EdgeInsets.only(left: 60,top: 10,right: 60),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Exchange"),
                                  const SizedBox(height: 6,),
                                  LayoutBuilder(
                                      builder: (BuildContext context, BoxConstraints constraints) {
                                        return CustomPopupMenuButton<String>(elevation: 4,
                                          validator: (value) {
                                            if(value == null || value.isEmpty){
                                              setState(() {
                                                // _invalidExchange = true;
                                              });
                                              return null;
                                            }
                                            return null;
                                          },
                                          textController: exchangeController,
                                          decoration: customPopupDecoration(hintText: 'Select Exchange',error: _invalidExchange,),
                                          hintText:selectExchange ,
                                          childWidth: constraints.maxWidth,
                                          shape: const RoundedRectangleBorder(
                                            side: BorderSide(color:mTextFieldBorder),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          offset: const Offset(1, 40),
                                          tooltip: '',
                                          itemBuilder:  (BuildContext context) {
                                            return yesNo.map((String choice) {
                                              return CustomPopupMenuItem<String>(
                                                value: choice,
                                                text: choice,
                                                child: Container()
                                              );
                                            }).toList();
                                          },

                                          onSelected: (String value)  {
                                            setState(() {
                                              selectExchange= value;
                                              exchangeController.text=value;
                                              _invalidExchange=false;
                                            });
                                          },
                                          onCanceled: () {

                                          },
                                          child: Container(),
                                        );
                                      }
                                  ),

                                ],
                              ),
                            )),
                        const SizedBox(width: 30,),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Car Model"),
                              const SizedBox(height: 6,),
                              TextFormField(
                                enabled: selectExchange=='Yes',
                                controller: carModelController,
                                validator: selectExchange=='Yes' ? checkCarModel : null,
                                decoration: textFieldDecoration(hintText: 'Enter Car Model',error: _invalidCarModel),
                              ),
                              const SizedBox(height: 20,),

                            ],
                          ),
                        )),
                        const SizedBox(width: 30,),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Evaluation Date"),
                              const SizedBox(height: 6,),
                              TextFormField(
                                enabled: selectExchange=='Yes',
                                controller: evaluationDateController,
                                validator: selectExchange == "Yes" ?checkEvaluationDate : null,
                                decoration: textFieldDecoration(hintText: 'Enter Date',error: _invalidEvaluationDate),
                              ),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ))
                      ],
                    ),
                  )

                ],
              ),
            ),
            const SizedBox(height: 30,),
            const Divider(height: 1,color: mTextFieldBorder),
            ///Finance Scheme
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 42,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Finance Scheme"),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: mTextFieldBorder),
                  Padding(
                    padding: const EdgeInsets.only(left: 60,top: 10,right: 60),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Car Finance"),
                                  const SizedBox(height: 6),
                                  LayoutBuilder(
                                      builder: (BuildContext context, BoxConstraints constraints) {
                                        return CustomPopupMenuButton<String>(elevation: 4,
                                          textController: financeController,
                                          decoration: customPopupDecoration(hintText: 'Select Finance'),
                                          hintText: selectFinance,
                                          childWidth: constraints.maxWidth,
                                          shape: const RoundedRectangleBorder(
                                            side: BorderSide(color:mTextFieldBorder),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          offset: const Offset(1, 40),
                                          tooltip: '',
                                          itemBuilder:  (BuildContext context) {
                                            return yesNo.map((String choice) {
                                              return CustomPopupMenuItem<String>(
                                                  value: choice,
                                                  text: choice,
                                                  child: Container()
                                              );
                                            }).toList();
                                          },

                                          onSelected: (String value)  {
                                            setState(() {
                                              selectFinance= value;
                                              financeController.text=value;
                                            });
                                          },
                                          onCanceled: () {

                                          },
                                          child: Container(),
                                        );
                                      }
                                  ),

                                ],
                              ),
                            )),
                        const SizedBox(width: 30,),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Finance Company"),
                              const SizedBox(height: 6,),
                              TextFormField(
                                enabled: financeController.text=='Yes',
                                decoration: textFieldDecoration(hintText: 'Enter Finance Company'),
                                controller: financeCompanyController,
                              ),
                              const SizedBox(height: 20,),

                            ],
                          ),
                        )),
                        const SizedBox(width: 30,),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Finance Amount"),
                              const SizedBox(height: 6),
                              TextFormField(
                                enabled: financeController.text=='Yes',
                                decoration: textFieldDecoration(hintText: 'Enter Finance Amount'),
                                controller: financeAmountController,
                              ),
                              const SizedBox(height: 20,),

                            ],
                          ),
                        ))
                      ],
                    ),
                  )

                ],
              ),
            ),
            const SizedBox(height: 30,),
            const Divider(height: 1,color: mTextFieldBorder),
          ],
        ),
      ),
    );

  }


  String? checkNameError(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _invalidName=true;
      });
      return 'Please Enter Name';
    }
    setState(() {
      _invalidName=false;
    });
    return null;
  }

  String? checkEmailError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidEmail=true;
      });
      return 'Please Enter Email.';
    }
    else if(!EmailValidator.validate(value)){
      setState(() {
        _invalidEmail=true;
      });
      return 'Please enter a valid email address';
    }
    else{
      setState(() {
        _invalidEmail=false;
      });
    }

    return null;
  }

  String? checkPanError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidPan=true;
      });
      return 'Please Enter Pan Number.';
    }
    setState(() {
      _invalidPan=false;
    });
    return null;
  }

  String? checkMobileError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidMobile=true;
      });
      return 'Please Enter Mobile Number.';
    }
    setState(() {
      _invalidMobile=false;
    });
    return null;
  }

  String? checkGSTError(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _invalidGST=true;
      });
      return 'Please Enter GST.';
    }
    setState(() {
      _invalidGST=false;
    });
    return null;
  }

  String? checkAddressError(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidAddress = true;
      });
      return "Please Enter Address";
    }
    setState(() {
      _invalidAddress = false;
    });
    return null;
  }

  String? checkPinError(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidPin = true;
      });
      return "Enter Pin";
    }
    setState(() {
      _invalidPin = false;
    });
    return null;
  }
  String? stateCheck(String ?value){
    if(value==null || value.isEmpty){
      setState(() {
        stateError=true;
      });
      return 'Select State';
    }
      setState(() {
        stateError=false;
      });
      return null;

}
  String? distCheck(String ?value){
    if(value==null || value.isEmpty){
      setState(() {
        distError=true;
      });
      return 'Select Dist';
    }
    setState(() {
      distError=false;
    });
    return null;

  }
  String? checkMake(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidMake = true;
      });
      return "Enter Make";
    }
    setState(() {
      _invalidMake = false;
    });
    return null;
  }
  String? checkModel(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidModel = true;
      });
      return "Enter Model";
    }
    setState(() {
      _invalidModel = false;
    });
    return null;
  }
  String? checkVariant(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidVariant = true;
      });
      return "Enter Variant";
    }
    setState(() {
      _invalidVariant = false;
    });
    return null;
  }
  String? checkCarModel(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidCarModel = true;
      });
      return "Enter Make";
    }
    setState(() {
      _invalidCarModel = false;
    });
    return null;
  }
  String? checkEvaluationDate(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidEvaluationDate = true;
      });
      return "Enter Date";
    }
    setState(() {
      _invalidEvaluationDate = false;
    });
    return null;
  }

  String? checkFinanceCompany(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidFinanceCompany = true;
      });
      return "Enter Finance Company";
    }
    setState(() {
      _invalidFinanceCompany = false;
    });
    return null;
  }

  String? checkFinanceAmount(String? value){
    if(value == null || value.isEmpty){
      setState(() {
        _invalidFinanceAmount = true;
      });
      return "Enter Finance Amount";
    }
    setState(() {
      _invalidFinanceAmount = false;
    });
    return null;
  }
}

//   class Choice {
//   const Choice({required this.title, required this.icon});
//
//   final String title;
//   final IconData icon;
// }

class SearchState {
  final String label;
  dynamic value;

  SearchState({required this.label, this.value});

  factory SearchState.fromJson(String stateName) {
    return SearchState(label: stateName, value: stateName);
  }
}



  class SearchDist{
  final String label;
  dynamic value;
  SearchDist({required this.label,required this.value});
  factory SearchDist.fromJson(String distName){
    return SearchDist(label: distName,
    value: distName,
    );
  }
  }


class SearchModel {
  final String label;
  dynamic value;

  SearchModel({required this.label, this.value});

  factory SearchModel.fromJson(String stateName) {
    return SearchModel(label: stateName, value: stateName);
  }
}

class SearchMake {
  final String label;
  dynamic value;

  SearchMake({required this.label, this.value});

  factory SearchMake.fromJson(String stateName) {
    return SearchMake(label: stateName, value: stateName);
  }
}

class SearchVariant {
  final String label;
  dynamic value;
  final String generalId ;
  final String color1;
  final String color2;
  final String color3;
  final String color4;
  final String color5;

  SearchVariant({required this.label, required this.generalId, required this.color1,required this.color2,required this.color3,required this.color4,required this.color5, this.value});

  factory SearchVariant.fromJson(Map variantData) {
    print(variantData);
    return SearchVariant(
      label: variantData['varient_name'],
      value: variantData['varient_name'],
      generalId: variantData['general_id'],
      color1: variantData['varient_color1'],
      color2: variantData['varient_color2'],
      color3: variantData['varient_color3'],
      color4: variantData['varient_color4'],
      color5: variantData['varient_color5'],
    );
  }
}

  class LowerCaseTextFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toLowerCase(),selection: newValue.selection);
  }

 }