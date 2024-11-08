class TransactionHistoryFilterProducts {
  int? status;
  String? message;
  List<String>? products;

  TransactionHistoryFilterProducts({this.status, this.message, this.products});

  TransactionHistoryFilterProducts.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    products =
        json["products"] == null ? null : List<String>.from(json["products"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (products != null) {
      data["products"] = products;
    }
    return data;
  }
}
