class EarningWallet {
  int? status;
  String? message;
  EarningWalletData? data;

  EarningWallet({this.status, this.message, this.data});

  EarningWallet.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data =
        json["data"] == null ? null : EarningWalletData.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    if (this.data != null) {
      data["data"] = this.data?.toJson();
    }
    return data;
  }
}

class EarningWalletData {
  var earningWalletAmount;
  var totalCashbackAndReferralEarning;
  var totalMoneyReceived;
  var transferableAmountToMainWallet;
  var level1Referrals;

  EarningWalletData({
    this.earningWalletAmount,
    this.totalCashbackAndReferralEarning,
    this.totalMoneyReceived,
    this.transferableAmountToMainWallet,
    this.level1Referrals,
  });

  EarningWalletData.fromJson(Map<String, dynamic> json) {
    earningWalletAmount = json["earning_wallet_amount"];
    totalCashbackAndReferralEarning =
        json["total_cashback_and_referral_earning"];
    totalMoneyReceived = json["total_money_received"];
    transferableAmountToMainWallet = json["transferable_amount_to_main_wallet"];
    level1Referrals = json["level_1_referrals"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["earning_wallet_amount"] = earningWalletAmount;
    data["total_cashback_and_referral_earning"] =
        totalCashbackAndReferralEarning;
    data["total_money_received"] = totalMoneyReceived;
    data["transferable_amount_to_main_wallet"] = transferableAmountToMainWallet;
    data["level1Referrals"] = level1Referrals;

    return data;
  }
}
