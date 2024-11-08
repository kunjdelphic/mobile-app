class TodaysReferralEarnings {
  int? status;
  String? message;
  TodaysReferralEarningsData? data;

  TodaysReferralEarnings({this.status, this.message, this.data});

  TodaysReferralEarnings.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null
        ? null
        : TodaysReferralEarningsData.fromJson(json["data"]);
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

class TodaysReferralEarningsData {
  var todaysReferralEarningWalletAmount;
  var totalReferrals;
  LevelWise? levelWise;

  TodaysReferralEarningsData(
      {this.todaysReferralEarningWalletAmount,
      this.totalReferrals,
      this.levelWise});

  TodaysReferralEarningsData.fromJson(Map<String, dynamic> json) {
    todaysReferralEarningWalletAmount =
        json["todays_referral_earning_wallet_amount"];
    totalReferrals = json["total_referrals"];
    levelWise = json["level_wise"] == null
        ? null
        : LevelWise.fromJson(json["level_wise"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["todays_referral_earning_wallet_amount"] =
        todaysReferralEarningWalletAmount;
    data["total_referrals"] = totalReferrals;
    if (levelWise != null) {
      data["level_wise"] = levelWise?.toJson();
    }
    return data;
  }
}

class LevelWise {
  Level1? level1;
  Level2? level2;
  Level3? level3;
  Level4? level4;
  Level5? level5;

  LevelWise({this.level1, this.level2, this.level3, this.level4, this.level5});

  LevelWise.fromJson(Map<String, dynamic> json) {
    level1 = json["level_1"] == null ? null : Level1.fromJson(json["level_1"]);
    level2 = json["level_2"] == null ? null : Level2.fromJson(json["level_2"]);
    level3 = json["level_3"] == null ? null : Level3.fromJson(json["level_3"]);
    level4 = json["level_4"] == null ? null : Level4.fromJson(json["level_4"]);
    level5 = json["level_5"] == null ? null : Level5.fromJson(json["level_5"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (level1 != null) {
      data["level_1"] = level1?.toJson();
    }
    if (level2 != null) {
      data["level_2"] = level2?.toJson();
    }
    if (level3 != null) {
      data["level_3"] = level3?.toJson();
    }
    if (level4 != null) {
      data["level_4"] = level4?.toJson();
    }
    if (level5 != null) {
      data["level_5"] = level5?.toJson();
    }
    return data;
  }
}

class Level1 {
  var total;
  List<Transactions>? transactions;

  Level1({this.total, this.transactions});

  Level1.fromJson(Map<String, dynamic> json) {
    total = json["total"];
    transactions = json["transactions"] == null
        ? null
        : (json["transactions"] as List)
            .map((e) => Transactions.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["total"] = total;
    if (transactions != null) {
      data["transactions"] = transactions?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Level2 {
  var total;
  List<Transactions>? transactions;

  Level2({this.total, this.transactions});

  Level2.fromJson(Map<String, dynamic> json) {
    total = json["total"];
    transactions = json["transactions"] == null
        ? null
        : (json["transactions"] as List)
            .map((e) => Transactions.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["total"] = total;
    if (transactions != null) {
      data["transactions"] = transactions?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Level3 {
  var total;
  List<Transactions>? transactions;

  Level3({this.total, this.transactions});

  Level3.fromJson(Map<String, dynamic> json) {
    total = json["total"];
    transactions = json["transactions"] == null
        ? null
        : (json["transactions"] as List)
            .map((e) => Transactions.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["total"] = total;
    if (transactions != null) {
      data["transactions"] = transactions?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Level4 {
  var total;
  List<Transactions>? transactions;

  Level4({this.total, this.transactions});

  Level4.fromJson(Map<String, dynamic> json) {
    total = json["total"];
    transactions = json["transactions"] == null
        ? null
        : (json["transactions"] as List)
            .map((e) => Transactions.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["total"] = total;
    if (transactions != null) {
      data["transactions"] = transactions?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Level5 {
  var total;
  List<Transactions>? transactions;

  Level5({this.total, this.transactions});

  Level5.fromJson(Map<String, dynamic> json) {
    total = json["total"];
    transactions = json["transactions"] == null
        ? null
        : (json["transactions"] as List)
            .map((e) => Transactions.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["total"] = total;
    if (transactions != null) {
      data["transactions"] = transactions?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? transactionId;
  String? transType;
  var amount;
  String? timestamp;
  String? productId;
  String? productName;
  String? name;
  dynamic profileImage;

  Transactions(
      {this.transactionId,
      this.transType,
      this.amount,
      this.timestamp,
      this.productId,
      this.productName,
      this.name,
      this.profileImage});

  Transactions.fromJson(Map<String, dynamic> json) {
    transactionId = json["transaction_id"];
    transType = json["trans_type"];
    amount = json["amount"];
    timestamp = json["timestamp"];
    productId = json["product_id"];
    productName = json["product_name"];
    name = json["name"];
    profileImage = json["profile_image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["transaction_id"] = transactionId;
    data["trans_type"] = transType;
    data["amount"] = amount;
    data["timestamp"] = timestamp;
    data["product_id"] = productId;
    data["product_name"] = productName;
    data["name"] = name;
    data["profile_image"] = profileImage;
    return data;
  }
}
