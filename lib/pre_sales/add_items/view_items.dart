import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/api/get_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../widgets/input_decoration_text_field.dart';
import 'add_items.dart';
import 'bloc/item_details_bloc.dart';
import 'edit_items.dart';
import 'model/item_detail_model.dart';


//dynamic data code.
class ViewItems extends StatefulWidget {
  final int title;
  final double drawerWidth;
  final double selectedDestination;
  final Map itemList;
  const ViewItems( {Key? key, required this.itemList, required this.title, required this.drawerWidth, required this.selectedDestination}) : super(key: key);

  @override
  _ViewItemsState createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {


  String selectedId="";
  late int selectedIndex;
  String? authToken;

  String type='';

  Future getInitialData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken= prefs.getString("authToken");
  }
  @override
  void initState() {

    // print(widget.itemList);
    super.initState();
    loading=true;
    getInitialData().whenComplete(() {
      selectedId=widget.itemList['newitem_id'];
      itemDetailsBloc.fetchItemNetwork(widget.itemList['newitem_id'],authToken!);
      fetchItemData();

    });
    // fetchItemData().whenComplete(() {
    //   selectedId=widget.itemList['newitem_id'];
    //   itemDetailsBloc.fetchItemNetwork(widget.itemList['newitem_id'],authToken!);
    // });

  }
  List itemList =[];
  bool loading = false;
  // Future fetchItemData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   authToken= prefs.getString("authToken");
  //   print("++++++++++++++++++++++++++++++++++++++++++++++++++");
  //   print(authToken);
  //   final response = await http
  //       .get(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/get_all_newitem_name_and_id'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Authorization': 'Bearer $authToken'
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     setState(() {
  //       print("+++++++++++Item List+++++++");
  //       itemList=jsonDecode(response.body);
  //       // print(itemList);
  //     });
  //     //return Album.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     print("++++++++++Status Code +++++++++++++++");
  //     print(response.statusCode.toString());
  //   }
  // }

  Future fetchItemData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/get_all_newitem_name_and_id';
    try {
      await getData(context: context,url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            itemList = value;
          }
          loading = false;
        });
      });
    }
    catch (e) {
      logOutApi(context: context, exception: e.toString(), response: response);
      setState(() {
        loading=false;
      });
    }
  }

  dynamic size;
  dynamic width;
  dynamic height;

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()
      ),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.drawerWidth,widget.selectedDestination),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(
                body:CustomLoader(
                  inAsyncCall: loading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                  child: Column(
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("All Items"),
                                          Row(
                                            children: [
                                              SizedBox(width: 60,child: MaterialButton(onPressed: (){
                                               // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItems(title: 1, drawerWidth: widget.drawerWidth, selectedDestination: widget.selectedDestination))).then((value) =>fetchItemData());
                                                Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                    const AddItems(drawerWidth: 190, selectedDestination: 2.4,)));
                                              },color: Colors.blue,child: const Text("+ New",style: TextStyle(color: Colors.white)),))
                                            ],
                                          )
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,

                                itemCount: itemList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(color: selectedId==itemList[index]['newitem_id'] ?Colors.grey[100]: Colors.white,
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(onTap: (){
                                              selectedId=itemList[index]['newitem_id'];
                                              setState(() {
                                                selectedIndex = index;
                                                itemDetailsBloc.fetchItemNetwork(itemList[index]['newitem_id'],authToken!

                                                );
                                              });
                                            },
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 8.0,top: 10,bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Center(child: Text(itemList[index]['name'],style: TextStyle(color: Colors.blue[800]))),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      const Divider(height: 1),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      StreamBuilder(
                          stream: itemDetailsBloc.getItemDetails,
                          builder: (context, AsyncSnapshot <ItemModel>snapshot) {
                            if(snapshot.hasData){

                              return Expanded(flex: 2,
                                child: DefaultTabController(
                                  length: 3,
                                  child: Scaffold(
                                    body:
                                    RawScrollbar(
                                      thumbColor: Colors.black45,
                                      radius: const Radius.circular(5.0),
                                      thumbVisibility: true,
                                      thickness: 10.0,
                                      child: SingleChildScrollView(
                                       // physics: const ScrollPhysics(),
                                       // controller: ScrollController(),
                                         primary: true,
                                        child:
                                        Column(
                                          children: [
                                            const Align(
                                              alignment: Alignment.topLeft,
                                              child: SizedBox(
                                                width: 400,
                                                child: TabBar(
                                                  // /    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                                  indicatorColor: Colors.blue,
                                                  labelColor: Colors.black,
                                                  unselectedLabelColor: Colors.lightBlue,
                                                  tabs: [
                                                    Tab(text: 'ITEM',),
                                                    Tab(text: 'INVENTORY'),
                                                    Tab(text: 'PURCHASE'),
                                                    // Tab(text: 'History'),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              height: height,
                                              child:
                                              Padding(
                                                padding: const EdgeInsets.only(left:50),
                                                child: TabBarView(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        Align(
                                                          alignment: Alignment.bottomLeft,
                                                          child:
                                                          SizedBox(
                                                            width: 500,
                                                            child:
                                                            Column(
                                                              children: [
                                                                //first container.
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children:  [
                                                                    Row(
                                                                      children:  [
                                                                        const SizedBox(
                                                                          width: 150,
                                                                          child: Text(
                                                                            'ItemType ',
                                                                            style:
                                                                            TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                          ),
                                                                        ),
                                                                        Text(snapshot.data!.docketData[0].itemData['type'])
                                                                      ],
                                                                    ),
                                                                    // MaterialButton(
                                                                    //   onPressed: () {
                                                                    //     // print("----------view edit vendor-----------");
                                                                    //     // print(snapshot.data!.vendorDocketData[0].vendorData);
                                                                    //     Navigator.push(
                                                                    //         context,
                                                                    //         MaterialPageRoute(
                                                                    //             builder: (context) => EditItems(
                                                                    //               drawerWidth: widget.drawerWidth,
                                                                    //               selectedDestination: widget.selectedDestination,
                                                                    //               itemData:snapshot.data!.docketData[0].itemData,
                                                                    //
                                                                    //             )
                                                                    //         )
                                                                    //     ).then(
                                                                    //             (value) =>
                                                                    //             fetchItemData());
                                                                    //   },
                                                                    //   color: Colors.blue,
                                                                    //   child: Row(
                                                                    //     children: const [
                                                                    //       Icon(Icons.edit,color: Colors.white),
                                                                    //       Text("Edit",
                                                                    //           style: TextStyle(
                                                                    //               color: Colors.white)
                                                                    //       ),
                                                                    //     ],
                                                                    //   ),
                                                                    // ),

                                                                    // MaterialButton(
                                                                    //   color: Colors.lightBlue,
                                                                    //   onPressed: (){
                                                                    //     showDialog(context: context, builder: (delete) =>
                                                                    //         AlertDialog(title: const Image(image: AssetImage('assets/logo/circular.png'),height: 50,),
                                                                    //           content: const Text('Please Conform '),
                                                                    //           actions: [
                                                                    //             Container(
                                                                    //               color: Colors.white,
                                                                    //               padding: const EdgeInsets.all(14),
                                                                    //               child:  Row(
                                                                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //                 children: [
                                                                    //                   InkWell(
                                                                    //                     child: Container(width: 50,
                                                                    //                       color: Colors.lightBlue,
                                                                    //                       height:25,child: Center(child: Text('Yes',style: TextStyle(color: Colors.white),)),
                                                                    //                     ),
                                                                    //                     onTap: (){
                                                                    //                       setState(() {
                                                                    //                         deleteItems();
                                                                    //                         selectedId = snapshot.data!.docketData[0].itemData['newitem_id'];
                                                                    //                         print('========================================');
                                                                    //                         print(selectedId);
                                                                    //
                                                                    //                       });
                                                                    //                     },
                                                                    //                   ),
                                                                    //                   InkWell(
                                                                    //                     child: Container(width: 50,
                                                                    //                       height: 25,
                                                                    //                       color: Colors.lightBlue,
                                                                    //                       child: Center(child: Text("No",style: TextStyle(color: Colors.white),)),
                                                                    //                     ),onTap: (){
                                                                    //                     setState(() {
                                                                    //                       ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                                                                    //                         content: new Text("Go Back"),)
                                                                    //                       );
                                                                    //                       Navigator.of(context).pop();
                                                                    //                     });
                                                                    //                   },
                                                                    //
                                                                    //
                                                                    //                   )
                                                                    //                 ],
                                                                    //               ),
                                                                    //             ),],
                                                                    //         )
                                                                    //     );
                                                                    //   },
                                                                    //   child: Row(children: const [
                                                                    //     Icon(Icons.delete,color: Colors.white,),
                                                                    //     Text("Delete",style: TextStyle(color: Colors.white),)
                                                                    //   ]),
                                                                    // )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 20,),
                                                                //second container.
                                                                Row(
                                                                  children:   [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Name',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text(snapshot.data!.docketData[0].itemData['name'])
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //item code
                                                                Row(
                                                                  children:   [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Item Code',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text(snapshot.data!.docketData[0].itemData['item_code'])
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Row(
                                                                  children:   [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Description',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text(snapshot.data!.docketData[0].itemData['description'])
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //third container
                                                                if(snapshot.data!.docketData[0].itemData['type']=='Goods')
                                                                  Row(
                                                                    children:   [
                                                                      const SizedBox(
                                                                        width: 150,
                                                                        child: Text(
                                                                          'HSN',
                                                                          style:
                                                                          TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                        ),
                                                                      ),

                                                                      Text(snapshot.data!.docketData[0].itemData['tax_code'])
                                                                    ],
                                                                  ),
                                                                const SizedBox(height: 10,),
                                                                if(snapshot.data!.docketData[0].itemData['type']=='Sevices')
                                                                  Row(
                                                                    children:   [
                                                                      const SizedBox(
                                                                        width: 150,
                                                                        child: Text(
                                                                          'SAC',
                                                                          style:
                                                                          TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                        ),
                                                                      ),

                                                                      Text(snapshot.data!.docketData[0].itemData['sac'])
                                                                    ],
                                                                  ),

                                                                const SizedBox(height: 10,),
                                                                //fourth container.
                                                                Row(
                                                                  children:   [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Unit',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text(snapshot.data!.docketData[0].itemData['unit'])
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                //fifth container.
                                                                // Row(
                                                                //   children: const [
                                                                //     SizedBox(
                                                                //       width: 150,
                                                                //       child: Text(
                                                                //         'Created Source',
                                                                //         style:
                                                                //         TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                //       ),
                                                                //     ),
                                                                //
                                                                //     Text('User')
                                                                //   ],
                                                                // ),
                                                                const SizedBox(height: 10,),

                                                                //six container.
                                                                Row(
                                                                  children:   [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Tax',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text('${snapshot.data!.docketData[0].itemData['tax_preference']}%')
                                                                    // Text('[5%]')
                                                                  ],
                                                                ),

                                                                const SizedBox(
                                                                  height: 35,
                                                                ),

                                                                const Align(
                                                                  alignment: Alignment.topLeft,
                                                                  child: Text(
                                                                    'Purchase Information',
                                                                    style: TextStyle(fontSize: 16),
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                //seventh container.
                                                                Row(
                                                                  children:   [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Purchase Price',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text(snapshot.data!.docketData[0].itemData['purchase_price'].toString())
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                //eight container.
                                                                Row(
                                                                  children:   [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Purchase Account',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text(snapshot.data!.docketData[0].itemData['purchase_account'])
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 15),
                                                                //ninth container.


                                                                // ------------------------------------------------------------//

                                                                const SizedBox(height: 35,),
                                                                const Align(
                                                                  alignment: Alignment.topLeft,
                                                                  child: Text(
                                                                    'Sales Information',
                                                                    style: TextStyle(fontSize: 16),
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                //seventh container.
                                                                Row(
                                                                  children:    [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Selling Price',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text(snapshot.data!.docketData[0].itemData['selling_price'].toString())
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                //eight container.
                                                                Row(
                                                                  children:   [
                                                                    const SizedBox(
                                                                      width: 150,
                                                                      child: Text(
                                                                        'Sales Account',
                                                                        style:
                                                                        TextStyle(color: Color.fromRGBO(119, 119, 119, 1)),
                                                                      ),
                                                                    ),

                                                                    Text(snapshot.data!.docketData[0].itemData['selling_account'])
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 15),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        // Align(
                                                        //   alignment: Alignment.topLeft,
                                                        //   child: Container(
                                                        //     width:500,
                                                        //     child: ExpansionTile(
                                                        //       title: Row(
                                                        //         children: const [
                                                        //           Text(
                                                        //             'Associated Price List',
                                                        //             style: TextStyle(
                                                        //                 color: Colors.blue
                                                        //             ),
                                                        //           ),
                                                        //           // Icon(Icons.arrow_drop_down,color: Colors.blue,)
                                                        //         ],
                                                        //       ),
                                                        //       // subtitle: Text('Trailing expansion arrow icon'),
                                                        //       children: <Widget>[
                                                        //         Column(
                                                        //           children: [
                                                        //             const Divider(color: Colors.grey,thickness: 1,),
                                                        //             Row(
                                                        //               children: const [
                                                        //                 Padding(
                                                        //                   padding: EdgeInsets.only(left: 15),
                                                        //                   child: SizedBox(
                                                        //                       width:200,
                                                        //                       child: Text('Name')),
                                                        //                 ),
                                                        //
                                                        //                 Text('Price'),
                                                        //               ],
                                                        //             ),
                                                        //             const Divider(color: Colors.grey,thickness: 1,),
                                                        //             const Text('The sales price lists associated with this item will be displayed'),
                                                        //             const SizedBox(height: 10,),
                                                        //             Padding(
                                                        //               padding: const EdgeInsets.only(left: 60),
                                                        //               child: Row(
                                                        //                 children: const [
                                                        //                   Text('here.'),
                                                        //                   Text('Create a price list',
                                                        //                     style: TextStyle(
                                                        //                         color: Colors.lightBlue
                                                        //                     ),
                                                        //                   ),
                                                        //                   Text('with a custom rate for this item.')
                                                        //                 ],
                                                        //               ),
                                                        //             ),
                                                        //             const SizedBox(height: 10,)
                                                        //           ],
                                                        //         )
                                                        //
                                                        //
                                                        //       ],
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            const SizedBox(height: 20,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                const Text(
                                                                  'Inventory',
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                                MaterialButton(onPressed: () {
                                                                  showInventoryDialog(context);
                                                                },
                                                                  color: Colors.blue,
                                                                  child: const Text('Add',style: TextStyle(color: Colors.white)),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(height: 20,),
                                                            Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Card(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text('Item Code : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('007',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Name : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('James Bond',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Manufacturer : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('Ian Fleming',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text('Description : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('A British secret agent ',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Item Code : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('007',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Name : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('James Bond',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 20,),
                                                                      Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          MaterialButton(
                                                                            onPressed: () {

                                                                            },
                                                                            color: Colors.blue,
                                                                            child: const Text('Edit',style:TextStyle(color: Colors.white)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            // SizedBox(
                                                            //   width: 700,
                                                            //   // child: getInventory(),
                                                            // ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            const SizedBox(height: 20,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                const Text(
                                                                  'Purchase',
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                                MaterialButton(onPressed: () {
                                                                  showPurchaseDialog(context);
                                                                },
                                                                  color: Colors.blue,
                                                                  child: const Text('Add',style: TextStyle(color: Colors.white)),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(height: 20,),
                                                            Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Card(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text('GRN ID : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('007',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Row(
                                                                                children: [
                                                                                  Text('GRN Quantity : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('James Bond',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Item Code : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('Ian Fleming',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text('GRN Item Name : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('A British secret agent ',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Item ID : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('007',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                              Row(
                                                                                children: [
                                                                                  Text('Item Cost : ',style: TextStyle(color: Colors.black87),),
                                                                                  // Text('James Bond',style: TextStyle(color: Colors.black),)
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 20,),
                                                                      Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          MaterialButton(
                                                                            onPressed: () {

                                                                            },
                                                                            color: Colors.blue,
                                                                            child: const Text('Edit',style:TextStyle(color: Colors.white)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],

                                                ),
                                              ),
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                    bottomNavigationBar: SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 30),
                                        child: Row(
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                // print("----------view edit vendor-----------");
                                                // print(snapshot.data!.vendorDocketData[0].vendorData);
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => EditItems(
                                                //           drawerWidth: widget.drawerWidth,
                                                //           selectedDestination: widget.selectedDestination,
                                                //           itemData:snapshot.data!.docketData[0].itemData,
                                                //
                                                //         )
                                                //     )
                                                // ).then(
                                                //         (value) =>
                                                //         fetchItemData());
                                                Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation1,animation2)=>
                                                EditItems(drawerWidth: 190, selectedDestination: 2.4, itemData:snapshot.data!.docketData[0].itemData,)
                                                ));
                                              },
                                              color: Colors.blue,
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.edit,color: Colors.white),
                                                  Text("Edit",
                                                      style: TextStyle(
                                                          color: Colors.white)
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ),
                                ),
                              );
                            }
                            else{
                              print("Snapshot Error");
                              return Container();
                            }

                          }
                      )
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }


  //delete items api.
  deleteItems() async{
    final deleteVendorsValue = await http.delete(Uri.parse(
        'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/newitem/delete_newitem/$selectedId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
    );
    if(deleteVendorsValue.statusCode ==200){
      setState(() {
        // print(selectedId);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data Deleted'),)
        );
        fetchItemData();
        itemDetailsBloc.fetchItemNetwork(selectedId,type);
        Navigator.of(context).pop();

      });
    }
    else{
      //If response Not Getting It Will Through Exception Error.
      setState(() {
        print(deleteVendorsValue.statusCode.toString());
      });
    }
  }
}

//----------------------------Inventory --------------

showInventoryDialog(BuildContext context){
  showDialog(context: context, builder: (BuildContext context) {
    return  const InventoryDialog();
  },);
}
class InventoryDialog extends StatefulWidget {
  const InventoryDialog({Key? key}) : super(key: key);

  @override
  State<InventoryDialog> createState() => _InventoryDialogState();
}

class _InventoryDialogState extends State<InventoryDialog> {

  final _inventoryForm = GlobalKey<FormState>();


  var itemCodeController = TextEditingController();
  var nameController = TextEditingController();
  var manufacturerController = TextEditingController();
  var descriptionController = TextEditingController();
  var costPerItemController = TextEditingController();
  var stockQuantityController = TextEditingController();

  bool itemCodeError = false;
  bool nameError = false;
  bool manufacturerError = false;
  bool descriptionError = false;
  bool costPerItemError = false;
  bool stockQuantityError = false;

  String? authToken;


  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add Inventory'),
          InkWell(
            child: const Icon(Icons.close_sharp,color: Colors.red,),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      content: SizedBox(
        width: 400,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Form(
                key: _inventoryForm,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    //--------item code------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Item Code'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: itemCodeError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    itemCodeError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    itemCodeError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: itemCodeController,
                              decoration: decorationInput5('Enter Item Code', itemCodeController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------name-------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Name'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: nameError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    nameError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    nameError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: nameController,
                              decoration: decorationInput5('Enter Name', nameController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------manufacturer------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Manufacturer'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: manufacturerError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    manufacturerError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    manufacturerError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: manufacturerController,
                              decoration: decorationInput5('', manufacturerController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------description-------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Description'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            // height: descriptionError ? 55 : 30,
                            height: 80,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              // validator: (value) {
                              //   if(value == null || value.isEmpty){
                              //     setState(() {
                              //       descriptionError = true;
                              //     });
                              //     return "Required";
                              //   }
                              //   else{
                              //     setState(() {
                              //       descriptionError = false;
                              //     });
                              //   }
                              //   return null;
                              // },
                              style: const TextStyle(fontSize: 14),
                              controller: descriptionController,
                              decoration: decorationInput6('Enter Remarks', descriptionController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------cost per item-----
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Cost Per Item'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: costPerItemError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    costPerItemError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    costPerItemError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: costPerItemController,
                              decoration: decorationInput5('Enter Cost', costPerItemController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------stock quantity-----
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Stock Quantity'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: stockQuantityError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    stockQuantityError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    stockQuantityError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: stockQuantityController,
                              decoration: decorationInput5('Enter Quantity', stockQuantityController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(onPressed: () {
                  if(_inventoryForm.currentState!.validate()){
                    itemCodeController.text.isNotEmpty&&
                        nameController.text.isNotEmpty&&
                        manufacturerController.text.isNotEmpty&&
                        // descriptionController.text.isNotEmpty&&
                        costPerItemController.text.isNotEmpty&&
                        stockQuantityController.text.isNotEmpty;
                    print(nameController.text);
                  }
                },
                  color: Colors.blue,
                  child: const Text('Save',style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


//----------------------Purchase ------------------------

showPurchaseDialog(BuildContext context){
  showDialog(context: context, builder: (BuildContext context) {
    return const PurchaseDialog();
  },);
}
class PurchaseDialog extends StatefulWidget {
  const PurchaseDialog({Key? key}) : super(key: key);

  @override
  State<PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {

  final _grnForm = GlobalKey<FormState>();


  var grnIdController = TextEditingController();
  var grnQuantityController = TextEditingController();
  var itemCodeController = TextEditingController();
  var grnItemNameController = TextEditingController();
  var itemIdController = TextEditingController();
  var itemCostController = TextEditingController();

  bool grnIdError = false;
  bool grnQuantityError = false;
  bool itemCodeError = false;
  bool grnItemNameError = false;
  bool itemIdError = false;
  bool itemCostError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add Purchase'),
          InkWell(
            child: const Icon(Icons.close_sharp,color: Colors.red,),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      content: SizedBox(
        width: 400,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Form(
                key: _grnForm,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    //--------grn id------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('GRN ID'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: grnIdError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    grnIdError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    grnIdError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: grnIdController,
                              decoration: decorationInput5('Enter GRN Id', grnIdController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------grn quantity-------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('GRN Quantity'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: grnQuantityError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    grnQuantityError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    grnQuantityError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: grnQuantityController,
                              decoration: decorationInput5('Enter Quantity', grnQuantityController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------item code------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Item Code'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: itemCodeError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    itemCodeError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    itemCodeError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: itemCodeController,
                              decoration: decorationInput5('Enter Item Code', itemCodeController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------GRN Item name-------
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('GRN Item Name'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: grnItemNameError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    grnItemNameError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    grnItemNameError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: grnItemNameController,
                              decoration: decorationInput5('Enter Name', grnItemNameController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  --------Item ID-----
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Item ID'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: itemIdError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    itemIdError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    itemIdError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: itemIdController,
                              decoration: decorationInput5('Enter Item ID', itemIdController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    //  ---------Item Cost-----
                    Row(
                      children:   [
                        const SizedBox(
                          width: 150,
                          child: Text('Item Cost'),
                        ),
                        SizedBox(
                          width: 200,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 0),
                            height: itemCostError ? 55 : 30,
                            child: TextFormField(
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  setState(() {
                                    itemCostError = true;
                                  });
                                  return "Required";
                                }
                                else{
                                  setState(() {
                                    itemCostError = false;
                                  });
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              controller: itemCostController,
                              decoration: decorationInput5('Enter Cost', itemCostController.text.isNotEmpty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(onPressed: () {
                  if(_grnForm.currentState!.validate()){

                  }
                },
                  color: Colors.blue,
                  child: const Text('Save',style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


