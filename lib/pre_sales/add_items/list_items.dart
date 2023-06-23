import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/classes/arguments_classes/arguments_classes.dart';
import 'package:new_project/pre_sales/add_items/view_items.dart';

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import 'add_items.dart';

class ListItems extends StatefulWidget {
  final ListAddItemsArguments arg;
  const ListItems({Key? key, required this.arg}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  List itemList = [];
  String? authToken;
  bool loading = false;



  Future fetchItemData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/get_all_newitem';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            itemList = value;
            // print('------- new get --------');
            // print(itemList);
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, response: response, exception: e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchItemData();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.arg.drawerWidth, widget.arg.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: CustomLoader(
              inAsyncCall: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50,top: 20),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "All Items ",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          MaterialButton(
                            onPressed: () {

                              Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                  const AddItems(drawerWidth: 190,
                                    selectedDestination: 2.4,),
                              transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero
                              )).then((value) => fetchItemData());
                            },
                            color: Colors.blue,
                            child: const Text("+ New",
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 40,
                          color: Colors.grey[200],
                          child: const Row(
                            children: [
                              Expanded(child: Center(child: Text("NAME"))),
                              Expanded(
                                  child: Center(child: Text("DESCRIPTION"))),
                              Expanded(child: Center(child: Text("RATE"))),
                              Expanded(child: Center(child: Text("HSN/SAC"))),
                              Expanded(
                                  child: Center(child: Text("USAGE UNIT"))),
                              Center(child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                color: Colors.transparent,
                              ),)
                            ],
                          )),
                      // Align(alignment: Alignment.centerLeft,child: Text("OCT 11, Monday",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900],fontSize: 14),)),
                      // SizedBox(height: 10,),
                      const SizedBox(
                        height: 10,
                      ),
                      //dynamic data code.
                      for(int i=0;i<itemList.length;i++)
                        Column(
                          children: [
                            Card(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  splashColor: const Color(0xFFA2BFEC),
                                  onTap: (){

                                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                        ViewItems(title: 1,itemList: itemList[i],drawerWidth: 190,selectedDestination: 2.4),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero
                                    ));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(child: Center(child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: SizedBox(height: 28,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text(itemList[i]['name'])
                                        ),
                                      ))),
                                      Expanded(child: Center(child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: SizedBox(height: 28,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text(itemList[i]['description']??"")
                                        ),
                                      ))),
                                      Expanded(child: Center(child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: SizedBox(height: 28,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Center(child: Column(
                                              children: [
                                                Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Text("Rs. "),
                                                    Text(itemList[i]['selling_price'].toString()),
                                                  ],
                                                ),
                                              ],
                                            ))
                                        ),
                                      ))),

                                      Expanded(child: Center(child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: SizedBox(height: 28,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:80),
                                              child: Row(
                                                children: [
                                                  Text(itemList[i]['tax_code']),
                                                  Text(itemList[i]['sac'].toString())
                                                ],
                                              ),
                                            )
                                        ),
                                      ))),


                                      Expanded(child: Center(child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: SizedBox(height: 28,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Center(child: Column(
                                              children: [
                                                Center(
                                                  child: Text(itemList[i]['unit'].toString()),
                                                ),
                                              ],
                                            ))
                                        ),
                                      ))),
                                      const Center(child: Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(CupertinoIcons.chevron_right_circle_fill,
                                          size: 18,
                                          color: Colors.blue,
                                        ),
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ]),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
