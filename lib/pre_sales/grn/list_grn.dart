import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'display_grn_details.dart';
import 'display_vehicle_po.dart';

class ListGrnItems extends StatefulWidget {
  final   ListGrnArguments  arg;
  const ListGrnItems({Key? key, required this. arg}) : super(key: key);

  @override
  State<ListGrnItems> createState() => _ListGrnItemsState();
}

class _ListGrnItemsState extends State<ListGrnItems> {

  List grnList =[];
  List displayGrnList =[];
  int startVal =0;
  bool loading = false;


  Future fetchPurchaseData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclegrn/get_all_newvehigrn';
    try {
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            grnList = value;
            if(displayGrnList.isEmpty){
              if(grnList.length>15){
                for(int i=startVal;i<startVal + 15;i++){
                  displayGrnList.add(grnList[i]);
                }
              }
              else{
                for(int i=startVal;i<grnList.length;i++){
                  displayGrnList.add(grnList[i]);
                }
              }
            }
            // print('-------GrnList-------');
            // print(grnList);
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
  @override
  void initState() {
    super.initState();
    fetchPurchaseData();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body:
      Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.arg.drawerWidth,widget.arg.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: CustomLoader(
              inAsyncCall: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40.0,top: 10,bottom: 10),
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
                            child: Column(children: [
                              const SizedBox(height: 18,),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0,right: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    const Text("All Items",style: TextStyle(color: Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),

                                    MaterialButton(
                                      onPressed: () {

                                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>const ViewGrn(
                                          drawerWidth: 190,
                                          selectedDestination: 2.2,),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero
                                        )).then((value) => fetchPurchaseData());
                                      },color: Colors.blue,
                                      child: const Text(
                                          "+ New",
                                          style: TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18,),
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
                                                    child: Text("VEHICLE ID")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text('VEHICLE NAME')
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("PURCHASE ORDER")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("VENDOR NAME")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("TOTAL")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("STATUS")
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
                            ]),
                          ),
                          const SizedBox(height: 4,),
                          for(int i=startVal;i<=displayGrnList.length;i++)
                            Column(
                              children: [
                                if(i!=displayGrnList.length)
                                MaterialButton(

                                hoverColor: mHoverColor,
                                  onPressed: () {
                                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                        DisplayGrnDetails(drawerWidth:190,
                                          selectedDestination:2.2,
                                          purchaseOrderMapDetails: grnList[i],),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                                    child: Row(
                                      children: [
                                        //Vehicle ID.

                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child:  Text(displayGrnList[i]['newvehi_grn_id'])
                                              ),
                                            )),
                                        //Vehicle Name.
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayGrnList[i]['vehicle_name']??""),
                                              ),
                                            )),

                                        //Purchase Order Id.
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(displayGrnList[i]['purchase_order_number']??"")
                                              ),
                                            )),

                                        //Vehicle Name.
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(displayGrnList[i]['vendor_name']??"")
                                              ),
                                            )),
                                        //Amount
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SizedBox(height: 25,
                                                  //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                  child: Text(double.parse(displayGrnList[i]['amount'].toString()).toStringAsFixed(2)),
                                              ),
                                            )),

                                        displayGrnList[i]['status'] == "Invoiced" ?
                                        Expanded(child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(
                                            height: 25,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                  color: displayGrnList[i]['status'] == "Invoiced" ? Colors.green : Colors.blue,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5,right: 5),
                                                  child: Text(displayGrnList[i]['status'].toString(),style: const TextStyle(color: Colors.white)),
                                                )
                                            ),
                                          ),
                                        )):
                                        const Expanded(child: Padding(
                                          padding: EdgeInsets.only(top: 4.0),
                                          child:
                                          SizedBox(height: 28,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text('--')
                                          ),
                                        )),
                                        const Center(child: Padding(
                                          padding: EdgeInsets.all( 8.0),
                                          child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                            size: 18,
                                            color: Colors.blue,

                                          ),
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),
                                if(i!=displayGrnList.length)
                                  Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),

                                if(i==displayGrnList.length)
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Text("${startVal+15>grnList.length?grnList.length:startVal+1}-${startVal+15>grnList.length?grnList.length:startVal+15} of ${grnList.length}",style: const TextStyle(color: Colors.grey)),
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
                                              displayGrnList=[];
                                              startVal = startVal-15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                try{
                                                  setState(() {
                                                    displayGrnList.add(grnList[i]);
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
                                            if(grnList.length>startVal+15){
                                              displayGrnList=[];
                                              startVal=startVal+15;
                                              for(int i=startVal;i<startVal+15;i++){
                                                try{
                                                  setState(() {
                                                    displayGrnList.add(grnList[i]);
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
