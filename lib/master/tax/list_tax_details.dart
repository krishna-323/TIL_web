import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/utils/static_data/motows_colors.dart';
import 'package:new_project/widgets/motows_buttons/outlined_mbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../classes/arguments_classes/arguments_classes.dart';
import '../../utils/api/get_api.dart';
import '../../utils/api/post_api.dart';
import '../../utils/customAppBar.dart';
import '../../utils/customDrawer.dart';
import '../../utils/custom_loader.dart';
import '../../widgets/input_decoration_text_field.dart';


class ListTaxDetails extends StatefulWidget {
  final ListTaxDetailsArgs args;
  const ListTaxDetails({Key? key, required this.args}) : super(key: key);

  @override
  State<ListTaxDetails> createState() => _ListTaxDetailsState();
}

class _ListTaxDetailsState extends State<ListTaxDetails> {

  List taxList=[];
  List displayTax= [];
  int startVal=0;
  Map createTax ={};
  bool loading = false;



  Future fetchTaxData() async {
    dynamic response;
    String url = 'https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/tax/get_all_tax';
    try {
      await getData(context: context, url: url).then((value) {
        setState(() {
          if(value!=null){
            response = value;
            taxList = value;
            if(displayTax.isEmpty){
              for(int i=startVal;i<startVal + 15;i++){
                displayTax.add(taxList[i]);
              }
            }
            else{
              for(int i=startVal;i<taxList.length;i++){
                displayTax.add(taxList[i]);
              }
            }
            // print('-------------');
            // print(taxList);
          }
          loading = false;
        });
      });
    }
    catch (e) {
      //logOutApi(context: context,exception: e.toString(),response: response);
      setState(() {
        loading = false;
      });
    }
  }






  @override
  initState(){
    loading = true;
    getInitialData().whenComplete(() {
      fetchTaxData();
    });
    super.initState();
  }
  @override
  void  dispose(){
    super.dispose();
  }
  String ?authToken;
  Future getInitialData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
          const VerticalDivider(width: 1,
            thickness: 1,),
          Expanded(child:
          CustomLoader(
            inAsyncCall: loading,
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE0E0E0),)

                    ),
                    child: Column(
                      children: [
                        Container( decoration: const BoxDecoration(
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
                                const Text(
                                  "All Taxes List",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                //New Tax Details create.
                                SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: OutlinedMButton(
                                    text: '+ New',
                                    buttonColor:mSaveButton ,
                                    textColor: Colors.white,
                                    borderColor: mSaveButton,
                                    onTap: () {
                                      createTaxDialog(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18,),
                          Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                          Container(
                             color: Colors.grey[100],height: 32,
                            child: IgnorePointer(
                            ignoring: true,
                            child: MaterialButton(
                              hoverElevation: 0,
                              onPressed: () {  },
                              hoverColor: Colors.transparent,
                              child: const Padding(
                                padding: EdgeInsets.only(left:18.0),
                                child: Row(children: [
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("NAME")
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("TAX CODE")
                                        ),
                                      )),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: SizedBox(height: 25,
                                            //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                            child: Text("TOTAL TAX PERCENTAGE")
                                        ),
                                      )),
                                ]),
                              ),
                            ),
                          ),),
                          Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                        ]),
                        ),

                        const SizedBox(height: 4,),

                        //updateTaxDetails(context),
                        for(int i=0;i<=displayTax.length;i++)
                          Column(
                            children: [
                              if(i!=displayTax.length)
                              MaterialButton(
                                hoverColor: mHoverColor,
                                onPressed: () {
                                  editTaxDetails(context,taxList[i]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left:18,top: 4,bottom: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child:Text(displayTax[i]['tax_name']??"")
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(displayTax[i]['tax_code']??"")
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(displayTax[i]['tax_total'].toString())
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              if(i!=displayTax.length)
                                Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),

                              if(i==displayTax.length)
                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text("${startVal+15>taxList.length?taxList.length:startVal+1}-${startVal+15>taxList.length?taxList.length:startVal+15} of ${taxList.length}",style: const TextStyle(color: Colors.grey)),
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
                                            displayTax=[];
                                            startVal = startVal-15;
                                            for(int i=startVal;i<startVal+15;i++){
                                              try{
                                                setState(() {
                                                  displayTax.add(taxList[i]);
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
                                          if(taxList.length>startVal+15){
                                            displayTax=[];
                                            startVal=startVal+15;
                                            for(int i=startVal;i<startVal+15;i++){
                                              try{
                                                setState(() {
                                                  displayTax.add(taxList[i]);
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

  updateDetails(Map  taxDetails)async {
    try{
      final response=await http.put(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/tax/update_tax'),
          headers: {"Content-Type": "application/json",
            'Authorization': 'Bearer $authToken'

          },
          body: json.encode(taxDetails)
      );
      if(response.statusCode==200){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Data Saved"),)
        );
        fetchTaxData();
        Navigator.of(context).pop();

      }
      else{
        print(response.statusCode.toString());
      }
    }
    catch(e){
      print(e.toString());
    }
  }
//Save Tax Post API().
  saveTaxDetails(Map  taxMap )async {
    String url = "https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/tax/add_tax";
    postData(requestBody: taxMap,url: url,context: context).then((value) {
      setState(() {
        if(value!=null){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Saved')));
          fetchTaxData();
          //print(response.body);
          Navigator.of(context).pop();

        }
        // clearDetails();
      });
    });
  }

//Delete Tax Details.
  deleteTaxDetails(String taxId) async{

    final delete_tax=await http.delete(Uri.parse('https://msq5vv563d.execute-api.ap-south-1.amazonaws.com/stage1/api/tax/delete_tax/$taxId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
    );
    if(delete_tax.statusCode==200){
      print(delete_tax.statusCode);
      setState(() {
        print(taxId);
        //fetchTaxData();
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
          content: Text('Data Deleted'),
        ));
        fetchTaxData();
        // updateDetails(_taxmap);
        Navigator.of(context).pop();

      });


    }

  }
//Create Tax Pop UP Form.
  createTaxDialog(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      final answerController=TextEditingController();
      final formKey=GlobalKey<FormState>();

      bool tax1Error=false;
      bool tax1PerError=false;
      bool taxError=false;
      bool nameError=false;
      bool tax2Error=false;
      bool tax2PerError=false;
      bool tax3Error=false;
      bool tax3PerError=false;
      bool tax4Error=false;
      bool tax4PerError=false;
      bool tax5Error=false;
      bool tax5PerError=false;
      bool totalTaxError=false;

      final tax1=TextEditingController();
      final tax1Per=TextEditingController();
      final tax2Per=TextEditingController();
      final tax3Per=TextEditingController();
      final tax4Per=TextEditingController();
      final tax5Per=TextEditingController();


      final tax2=TextEditingController();
      final name=TextEditingController();
      final tax=TextEditingController();
      final tax3=TextEditingController();

      final tax4=TextEditingController();

      final tax5=TextEditingController();

      return Dialog(
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder:(context, setState) {
            return  SizedBox(
              width: 500,
              child: Stack(children: [

                Container(
                  decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                  margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(left:50.0,top: 30,right:50,bottom: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            const Align(alignment: Alignment.center,
                              child:  Text('Enter Tax Details',
                                style: TextStyle(color: Colors.indigo,
                                    fontSize: 20
                                ),
                              ),
                            ),

                            const SizedBox(height: 10,),

                            //tax name
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(

                                    width: 100,
                                    child: Text('NAME',style: TextStyle(color: Colors.red),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: nameError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            nameError =true;
                                          });
                                          // print(name_error);
                                          return "Required";
                                        } else {
                                          setState(() {
                                            nameError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: name,
                                      decoration: decorationInput5('Enter Name',name.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //Tax code
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX CODE',style: TextStyle(color: Colors.red),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: taxError ? 55 : 30,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          setState(() {
                                            taxError=true;
                                          });
                                          return "Required";
                                        } else {
                                          setState(() {
                                            taxError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax,
                                      decoration: decorationInput5('Enter Tax',tax.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 1
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 1',style: TextStyle(color: Colors.red),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax1Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          setState(() {
                                            tax1Error=true;
                                          });
                                          return "Required";
                                        } else {
                                          setState(() {
                                            tax1Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax1,
                                      decoration: decorationInput5('Tax Name1',tax1.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax1PerError ? 55 : 30,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),],
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          setState(() {
                                            tax1PerError=true;
                                          });
                                          return "Required";
                                        } else {
                                          setState(() {
                                            tax1PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {
                                          answerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)
                                          ).toString();
                                          // num[0]=_stringToDouble(text);
                                          // answerController.text = "${sum(num)}";
                                        }
                                        );
                                      },
                                      controller: tax1Per,
                                      decoration: decorationInput5('Tax Percentage',tax1Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 2
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 2',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax2Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax2Error=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax2Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),

                                      controller: tax2,
                                      decoration: decorationInput5('Tax Name2',tax2.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax2PerError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax2PerError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax2PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (value) {
                                        setState(() {
                                          // num[1]=_stringToDouble(value);
                                          // answerController.text='${sum(num)}';
                                          answerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)

                                          ).toString();
                                        });
                                      },
                                      controller: tax2Per,
                                      decoration: decorationInput5('Tax Percentage',tax2Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 3
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 3',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax3Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax3Error=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax3Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax3,
                                      decoration: decorationInput5('Tax Name3',tax3.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax3PerError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax3PerError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax3PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {
                                          // num[2]=_stringToDouble(text);
                                          // answerController.text='${sum(num)}';
                                          answerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)

                                          ).toString();
                                        });
                                      },
                                      controller: tax3Per,
                                      decoration: decorationInput5('Tax Percentage',tax3Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 4
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 4',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax4Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax4Error=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax4Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax4,
                                      decoration: decorationInput5('Tax Name4',tax4.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax4PerError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax4PerError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax4PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {
                                          // num[3]=_stringToDouble(text);
                                          // answerController.text='${sum(num)}';
                                          answerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)

                                          ).toString();
                                        });
                                      },
                                      controller: tax4Per,
                                      decoration: decorationInput5('Tax Percentage',tax4Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 5
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 5',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax5Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax5Error=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax5Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax5,
                                      decoration: decorationInput5('Tax Name5',tax5.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax5PerError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax5PerError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax5PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {
                                          // num[4]=_stringToDouble(text);
                                          // answerController.text='${sum(num)}';
                                          answerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)

                                          ).toString();
                                        });
                                      },
                                      controller: tax5Per,
                                      decoration: decorationInput5('Tax Percentage',tax5Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //total tax
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(
                                //     width: 130,
                                //     child: Text('Total Tax Percentage',style: TextStyle(color: Colors.black),)),
                                Container(width: 100,),
                                const Expanded(child: Text('TOTAL TAX PERCENTAGE',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: totalTaxError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            totalTaxError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            totalTaxError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: answerController,
                                      decoration: decorationInput5('Total Tax Percentage',answerController.text.isNotEmpty),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(height: 20,),
                            Align(alignment: Alignment.center,
                              child: SizedBox(
                                height: 30,
                                width: 80,
                                child: OutlinedMButton(
                                    text: 'Save',
                                  buttonColor:mSaveButton ,
                                  textColor: Colors.white,
                                  borderColor: mSaveButton,
                                  onTap: () {
                                    setState(() {

                                      if(formKey.currentState!.validate()){
                                        createTax={
                                          'tax_code':tax.text,
                                          'tax_name':name.text,
                                          'tax_name1':tax1.text,
                                          'tax_name2':tax2.text,
                                          'tax_name3':tax3.text,
                                          'tax_name4':tax4.text,
                                          'tax_name5':tax5.text,
                                          'tax_percent':'',
                                          'tax_percent1':tax1Per.text,
                                          'tax_percent2':tax2Per.text,
                                          'tax_percent3':tax3Per.text,
                                          'tax_percent4':tax4Per.text,
                                          'tax_percent5':tax5Per.text,
                                          'tax_total':answerController.text,
                                        };
                                        saveTaxDetails(createTax);
                                      }

                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(right: 0.0,

                  child: InkWell(
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:
                              const Color.fromRGBO(204, 204, 204, 1),
                            ),
                            color: Colors.blue),
                        child: const Icon(
                          Icons.close_sharp,
                          color: Colors.white,
                        )),
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ],

              ),
            );
          }, ),
      );
    });
  }

  editTaxDetails(BuildContext context, taxList){
    // print('---------inside--------------');
    // print(taxList);
    // print(taxList['tax_id']);
    // print(taxList['tax_code']);
    // print(taxList['tax_name']);
    showDialog(context: context, builder: (BuildContext context){

      final editForm=GlobalKey<FormState>();
      bool nameError=false;
      bool taxCodeError=false;
      bool tax1Error=false;
      bool tax1PerError=false;
      bool tax2Error=false;
      bool tax2PerError=false;
      bool tax3Error=false;
      bool tax3PerError=false;
      bool tax4Error=false;
      bool tax4PerError=false;
      bool tax5Error=false;
      bool tax5PerError=false;
      bool totalTaxError=false;


      final name=TextEditingController();
      name.text=taxList['tax_name'];
      final taxCode=TextEditingController();
      taxCode.text=taxList['tax_code'];
      final tax1=TextEditingController();
      tax1.text=taxList['tax_name1'];
      final tax1Per=TextEditingController();
      tax1Per.text=taxList['tax_percent1'];
      final tax2Per=TextEditingController();
      tax2Per.text=taxList['tax_percent2'];
      final tax3Per=TextEditingController();
      tax3Per.text=taxList['tax_percent3'];
      final tax4Per=TextEditingController();
      tax4Per.text=taxList['tax_percent4'];
      final tax5Per=TextEditingController();
      tax5Per.text=taxList['tax_percent5'];
      final tax2=TextEditingController();
      tax2.text=taxList['tax_name2'];
      final tax3=TextEditingController();
      tax3.text=taxList['tax_name3'];
      final tax4=TextEditingController();
      tax4.text=taxList['tax_name4'];
      final tax5=TextEditingController();
      tax5.text=taxList['tax_name5'];
      final editAnswerController=TextEditingController();
      editAnswerController.text=taxList['tax_total'];

      return Dialog(
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder:(context, setState) {
            return  SizedBox(
              width: 500,
              child: Stack(children: [

                Container(
                  decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                  margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: editForm,
                      child: Padding(
                        padding: const EdgeInsets.only(left:50.0,top: 30,right:50,bottom: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            const Align(alignment: Alignment.center,
                              child:  Text('Edit Tax Details',
                                style: TextStyle(color: Colors.indigo,
                                    fontSize: 20
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            //tax name
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(

                                    width: 100,
                                    child: Text('NAME',style: TextStyle(color: Colors.red),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: nameError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            nameError =true;
                                          });
                                          // print(name_error);
                                          return "Required";
                                        } else {
                                          setState(() {
                                            nameError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: name,
                                      decoration: decorationInput5('Enter Name',name.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //Tax code
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX CODE',style: TextStyle(color: Colors.red),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: taxCodeError ? 55 : 30,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          setState(() {
                                            taxCodeError=true;
                                          });
                                          return "Required";
                                        } else {
                                          setState(() {
                                            taxCodeError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: taxCode,
                                      decoration: decorationInput5('Enter Tax',taxCode.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 1
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 1',style: TextStyle(color: Colors.red),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax1Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          setState(() {
                                            tax1Error=true;
                                          });
                                          return "Required";
                                        } else {
                                          setState(() {
                                            tax1Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax1,
                                      decoration: decorationInput5('Tax Name1',tax1.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax1PerError ? 55 : 30,
                                    child: TextFormField(

                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          setState(() {
                                            tax1PerError=true;
                                          });
                                          return "Required";
                                        } else {
                                          setState(() {
                                            tax1PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {
                                          editAnswerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)
                                          ).toString();
                                          // num[0]=_stringToDouble(text);
                                          // answerController.text = "${sum(num)}";
                                        }
                                        );
                                      },
                                      controller: tax1Per,
                                      decoration: decorationInput5('Tax Percentage',tax1Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 2
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 2',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax2Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value) {
                                        if(value!.isNotEmpty){
                                          setState((){
                                            tax2Error=false;
                                          });
                                          return null;
                                        }
                                        else if (tax2Per.text.isNotEmpty){
                                          setState((){
                                            tax2Error=true;
                                          });
                                          return "Enter Tax ";
                                        }
                                        else{
                                          setState((){
                                            tax2Error=false;
                                          });
                                          return null;
                                        }

                                      },
                                      style: const TextStyle(
                                          fontSize: 14),

                                      controller: tax2,
                                      decoration: decorationInput5('Tax Name2',tax2.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax2PerError ? 55 : 30,
                                    child: TextFormField(
                                      validator:(value){
                                        if(tax2Per.text.isNotEmpty){
                                          setState((){
                                            tax2PerError=false;
                                          });
                                          return null;
                                        }
                                        else if(tax2.text=="  "){
                                          setState((){
                                            tax2PerError=false;
                                          });
                                          return null;
                                        }
                                        if (tax2.text.isNotEmpty){
                                          setState((){
                                            tax2PerError=true;
                                          });
                                          return "Enter Percentage";
                                        }
                                        return null;

                                      },

                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (value) {
                                        setState(() {
                                          // num[1]=_stringToDouble(value);
                                          // answerController.text='${sum(num)}';
                                          editAnswerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)

                                          ).toString();
                                        });
                                      },
                                      controller: tax2Per,
                                      decoration: decorationInput5('Tax Percentage',tax2Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 3
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 3',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax3Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax3Error=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax3Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax3,
                                      decoration: decorationInput5('Tax Name3',tax3.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax3PerError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value == null){
                                          setState((){
                                            tax3PerError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax3PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {
                                          // num[2]=_stringToDouble(text);
                                          // answerController.text='${sum(num)}';
                                          editAnswerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)

                                          ).toString();
                                        });
                                      },
                                      controller: tax3Per,
                                      decoration: decorationInput5('Tax Percentage',tax3Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 4
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 4',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax4Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax4Error=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax4Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax4,
                                      decoration: decorationInput5('Tax Name4',tax4.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax4PerError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax4PerError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax4PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {
                                          // num[3]=_stringToDouble(text);
                                          // answerController.text='${sum(num)}';
                                          editAnswerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)

                                          ).toString();
                                        });
                                      },
                                      controller: tax4Per,
                                      decoration: decorationInput5('Tax Percentage',tax4Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //tax 5
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text('TAX 5',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax5Error ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax5Error=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax5Error=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: tax5,
                                      decoration: decorationInput5('Tax Name5',tax5.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: tax5PerError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            tax5PerError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            tax5PerError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {
                                          // num[4]=_stringToDouble(text);
                                          // answerController.text='${sum(num)}';
                                          editAnswerController.text = (
                                              double.parse(tax1Per.text.isEmpty ? "0":tax1Per.text) +
                                                  double.parse(tax2Per.text.isEmpty ? "0":tax2Per.text) +
                                                  double.parse(tax3Per.text.isEmpty ? "0":tax3Per.text) +
                                                  double.parse(tax4Per.text.isEmpty ? "0":tax4Per.text) +
                                                  double.parse(tax5Per.text.isEmpty ? "0":tax5Per.text)

                                          ).toString();
                                        });
                                      },
                                      controller: tax5Per,
                                      decoration: decorationInput5('Tax Percentage',tax5Per.text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            //total tax
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(
                                //     width: 130,
                                //     child: Text('Total Tax Percentage',style: TextStyle(color: Colors.black),)),
                                Container(width: 100,),
                                const Expanded(child: Text('TOTAL TAX PERCENTAGE',style: TextStyle(color: Colors.black),)),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 0),
                                    height: totalTaxError ? 55 : 30,
                                    child: TextFormField(
                                      validator: (value){
                                        if(value==null){
                                          setState((){
                                            totalTaxError=true;
                                          });
                                          return null;
                                        }
                                        else if(value.isEmpty){
                                          setState((){
                                            totalTaxError=false;
                                          });
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          fontSize: 14),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      controller: editAnswerController,
                                      decoration: decorationInput5('Total Tax Percentage',editAnswerController.text.isNotEmpty),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(height: 20,),
                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: OutlinedMButton(
                                    text :"Update",
                                    borderColor: Colors.indigo,
                                    textColor:  Colors.indigo,
                                    onTap: () {
                                      setState(() {

                                        if(editForm.currentState!.validate()){
                                          Map  updateTax={
                                            'tax_id':taxList['tax_id'],
                                            'tax_code':taxCode.text,
                                            'tax_name':name.text,
                                            'tax_name1':tax1.text,
                                            'tax_name2':tax2.text,
                                            'tax_name3':tax3.text,
                                            'tax_name4':tax4.text,
                                            'tax_name5':tax5.text,
                                            'tax_percent1':tax1Per.text,
                                            'tax_percent2':tax2Per.text,
                                            'tax_percent3':tax3Per.text,
                                            'tax_percent4':tax4Per.text,
                                            'tax_percent5':tax5Per.text,
                                            'tax_total':editAnswerController.text,
                                          };
                                          // print('-------updateTax-----');
                                          // print(updateTax);
                                          updateDetails(updateTax);
                                        }

                                      });
                                    },
                                  ),
                                ),
                                // MaterialButton(
                                //   color: Colors.lightBlue,
                                //   child: const Text("Update",style: TextStyle(color: Colors.white),),
                                //   onPressed: () {
                                //
                                //     setState(() {
                                //
                                //       if(editForm.currentState!.validate()){
                                //         Map  updateTax={
                                //           'tax_id':taxList['tax_id'],
                                //           'tax_code':taxCode.text,
                                //           'tax_name':name.text,
                                //           'tax_name1':tax1.text,
                                //           'tax_name2':tax2.text,
                                //           'tax_name3':tax3.text,
                                //           'tax_name4':tax4.text,
                                //           'tax_name5':tax5.text,
                                //           'tax_percent1':tax1Per.text,
                                //           'tax_percent2':tax2Per.text,
                                //           'tax_percent3':tax3Per.text,
                                //           'tax_percent4':tax4Per.text,
                                //           'tax_percent5':tax5Per.text,
                                //           'tax_total':editAnswerController.text,
                                //         };
                                //         // print('-------updateTax-----');
                                //         // print(updateTax);
                                //         updateDetails(updateTax);
                                //       }
                                //
                                //     });
                                //
                                //
                                //   },
                                // ),
                                const SizedBox(width: 50,),
                                SizedBox(
                                  height: 30,
                                  width: 100,
                                  child: OutlinedMButton(
                                    text :"Delete",
                                    borderColor: Colors.redAccent,
                                    textColor:  Colors.redAccent,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: StatefulBuilder(
                                              builder: (context, setState) {
                                                return SizedBox(
                                                  height: 200,
                                                  width: 300,
                                                  child: Stack(children: [
                                                    Container(
                                                      decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                                      margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                                      child: Column(
                                                        children: [

                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          const Icon(
                                                            Icons.warning_rounded,
                                                            color: Colors.red,
                                                            size: 50,
                                                          ),

                                                          const Center(
                                                              child: Text(
                                                                'Are You Sure, You Want To Delete ?',
                                                                style: TextStyle(
                                                                    color: Colors.indigo,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16),
                                                              )),
                                                          const SizedBox(
                                                            height: 35,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              MaterialButton(
                                                                color: Colors.red,
                                                                onPressed: () {
                                                                  // print(userId);

                                                                  deleteTaxDetails(taxList['tax_id']);

                                                                },
                                                                child: const Text(
                                                                  'Ok',
                                                                  style: TextStyle(color: Colors.white),
                                                                ),
                                                              ),
                                                              MaterialButton(
                                                                color: Colors.blue,
                                                                onPressed: () {
                                                                  setState(() {
                                                                    Navigator.of(context).pop();
                                                                  });
                                                                },
                                                                child: const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(color: Colors.white),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(right: 0.0,

                                                      child: InkWell(
                                                        child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                border: Border.all(
                                                                  color:
                                                                  const Color.fromRGBO(204, 204, 204, 1),
                                                                ),
                                                                color: Colors.blue),
                                                            child: const Icon(
                                                              Icons.close_sharp,
                                                              color: Colors.white,
                                                            )),
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.of(context).pop();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],

                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                // MaterialButton(
                                //   color:Colors.red,
                                //   onPressed: (){
                                //     Navigator.of(context).pop();
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return Dialog(
                                //           backgroundColor: Colors.transparent,
                                //           child: StatefulBuilder(
                                //             builder: (context, setState) {
                                //               return SizedBox(
                                //                 height: 200,
                                //                 width: 300,
                                //                 child: Stack(children: [
                                //                   Container(
                                //                     decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                                //                     margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                                //                     child: Column(
                                //                       children: [
                                //
                                //                         const SizedBox(
                                //                           height: 20,
                                //                         ),
                                //                         const Icon(
                                //                           Icons.warning_rounded,
                                //                           color: Colors.red,
                                //                           size: 50,
                                //                         ),
                                //
                                //                         const Center(
                                //                             child: Text(
                                //                               'Are You Sure, You Want To Delete ?',
                                //                               style: TextStyle(
                                //                                   color: Colors.indigo,
                                //                                   fontWeight: FontWeight.bold,
                                //                                   fontSize: 16),
                                //                             )),
                                //                         const SizedBox(
                                //                           height: 35,
                                //                         ),
                                //                         Row(
                                //                           mainAxisAlignment:
                                //                           MainAxisAlignment.spaceEvenly,
                                //                           children: [
                                //                             MaterialButton(
                                //                               color: Colors.red,
                                //                               onPressed: () {
                                //                                 // print(userId);
                                //
                                //                                 deleteTaxDetails(taxList['tax_id']);
                                //
                                //                               },
                                //                               child: const Text(
                                //                                 'Ok',
                                //                                 style: TextStyle(color: Colors.white),
                                //                               ),
                                //                             ),
                                //                             MaterialButton(
                                //                               color: Colors.blue,
                                //                               onPressed: () {
                                //                                 setState(() {
                                //                                   Navigator.of(context).pop();
                                //                                 });
                                //                               },
                                //                               child: const Text(
                                //                                 'Cancel',
                                //                                 style: TextStyle(color: Colors.white),
                                //                               ),
                                //                             )
                                //                           ],
                                //                         )
                                //                       ],
                                //                     ),
                                //                   ),
                                //                   Positioned(right: 0.0,
                                //
                                //                     child: InkWell(
                                //                       child: Container(
                                //                           width: 30,
                                //                           height: 30,
                                //                           decoration: BoxDecoration(
                                //                               borderRadius: BorderRadius.circular(15),
                                //                               border: Border.all(
                                //                                 color:
                                //                                 const Color.fromRGBO(204, 204, 204, 1),
                                //                               ),
                                //                               color: Colors.blue),
                                //                           child: const Icon(
                                //                             Icons.close_sharp,
                                //                             color: Colors.white,
                                //                           )),
                                //                       onTap: () {
                                //                         setState(() {
                                //                           Navigator.of(context).pop();
                                //                         });
                                //                       },
                                //                     ),
                                //                   ),
                                //                 ],
                                //
                                //                 ),
                                //               );
                                //             },
                                //           ),
                                //         );
                                //       },
                                //     );
                                //   },
                                //   child: Row(
                                //       children: const [
                                //         Icon(Icons.delete,color: Colors.white,),
                                //         Text('Delete',style: TextStyle(color:Colors.white),)
                                //       ]),
                                // ),
                              ],
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(right: 0.0,

                  child: InkWell(
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:
                              const Color.fromRGBO(204, 204, 204, 1),
                            ),
                            color: Colors.blue),
                        child: const Icon(
                          Icons.close_sharp,
                          color: Colors.white,
                        )),
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ],

              ),
            );
          }, ),
      );
    });
  }

}

