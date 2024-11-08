class MyReferral {
  MyReferral({
     this.status,
     this.message,
     this.data,
  });
  int? status;
  String? message;
  Data? data;

  MyReferral.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data!.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.referralEarning,
    required this.referralEarning_1,
    required this.referralEarning_2,
    required this.referralEarning_3,
    required this.referralEarning_4,
    required this.referralEarning_5,
    required this.referralCount,
    required this.referralCount_1,
    required this.referralCount_2,
    required this.referralCount_3,
    required this.referralCount_4,
    required this.referralCount_5,
  });
  var referralEarning;
  var referralEarning_1;
  var referralEarning_2;
  var referralEarning_3;
  var referralEarning_4;
  var referralEarning_5;
  var referralCount;
  var referralCount_1;
  var referralCount_2;
  var referralCount_3;
  var referralCount_4;
  var referralCount_5;

  Data.fromJson(Map<String, dynamic> json) {
    referralEarning = json['referral_earning'];
    referralEarning_1 = json['referral_earning_1'];
    referralEarning_2 = json['referral_earning_2'];
    referralEarning_3 = json['referral_earning_3'];
    referralEarning_4 = json['referral_earning_4'];
    referralEarning_5 = json['referral_earning_5'];
    referralCount = json['referral_count'];
    referralCount_1 = json['referral_count_1'];
    referralCount_2 = json['referral_count_2'];
    referralCount_3 = json['referral_count_3'];
    referralCount_4 = json['referral_count_4'];
    referralCount_5 = json['referral_count_5'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['referral_earning'] = referralEarning;
    _data['referral_earning_1'] = referralEarning_1;
    _data['referral_earning_2'] = referralEarning_2;
    _data['referral_earning_3'] = referralEarning_3;
    _data['referral_earning_4'] = referralEarning_4;
    _data['referral_earning_5'] = referralEarning_5;
    _data['referral_count'] = referralCount;
    _data['referral_count_1'] = referralCount_1;
    _data['referral_count_2'] = referralCount_2;
    _data['referral_count_3'] = referralCount_3;
    _data['referral_count_4'] = referralCount_4;
    _data['referral_count_5'] = referralCount_5;
    return _data;
  }
}
