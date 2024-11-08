class OutstandingBill {
  int? status;
  String? message;
  Bill? bill;

  OutstandingBill({this.status, this.message, this.bill});

  OutstandingBill.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    bill = json["bill"] == null ? null : Bill.fromJson(json["bill"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (bill != null) {
      data["bill"] = bill?.toJson();
    }
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
