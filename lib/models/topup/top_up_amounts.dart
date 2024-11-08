class TopUpAmounts {
  TopUpAmounts({
     this.status,
     this.message,
     this.amounts,
     this.info,
  });
  int? status;
  String? message;
  List<TopUpAmountsData>? amounts;
  Info? info;

  TopUpAmounts.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    amounts =
        List.from(json['amounts']).map((e) => TopUpAmountsData.fromJson(e)).toList();
    info = Info.fromJson(json['info']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['amounts'] = amounts!.map((e) => e.toJson()).toList();
    _data['info'] = info!.toJson();
    return _data;
  }
}

class TopUpAmountsData {
  TopUpAmountsData({
    required this.id,
    required this.amountId,
    required this.currency,
    required this.cashbackAmount,
    required this.amount,
  });
  String? id;
  String? amountId;
  String? currency;
  dynamic cashbackAmount;
  dynamic amount;

  TopUpAmountsData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    amountId = json['amount_id'];
    currency = json['currency'];
    cashbackAmount = json['cashback_amount'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['amount_id'] = amountId;
    _data['currency'] = currency;
    _data['cashback_amount'] = cashbackAmount;
    _data['amount'] = amount;
    return _data;
  }
}

class Info {
  Info({
    required this.helpText,
    required this.fieldsRequired,
    required this.hasOutstandingAmount,
  });
  String? helpText;
  List<String>? fieldsRequired;
  bool? hasOutstandingAmount;

  Info.fromJson(Map<String, dynamic> json) {
    helpText = json['help_text'];
    fieldsRequired = List.castFrom<dynamic, String>(json['fields_required']);
    hasOutstandingAmount = json['has_outstanding_amount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['help_text'] = helpText;
    _data['fields_required'] = fieldsRequired;
    _data['has_outstanding_amount'] = hasOutstandingAmount;
    return _data;
  }
}
