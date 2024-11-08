class TopUpProducts {
  int? status;
  String? message;
  List<Products>? products;

  TopUpProducts({this.status, this.message, this.products});

  TopUpProducts.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    products = json["products"] == null
        ? null
        : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (products != null) {
      data["products"] = products?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productId;
  String? name;
  String? logo;
  String? type;
  List<Amounts>? amounts;
  String? helpText;
  List<FieldsRequired>? fieldsRequired;
  String? amountType;
  String? country;
  String? currency;

  Products(
      {this.productId,
      this.name,
      this.logo,
      this.type,
      this.amounts,
      this.helpText,
      this.fieldsRequired,
      this.amountType,
      this.country,
      this.currency});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json["product_id"];
    name = json["name"];
    logo = json["logo"];
    type = json["type"];
    amounts = json["amounts"] == null
        ? null
        : (json["amounts"] as List).map((e) => Amounts.fromJson(e)).toList();
    helpText = json["help_text"];
    fieldsRequired = json["fields_required"] == null
        ? null
        : (json["fields_required"] as List)
            .map((e) => FieldsRequired.fromJson(e))
            .toList();
    amountType = json["amount_type"];
    country = json["country"];
    currency = json["currency"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["product_id"] = productId;
    data["name"] = name;
    data["logo"] = logo;
    data["type"] = type;
    if (amounts != null) {
      data["amounts"] = amounts?.map((e) => e.toJson()).toList();
    }
    data["help_text"] = helpText;
    if (fieldsRequired != null) {
      data["fields_required"] = fieldsRequired?.map((e) => e.toJson()).toList();
    }
    data["amount_type"] = amountType;
    data["country"] = country;
    data["currency"] = currency;
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

class Amounts {
  String? amountId;
  dynamic cashbackAmount;
  dynamic amount;
  String? currency;

  Amounts({this.amountId, this.cashbackAmount, this.amount, this.currency});

  Amounts.fromJson(Map<String, dynamic> json) {
    amountId = json["amount_id"];
    cashbackAmount = json["cashback_amount"];
    amount = json["amount"];
    currency = json["currency"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["amount_id"] = amountId;
    data["cashback_amount"] = cashbackAmount;
    data["amount"] = amount;
    data["currency"] = currency;
    return data;
  }
}
