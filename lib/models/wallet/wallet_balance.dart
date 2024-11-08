import 'dart:core';

class WalletBalance {
  WalletBalance({
    this.status,
    this.message,
    this.data,
  });
  int? status;
  String? message;
  WalletBalanceData? data;

  WalletBalance.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = WalletBalanceData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data!.toJson();
    return _data;
  }
}

class WalletBalanceData {
  WalletBalanceData({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.accountStatus,
    required this.joiningTimestamp,
    required this.mainWalletAmount,
    required this.phoneVerified,
    required this.referralCode,
    required this.transactions,
  });
  String? name;
  String? email;
  String? profileImage;
  String? accountStatus;
  String? joiningTimestamp;
  var mainWalletAmount;
  bool? phoneVerified;
  String? referralCode;
  List<WalletTransaction>? transactions;

  WalletBalanceData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
    accountStatus = json['account_status'];
    joiningTimestamp = json['joining_timestamp'];
    mainWalletAmount = json['main_wallet_amount'];
    phoneVerified = json['phone_verified'];
    referralCode = json['referral_code'];
    transactions = List.from(json['transactions'])
        .map((e) => WalletTransaction.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['profile_image'] = profileImage;
    _data['account_status'] = accountStatus;
    _data['joining_timestamp'] = joiningTimestamp;
    _data['main_wallet_amount'] = mainWalletAmount;
    _data['phone_verified'] = phoneVerified;
    _data['referral_code'] = referralCode;
    _data['transactions'] = transactions!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class WalletTransaction {
  WalletTransaction({
    required this.transactionId,
    required this.secretId,
    required this.timestamp,
    required this.amount,
    required this.currency,
    required this.status,
    required this.remarks,
    required this.transType,
    required this.type,
    required this.receipt,
    required this.adminReport,
    required this.others,
  });
  String? transactionId;
  String? secretId;
  String? timestamp;
  var amount;
  String? currency;
  String? status;
  String? remarks;
  String? transType;
  String? type;
  var receipt;
  bool? adminReport;
  Others? others;

  WalletTransaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    secretId = json['secret_id'];
    timestamp = json['timestamp'];
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
    remarks = json['remarks'];
    transType = json['trans_type'];
    type = json['type'];
    receipt = json['receipt'];
    adminReport = json['admin_report'];
    others = Others.fromJson(json['others']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['transaction_id'] = transactionId;
    _data['secret_id'] = secretId;
    _data['timestamp'] = timestamp;
    _data['amount'] = amount;
    _data['currency'] = currency;
    _data['status'] = status;
    _data['remarks'] = remarks;
    _data['trans_type'] = transType;
    _data['type'] = type;
    _data['receipt'] = receipt;
    _data['admin_report'] = adminReport;
    _data['others'] = others!.toJson();
    return _data;
  }
}

class Others {
  Others({
    required this.fpxBankId,
    required this.fpxBankName,
    required this.logo,
    required this.bgColor,
    required this.fontColor,
    required this.order,
    required this.country,
    required this.currency,
    required this.helpText,
    required this.mainWalletAmount,
    required this.cashbackWalletAmount,
    required this.todaysReferralEarningWalletAmount,
    required this.receiveMoneyWalletAmount,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.negativeWalletCharge,
    required this.reloadFee,
    required this.serviceProviderTransactionFee,
  });
  String? fpxBankId;
  String? fpxBankName;
  String? logo;
  String? bgColor;
  String? fontColor;
  var order;
  String? country;
  String? currency;
  String? helpText;
  var mainWalletAmount;
  var cashbackWalletAmount;
  var todaysReferralEarningWalletAmount;
  var receiveMoneyWalletAmount;
  String? name;
  String? email;
  String? phoneNumber;
  String? countryCode;
  var negativeWalletCharge;
  var reloadFee;
  var serviceProviderTransactionFee;

  Others.fromJson(Map<String, dynamic> json) {
    fpxBankId = json['fpx_bank_id'];
    fpxBankName = json['fpx_bank_name'];
    logo = json['logo'];
    bgColor = json['bg_color'];
    fontColor = json['font_color'];
    order = json['order'];
    country = json['country'];
    currency = json['currency'];
    helpText = json['help_text'];
    mainWalletAmount = json['main_wallet_amount'];
    cashbackWalletAmount = json['cashback_wallet_amount'];
    todaysReferralEarningWalletAmount =
        json['todays_referral_earning_wallet_amount'];
    receiveMoneyWalletAmount = json['receive_money_wallet_amount'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    countryCode = json['country_code'];
    negativeWalletCharge = json['negative_wallet_charge'];
    reloadFee = json['reload_fee'];
    serviceProviderTransactionFee = json['service_provider_transaction_fee'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fpx_bank_id'] = fpxBankId;
    _data['fpx_bank_name'] = fpxBankName;
    _data['logo'] = logo;
    _data['bg_color'] = bgColor;
    _data['font_color'] = fontColor;
    _data['order'] = order;
    _data['country'] = country;
    _data['currency'] = currency;
    _data['help_text'] = helpText;
    _data['main_wallet_amount'] = mainWalletAmount;
    _data['cashback_wallet_amount'] = cashbackWalletAmount;
    _data['todays_referral_earning_wallet_amount'] =
        todaysReferralEarningWalletAmount;
    _data['receive_money_wallet_amount'] = receiveMoneyWalletAmount;
    _data['name'] = name;
    _data['email'] = email;
    _data['phone_number'] = phoneNumber;
    _data['country_code'] = countryCode;
    _data['negative_wallet_charge'] = negativeWalletCharge;
    _data['reload_fee'] = reloadFee;
    _data['service_provider_transaction_fee'] = serviceProviderTransactionFee;
    return _data;
  }
}
