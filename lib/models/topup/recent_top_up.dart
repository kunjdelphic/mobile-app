class RecentTopUp {
  int? status;
  String? message;
  List<RecentTopUpData>? data;

  RecentTopUp({this.status, this.message, this.data});

  RecentTopUp.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["records"] == null
        ? null
        : (json["records"] as List)
            .map((e) => RecentTopUpData.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (this.data != null) {
      data["records"] = this.data?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class RecentTopUpData {
  dynamic transactionId;
  dynamic secretId;
  dynamic timestamp;
  dynamic amount;
  dynamic currency;
  dynamic status;
  dynamic remarks;
  dynamic transType;
  dynamic type;
  dynamic receipt;
  dynamic mainWalletAmount;
  dynamic cashbackWalletAmount;
  dynamic todaysReferralEarningWalletAmount;
  dynamic receiveMoneyWalletAmount;
  dynamic adminReport;
  Others? others;

  RecentTopUpData(
      {this.transactionId,
      this.secretId,
      this.timestamp,
      this.amount,
      this.currency,
      this.status,
      this.remarks,
      this.transType,
      this.type,
      this.receipt,
      this.mainWalletAmount,
      this.cashbackWalletAmount,
      this.todaysReferralEarningWalletAmount,
      this.receiveMoneyWalletAmount,
      this.adminReport,
      this.others});

  RecentTopUpData.fromJson(Map<String, dynamic> json) {
    transactionId = json["transaction_id"];
    secretId = json["secret_id"];
    timestamp = json["timestamp"];
    amount = json["amount"];
    currency = json["currency"];
    status = json["status"];
    remarks = json["remarks"];
    transType = json["trans_type"];
    type = json["type"];
    receipt = json["receipt"];
    mainWalletAmount = json["main_wallet_amount"];
    cashbackWalletAmount = json["cashback_wallet_amount"];
    todaysReferralEarningWalletAmount =
        json["todays_referral_earning_wallet_amount"];
    receiveMoneyWalletAmount = json["receive_money_wallet_amount"];
    adminReport = json["admin_report"];
    others = json["others"] == null ? null : Others.fromJson(json["others"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["transaction_id"] = transactionId;
    data["secret_id"] = secretId;
    data["timestamp"] = timestamp;
    data["amount"] = amount;
    data["currency"] = currency;
    data["status"] = status;
    data["remarks"] = remarks;
    data["trans_type"] = transType;
    data["type"] = type;
    data["receipt"] = receipt;
    data["main_wallet_amount"] = mainWalletAmount;
    data["cashback_wallet_amount"] = cashbackWalletAmount;
    data["todays_referral_earning_wallet_amount"] =
        todaysReferralEarningWalletAmount;
    data["receive_money_wallet_amount"] = receiveMoneyWalletAmount;
    data["admin_report"] = adminReport;
    if (others != null) {
      data["others"] = others?.toJson();
    }
    return data;
  }
}

class Others {
  dynamic accountNumber;
  dynamic amountId;
  dynamic serviceProviderId;
  dynamic productId;
  dynamic productName;
  dynamic productLogo;
  dynamic paymentType;
  dynamic serviceProviderTransactionId;
  dynamic serviceProviderProductId;
  dynamic totalProfit;
  dynamic parrotposProfit;
  dynamic cashbackAmount;
  dynamic level1ReferralAmount;
  dynamic level2ReferralAmount;
  dynamic level3ReferralAmount;
  dynamic level4ReferralAmount;
  dynamic level5ReferralAmount;
  dynamic donationAmount;
  dynamic nickName;

  Others(
      {this.accountNumber,
      this.amountId,
      this.serviceProviderId,
      this.productId,
      this.productName,
      this.productLogo,
      this.paymentType,
      this.serviceProviderTransactionId,
      this.serviceProviderProductId,
      this.totalProfit,
      this.parrotposProfit,
      this.cashbackAmount,
      this.level1ReferralAmount,
      this.level2ReferralAmount,
      this.level3ReferralAmount,
      this.level4ReferralAmount,
      this.level5ReferralAmount,
      this.donationAmount,
      this.nickName});

  Others.fromJson(Map<String, dynamic> json) {
    accountNumber = json["account_number"];
    amountId = json["amount_id"];
    serviceProviderId = json["service_provider_id"];
    productId = json["product_id"];
    productName = json["product_name"];
    productLogo = json["product_logo"];
    paymentType = json["payment_type"];
    serviceProviderTransactionId = json["service_provider_transaction_id"];
    serviceProviderProductId = json["service_provider_product_id"];
    totalProfit = json["total_profit"];
    parrotposProfit = json["parrotpos_profit"];
    cashbackAmount = json["cashback_amount"];
    level1ReferralAmount = json["level_1_referral_amount"];
    level2ReferralAmount = json["level_2_referral_amount"];
    level3ReferralAmount = json["level_3_referral_amount"];
    level4ReferralAmount = json["level_4_referral_amount"];
    level5ReferralAmount = json["level_5_referral_amount"];
    donationAmount = json["donation_amount"];
    nickName = json["nick_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["account_number"] = accountNumber;
    data["amount_id"] = amountId;
    data["service_provider_id"] = serviceProviderId;
    data["product_id"] = productId;
    data["product_name"] = productName;
    data["product_logo"] = productLogo;
    data["payment_type"] = paymentType;
    data["service_provider_transaction_id"] = serviceProviderTransactionId;
    data["service_provider_product_id"] = serviceProviderProductId;
    data["total_profit"] = totalProfit;
    data["parrotpos_profit"] = parrotposProfit;
    data["cashback_amount"] = cashbackAmount;
    data["level_1_referral_amount"] = level1ReferralAmount;
    data["level_2_referral_amount"] = level2ReferralAmount;
    data["level_3_referral_amount"] = level3ReferralAmount;
    data["level_4_referral_amount"] = level4ReferralAmount;
    data["level_5_referral_amount"] = level5ReferralAmount;
    data["donation_amount"] = donationAmount;
    data["nick_name"] = nickName;
    return data;
  }
}
