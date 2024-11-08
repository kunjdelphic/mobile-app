class BillPaymentAmounts {
  int? status;
  String? message;
  List<Amounts>? amounts;
  Bill? bill;
  Info? info;

  BillPaymentAmounts(
      {this.status, this.message, this.amounts, this.bill, this.info});

  BillPaymentAmounts.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    amounts = json["amounts"] == null
        ? null
        : (json["amounts"] as List).map((e) => Amounts.fromJson(e)).toList();
    bill = json["bill"] == null ? null : Bill.fromJson(json["bill"]);
    info = json["info"] == null ? null : Info.fromJson(json["info"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (amounts != null) {
      data["amounts"] = amounts?.map((e) => e.toJson()).toList();
    }
    if (bill != null) {
      data["bill"] = bill?.toJson();
    }
    if (info != null) {
      data["info"] = info?.toJson();
    }
    return data;
  }
}

class Info {
  String? helpText;
  List<FieldsRequired>? fieldsRequired;

  bool? hasOutstandingAmount;
  dynamic maximumAmount;
  dynamic minimumAmount;

  Info({
    this.helpText,
    this.fieldsRequired,
    this.hasOutstandingAmount,
    this.maximumAmount,
    this.minimumAmount,
  });

  Info.fromJson(Map<String, dynamic> json) {
    helpText = json["help_text"];
    fieldsRequired = json["fields_required"] == null
        ? null
        : (json["fields_required"] as List)
            .map((e) => FieldsRequired.fromJson(e))
            .toList();
    hasOutstandingAmount = json["has_outstanding_amount"];
    maximumAmount = json["maximum_amount"];
    minimumAmount = json["minimum_amount"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["help_text"] = helpText;
    if (fieldsRequired != null) {
      data["fields_required"] = fieldsRequired;
    }
    data["has_outstanding_amount"] = hasOutstandingAmount;
    data["maximum_amount"] = maximumAmount;
    data["minimum_amount"] = minimumAmount;
    return data;
  }
}

class FieldsRequired {
  String? type;
  dynamic minLength;

  FieldsRequired({this.type, this.minLength});

  FieldsRequired.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    minLength = json["min_length"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = type;
    data["min_length"] = minLength;
    return data;
  }
}

class Bill {
  String? accountHolderName;
  String? outstandingAmount;
  String? lastUpdated;
  String? bill;
  String? remarks;

  Bill(
      {this.accountHolderName,
      this.outstandingAmount,
      this.lastUpdated,
      this.bill,
      this.remarks});

  Bill.fromJson(Map<String, dynamic> json) {
    accountHolderName = json["account_holder_name"];
    outstandingAmount = json["outstanding_amount"];
    lastUpdated = json["last_updated"];
    bill = json["bill"];
    remarks = json["remarks"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["account_holder_name"] = accountHolderName;
    data["outstanding_amount"] = outstandingAmount;
    data["last_updated"] = lastUpdated;
    data["bill"] = bill;
    data["remarks"] = remarks;
    return data;
  }
}

class Amounts {
  String? id;
  String? amountId;
  String? currency;
  dynamic minAmount;
  dynamic maxAmount;
  dynamic cashbackAmount;

  Amounts(
      {this.id,
      this.amountId,
      this.currency,
      this.minAmount,
      this.maxAmount,
      this.cashbackAmount});

  Amounts.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    amountId = json["amount_id"];
    currency = json["currency"];
    minAmount = json["min_amount"];
    maxAmount = json["max_amount"];
    cashbackAmount = json["cashback_amount"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data["amount_id"] = amountId;
    data["currency"] = currency;
    data["min_amount"] = minAmount;
    data["max_amount"] = maxAmount;
    data["cashback_amount"] = cashbackAmount;
    return data;
  }
}
