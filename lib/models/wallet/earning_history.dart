class EarningHistory {
  int? status;
  String? message;
  List<EarningHistoryData>? data;

  
  EarningHistory({this.status, this.message, this.data});

  EarningHistory.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => EarningHistoryData.fromJson(e))
            .toList();
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

class EarningHistoryData {
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
  Others? others;

  EarningHistoryData(
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
      this.others});

  EarningHistoryData.fromJson(Map<String, dynamic> json) {
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
    if (others != null) {
      data["others"] = others?.toJson();
    }
    return data;
  }
}

class Others {
  dynamic senderSecretId;
  dynamic senderMainWalletAmount;
  dynamic senderCashbackWalletAmount;
  dynamic senderTodaysReferralEarningWalletAmount;
  dynamic senderReceiveMoneyWalletAmount;
  dynamic senderPhoneNumber;
  dynamic senderCountryCode;
  dynamic senderName;
  dynamic senderEmail;
  dynamic senderProfileImage;
  dynamic receiverPhoneNumber;
  dynamic receiverCountryCode;
  dynamic receiverName;
  dynamic receiverEmail;
  dynamic receiverProfileImage;
  dynamic deductFromReceiveMoneyWallet;
  dynamic deductFromCashbackWallet;
  dynamic deductFromTransactionFees;
  dynamic reason;
  dynamic accountNumber;
  dynamic amountId;
  dynamic serviceProviderId;
  dynamic productId;
  dynamic productName;
  dynamic productLogo;
  dynamic transactionAmount;
  dynamic paymentType;
  dynamic nickName;
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
  dynamic fpxBankId;
  dynamic bankName;
  dynamic bankLogo;
  dynamic bankBgColor;
  dynamic bankFontColor;
  dynamic serviceProviderFpxBankId;
  dynamic name;
  dynamic email;
  dynamic phoneNumber;
  dynamic countryCode;
  dynamic referralCount;
  dynamic totalDeduction;

  Others(
      {this.senderSecretId,
      this.senderMainWalletAmount,
      this.senderCashbackWalletAmount,
      this.senderTodaysReferralEarningWalletAmount,
      this.senderReceiveMoneyWalletAmount,
      this.senderPhoneNumber,
      this.senderCountryCode,
      this.senderName,
      this.senderEmail,
      this.senderProfileImage,
      this.receiverPhoneNumber,
      this.receiverCountryCode,
      this.receiverName,
      this.receiverEmail,
      this.receiverProfileImage,
      this.deductFromReceiveMoneyWallet,
      this.deductFromCashbackWallet,
      this.deductFromTransactionFees,
      this.reason,
      this.accountNumber,
      this.amountId,
      this.serviceProviderId,
      this.productId,
      this.productName,
      this.productLogo,
      this.transactionAmount,
      this.paymentType,
      this.nickName,
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
      this.fpxBankId,
      this.bankName,
      this.bankLogo,
      this.bankBgColor,
      this.bankFontColor,
      this.serviceProviderFpxBankId,
      this.name,
      this.email,
      this.phoneNumber,
      this.countryCode,
      this.referralCount});

  Others.fromJson(Map<String, dynamic> json) {
    senderSecretId = json["sender_secret_id"];
    senderMainWalletAmount = json["sender_main_wallet_amount"];
    senderCashbackWalletAmount = json["sender_cashback_wallet_amount"];
    senderTodaysReferralEarningWalletAmount =
        json["sender_todays_referral_earning_wallet_amount"];
    senderReceiveMoneyWalletAmount = json["sender_receive_money_wallet_amount"];
    senderPhoneNumber = json["sender_phone_number"];
    senderCountryCode = json["sender_country_code"];
    senderName = json["sender_name"];
    senderEmail = json["sender_email"];
    senderProfileImage = json["sender_profile_image"];
    receiverPhoneNumber = json["receiver_phone_number"];
    receiverCountryCode = json["receiver_country_code"];
    receiverName = json["receiver_name"];
    receiverEmail = json["receiver_email"];
    receiverProfileImage = json["receiver_profile_image"];
    deductFromReceiveMoneyWallet = json["deduct_from_receive_money_wallet"];
    deductFromCashbackWallet = json["deduct_from_cashback_wallet"];
    deductFromTransactionFees = json["deduct_from_transaction_fees"];
    reason = json["reason"];
    accountNumber = json["account_number"];
    amountId = json["amount_id"];
    serviceProviderId = json["service_provider_id"];
    productId = json["product_id"];
    productName = json["product_name"];
    productLogo = json["product_logo"];
    transactionAmount = json["transaction_amount"];
    paymentType = json["payment_type"];
    nickName = json["nick_name"];
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
    fpxBankId = json["fpx_bank_id"];
    bankName = json["bank_name"];
    bankLogo = json["bank_logo"];
    bankBgColor = json["bank_bg_color"];
    bankFontColor = json["bank_font_color"];
    serviceProviderFpxBankId = json["service_provider_fpx_bank_id"];
    name = json["name"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    countryCode = json["country_code"];
    referralCount = json["referral_count"];
    totalDeduction = json["total_deduction"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["sender_secret_id"] = senderSecretId;
    data["sender_main_wallet_amount"] = senderMainWalletAmount;
    data["sender_cashback_wallet_amount"] = senderCashbackWalletAmount;
    data["sender_todays_referral_earning_wallet_amount"] =
        senderTodaysReferralEarningWalletAmount;
    data["sender_receive_money_wallet_amount"] = senderReceiveMoneyWalletAmount;
    data["sender_phone_number"] = senderPhoneNumber;
    data["sender_country_code"] = senderCountryCode;
    data["sender_name"] = senderName;
    data["sender_email"] = senderEmail;
    data["sender_profile_image"] = senderProfileImage;
    data["receiver_phone_number"] = receiverPhoneNumber;
    data["receiver_country_code"] = receiverCountryCode;
    data["receiver_name"] = receiverName;
    data["receiver_email"] = receiverEmail;
    data["receiver_profile_image"] = receiverProfileImage;
    data["deduct_from_receive_money_wallet"] = deductFromReceiveMoneyWallet;
    data["deduct_from_cashback_wallet"] = deductFromCashbackWallet;
    data["deduct_from_transaction_fees"] = deductFromTransactionFees;
    data["reason"] = reason;
    data["account_number"] = accountNumber;
    data["amount_id"] = amountId;
    data["service_provider_id"] = serviceProviderId;
    data["product_id"] = productId;
    data["product_name"] = productName;
    data["product_logo"] = productLogo;
    data["transaction_amount"] = transactionAmount;
    data["payment_type"] = paymentType;
    data["nick_name"] = nickName;
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
    data["fpx_bank_id"] = fpxBankId;
    data["bank_name"] = bankName;
    data["bank_logo"] = bankLogo;
    data["bank_bg_color"] = bankBgColor;
    data["bank_font_color"] = bankFontColor;
    data["service_provider_fpx_bank_id"] = serviceProviderFpxBankId;
    data["name"] = name;
    data["email"] = email;
    data["phone_number"] = phoneNumber;
    data["country_code"] = countryCode;
    data["referral_count"] = referralCount;
    data["total_deduction"] = totalDeduction;

    return data;
  }
}
