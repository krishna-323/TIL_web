
class CustomerModel{
  List<_CustomerModel> _customerList = [];
  CustomerModel.fromProvider(Map parsedJson){
    List<_CustomerModel> customerTemp = [];

    _CustomerModel CustomerResult = _CustomerModel(parsedJson);
    customerTemp.add(CustomerResult);
    _customerList = customerTemp;
  }
  List<_CustomerModel> get customerDocketData => _customerList;
}

class _CustomerModel{
  Map _CustomerData = {};
  _CustomerModel(response){

    _CustomerData ={
      "customer_id":response["customer_id"]??'',
      "customer_name": response["customer_name"]??"",
    "mobile": response["mobile"]??"",
    "email_id": response["email_id"]??"",
    "type": response["type"]??"",
    "pan_number": response["pan_number"]??"",
    "gstin": response["gstin"]??"",
    "street_address": response["street_address"]??"",
    "pin_code": response["pin_code"]??"",
    "city": response["city"]??"",
    "location":response["location"]??"",
    // "contact_first_name": response["contact_first_name"]??"",
    // "contact_last_name": response["contact_last_name"]??"",
    // "email_address": response["email_address"]??"",
    // "work_phone": response["work_phone"]??"",
    // "mobile": response["mobile"]??"",
    // "currency": response["currency"]??"",
    // "opening_balance":response["opening_balance"]??"",
    // "gst_treatment": response["gst_treatment"]?? "",
    // "place_of_supply": response["place_of_supply"]?? "",
    //
    // "exchange_rate": response[ "exchange_rate"]??"",
    // "payment_terms": response["payment_terms"]??"",
    // "price_list": response["price_list"]??"",
    // "facebook": response["facebook"]??"",
    // "twitter": response["twitter"]??"",
    // "billing_attention": response["billing_attention"]??"",
    // "billing_country": response["billing_country"]??"",
    // "billing_address_street1": response["billing_address_street1"]??"",
    // "billing_address_street2": response["billing_address_street2"]??"",
    // "billing_city": response["billing_city"]??"",
    // "billing_state": response["billing_state"]??"",
    // "billing_zipcode": response["billing_zipcode"]??"",
    // "billing_phone": response["billing_phone"]??"",
    // "billing_fax": response["billing_fax"]??"",
    // "shipping_attention": response[ "shipping_attention"]??"",
    // "shipping_country": response["shipping_country"]??"",
    // "shipping_address_street1": response["shipping_address_street1"]??"",
    // "shipping_address_street2": response["shipping_address_street2"]??"",
    // "shipping_city": response["shipping_city"]??"",
    // "shipping_state": response["shipping_state"]??"",
    // "shipping_zipcode": response["shipping_zipcode"]??"",
    // "shipping_phone": response["shipping_phone"]??"",
    // "shipping_fax": response["shipping_fax"]??"",
    // "exemption_reason": response["exemption_reason"]??"",
    //   "tax_preferences":response ["tax_preferences"]??'',
    //   "enable_portal":response["enable_portal"]??'',
    //   "portal_language":response["portal_language"]??'',
    };
   // print("--------Customer Model---------");
   // print(_CustomerData);
  }

  Map get customerData => _CustomerData;
}