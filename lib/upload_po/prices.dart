

import 'package:flutter/material.dart';

import '../utils/api/getApi.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_loader.dart';
import 'display_excel_data.dart';

class Prices extends StatefulWidget {
  final  args;
  const Prices({Key? key, required this.args}) : super(key: key);

  @override
  State<Prices> createState() => _PricesState();
}

class _PricesState extends State<Prices> {

  List poList=[];
  bool isLoading = true;

   fetchPoData() async{
    dynamic response;
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_mod_general";
    try {
      await getData(context: context, url: url).then((value) {
        // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["general_id"]}");
        // print(value);
        setState(() {
          if(value!=null){
            response = value;

            poList = value;

            // print('------new get all docket data ----------');
            // print(docketData);
            // print(total);
          }
          isLoading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // ODO: implement initState
    super.initState();
    fetchPoData();
  }

  String selectedDate ='';
  DateTime selectedDateTime = DateTime.now();
   _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDateTime = picked;

        selectedDate = "${picked.day.toString()}-${picked.month.toString()}-${picked.year.toString()}";
        print(selectedDate);
        getPoByCate(selectedDate);
      });
    }
  }

   getPoByCate(poDate) async{
    dynamic response;
    String url = "https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/excel/get_all_by_date/$poDate";
    try {
      await getData(context: context, url: url).then((value) {
        // print("https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/docket_customer/get_docket_wrapper_by_id/${widget.docketDetails["general_id"]}");
        // print(value);
        setState(() {
          if(value!=null){
            response = value;
            poList = value;
            // print('------new get all docket data ----------');
            // print(docketData);
            // print(total);
          }
          isLoading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()) ,
      body:Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.args.drawerWidth,widget.args.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: CustomLoader(
              inAsyncCall: isLoading,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:  const EdgeInsets.only(top: 8,left: 40,right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text(" ",style: TextStyle(color: Colors.indigo,fontSize: 18,fontWeight: FontWeight.bold),),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed:(){
                                Navigator.push(context, MaterialPageRoute(builder:(context)=>ExcelTableScreen(
                                  drawerWidth:widget.args.drawerWidth,
                                    selectedDestination:widget.args.selectedDestination,
                                ),),
                                );
                              },
                              child:Text('Display Page'),
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 50,),
                              SizedBox(
                                width: 160,
                                child: TextField(
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      hintText: 'Search by date'
                                  ),
                                  onTap: (){
                                    _selectDate(context);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10,),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Container(color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10,top: 10,right: 4,left: 8),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  const [
                                Expanded(child: Text("Make",overflow: TextOverflow.ellipsis,)),
                                Divider(color: Colors.black,
                                  height: 2,
                                  thickness: 3,
                                ),
                                Expanded(child: Text('Model',maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                VerticalDivider(
                                  width: 1,
                                  thickness: 1,
                                ),
                                Expanded(child: Text('Varient',maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                VerticalDivider(
                                  width: 1,
                                  thickness: 1,
                                ),
                                Expanded(child: Text('Date',maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                VerticalDivider(
                                  width: 1,
                                  thickness: 1,
                                ),
                                Expanded(child: Text('On-Road Price',maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                VerticalDivider(
                                  width: 1,
                                  thickness: 1,
                                ),
                                Expanded(child: Text('Color',maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                VerticalDivider(
                                  width: 1,
                                  thickness: 1,
                                ),
                                Expanded(child: Text('Manufacture Year',maxLines: 1,overflow: TextOverflow.ellipsis,)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          for(int i=0;i<poList.length;i++)
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(poList[i]['make'].toString(),overflow: TextOverflow.ellipsis,)),
                                Expanded(child: Text(poList[i]['model'].toString(),overflow: TextOverflow.ellipsis,)),
                                Expanded(child: Text(poList[i]['varient'].toString(),overflow: TextOverflow.ellipsis,)),
                                Expanded(child: Text(poList[i]['date'].toString(),overflow: TextOverflow.ellipsis,)),
                                Expanded(child: Text(poList[i]['on_road_price'].toString(),overflow: TextOverflow.ellipsis,)),
                                Expanded(child: Text(poList[i]['color'].toString(),overflow: TextOverflow.ellipsis,)),
                                Expanded(child: Text(poList[i]['year_of_manufacture'].toString(),overflow: TextOverflow.ellipsis,)),
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ) ,
    );
  }
}
