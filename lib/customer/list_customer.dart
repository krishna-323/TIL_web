import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/customer/view_customer_details.dart';
import '../../classes/arguments_classes/arguments_classes.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../utils/api/get_api.dart';
import '../utils/custom_loader.dart';
import '../utils/static_data/motows_colors.dart';
import 'add_new_customer.dart';

class ViewCustomerList extends StatefulWidget {

  final CustomerArguments arg;
  const ViewCustomerList({Key? key,  required this.arg  }) : super(key: key);

  @override
  State<ViewCustomerList> createState() => _ViewCustomerListState();
}

class _ViewCustomerListState extends State<ViewCustomerList> {

  List customersList=[];
  List displayList=[];
  bool loading = false;
  String? authToken;
  int startVal=0;
  String selectedDate='Select Date';
  String selectedType='Select Type';
  String selectedTypeAll='Type All';
  String selectedType2='Select Type';




  Future fetchListCustomerData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/get_all_newcustomer';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            customersList = value;
            if(displayList.isEmpty){
              if(customersList.length>5){
                for(int i=startVal;i<startVal+15;i++){
                  displayList.add(customersList[i]);
                }
              }
              else{
                for(int i=0;i<customersList.length;i++){
                  displayList.add(customersList[i]);
                }
              }
            }

            for(int i=0;i<customersList.length;i++){
              cityNames.add(
                  customersList[i]['city']??""
              );
            }

          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }


  Future fetchCustomerName(String customerName)async{

    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/get_search_by_customer_name/$customerName';
    try{
        await getData(url:url ,context: context).then((value) {
          setState(() {
            if(value!=null){
              response=value;
              customersList=response;
              //Assigning displayList to empty list[].
              displayList=[];
              //Checking displayList is empty or Not.
              if(displayList.isEmpty){
                if(customersList.length>15){
                  //For adding only Five Items at a time.
                  for(int i=startVal;i<startVal+15;i++){
                    displayList.add(customersList[i]);
                  }
                }
                else{
                  for(int i=startVal;i<customersList.length;i++){
                    displayList.add(customersList[i]);
                  }
                }
              }
            }
          });

      });
    }
    catch(e){
      log(e.toString());
    }
  }
  Future fetchPhoneName(String phoneNumber)async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/get_search_by_mobileno/$phoneNumber';
    try{
      await getData(context:context ,url: url).then((value) => {
        setState((){
          if(value!=null){
            response=value;
            customersList=response;
            //DisplayList assigning empty list.
            displayList=[];
            // Checking displayList Items.
             if(displayList.isEmpty){
               //checking initial list length.
               if(customersList.length>15){
                 for(int i=startVal;i<startVal+15;i++){
                   try{
                     setState(() {
                       displayList.add(customersList[i]);
                     });
                   }
                  catch(e){
                     log(e.toString());
                  }

                 }
               }
               else{
                 for(int i=startVal;i<customersList.length;i++){
                   displayList.add(customersList[i]);
                 }
               }
             }

          }
        }),
      });
    }
    catch(e){
      logOutApi(context: context,response:response ,exception:e.toString());
     log(e.toString());
    }
  }
  Future fetchCityNames(String cityName)async{
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/newcustomer/get_search_by_city/$cityName';
    try{
      await getData(url: url,context:context ).then((value) =>{
        setState((){
          if(value!=null){
            customersList=value;
            displayList=[];
            if(displayList.isEmpty){
              if(customersList.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayList.add(customersList[i]);
                }
              }
              else{
                for(int i=startVal;i<customersList.length;i++){
                  displayList.add(customersList[i]);
                }
              }
            }
          }
        }),
      });
    }
    catch(e){
      log(e.toString());
    }
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
  textFieldStateName({required String hintText, bool? error}) {
    return  InputDecoration(
      suffixIcon: cityNameController.text.isEmpty?const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.search,size: 18,),
      ):
      InkWell(onTap: (){
        setState(() {
          startVal=0;
          displayList=[];
          fetchListCustomerData();
          customerNameController.clear();
          phoneController.clear();
        });

      },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.close,size: 18,),
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
  searchCustomerNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: customerNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayList=[];
              customerNameController.clear();
              fetchListCustomerData();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  searchCityNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: cityNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              displayList=[];
              cityNameController.clear();
              fetchListCustomerData();
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  searchCustomerPhoneNumber ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: phoneController.text.isEmpty? const Icon(Icons.search,size: 18,):InkWell(
      onTap: (){
        setState(() {
          setState(() {
            startVal=0;
            displayList=[];
            phoneController.clear();
            fetchListCustomerData();
          });
        });
      },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  final customerNameController=TextEditingController();
  final phoneController=TextEditingController();
  final cityNameController=TextEditingController();
  bool isTypeFocused =false;
  bool invalidType=false;
  List <String>cityNames=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchListCustomerData();
    loading = true;
  }

  Future getCityName()async{
    List name=[];
    for(int i=0;i<cityNames.length;i++){
      name.add(SearchCityName.fromJson(cityNames[i]));
    }
    return name;
 }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomDrawer(widget.arg.drawerWidth,widget.arg.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child:
            Container(
              color: Colors.grey[50],
              child: CustomLoader(
                inAsyncCall: loading,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40,top: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE0E0E0),)

                      ),
                      child: Column(
                        children: [
                          Container(
                              height: 198,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 18,),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 18.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                        Text("Customer List ", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:18.0),
                                    child: SizedBox(height: 100,
                                      child: Row(
                                        children: [
                                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(  width: 190,height: 30, child: TextFormField(
                                                controller:customerNameController,
                                                onChanged: (value){
                                                  if(value.isEmpty || value==""){
                                                      startVal=0;
                                                      displayList=[];
                                                      fetchListCustomerData();
                                                  }
                                                  else if(phoneController.text.isNotEmpty || cityNameController.text.isNotEmpty){
                                                    phoneController.clear();
                                                    cityNameController.clear();
                                                  }
                                                  else{
                                                      startVal=0;
                                                      displayList=[];
                                                      fetchCustomerName(customerNameController.text);
                                                  }
                                                },
                                                style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchCustomerNameDecoration(hintText: 'Search By Name'),  ),),
                                              const SizedBox(height: 20),
                                              Row(
                                                children: [

                                                  SizedBox(  width: 190,height: 30, child: TextFormField(
                                                    controller:cityNameController,
                                                    onChanged: (value){
                                                      if(value.isEmpty || value==""){
                                                        startVal=0;
                                                        displayList=[];
                                                        fetchListCustomerData();
                                                      }
                                                      else if(phoneController.text.isNotEmpty || customerNameController.text.isNotEmpty){
                                                        phoneController.clear();
                                                        customerNameController.clear();
                                                      }
                                                      else{
                                                        startVal=0;
                                                        displayList=[];
                                                        fetchCityNames(cityNameController.text);
                                                      }
                                                    },
                                                    style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchCityNameDecoration(hintText: 'Search By Cityname'),  ),),
                                            const SizedBox(width: 10,),

                                                  SizedBox(  width: 190,height: 30, child: TextFormField(
                                                    controller:phoneController,
                                                    onChanged: (value){
                                                      if(value.isEmpty || value==""){
                                                        startVal=0;
                                                        displayList=[];
                                                        fetchListCustomerData();
                                                      }
                                                      else if(customerNameController.text.isNotEmpty || cityNameController.text.isNotEmpty){
                                                        customerNameController.clear();
                                                        cityNameController.clear();
                                                      }
                                                      else{
                                                          try{
                                                            startVal=0;
                                                            displayList=[];
                                                            fetchPhoneName(phoneController.text);
                                                          }
                                                          catch(e){
                                                            log(e.toString());
                                                          }
                                                      }
                                                    },
                                                    style: const TextStyle(fontSize: 14),
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    maxLength: 10,
                                                    decoration: searchCustomerPhoneNumber(hintText: 'Search By Phone'),  ),),
                                                  const SizedBox(width: 10,),
                                                ],
                                              ),
                                            ],
                                          )),
                                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 44),
                                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: MaterialButton(
                                                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4.0) ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context)=>AddNewCustomer(
                                                              drawerWidth:widget.arg.drawerWidth ,
                                                              selectedDestination: widget.arg.selectedDestination, title: 1,
                                                            )
                                                            )
                                                        ).then((value) => fetchListCustomerData());
                                                      },color: Colors.blue,
                                                      child:  const Padding(
                                                        padding: EdgeInsets.only(left:10.0,right: 10.0),
                                                        child: Text(
                                                            "+ Customer",
                                                            style: TextStyle(color: Colors.white)),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20,),
                                                  // SizedBox(width: 10,),
                                                  // MaterialButton(
                                                  //   minWidth: 20,
                                                  //   shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(12.0) ),
                                                  //   color: Colors.white,
                                                  //   onPressed: () {
                                                  //     Navigator.push(
                                                  //         context,
                                                  //         MaterialPageRoute(builder: (context)=>OrderDetails(
                                                  //           drawerWidth:widget.arg.drawerWidth ,
                                                  //           selectedDestination: widget.arg.selectedDestination, title: 1,
                                                  //         )
                                                  //         )
                                                  //     ).then((value) => fetchListCustomerData());
                                                  //   },
                                                  //   child: const Icon(
                                                  //       Icons.more_vert,
                                                  //     color: Colors.black,
                                                  //       ),
                                                  // )
                                                ],
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                  Container(color: Colors.grey[100],height: 32,
                                    child:  IgnorePointer(
                                      ignoring: true,
                                      child: MaterialButton(
                                        onPressed: (){},
                                        hoverColor: Colors.transparent,
                                        hoverElevation: 0,
                                        child: const Padding(
                                          padding: EdgeInsets.only(left: 18.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4.0),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text("Customer ID")
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4),
                                                    child: SizedBox(
                                                        height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text('Name')
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text("City")
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text("Email")
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 4),
                                                    child: SizedBox(height: 25,
                                                        //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                        child: Text("Phone No")
                                                    ),
                                                  )),

                                              Center(child: Padding(
                                                padding: EdgeInsets.only(right: 8),
                                                child: Icon(size: 18,
                                                  Icons.more_vert,
                                                  color: Colors.transparent,
                                                ),
                                              ),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                ],
                              )
                          ),
                          for(int i=0;i<=displayList.length;i++)
                            Column(
                              children: [
                                if(i!=displayList.length)
                                MaterialButton(
                                  hoverColor: Colors.blue[50],
                                  onPressed: (){
                                    // print('-------------inontap------------------');
                                    // print(displayList[i]['customer_id']);
                                    Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (context,animation1,animation2) => ViewCustomers(customerList: displayList[i],drawerWidth: widget.arg.drawerWidth,selectedDestination: widget.arg.selectedDestination,
                                        customerId: displayList[i]['customer_id'],),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    )
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayList[i]['customer_name']??"")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: SizedBox(
                                                  height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayList[i]['street_address']?? '')
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayList[i]['city']??"")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayList[i]['email_id'] ?? "")
                                              ),
                                            )),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayList[i]['mobile']??"")
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

                                      Text("${startVal+15>customersList.length?customersList.length:startVal+1}-${startVal+15>customersList.length?customersList.length:startVal+15} of ${customersList.length}",style: const TextStyle(color: Colors.grey)),
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
                                              displayList=[];
                                              startVal = startVal-15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                try{
                                                  setState(() {
                                                    displayList.add(customersList[i]);
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
                                            if(customersList.length>startVal+15){
                                              displayList=[];
                                              startVal=startVal+15;
                                              for(int i=startVal;i<startVal+15;i++){
                                               try{
                                                 setState(() {
                                                   displayList.add(customersList[i]);
                                                 });
                                               }
                                               catch(e){
                                                 log(e.toString());
                                               }

                                              }
                                            }
                                            // if(startVal+1+5>customersList.length){
                                            //   // print("Block");
                                            // }
                                            // else if(customersList.length>startVal+5){
                                            //   displayList=[];
                                            //   startVal=startVal+5;
                                            //   for(int i=startVal;i<startVal+5;i++){
                                            //     setState(() {
                                            //       try{
                                            //         displayList.add(customersList[i]);
                                            //       }
                                            //       catch(e){
                                            //         print(e);
                                            //       }
                                            //
                                            //     });
                                            //   }
                                            // }

                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 20,),

                                    ],
                                  )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}
class SearchCityName{
  final String label;
  dynamic value;
  SearchCityName({required this.label, required this.value});
  factory SearchCityName.fromJson(String cityName){
    return SearchCityName(label: cityName, value: cityName);
}
}
