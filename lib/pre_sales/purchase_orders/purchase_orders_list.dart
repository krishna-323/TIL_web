import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../classes/arguments_classes/arguments_classes.dart';
import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../utils/static_data/motows_colors.dart';
import 'add_new_po.dart';
import 'details_po.dart';



class DisplayEstimateItems extends StatefulWidget {
  final DisplayEstimateItemsArgs args;

  const DisplayEstimateItems({Key? key, required this.args}) : super(key: key);

  @override
  State<DisplayEstimateItems> createState() => _DisplayEstimateItemsState();
}

class _DisplayEstimateItemsState extends State<DisplayEstimateItems> {
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
  Future fetchEstimate()async{
    dynamic response;
    String url='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/estimatevehicle/get_all_estimate_vehicle';
    try{
      await getData(url:url ,context: context).then((value) {
        setState(() {
          if(value!=null){
            response=value;
            estimateItems=response;
            // print('---------response-------');
            // print(estimateItems);
            if(displayListItems.isEmpty){
              if(estimateItems.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayListItems.add(estimateItems[i]);
                }
              }
              else{
                for(int i=0;i<estimateItems.length;i++){
                  displayListItems.add(estimateItems[i]);
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
  // Search Controller Declaration.
  final searchByStatus=TextEditingController();
  final searchByName=TextEditingController();
  final searchByOrder=TextEditingController();
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
                    padding: const EdgeInsets.only(left: 40,right: 40,top: 20,bottom: 20),
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
                                const SizedBox(height: 18,),
                                const Padding(
                                  padding: EdgeInsets.only(left: 18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:   [
                                      Text("Vehicle Orders List", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
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
                                              controller:searchByName,
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
                                              style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchNameDecoration(hintText: 'Search By Name'),  ),),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [

                                                SizedBox(  width: 190,height: 30, child: TextFormField(
                                                  controller:searchByOrder,
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
                                                  style: const TextStyle(fontSize: 14),  keyboardType: TextInputType.text,    decoration: searchStatusDecoration(hintText: 'Search By Order #'),  ),),
                                                const SizedBox(width: 10,),

                                                SizedBox(  width: 190,height: 30, child: TextFormField(
                                                  controller:searchByStatus,
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
                                                  decoration: searchByOrderDecoration(hintText: 'Search By Status'),  ),),
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
                                                  padding: const EdgeInsets.only(right: 50.0),
                                                  child: MaterialButton(onPressed: (){
                                                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                        Estimate(selectedDestination: widget.args.selectedDestination,
                                                          drawerWidth: widget.args.drawerWidth,)
                                                    )).then((value) => fetchEstimate());
                                                  },
                                                    color: Colors.blue,
                                                    child: const Text('+ Create Vehicle Order',style: TextStyle(color: Colors.white),),
                                                  ),
                                                ),
                                                const SizedBox(width: 20,),
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
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Vehicle Id")
                                                  ),
                                                )),
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
                                                      child: Text("Total Amount")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Status")
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

                                      // print('-------------inontap------------------');
                                      // print(estimateItems[i]);
                                      Navigator.of(context).push(PageRouteBuilder(
                                          pageBuilder: (context,animation1,animation2) => ViewEstimateItem(
                                            //customerList: displayList[i],
                                            drawerWidth: widget.args.drawerWidth,
                                            selectedDestination: widget.args.selectedDestination,
                                            estimateItem: estimateItems[i],
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
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(double.parse(displayListItems[i]['total'].toString()).toStringAsFixed(2))
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text(displayListItems[i]['status']??'--')
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if(i!=displayListItems.length)
                                  Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                                if(i==displayListItems.length)
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("${startVal+15>estimateItems.length?estimateItems.length:startVal+1}-${startVal+15>estimateItems.length?estimateItems.length:startVal+15} of ${estimateItems.length}",style: const TextStyle(color: Colors.grey)),
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
  // Search Text field Decoration.
  searchNameDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByName.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
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
  searchStatusDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByStatus.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
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
  searchByOrderDecoration ({required String hintText, bool? error}){
    return InputDecoration(hoverColor: mHoverColor,
      suffixIcon: searchByOrder.text.isEmpty? const Icon(Icons.search,size: 18,):InkWell(
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
