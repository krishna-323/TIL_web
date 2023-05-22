import 'package:flutter/material.dart';


import '../cart_bloc/cart_items_bloc.dart';


class Checkout extends StatefulWidget {
  final bool isFromVoice;
   const Checkout({Key? key, required this.isFromVoice}) : super(key: key);


  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  num jobTotal=0 ,voiceTotal=0,partsTotal=0;

  late num totalPrice;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if(widget.isFromVoice){
          print("Go back to voice");
         // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const AddVoice(isEdit: false, tech: '')),);
        }
        else
        {
          Navigator.of(context).pop();
        }
        throw("");
      },
      child: Scaffold(
        appBar:  AppBar(centerTitle: true,
          leading: Row(
            children: [
              const SizedBox(width: 22,),
              InkWell(
                child: Stack(
                  children: [
                    Center(
                      child: Container(height: 30,width: 30,decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff131d48)
                      ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Center(child: Icon(Icons.arrow_back_rounded, color: Colors.white,size: 20,)),
                    ),
                  ],
                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ],
          ),

          title: const Text("Cart ", style: TextStyle(color: Color(0xff131d48))),

        ),
        body: StreamBuilder(
          stream: bloc.getStream,
          initialData: bloc.allItems,
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            return  SingleChildScrollView(
              child: Column(
                      children: <Widget>[
                  if (snapshot.data['cart items'].length > 0)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        const Center(
                            child: Text("Job Cart",
                                style: TextStyle(color: Color(0xff131d48),fontSize: 20))),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data["cart items"].length,
                          itemBuilder: (BuildContext context, i) {
                            final cartList = snapshot.data["cart items"];
                            print("+++++++++++++++++++++++");
                            print(cartList);
                            return ListTile(
                              title: Text(cartList[i]['jobTemplateDiscription'] ?? ""),
                              subtitle: Text("${cartList[i]['price']}"),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.grey),
                                onPressed: () {
                                  bloc.removeFromCart(cartList[i],cartList[i]['jobTemplateId']);
                                  snapshot.data['cart items'].forEach((item){
                                    jobTotal += item["price"];
                                  }); snapshot.data['voiceCart'].forEach((item){
                                    voiceTotal += int.parse(item["price"]);
                                  }); snapshot.data['partsCart'].forEach((item){
                                    partsTotal += item["salesPrice"];
                                  });
                                  print("Total");
                                  print(jobTotal+voiceTotal+partsTotal);
                                  totalPrice =jobTotal+voiceTotal+partsTotal;
                                  bloc.setTotal(totalPrice);
                                  jobTotal=0;
                                  voiceTotal=0;
                                  partsTotal=0;
                                },
                              ),
                              onTap: () {
                                print("Total");
                                print(jobTotal+voiceTotal+partsTotal);
                                totalPrice =jobTotal+voiceTotal+partsTotal;
                               // bloc.setTotal(totalPrice);
                              },
                            );
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                      ],
                    ),
                  if (snapshot.data['voiceCart'].length > 0)
                    Column(
                      children: [
                        const SizedBox(height: 20,),
                        const Center(child: Text("Customer Voice", style: TextStyle(color: Color(0xff131d48),fontSize: 20))),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data["voiceCart"].length,
                          itemBuilder: (BuildContext context, i) {
                            final cartList = snapshot.data["voiceCart"];
                            print(cartList);
                            return ListTile(
                              title: Text(cartList[i]['name']),
                              subtitle: Text("₹ ""${cartList[i]['price']}"),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.grey),
                                onPressed: () {
                                  print(cartList[i]);
                                  bloc.removeVoiceCart(cartList[i]);
                                  snapshot.data['cart items'].forEach((item){
                                    jobTotal += item["price"];
                                  }); snapshot.data['voiceCart'].forEach((item){
                                    voiceTotal += int.parse(item["price"]);
                                  }); snapshot.data['partsCart'].forEach((item){
                                    partsTotal += item["salesPrice"];
                                  });
                                  totalPrice =jobTotal+voiceTotal+partsTotal;
                                  bloc.setTotal(totalPrice);
                                  jobTotal=0;
                                  voiceTotal=0;
                                  partsTotal=0;
                                },
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                        const Divider(color: Colors.black,),
                      ],
                    ),
                  if (snapshot.data['partsCart'].length > 0)
                    Column(
                      children: [
                        const SizedBox(height: 20,),
                        const Center(child: Text("Selected Parts",
                                style: TextStyle(
                                    color: Color(0xff131d48), fontSize: 20))),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data["partsCart"].length,
                          itemBuilder: (BuildContext context, i) {
                            final cartList = snapshot.data["partsCart"];
                            print(cartList);
                            return ListTile(
                              title: Text(cartList[i]['partDescription']),
                              subtitle: Row(
                                children: [
                                  Text("₹ ""${cartList[i]['salesPrice']}"),
                                  SizedBox(width: 10,),
                                  Text("Qty : ${cartList[i]['Qty']}"),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.grey),
                                onPressed: () {
                                  bloc.removePartsCart(cartList[i]['partID']);
                                  snapshot.data['cart items'].forEach((item){
                                    jobTotal += item["price"];
                                  }); snapshot.data['voiceCart'].forEach((item){
                                    voiceTotal += int.parse(item["price"]);
                                  }); snapshot.data['partsCart'].forEach((item){
                                    partsTotal += item["salesPrice"];
                                  });
                                  print("Total");
                                  print(jobTotal+voiceTotal+partsTotal);
                                  totalPrice =jobTotal+voiceTotal+partsTotal;
                                  bloc.setTotal(totalPrice);
                                  jobTotal=0;
                                  voiceTotal=0;
                                  partsTotal=0;
                                },
                              ),
                            );
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                      ],
                    ),
                  if (snapshot.data['cart items'].length == 0 && snapshot.data['voiceCart'].length == 0 && snapshot.data['partsCart'].length == 0)
                    Column(
                      children: const [
                        SizedBox(
                          height: 60,
                        ),
                        Center(child: Text("No data")),
                      ],
                    )
                ],
                    ),
            );

          },
        ),
      ),
    );
  }
}

