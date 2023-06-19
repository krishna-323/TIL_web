import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/arguments_classes/arguments_classes.dart';
import '../utils/api/get_api.dart';
import '../utils/api/post_api.dart';
import '../utils/customAppBar.dart';
import '../utils/customDrawer.dart';
import '../utils/custom_loader.dart';
import '../utils/static_data/motows_colors.dart';
import '../widgets/input_decoration_text_field.dart';
import 'list_users.dart';

class CompanyManagement extends StatefulWidget {
  final CompanyManagementArguments args;


  const CompanyManagement(
      {Key? key, required this.args,})
      : super(key: key);

  @override
  State<CompanyManagement> createState() => _CompanyManagementState();
}

class _CompanyManagementState extends State<CompanyManagement> {
  bool loading=false;

  @override
  initState() {
    getInitialData();
    super.initState();
    getCompanyList();
    loading=true;
  }

  List listCompanies = [];
  List displayListCompanies=[];
  int startVal=0;
  //get Api().
  Future getCompanyList() async {
    dynamic response;
    String url =
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company/get_all_company';
    try {
      await getData(url: url, context: context).then((value) {
        setState(() {
          if (value != null) {
            response = value;
            listCompanies = response;
           if(displayListCompanies.isEmpty){
             if(listCompanies.length>15){
               for(int i=startVal;i<startVal+15;i++){
                 displayListCompanies.add(listCompanies[i]);
               }
             }
             else{
               for(int i=0;i<listCompanies.length;i++){
                 displayListCompanies.add(listCompanies[i]);
               }
             }
           }
          }
          loading=false;
        });
      });
    } catch (e) {
      logOutApi(context: context, exception: e.toString(), response: response);
  setState(() {
    loading=false;
  });
    }
  }

   //Post api().
  Future postCompanyDetails(companyList) async {
    String url =
        'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company/add_company';
    postData(context: context, url: url, requestBody: companyList)
        .then((value) {
      setState(() {
        if (value != null) {
          getCompanyList();
          Navigator.of(context).pop();
        }
      });
    });
  }

  String? authToken;

  Future getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }
  // @override
  //   bool mounted=false;
  //Edit api().
  Future editCompany(requestBody) async {
    String url ='https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company/update_company';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      getCompanyList();
      if(mounted){
        Navigator.of(context).pop();
      }


    } else {
      log(response.statusCode.toString());
    }
  }
  //Delete api()
  Future deleteCompany(String companyId)async{

    String url= 'https://x23exo3n88.execute-api.ap-south-1.amazonaws.com/stage1/api/company/delete_company/$companyId';
    final response=await http.delete(Uri.parse(url),
    //After login token will generate that token passing here.
    headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $authToken'
    }
    );
    if(response.statusCode==200){
       getCompanyList();
       if(mounted) {
         Navigator.of(context).pop();
       }



    }
    else{
      log(response.statusCode.toString());
    }
}

  _getPopupMenu(BuildContext context,) {
    return  [

      PopupMenuItem(value: 1,
          child:  Center(
            child: Row(
              children: [
                Icon(Icons.edit_sharp,size: 18,color: Colors.grey[800],),
                const SizedBox(width: 10,),
                Text(
                  'Edit',
                  style: TextStyle(color: Colors.grey[800],fontSize: 15,fontWeight: FontWeight.bold),
                ),


              ],
            ),
          )),
      PopupMenuItem(value: 2,
          child:  Center(
            child: Row(
              children: [
                Icon(Icons.delete_sharp,color: Colors.grey[800],size: 18,),
                const SizedBox(width: 10,),
                Text(
                  'Delete',
                  style: TextStyle(color: Colors.grey[800],fontSize: 15,fontWeight: FontWeight.bold),
                ),


              ],
            ),
          )),
    ];
  }

  //Pop up menu method.
  Theme _popMenu(companyData) {
    // print('-----------------------check-----------------');
    // print(companyData);
    return Theme(
        data: Theme.of(context).copyWith(),
        child: PopupMenuButton(offset:const Offset(0, 30),
          tooltip: '',
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipRRect(borderRadius: BorderRadius.circular(20),
              child: const Icon(Icons.more_vert,color: Colors.black,
                size: 18,
              ),
            ),
          ),
          itemBuilder: (BuildContext context) {
            return _getPopupMenu(context,
                // companyId, company, city, state, country,
                // address1, address2, zipcode
            );
          },
          onSelected: (value) {
            if(value==1){
              showDialog(
                context: context,
                builder: (context) {

                  Map companyDetails = {};
                  final editCompanyKey = GlobalKey<FormState>();
                  bool editCompanyError = false;
                  bool editCityNameError = false;
                  bool editStateError = false;
                  bool editCountryError = false;
                  bool editAddress1Error = false;
                  bool editAddress2Error = false;
                  bool editZipcodeError = false;

                  final editCompanyName = TextEditingController();
                  editCompanyName.text=companyData['company_name'];
                  final editCityName = TextEditingController();
                  editCityName.text=companyData['city'];
                  final editState = TextEditingController();
                  editState.text=companyData['state'];
                  final editCountry = TextEditingController();
                  editCountry.text=companyData['country'];
                  final editAddress1 = TextEditingController();
                  editAddress1.text=companyData['address_line1'];
                  final editAddress2 = TextEditingController();
                  editAddress2.text=companyData['address_line2'];
                  final editZipcode = TextEditingController();
                  editZipcode.text=companyData['zip_code'].toString();

                  String capitalizeFirstWord(String value) {
                    if(value.isNotEmpty){
                      var result = value[0].toUpperCase();
                      for (int i = 1; i < value.length; i++) {
                        if (value[i - 1] == "1") {
                          result = result + value[i].toUpperCase();
                        } else {
                          result = result + value[i];
                        }
                      }
                      return result;
                    }
                    return '';
                  }
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: StatefulBuilder(
                      builder: (BuildContext context, setState) {

                        return SizedBox(
                          width: 470,
                          child: Stack(children: [
                            Container(
                              decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                              margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                              child: SingleChildScrollView(
                              child: Form(
                                key: editCompanyKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35.0,right: 35),
                                  child: Column(children: [
                                   const SizedBox(height: 15,),
                                    //Top Container.
                                    const Align(alignment: Alignment.center,
                                       child: Text(
                                        'Edit Company Details',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold),
                                    ),
                                     ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    //Company Name.
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 130, child: Text('Company Name')),
                                        const SizedBox(height: 10),
                                        Expanded(

                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: editCompanyError ? 55 : 30,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  setState(() {
                                                    editCompanyError = true;
                                                  });
                                                  return "Enter User Name";
                                                } else {
                                                  setState(() {
                                                    editCompanyError = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(fontSize: 14),
                                              onChanged: (value) {
                                              editCompanyName.value=TextEditingValue(
                                                text: capitalizeFirstWord(value),
                                                selection: editCompanyName.selection,
                                              );
                                              },
                                              controller: editCompanyName,
                                              decoration: decorationInput5(
                                                  'Edit Company Name',
                                                  editCompanyName.text.isNotEmpty),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    //City Name.
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 130, child: Text('City Name')),
                                        const SizedBox(height: 10),
                                        Expanded(

                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: editCityNameError ? 55 : 30,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  setState(() {
                                                    editCityNameError = true;
                                                  });
                                                  return "Enter City Name";
                                                } else {
                                                  setState(() {
                                                    editCityNameError = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(fontSize: 14),
                                              onChanged: (value) {
                                              editCityName.value=TextEditingValue(
                                                text: capitalizeFirstWord(value),
                                                selection: editCityName.selection,
                                              );
                                              },
                                              controller: editCityName,
                                              decoration: decorationInput5('Edit City Name',
                                                  editCityName.text.isNotEmpty),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    //state.
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 130, child: Text('State Name')),
                                        const SizedBox(height: 10),
                                        Expanded(

                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: editStateError ? 55 : 30,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  setState(() {
                                                    editStateError = true;
                                                  });
                                                  return "Enter State Name";
                                                } else {
                                                  setState(() {
                                                    editStateError = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(fontSize: 14),
                                              onChanged: (value) {
                                              editState.value=TextEditingValue(
                                                text: capitalizeFirstWord(value),
                                                selection: editState.selection,
                                              );
                                              },
                                              controller: editState,
                                              decoration: decorationInput5(
                                                  'Edit State Name',
                                                  editState.text.isNotEmpty),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    //Country .
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 130, child: Text('Country Name')),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: editCountryError ? 55 : 30,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  setState(() {
                                                    editCountryError = true;
                                                  });
                                                  return "Enter Country Name";
                                                } else {
                                                  setState(() {
                                                    editCountryError = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(fontSize: 14),
                                              onChanged: (value) {
                                              editCountry.value=TextEditingValue(
                                                text: capitalizeFirstWord(value),
                                                selection: editCountry.selection,
                                              );
                                              },
                                              controller: editCountry,
                                              decoration: decorationInput5(
                                                  'Enter Country Name',
                                                  editCountry.text.isNotEmpty),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    //address 1.
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                            width: 130, child: Text('Address Line1 ')),
                                        const SizedBox(height: 10),
                                        Expanded(

                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: editAddress1Error ? 55 : 30,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  setState(() {
                                                    editAddress1Error = true;
                                                  });
                                                  return "Enter Address Line";
                                                } else {
                                                  setState(() {
                                                    editAddress1Error = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(fontSize: 14),
                                              onChanged: (value) {
                                               editAddress1.value=TextEditingValue(
                                                 text: capitalizeFirstWord(value),
                                                 selection: editAddress1.selection,
                                               );

                                              },
                                              controller: editAddress1,
                                              decoration: decorationInput5(
                                                  'Enter Address Line1',
                                                  editAddress1.text.isNotEmpty),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    //address line 2.
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                            width: 130, child: Text('Address Line2 ')),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: editAddress2Error ? 55 : 30,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  setState(() {
                                                    editAddress2Error = true;
                                                  });
                                                  return "Enter Address Line";
                                                } else {
                                                  setState(() {
                                                    editAddress2Error = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(fontSize: 14),
                                              onChanged: (value) {
                                             editAddress2.value=TextEditingValue(
                                               text: capitalizeFirstWord(value),
                                               selection: editAddress2.selection,
                                             );
                                              },
                                              controller: editAddress2,
                                              decoration: decorationInput5(
                                                  'Enter Address Line2',
                                                  editAddress2.text.isNotEmpty),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    //zip code.
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 130, child: Text('Zip Code')),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 0),
                                            height: editZipcodeError ? 55 : 30,
                                            child: TextFormField(keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              maxLength: 6,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  setState(() {
                                                    editZipcodeError = true;
                                                  });
                                                  return "Enter Zipcode";
                                                } else {
                                                  setState(() {
                                                    editZipcodeError = false;
                                                  });
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(fontSize: 14),
                                              onChanged: (text) {
                                                setState(() {});
                                              },
                                              controller: editZipcode,
                                              decoration: decorationInput5('Enter Zipcode',
                                                  editZipcode.text.isNotEmpty),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    MaterialButton(
                                        color: Colors.blue,
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (editCompanyKey.currentState!.validate()) {
                                              companyDetails = {
                                                "company_id": companyData['company_id'],
                                                'company_name':editCompanyName.text,
                                                'city':editCityName.text,
                                                'state':editState.text,
                                                'country':editCountry.text,
                                                'address_line1':editAddress1.text,
                                                'address_line2':editAddress2.text,
                                                'zip_code':editZipcode.text.toString(),
                                                // 'userid':'',
                                              };
                                              editCompany(companyDetails);
                                            }
                                          });
                                        }),
                                  const SizedBox(height: 35,),
                                  ]),
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
                      },
                    ),
                  );
                },
              );
            }
            //second.
            if(value==2){

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
                          child: Stack(
                            children: [
                            Container(
                              decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                              margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                              child: Column(
                              children: [
                               const SizedBox(height: 20,),
                                const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                  size: 50,
                                ),
                                const SizedBox(
                                  height: 10,
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
                                        setState(() {
                                          deleteCompany(companyData['company_id']);
                                        });
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
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(  preferredSize: Size.fromHeight(60),
          child: CustomAppBar()),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        CustomDrawer(widget.args.drawerWidth, widget.args.selectedDestination),
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
                    padding: const EdgeInsets.only(left: 50.0, right: 50, top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0),)

                      ),
                      child: Column(
                        children: [
                          Container(
                            //height: 198,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 18,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Company Management",
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          //Post new User dialog box.
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: MaterialButton(
                                              color: Colors.blue,
                                              onPressed: () {
                                                addCompanyDetails(context);
                                              },
                                              child: const Text(
                                                "+ Create Company",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                                const SizedBox(height: 18,),
                                Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                Container(color: Colors.grey[100],
                                  child:  IgnorePointer(
                                    ignoring: true,
                                    child: MaterialButton(
                                      onPressed: (){},
                                      hoverColor: Colors.transparent,
                                      hoverElevation: 0,
                                      child:  const Padding(
                                        padding: EdgeInsets.only(left: 18.0),
                                        child:Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("Company NAME")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("STATE")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(height: 25,
                                                      //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                      child: Text("COUNTRY NAME")
                                                  ),
                                                )),
                                            Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: SizedBox(
                                                      height: 25,
                                                      child: Text("ZIP CODE")),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.only(right: 38.0),
                                              child: SizedBox(
                                                  height: 25,),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                              ],
                            ),
                          ),
                          for (int i = 0; i <= displayListCompanies.length; i++)
                          Column(children: [
                            if(i!=displayListCompanies.length)
                              MaterialButton(
                                hoverColor: Colors.blue[50],
                                onPressed: (){
                                  // print('-------------inontap------------------');
                                  // print(displayList[i]['customer_id']);
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context,animation1,animation2) => CompanyDetails( companyName:listCompanies[i]['company_name'], selectedDestination: widget.args.selectedDestination, drawerWidth: widget.args.drawerWidth,),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0,bottom: 3,top:4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(displayListCompanies[i]['company_name']??"")
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: SizedBox(
                                                height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(displayListCompanies[i]['state']?? '')
                                            ),
                                          )
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(displayListCompanies[i]['country']??"")
                                            ),
                                          )),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: SizedBox(height: 25,
                                                //   decoration: state.text.isNotEmpty ?BoxDecoration():BoxDecoration(boxShadow: [BoxShadow(color:Color(0xFFEEEEEE),blurRadius: 2)]),
                                                child: Text(displayListCompanies[i]['zip_code'].toString())
                                            ),
                                          )),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Center(
                                          child: SizedBox(
                                              height: 28,
                                              child: Center(
                                                  child: _popMenu(displayListCompanies[i],))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if(i!=displayListCompanies.length)
                              Divider(height: 0.5,color: Colors.grey[300],thickness: 0.5,),
                            if(i==displayListCompanies.length)
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${startVal+15>listCompanies.length?listCompanies.length:startVal+1}-${startVal+15>listCompanies.length?listCompanies.length:startVal+15} of ${listCompanies.length}",style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(width: 10,),
                                  Material(color: Colors.transparent,
                                    child: InkWell(
                                      hoverColor: mHoverColor,
                                      child: const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Icon(Icons.arrow_back_ios_sharp,size: 12),
                                      ),
                                      onTap: (){
                                        if(startVal>4){
                                          displayListCompanies=[];
                                          startVal = startVal-5;
                                          for(int i=startVal;i<startVal+5;i++){
                                            try{
                                              setState(() {
                                                displayListCompanies.add(listCompanies[i]);
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
                                        if(listCompanies.length>startVal+15){
                                          displayListCompanies=[];
                                          startVal=startVal+15;
                                          for(int i=startVal;i<startVal+15;i++){
                                            try{
                                              setState(() {
                                                displayListCompanies.add(listCompanies[i]);
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
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        )
      ]),
    );
  }

  //Add company details method.
  addCompanyDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        bool companyError = false;
        bool cityNameError = false;
        bool stateError = false;
        bool countryError = false;
        bool address1Error = false;
        bool address2Error = false;
        bool zipcodeError = false;
        var companyName = TextEditingController();
        final cityName = TextEditingController();
        final state = TextEditingController();
        final country = TextEditingController();
        final address1 = TextEditingController();
        final address2 = TextEditingController();
        final zipCode = TextEditingController();
        Map addCompany = {};
        final companiesKey = GlobalKey<FormState>();

        String capitalizeFirstWord (String name){
          if(name.isNotEmpty){
            var result=name[0].toUpperCase();
          for(int i=1;i<name.length;i++){
            if(name[i-1]=='1'){
              result=result+name[i].toUpperCase();
            }
            else{
              result=result+name[i];
            }
          }
          return result;
          }
          return '';
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {

              return SizedBox(
                width: 500,

                child: Stack(
                  children: [
                    Container(

                      decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(20)),
                      margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: companiesKey,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 35,right: 35),
                            child: Column(
                                children: [
                                 const SizedBox(height: 30,),
                              //Top Container.
                              const Align(alignment: Alignment.center,
                                child: Text(
                                  'Add New Company',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              //Company Name.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 130, child: Text('Company Name')),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: companyError ? 55 : 30,
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.words,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              companyError = true;
                                            });
                                            return "Enter User Name";
                                          } else {
                                            setState(() {
                                              companyError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (value) {
                                       companyName.value=TextEditingValue(
                                         text: capitalizeFirstWord(value),
                                         selection: companyName.selection,
                                       );
                                        },
                                        controller: companyName,
                                        decoration: decorationInput5(
                                            'Enter Company Name',
                                            companyName.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              //City Name.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 130, child: Text('City Name')),
                                  const SizedBox(height: 10),
                                  Expanded(

                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: cityNameError ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              cityNameError = true;
                                            });
                                            return "Enter City Name";
                                          } else {
                                            setState(() {
                                              cityNameError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),

                                        onChanged: (value) {
                                         cityName.value=TextEditingValue(
                                           text: capitalizeFirstWord(value),
                                           selection: cityName.selection,
                                         );
                                        },
                                        controller: cityName,
                                        decoration: decorationInput5(
                                            'Enter City Name',
                                            cityName.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              //state.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 130, child: Text('State Name')),
                                  const SizedBox(height: 10),
                                  Expanded(

                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: stateError ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              stateError = true;
                                            });
                                            return "Enter State Name";
                                          } else {
                                            setState(() {
                                              stateError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (value) {
                                      state.value=TextEditingValue(
                                        text: capitalizeFirstWord(value),
                                        selection: state.selection,
                                      );
                                        },
                                        controller: state,
                                        decoration: decorationInput5(
                                            'Enter State Name',
                                            state.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              //Country .
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 130, child: Text('Country Name')),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: countryError ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              countryError = true;
                                            });
                                            return "Enter Country Name";
                                          } else {
                                            setState(() {
                                              countryError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (value) {
                                      country.value=TextEditingValue(
                                        text: capitalizeFirstWord(value),
                                        selection: country.selection,
                                      );
                                        },
                                        controller: country,
                                        decoration: decorationInput5(
                                            'Enter Country Name',
                                            country.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              //address 1.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 130, child: Text('Address Line1 ')),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: address1Error ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              address1Error = true;
                                            });
                                            return "Enter Address Line";
                                          } else {
                                            setState(() {
                                              address1Error = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (value) {
                                       address1.value=TextEditingValue(
                                         text: capitalizeFirstWord(value),
                                         selection: address1.selection,
                                       );
                                        },
                                        controller: address1,
                                        decoration: decorationInput5(
                                            'Enter Address Line1',
                                            address1.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              //address line 2.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 130, child: Text('Address Line2 ')),
                                  const SizedBox(height: 10),
                                  Expanded(

                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: address2Error ? 55 : 30,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              address2Error = true;
                                            });
                                            return "Enter Address Line";
                                          } else {
                                            setState(() {
                                              address2Error = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (value) {
                                       address2.value=TextEditingValue(
                                         text: capitalizeFirstWord(value),
                                         selection: address2.selection,
                                       );
                                        },
                                        controller: address2,
                                        decoration: decorationInput5(
                                            'Enter Address Line2',
                                            address2.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              //zip code.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 130, child: Text('Zip Code')),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 0),
                                      height: zipcodeError ? 55 : 30,
                                      child: TextFormField(inputFormatters:[ FilteringTextInputFormatter.digitsOnly],
                                        keyboardType:TextInputType.number,maxLength: 6,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            setState(() {
                                              zipcodeError = true;
                                            });
                                            return "Enter Zipcode";
                                          } else {
                                            setState(() {
                                              zipcodeError = false;
                                            });
                                          }
                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 14),
                                        onChanged: (text) {
                                          setState(() {});
                                        },
                                        controller: zipCode,
                                        decoration: decorationInput5(
                                            'Enter Zipcode', zipCode.text.isNotEmpty),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              MaterialButton(
                                  color: Colors.blue,
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (companiesKey.currentState!.validate()) {
                                      addCompany = {
                                        'company_name':companyName.text,
                                        'city':cityName.text,
                                        'state': state.text,
                                        'country': country.text,
                                        'address_line1':address1.text,
                                        'address_line2': address2.text,
                                        'zip_code':zipCode.text,
                                        'userid': '',
                                      };
                                      postCompanyDetails(addCompany);
                                    }
                                  }),
                                 const SizedBox(height: 35,)
                            ]),
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
            },
          ),
        );
      },
    );
  }
}
