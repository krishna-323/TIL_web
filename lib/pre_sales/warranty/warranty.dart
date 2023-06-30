import 'dart:developer';

import 'package:flutter/material.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';
import 'add_new_warranty.dart';
import 'warranty_details.dart';

class WarrantyArgs{
  final double drawerWidth;
  final double selectedDestination;
  WarrantyArgs({required this.drawerWidth,required this.selectedDestination});
}


class Warranty extends StatefulWidget {
  final WarrantyArgs args;

  const Warranty({Key? key, required this.args}) : super(key: key);

  @override
  State<Warranty> createState() => _WarrantyState();
}

class _WarrantyState extends State<Warranty> {
  @override
  void  initState(){
    super.initState();
    fetchEstimate();
    loading=true;
  }
  bool loading=false;
  List estimateItems=[];
  List displayListItems=[];
  int startVal=0;

  final customerNameController=TextEditingController();
  final phoneController=TextEditingController();
  final cityNameController=TextEditingController();

  Future fetchEstimate()async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/partswarranty/get_all_parts_warranty';
    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            estimateItems=response;
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  if(estimateItems[i]['estVehicleId'] =="SEVH_05590"||estimateItems[i]['estVehicleId'] =="SEVH_05659") {
                    displayListItems.add(estimateItems[i]);
                  }
                }
              }
              else{
                for(int i=0;i<estimateItems.length;i++){

                  if(estimateItems[i]['estVehicleId'] != "SEVH_05608" && estimateItems[i]['estVehicleId'] != "SEVH_05610" && estimateItems[i]['estVehicleId'] != "SEVH_05612" && estimateItems[i]['estVehicleId'] != "SEVH_05627") {

                    displayListItems.add(estimateItems[i]);
                  }
                  else{
                    print(estimateItems[i]['estVehicleId']);
                  }
                }
              }
            }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize:Size.fromHeight(60) ,
        child: CustomAppBar(),),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
          const VerticalDivider(width: 1,
            thickness: 1,),
          Expanded(
            child:
            CustomLoader(
              inAsyncCall: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[50],
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
                            // height:100,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 28,),
                                const Padding(
                                  padding: EdgeInsets.only(left: 18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:   [
                                      Text("Warranty Orders List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(right: 50.0),
                                      //   child: MaterialButton(onPressed: (){
                                      //     Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                      //         AddNewWarranty(selectedDestination: widget.args.selectedDestination,
                                      //           drawerWidth: widget.args.drawerWidth,)
                                      //     )).then((value) => fetchEstimate());
                                      //   },
                                      //     color: Colors.blue,
                                      //     child: const Text('+ Create Purchase Order',style: TextStyle(color: Colors.white),),
                                      //   ),
                                      // )
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
                                                // if(value.isEmpty || value==""){
                                                //   startVal=0;
                                                //  // displayList=[];
                                                // //  fetchListCustomerData();
                                                // }
                                                // else if(phoneController.text.isNotEmpty || cityNameController.text.isNotEmpty){
                                                //   phoneController.clear();
                                                //   cityNameController.clear();
                                                // }
                                                // else{
                                                //   startVal=0;
                                                //   displayList=[];
                                                //   fetchCustomerName(customerNameController.text);
                                                // }
                                              },
                                              style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchCustomerNameDecoration(hintText: 'Search By Name'),  ),),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [

                                                SizedBox(  width: 190,height: 30, child: TextFormField(
                                                  controller:cityNameController,
                                                  onChanged: (value){
                                                    // if(value.isEmpty || value==""){
                                                    //   startVal=0;
                                                    //   displayList=[];
                                                    //   fetchListCustomerData();
                                                    // }
                                                    // else if(phoneController.text.isNotEmpty || customerNameController.text.isNotEmpty){
                                                    //   phoneController.clear();
                                                    //   customerNameController.clear();
                                                    // }
                                                    // else{
                                                    //   startVal=0;
                                                    //   displayList=[];
                                                    //   fetchCityNames(cityNameController.text);
                                                    // }
                                                  },
                                                  style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchCityNameDecoration(hintText: 'Search By Order #'),  ),),
                                                const SizedBox(width: 10,),

                                                SizedBox(  width: 190,height: 30, child: TextFormField(
                                                  controller:phoneController,
                                                  onChanged: (value){
                                                    // if(value.isEmpty || value==""){
                                                    //   startVal=0;
                                                    //   displayList=[];
                                                    //   fetchListCustomerData();
                                                    // }
                                                    // else if(customerNameController.text.isNotEmpty || cityNameController.text.isNotEmpty){
                                                    //   customerNameController.clear();
                                                    //   cityNameController.clear();
                                                    // }
                                                    // else{
                                                    //   try{
                                                    //     startVal=0;
                                                    //     displayList=[];
                                                    //     fetchPhoneName(phoneController.text);
                                                    //   }
                                                    //   catch(e){
                                                    //     log(e.toString());
                                                    //   }
                                                    // }
                                                  },
                                                  style: const TextStyle(fontSize: 14),
                                               //  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  maxLength: 10,
                                                  decoration: searchCustomerPhoneNumber(hintText: 'Search By Status'),  ),),
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
                                                  child: MaterialButton(onPressed: (){
                                                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                        AddNewWarranty(selectedDestination: widget.args.selectedDestination,
                                                          drawerWidth: widget.args.drawerWidth,)
                                                    )).then((value) => fetchEstimate());
                                                  },
                                                    color: Colors.blue,
                                                    child: const Text('+ Create Purchase Order',style: TextStyle(color: Colors.white),),
                                                  )
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
                                Container(color: Colors.grey[100],
                                  //height: 32,
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
                                                      child: Text("Vendor Name")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text('Ship To Name')
                                                  ),
                                                )
                                            ),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Estimated Vehicle Id")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Total Amount")
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                const SizedBox(height: 4,)
                              ],
                            ),
                          ),
                          for(int i=0;i<=displayListItems.length;i++)
                            Column(
                              children: [
                                if(i!=displayListItems.length)
                                  MaterialButton(
                                    hoverColor: Colors.blue[50],
                                    onPressed: (){

                                      Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (context,animation1,animation2) => WarrantyDetails(
                                            //customerList: displayList[i],
                                            drawerWidth: widget.args.drawerWidth,
                                            selectedDestination: widget.args.selectedDestination,
                                            estimateItem: displayListItems[i],
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero,
                                          )
                                      ));
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
                                                    child: Text(displayListItems[i]['billAddressName']??"")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[i]['shipAddressName']?? '')
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[i]['estVehicleId']?? '')
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(double.parse(displayListItems[i]['total'].toString()).toStringAsFixed(2))
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                if(i!=displayListItems.length)
                                  Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                if(i==displayListItems.length)
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("${startVal+15>displayListItems.length?displayListItems.length:startVal+1}-${startVal+15>displayListItems.length?displayListItems.length:startVal+15} of ${displayListItems.length}",style: const TextStyle(color: Colors.grey)),
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
                                              displayListItems=[];
                                              startVal = startVal-15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                setState(() {
                                                  displayListItems.add(estimateItems[i]);
                                                });
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
                                            if(startVal+1+5>estimateItems.length){
                                              // print("Block");
                                            }
                                            else
                                            if(estimateItems.length>startVal+15){
                                              displayListItems=[];
                                              startVal=startVal+15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                setState(() {
                                                  try{
                                                    displayListItems.add(estimateItems[i]);
                                                  }
                                                  catch(e){
                                                    log(e.toString());
                                                  }

                                                });
                                              }
                                            }

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

  searchCustomerNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: customerNameController.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              startVal=0;
              // displayList=[];
              // customerNameController.clear();
              // fetchListCustomerData();
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
              // displayList=[];
              // cityNameController.clear();
              // fetchListCustomerData();
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
                // displayList=[];
                // phoneController.clear();
                // fetchListCustomerData();
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
}
