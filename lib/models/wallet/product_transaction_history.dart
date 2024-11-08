class ProductTransactionHistory {
  int? status;
  String? message;
  String? description;
  List<ProductTransactionHistoryTransactions>? transactions;
  dynamic totalSuccessfullPayment;

  ProductTransactionHistory(
      {this.status,
      this.message,
      this.description,
      this.transactions,
      this.totalSuccessfullPayment});

  ProductTransactionHistory.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    description = json["description"];
    transactions = json["transactions"] == null
        ? null
        : (json["transactions"] as List)
            .map((e) => ProductTransactionHistoryTransactions.fromJson(e))
            .toList();
    totalSuccessfullPayment = json["total_successfull_payment"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    data["description"] = description;
    if (transactions != null) {
      data["transactions"] = transactions?.map((e) => e.toJson()).toList();
    }
    data["total_successfull_payment"] = totalSuccessfullPayment;
    return data;
  }
}

class ProductTransactionHistoryTransactions {
  String? id;
  String? transactionId;
  String? secretId;
  String? timestamp;
  String? amount;
  String? currency;
  String? status;
  String? remarks;
  dynamic receipt;
  String? accountNumber;
  String? productId;
  String? productName;
  String? productImage;
  String? mainWalletAmount;
  String? cashbackWalletAmount;
  String? todaysReferralEarningWalletAmount;
  String? receiveMoneyWalletAmount;
  String? amountId;
  String? cashback;
  String? paymentType;

  ProductTransactionHistoryTransactions(
      {this.id,
      this.transactionId,
      this.secretId,
      this.timestamp,
      this.amount,
      this.currency,
      this.status,
      this.remarks,
      this.receipt,
      this.accountNumber,
      this.productId,
      this.productName,
      this.productImage,
      this.mainWalletAmount,
      this.cashbackWalletAmount,
      this.todaysReferralEarningWalletAmount,
      this.receiveMoneyWalletAmount,
      this.amountId,
      this.cashback,
      this.paymentType});

  ProductTransactionHistoryTransactions.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    transactionId = json["transaction_id"];
    secretId = json["secret_id"];
    timestamp = json["timestamp"];
    amount = json["amount"];
    currency = json["currency"];
    status = json["status"];
    remarks = json["remarks"];
    receipt = json["receipt"];
    accountNumber = json["account_number"];
    productId = json["product_id"];
    productName = json["product_name"];
    productImage = json["product_image"];
    mainWalletAmount = json["main_wallet_amount"];
    cashbackWalletAmount = json["cashback_wallet_amount"];
    todaysReferralEarningWalletAmount =
        json["todays_referral_earning_wallet_amount"];
    receiveMoneyWalletAmount = json["receive_money_wallet_amount"];
    amountId = json["amount_id"];
    cashback = json["cashback"];
    paymentType = json["payment_type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data["transaction_id"] = transactionId;
    data["secret_id"] = secretId;
    data["timestamp"] = timestamp;
    data["amount"] = amount;
    data["currency"] = currency;
    data["status"] = status;
    data["remarks"] = remarks;
    data["receipt"] = receipt;
    data["account_number"] = accountNumber;
    data["product_id"] = productId;
    data["product_name"] = productName;
    data["product_image"] = productImage;
    data["main_wallet_amount"] = mainWalletAmount;
    data["cashback_wallet_amount"] = cashbackWalletAmount;
    data["todays_referral_earning_wallet_amount"] =
        todaysReferralEarningWalletAmount;
    data["receive_money_wallet_amount"] = receiveMoneyWalletAmount;
    data["amount_id"] = amountId;
    data["cashback"] = cashback;
    data["payment_type"] = paymentType;
    return data;
  }
}
