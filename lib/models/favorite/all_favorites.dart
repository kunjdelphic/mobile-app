class AllFavorites {
  int? status;
  String? message;
  List<AllFavoritesData>? data;

  AllFavorites({this.status, this.message, this.data});

  AllFavorites.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => AllFavoritesData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (this.data != null) {
      data["data"] = this.data?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class AllFavoritesData {
  String? favoriteId;
  String? type;
  String? nickName;
  String? lastUpdated;
  dynamic amount;
  dynamic cashback;
  String? lastPaidBill;
  dynamic order;
  String? accountNumber;
  String? lastTransactionId;
  String? lastTransactionStatus;
  String? lastTransactionTimestamp;
  bool? reminder;
  bool? recurring;
  bool? hasOutstandingAmount;
  String? productId;
  String? productName;
  String? productImage;
  String? serviceId;
  String? categoryId;
  String? country;
  String? currency;
  String? helpText;
  List<FieldsRequired>? fieldsRequired;
  String? amountType;
  dynamic maximumAmount;
  dynamic minimumAmount;
  List<Amounts>? amounts;

  AllFavoritesData(
      {this.favoriteId,
      this.type,
      this.nickName,
      this.lastUpdated,
      this.amount,
      this.cashback,
      this.lastPaidBill,
      this.order,
      this.accountNumber,
      this.lastTransactionId,
      this.lastTransactionStatus,
      this.lastTransactionTimestamp,
      this.reminder,
      this.recurring,
      this.hasOutstandingAmount,
      this.productId,
      this.productName,
      this.productImage,
      this.serviceId,
      this.categoryId,
      this.country,
      this.currency,
      this.helpText,
      this.fieldsRequired,
      this.amountType,
      this.maximumAmount,
      this.minimumAmount,
      this.amounts});

  AllFavoritesData.fromJson(Map<String, dynamic> json) {
    favoriteId = json["favorite_id"];
    type = json["type"];
    nickName = json["nick_name"];
    lastUpdated = json["last_updated"];
    amount = json["amount"];
    cashback = json["cashback"];
    lastPaidBill = json["last_paid_bill"];
    order = json["order"];
    accountNumber = json["account_number"];
    lastTransactionId = json["last_transaction_id"];
    lastTransactionStatus = json["last_transaction_status"];
    lastTransactionTimestamp = json["last_transaction_timestamp"];
    reminder = json["reminder"];
    recurring = json["recurring"];
    hasOutstandingAmount = json["has_outstanding_amount"];
    productId = json["product_id"];
    productName = json["product_name"];
    productImage = json["product_image"];
    serviceId = json["service_id"];
    categoryId = json["category_id"];
    country = json["country"];
    currency = json["currency"];
    helpText = json["help_text"];
    fieldsRequired = json["fields_required"] == null
        ? null
        : (json["fields_required"] as List)
            .map((e) => FieldsRequired.fromJson(e))
            .toList();
    amountType = json["amount_type"];
    maximumAmount = json["maximum_amount"];
    minimumAmount = json["minimum_amount"];
    amounts = json["amounts"] == null
        ? null
        : (json["amounts"] as List).map((e) => Amounts.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["favorite_id"] = favoriteId;
    data["type"] = type;
    data["nick_name"] = nickName;
    data["last_updated"] = lastUpdated;
    data["amount"] = amount;
    data["cashback"] = cashback;
    data["last_paid_bill"] = lastPaidBill;
    data["order"] = order;
    data["account_number"] = accountNumber;
    data["last_transaction_id"] = lastTransactionId;
    data["last_transaction_status"] = lastTransactionStatus;
    data["last_transaction_timestamp"] = lastTransactionTimestamp;
    data["reminder"] = reminder;
    data["recurring"] = recurring;
    data["has_outstanding_amount"] = hasOutstandingAmount;
    data["product_id"] = productId;
    data["product_name"] = productName;
    data["product_image"] = productImage;
    data["service_id"] = serviceId;
    data["category_id"] = categoryId;
    data["country"] = country;
    data["currency"] = currency;
    data["help_text"] = helpText;
    if (fieldsRequired != null) {
      data["fields_required"] = fieldsRequired?.map((e) => e.toJson()).toList();
    }
    data["amount_type"] = amountType;
    data["maximum_amount"] = maximumAmount;
    data["minimum_amount"] = minimumAmount;
    if (amounts != null) {
      data["amounts"] = amounts?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Amounts {
  String? amountId;
  String? cashbackAmount;
  dynamic minAmount;
  dynamic maxAmount;
  String? currency;

  Amounts(
      {this.amountId,
      this.cashbackAmount,
      this.minAmount,
      this.maxAmount,
      this.currency});

  Amounts.fromJson(Map<String, dynamic> json) {
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
