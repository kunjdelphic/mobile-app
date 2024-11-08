class Recurring {
  int? status;
  String? message;
  List<RecurringData>? data;

  Recurring({this.status, this.message, this.data});

  Recurring.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => RecurringData.fromJson(e)).toList();
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

class RecurringData {
  String? favoriteId;
  String? type;
  String? nickName;
  String? lastUpdated;
  var amount;
  var cashback;
  String? lastPaidBill;
  var order;
  String? accountNumber;
  String? lastTransactionId;
  String? lastTransactionStatus;
  String? lastTransactionTimestamp;
  bool? reminder;
  String? reminderType;
  var reminderDay;
  var reminderHour;
  var reminderMinute;
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

  RecurringData({
    this.favoriteId,
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
    this.reminderType,
    this.reminderDay,
    this.reminderHour,
    this.reminderMinute,
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
  });

  RecurringData.fromJson(Map<String, dynamic> json) {
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
    reminderType = json["reminder_type"];
    reminderDay = json["reminder_day"];
    reminderHour = json["reminder_hour"];
    reminderMinute = json["reminder_minute"];
    recurring = json["recurring"];
    hasOutstandingAmount = json["show_outstanding_amount"];
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
    data["reminder_type"] = reminderType;
    data["reminder_day"] = reminderDay;
    data["reminder_hour"] = reminderHour;
    data["reminder_minute"] = reminderMinute;
    data["recurring"] = recurring;
    data["show_outstanding_amount"] = hasOutstandingAmount;
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
    return data;
  }
}

class FieldsRequired {
  String? type;
  var minLength;

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
