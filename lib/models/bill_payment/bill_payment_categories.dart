class BillPaymentCategories {
  int? status;
  String? message;
  List<BillPaymentCategoriesCategories>? categories;

  BillPaymentCategories({this.status, this.message, this.categories});

  BillPaymentCategories.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    categories = json["categories"] == null
        ? null
        : (json["categories"] as List)
            .map((e) => BillPaymentCategoriesCategories.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (categories != null) {
      data["categories"] = categories?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class BillPaymentCategoriesCategories {
  String? name;
  String? categoryId;
  List<BillPaymentCategoriesProducts>? products;

  BillPaymentCategoriesCategories({this.name, this.categoryId, this.products});

  BillPaymentCategoriesCategories.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    categoryId = json["category_id"];
    products = json["products"] == null
        ? null
        : (json["products"] as List)
            .map((e) => BillPaymentCategoriesProducts.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["category_id"] = categoryId;
    if (products != null) {
      data["products"] = products?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class BillPaymentCategoriesProducts {
  String? productId;
  String? name;
  String? logo;
  String? type;
  List<BillPaymentCategoriesAmounts>? amounts;
  String? helpText;
  List<FieldsRequired>? fieldsRequired;
  bool? hasOutstandingAmount;
  dynamic maximumAmount;
  dynamic minimumAmount;
  String? amountType;
  String? country;
  String? currency;

  BillPaymentCategoriesProducts(
      {this.productId,
      this.name,
      this.logo,
      this.type,
      this.amounts,
      this.helpText,
      this.fieldsRequired,
      this.hasOutstandingAmount,
      this.maximumAmount,
      this.minimumAmount,
      this.amountType,
      this.country,
      this.currency});

  BillPaymentCategoriesProducts.fromJson(Map<String, dynamic> json) {
    productId = json["product_id"];
    name = json["name"];
    logo = json["logo"];
    type = json["type"];
    amounts = json["amounts"] == null
        ? null
        : (json["amounts"] as List)
            .map((e) => BillPaymentCategoriesAmounts.fromJson(e))
            .toList();
    helpText = json["help_text"];
    fieldsRequired = json["fields_required"] == null
        ? null
        : (json["fields_required"] as List)
            .map((e) => FieldsRequired.fromJson(e))
            .toList();
    hasOutstandingAmount = json["has_outstanding_amount"];
    maximumAmount = json["maximum_amount"];
    minimumAmount = json["minimum_amount"];
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
    data["has_outstanding_amount"] = hasOutstandingAmount;
    data["maximum_amount"] = maximumAmount;
    data["minimum_amount"] = minimumAmount;
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

class BillPaymentCategoriesAmounts {
  String? amountId;
  dynamic cashbackAmount;
  dynamic minAmount;
  dynamic maxAmount;
  String? currency;

  BillPaymentCategoriesAmounts(
      {this.amountId,
      this.cashbackAmount,
      this.minAmount,
      this.maxAmount,
      this.currency});

  BillPaymentCategoriesAmounts.fromJson(Map<String, dynamic> json) {
    amountId = json["amount_id"];
    cashbackAmount = json["cashback_amount"];
    minAmount = json["min_amount"];
    maxAmount = json["max_amount"];
    currency = json["currency"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["amount_id"] = amountId;
    data["cashback_amount"] = cashbackAmount;
    data["min_amount"] = minAmount;
    data["max_amount"] = maxAmount;
    data["currency"] = currency;
    return data;
  }
}
