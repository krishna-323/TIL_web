import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:new_project/utils/static_data/motows_colors.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'add_new_vehicle_po.dart';
import 'edit_vehicle_po.dart';


class ListVehicleOrders extends StatefulWidget {
  final ListVehicleArguments arg;
  const ListVehicleOrders({Key? key, required this.arg}) : super(key: key);

  @override
  State<ListVehicleOrders> createState() => _ListVehicleOrdersState();
}

class _ListVehicleOrdersState extends State<ListVehicleOrders> {

  List poList =[];
  List displayPoList =[];
  int startVal= 0;
  bool loading = false;


  Future fetchPurchaseData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newvehiclepurchase/get_all_new_vehi_pur';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            poList = response;
            // print('+++++++++Check here++++++++');
            // print(poList);
            if(displayPoList.isEmpty){
              if(poList.length>15){
                for(int i=startVal;i<startVal+15;i++){
                  displayPoList.add(poList[i]);
                }
              }
              else{
                for(int i=0;i<poList.length;i++){
                  displayPoList.add(poList[i]);
                }
              }
            }
            // print('--------- new get --------');
            // print(poList);
          }
          loading = false;
        });
      });
    }
    catch (e) {
     // logOutApi(context: context,response: response,exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPurchaseData();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.arg.drawerWidth,widget.arg.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child:  CustomLoader(
              inAsyncCall: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  child: Padding(
                    padding:  const EdgeInsets.only(left: 40.0,right: 40,top:10,bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                         // border: Border.all(color:  Color(0xFFE0E0E0),)

                      ),
                      child: Column(
                        children: [
                          Container(
                           // height: 198,
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
                                    const Text("All Items", style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        // MaterialButton(onPressed: () {
                                        //   exportToExcel();
                                        // },color: Colors.blue,
                                        //   child: const Icon(Icons.document_scanner_outlined,color: Colors.white),),
                                        const SizedBox(width: 10,),
                                        MaterialButton(
                                          color: Colors.blue,
                                          onPressed: (){
                                            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                            const AddNewVehiclePurchaseOrder(selectedDestination: 1.1, drawerWidth: 190,),
                                                transitionDuration: Duration.zero,
                                                reverseTransitionDuration: Duration.zero
                                            )).then((value) => fetchPurchaseData());


                                          },
                                          child: const Text("+ New",style: TextStyle(color: Colors.white),),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),
                              ),
                              const SizedBox(height: 18,),
                              Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                              Container(
                                color: Colors.grey[100],height: 32,
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
                                                    child: Text("Purchase Order")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(
                                                    height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text('Vendor Name')
                                                ),
                                              )
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("Shipping Address")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("Pay-To Address")
                                                ),
                                              )),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: SizedBox(height: 25,
                                                    //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                    child: Text("Total")
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
                           const SizedBox(height:4),
                           for(int i=0;i<=displayPoList.length;i++)
                          Column(
                            children: [
                              if(i!=displayPoList.length)
                              MaterialButton(
                                hoverColor:mHoverColor,
                                onPressed: (){

                                  Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>EditVehiclePurchaseOrder(poList: displayPoList[i], selectedDestination: 1.1, drawerWidth: 190,),
                                                transitionDuration: Duration.zero,
                                                reverseTransitionDuration: Duration.zero
                                            )).then((value) {
                                              fetchPurchaseData();
                                            });
                              },
                                child: Padding(padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                                  child: Row(children: [
                                    Expanded(flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(height: 25,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(displayPoList[i]['po_id']??"")
                                          ),
                                        )),
                                    Expanded(flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(height: 25,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(displayPoList[i]['vendor_name']??"")
                                          ),
                                        )),
                                    Expanded(flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(height: 25,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child:Text(displayPoList[i]['shippingAddressName']??"")
                                          ),
                                        )),
                                    Expanded(flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(height: 25,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child:  Text(displayPoList[i]['shippingAddressName']??"")
                                          ),
                                        )),
                                    Expanded(flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(height: 25,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(displayPoList[i]['grand_total'].toStringAsFixed(2))
                                          ),
                                        )),
                                    Expanded(flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(height: 25,
                                              //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                              child: Text(displayPoList[i]['status']??"")
                                          ),
                                        )),
                                    const Center(child: Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(size: 18,
                                        Icons.arrow_circle_right,
                                        color: Colors.blue,
                                      ),
                                    ),)
                                  ]),
                                  
                                ),
                              ),
                              if(i!=displayPoList.length)
                                Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                              if(i==displayPoList.length)
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text("${startVal+15>poList.length?poList.length:startVal+1}-${startVal+15>poList.length?poList.length:startVal+15} of ${poList.length}",style: const TextStyle(color: Colors.grey)),
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
                                            displayPoList=[];
                                            startVal = startVal-15;
                                            for(int i=startVal;i<startVal+15;i++){
                                              try{
                                                setState(() {
                                                  displayPoList.add(poList[i]);
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
                                          if(poList.length>startVal+15){
                                            displayPoList =[];
                                            startVal=startVal+15;
                                            for(int i=startVal;i<startVal+15;i++){
                                              try{
                                                setState(() {
                                                  displayPoList.add(poList[i]);
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
                          )
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
