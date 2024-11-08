class AllRecurring {
    int? status;
    String? message;
    List<AllRecurringData>? recurring;

    AllRecurring({this.status, this.message, this.recurring});

    AllRecurring.fromJson(Map<String, dynamic> json) {
        status = json["status"];
        message = json["message"];
        recurring = json["recurring"]==null ? null : (json["recurring"] as List).map((e)=>AllRecurringData.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["status"] = status;
        data["message"] = message;
        if(recurring != null) {
          data["recurring"] = recurring?.map((e)=>e.toJson()).toList();
        }
        return data;
    }
}

class AllRecurringData {
    String? favoriteId;
    String? type;
    String? nickName;
    String? lastUpdated;
    String? productId;
    String? productName;
    var productImage;
    var amount;
    var cashback;
    String? lastPaidBill;
    var order;
    String? accountNumber;
    String? lastTransactionId;
    String? lastTransactionStatus;
    String? lastTransactionTimestamp;
    bool? showOutstandingAmount;
    bool? reminder;
    bool? recurring;
    String? recurringType;
    var recurringDay;
    var recurringHour;
    var recurringMinute;

    AllRecurringData({this.favoriteId, this.type, this.nickName, this.lastUpdated, this.productId, this.productName, this.productImage, this.amount, this.cashback, this.lastPaidBill, this.order, this.accountNumber, this.lastTransactionId, this.lastTransactionStatus, this.lastTransactionTimestamp, this.showOutstandingAmount, this.reminder, this.recurring, this.recurringType, this.recurringDay, this.recurringHour, this.recurringMinute});

    AllRecurringData.fromJson(Map<String, dynamic> json) {
        favoriteId = json["favorite_id"];
        type = json["type"];
        nickName = json["nick_name"];
        lastUpdated = json["last_updated"];
        productId = json["product_id"];
        productName = json["product_name"];
        productImage = json["product_image"];
        amount = json["amount"];
        cashback = json["cashback"];
        lastPaidBill = json["last_paid_bill"];
        order = json["order"];
        accountNumber = json["account_number"];
        lastTransactionId = json["last_transaction_id"];
        lastTransactionStatus = json["last_transaction_status"];
        lastTransactionTimestamp = json["last_transaction_timestamp"];
        showOutstandingAmount = json["show_outstanding_amount"];
        reminder = json["reminder"];
        recurring = json["recurring"];
        recurringType = json["recurring_type"];
        recurringDay = json["recurring_day"];
        recurringHour = json["recurring_hour"];
        recurringMinute = json["recurring_minute"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["favorite_id"] = favoriteId;
        data["type"] = type;
        data["nick_name"] = nickName;
        data["last_updated"] = lastUpdated;
        data["product_id"] = productId;
        data["product_name"] = productName;
        data["product_image"] = productImage;
        data["amount"] = amount;
        data["cashback"] = cashback;
        data["last_paid_bill"] = lastPaidBill;
        data["order"] = order;
        data["account_number"] = accountNumber;
        data["last_transaction_id"] = lastTransactionId;
        data["last_transaction_status"] = lastTransactionStatus;
        data["last_transaction_timestamp"] = lastTransactionTimestamp;
        data["show_outstanding_amount"] = showOutstandingAmount;
        data["reminder"] = reminder;
        data["recurring"] = recurring;
        data["recurring_type"] = recurringType;
        data["recurring_day"] = recurringDay;
        data["recurring_hour"] = recurringHour;
        data["recurring_minute"] = recurringMinute;
        return data;
    }
}