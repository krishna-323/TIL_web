class DocketDetailsModel {

  List<_DocketDetails> _list =[];
  DocketDetailsModel.fromProvider(Map parsedJson) {
    List <_DocketDetails> temp =[];
    // for(int i =0; i<parsedJson.length; i++) {
    _DocketDetails result = _DocketDetails(parsedJson);
    temp.add(result);
    // }
    _list = temp;
  }
  List<_DocketDetails> get docketData => _list;
}


class _DocketDetails{
  List list=[] ;
  _DocketDetails(response){
      Map data = {
        "docket_id": response['docket_id'] ?? "",
        "customer_id":response['customer_id'] ?? "",
        "brand_id": response['brand_id'] ?? "",
        "model_id": response['model_id'] ?? "",
        "color_id":response['color_id'] ?? "",
        "varient_id":response['varient_id'] ?? "",
        "year":response['year'] ?? "",
        "ex_showroom_price": response['ex_showroom_price'] ?? "",
        "rto": response['rto'] ?? "",
        "insurance": response['insurance'] ?? "",
        "accessories_charges":response['accessories_charges'] ?? "",
        "transmission":response['transmission'] ?? "",
        "extended_warranty":response['extended_warranty'] ?? "",
        "tr_pr_charges": response['tr_pr_charges'] ?? "",
        "fast_tag":response['fast_tag'] ?? "",
        "ms_rewards": response['ms_rewards'] ?? "",
        "on_road_price": response['on_road_price'] ?? "",
        "customer_name": response['customer_name'] ?? "",
        "mobile":response['mobile'] ?? "",
        "email_id":response['email_id'] ?? "",
        "address_line_1":response['address_line_1'] ?? "",
        "address_line_2": response['address_line_2'] ?? "",
        "wo_or_so":response['wo_or_so'] ?? "",
        "pan_number": response['pan_number'] ?? "",
        "dob": response['dob'] ?? "",
        "city": response['city'] ?? "",
        "state": response['state'] ?? "",
        "pincode": response['pincode'] ?? "",
        "existing_car": response['existing_car'] ?? "",
        "existing_car_model": response['existing_car_model'] ?? "",
        "evaluation_date": response['evaluation_date'] ?? "",
        "finance_scheme": response['finance_scheme'] ?? "",
        "finance_company": response['finance_company'] ?? "",
        "finance_amount": response['finance_amount'] ?? "",
        "booking_amount": response['booking_amount'] ?? "",
        "payment_mode":response['payment_mode'] ?? "",
        "customer_notes": response['customer_notes'] ?? "",
        "terms_and_conditions": response['terms_and_conditions'] ?? "",
        "booking_date": response['booking_date'] ?? "",
        "address_l1": response['address_l1'] ?? "",
        "address_l2": response['address_l2'] ?? "",
        "booking_model": response['booking_model'] ?? "",
        "exchange_model": response['exchange_model'] ?? "",
        "date_of_booking": response['date_of_booking'] ?? "",
        "chassis_no": response['chassis_no'] ?? "",
        "booking_allotment_date":response['booking_allotment_date'] ?? "",
        "booking_varient":response['booking_varient'] ?? "",
        "booking_color":response['booking_color'] ?? "",
        "booking_id":response['booking_id'] ?? "",
        "car_status":response['car_status'] ?? "",
        "engine_no": response['engine_no'] ?? "",
        "alloted_by": response['alloted_by'] ?? "",
        "color": response['color'] ?? "",
        "booking_id": response['booking_id'] ?? "",
        "allotment_no": response['allotment_no'] ?? "",
        "status": response['status'] ?? "",
        "invoice_no": response['invoice_no'] ?? "",
        "invoice_date": response['invoice_date'] ?? "",
        "ins_no": response['ins_no'] ?? "",
        "ew_no": response['ew_no'] ?? "",
        "maruthi_insurance":response['maruthi_insurance'] ?? "",
        "insurance_remarks": response['insurance_remarks'] ?? "",
        "ins_mgr_remarks": response['ins_mgr_remarks'] ?? "",
        "ex_showroom_actual": response['ex_showroom_actual'] ?? "",
        "ex_showroom_discounted": response['ex_showroom_discounted'] ?? "",
        "life_tax_actual": response['life_tax_actual'] ?? "",
        "life_tax_discounted":response['life_tax_discounted'] ?? "",
        "zero_dep_insurance_actual": response['zero_dep_insurance_actual'] ?? "",
        "zero_dep_insurance_discounted": response['zero_dep_insurance_discounted'] ?? "",
        "insurance_actual":response['insurance_actual'] ?? "",
        "insurance_discounted": response['insurance_discounted'] ?? "",
        "reg_no_actual": response['reg_no_actual'] ?? "",
        "reg_no_discounted":response['reg_no_discounted'] ?? "",
        "warranty_year_actual":response['warranty_year_actual'] ?? "",
        "warranty_year_discounted":response['warranty_year_discounted'] ?? "",
        "accessories_actual": response['accessories_actual'] ?? "",
        "accessories_discounted": response['accessories_discounted'] ?? "",
        "others_actual":response['others_actual'] ?? "",
        "others_discounted":response['others_discounted'] ?? "",
        "refund_actual":response['refund_actual'] ?? "",
        "refund_discounted":response['refund_discounted'] ?? "",
        "total_actual_amount": response['total_actual_amount'] ?? "",
        "total_discounted_amount": response['total_discounted_amount'] ?? "",
        "preg_no": response['preg_no'] ?? "",
        "rc_copy": response['rc_copy'] ?? "",
        "mfg_year":response['mfg_year'] ?? "",
        "relation_ship": response['relation_ship'] ?? "",
        "vehicle_cost":response['vehicle_cost'] ?? "",
        "less_per_closing_amount":response['less_per_closing_amount'] ?? "",
        "less_trafic_challan":response['less_trafic_challan'] ?? "",
        "less_balance_new_car": response['less_balance_new_car'] ?? "",
        "terms_conditions": response['terms_conditions'] ?? "",
      "oem_accessories_disc": response['oem_accessories_disc'] ?? "",
      "oem_additional_discount": response['oem_additional_discount'] ?? "",
      "oem_consumer_offer": response['oem_consumer_offer'] ?? "",
      "oem_corporate_offer": response['oem_corporate_offer'] ?? "",
      "oem_exchange_bonus": response['oem_exchange_bonus'] ?? "",
      "offer_details_id": response['offer_details_id'] ?? "",
      "overall_amount": response['overall_amount'] ?? "",
      "self_accessories_disc": response['self_accessories_disc'] ?? "",
      "self_additional_discount": response['self_additional_discount'] ?? "",
      "self_consumer_offer": response['self_consumer_offer'] ?? "",
      "self_corporate_offer": response['self_corporate_offer'] ?? "",
      "self_exchange_bonus": response['self_exchange_bonus'] ?? "",
      "total_accessories_disc": response['total_accessories_disc'] ?? "",
      "total_additional_discount": response['total_additional_discount'] ?? "",
      "total_consumer_offer": response['total_consumer_offer'] ?? "",
      "total_corporate_offer": response['total_corporate_offer'] ?? "",
      "total_exchange_bonus": response['total_exchange_bonus'] ?? "",



        "total_amount":response['total_amount'] ?? "",
      };


     list.add(data);

    }
  List get partsList => list;
}







