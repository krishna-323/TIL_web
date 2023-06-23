

class VendorData {
  final String label;
  final String firstName;
  final String vendorID;
  final String last_name;

  final String company_name;

  final String vendor_display_name;

  final String vendor_email;

  final String vendor_mobile_phone;

  final String website;

  final String currency;

  final String contact_persons_salutation;

  final String contact_persons_first_name;

  final String contact_persons_last_name;

  final String contact_persons_email_id;

  final String contact_persons_mobile;

  final String billing_address_address;

  final String billing_address_country;

  final String billing_address_city;

  final String billing_address_state;

  final String billing_address_zip_code;

  final String shipping_address_attention;

  final String shipping_address_country;

  final String shipping_address_street1;

  final String shipping_address_street2;

  final String shipping_address_city;

  final String shipping_address_state;

  final String shipping_address_zip_code;
  final String payto_address1;
  final String payto_address2;
  final String payto_region;
  final String payto_state;
  final String payto_city;
  final String payto_zip;
  VendorData({
    required this.payto_address1,
    required this.payto_address2,
    required this.payto_region,
    required this.payto_state,
    required this.payto_city,
    required this.payto_zip,
    required this.label,
    required this.firstName,
    required this.vendorID,
    required this.last_name,
    required this.company_name,
    required this.vendor_display_name,
    required this.vendor_email,
    required this.vendor_mobile_phone,
    required this.website,
    required this.currency,
    required this.contact_persons_salutation,
    required this.contact_persons_first_name,
    required this.contact_persons_last_name,
    required this.contact_persons_email_id,
    required this.contact_persons_mobile,
    required this.billing_address_address,
    required this.billing_address_country,
    required this.billing_address_city,
    required this.billing_address_state,
    required this.billing_address_zip_code,
    required this.shipping_address_attention,
    required this.shipping_address_country,
    required this.shipping_address_street1,
    required this.shipping_address_street2,
    required this.shipping_address_city,
    required this.shipping_address_state,
    required this.shipping_address_zip_code,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) {
    // print(json);
    return VendorData(
      label: json['contact_persons_name'],
      firstName: json['contact_persons_name'],
      vendorID: json['new_vendor_id'],
      last_name: json['contact_persons_name'],
      company_name: json['company_name'],
      vendor_display_name: json['vendor_display_name'],
      vendor_email: json['vendor_email'],
      vendor_mobile_phone: json['vendor_mobile_phone'],
      website: json['contact_persons_name'],
      currency: json['contact_persons_name'],
      contact_persons_salutation: json['contact_persons_name'],
      contact_persons_first_name: json['contact_persons_name'],
      contact_persons_last_name: json['contact_persons_name'],
      contact_persons_email_id: json['contact_persons_name'],
      contact_persons_mobile: json['contact_persons_name'],
      billing_address_address:
      json['vendor_address1'] + " " + json['vendor_address2'],
      billing_address_country: json['vendor_city'],
      billing_address_city: json['vendor_region'],
      billing_address_state: json['vendor_state'],
      billing_address_zip_code: json['vendor_zip'],
      shipping_address_attention: json['shipto_address1'],
      shipping_address_country: json['shipto_city'],
      shipping_address_street1: json['shipto_address1'],
      shipping_address_street2: json['shipto_address2'],
      shipping_address_city: json['shipto_region'],
      shipping_address_state: json['shipto_state'],
      shipping_address_zip_code: json['shipto_zip'],
      payto_address1: json['payto_address1'],
      payto_address2: json['payto_address1'],
      payto_region: json['payto_region'],
      payto_state: json['payto_state'],
      payto_city: json['payto_city'],
      payto_zip: json['payto_zip'],

    );
  }
}