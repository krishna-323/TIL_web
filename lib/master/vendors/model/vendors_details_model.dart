
class VendorModel{
  List<_VendorModel> _vendorList = [];
  VendorModel.fromProvider(Map parsedJson){
    List<_VendorModel> vendorTemp = [];
    _VendorModel vendorResult = _VendorModel(parsedJson);
    vendorTemp.add(vendorResult);
    _vendorList = vendorTemp;
  }
  List<_VendorModel> get vendorDocketData => _vendorList;
}

class _VendorModel{
  Map _vendorData = {};
  _VendorModel(response){
    _vendorData ={
      "new_vendor_id": response["new_vendor_id"]?? "",
      "company_name": response["company_name"]??"",
      "vendor_display_name": response["vendor_display_name"]??"",
      "vendor_email": response["vendor_email"]??"",
      "vendor_mobile_phone": response["vendor_mobile_phone"]??"",
      "contact_persons_name": response["contact_persons_name"]??"",
      "contact_persons_email_id": response["contact_persons_email_id"]??"",
      "contact_persons_mobile":response["contact_persons_mobile"]??"",
      "gst":response["gst"]??"",
      "pan":response["pan"]??"",
      "vendor_address1":response["vendor_address1"]??"",
      "vendor_address2":response["vendor_address2"]??"",
      "vendor_state":response["vendor_state"]??"",
      "vendor_zip":response["vendor_zip"]??"",
      "vendor_region":response["vendor_region"]??"",
      "vendor_city":response["vendor_city"]??"",
      "vendor_gst":response["vendor_gst"]??"",
      "vendor_pan":response["vendor_pan"]??"",
      "pay_to_name":response["pay_to_name"]??"",
      "payto_address1":response["payto_address1"]??"",
      "payto_address2":response["payto_address2"]??"",
      "payto_state":response["payto_state"]??"",
      "payto_zip":response["payto_zip"]??"",
      "payto_region":response["payto_region"]??"",
      "payto_city":response["payto_city"]??"",
      "payto_gst":response["payto_gst"]??"",
      "payto_pan":response["payto_pan"]??"",
      "ship_to_name":response["ship_to_name"]??"",
      "shipto_address1":response["shipto_address1"]??"",
      "shipto_address2":response["shipto_address2"]??"",
      "shipto_state":response["shipto_state"]??"",
      "shipto_zip":response["shipto_zip"]??"",
      "shipto_region":response["shipto_region"]??"",
      "shipto_city":response["shipto_city"]??"",
      "shipto_gst":response["shipto_gst"]??"",
      "shipto_pan":response["shipto_pan"]??"",
      "vendor_type":response["vendor_type"]??"",
      "vendor_code":response["vendor_code"]??"",
    };
  }
  Map get vendorData => _vendorData;
}