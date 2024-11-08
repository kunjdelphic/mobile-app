// class UserProfile {
//   int? status;
//   String? message;
//   Data? data;

//   UserProfile({this.status, this.message, this.data});

//   UserProfile.fromJson(Map<String, dynamic> json) {
//     status = json["status"];
//     message = json["message"];
//     data = json["data"] == null ? null : Data.fromJson(json["data"]);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["status"] = status;
//     data["message"] = message;
//     if (this.data != null) data["data"] = this.data?.toJson();
//     return data;
//   }
// }

// class Data {
//   String? phoneNumber;
//   String? countryCode;
//   bool? phoneVerified;
//   String? name;
//   String? email;
//   bool? emailVerified;
//   bool? emailVerifiedTime;
//   String? joiningTimestamp;
//   String? accountStatus;
//   String? accountStatusUpdateTime;
//   String? referralCode;
//   bool? mainWalletActivated;
//   int? mainWalletAmount;
//   bool? earningWalletActivated;
//   int? earningWalletAmount;
//   List<Promotion>? promotion;
//   List<dynamic>? extraGuide;

//   Data(
//       {this.phoneNumber,
//       this.countryCode,
//       this.phoneVerified,
//       this.name,
//       this.email,
//       this.emailVerified,
//       this.emailVerifiedTime,
//       this.joiningTimestamp,
//       this.accountStatus,
//       this.accountStatusUpdateTime,
//       this.referralCode,
//       this.mainWalletActivated,
//       this.mainWalletAmount,
//       this.earningWalletActivated,
//       this.earningWalletAmount,
//       this.promotion,
//       this.extraGuide});

//   Data.fromJson(Map<String, dynamic> json) {
//     phoneNumber = json["phone_number"];
//     countryCode = json["country_code"];
//     phoneVerified = json["phone_verified"];
//     name = json["name"];
//     email = json["email"];
//     emailVerified = json["email_verified"];
//     emailVerifiedTime = json["email_verified_time"];
//     joiningTimestamp = json["joining_timestamp"];
//     accountStatus = json["account_status"];
//     accountStatusUpdateTime = json["account_status_update_time"];
//     referralCode = json["referral_code"];
//     mainWalletActivated = json["main_wallet_activated"];
//     mainWalletAmount = json["main_wallet_amount"];
//     earningWalletActivated = json["earning_wallet_activated"];
//     earningWalletAmount = json["earning_wallet_amount"];
//     promotion = json["promotion"] == null
//         ? null
//         : (json["promotion"] as List)
//             .map((e) => Promotion.fromJson(e))
//             .toList();
//     extraGuide = json["extra_guide"] ?? [];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data["phone_number"] = phoneNumber;
//     data["country_code"] = countryCode;
//     data["phone_verified"] = phoneVerified;
//     data["name"] = name;
//     data["email"] = email;
//     data["email_verified"] = emailVerified;
//     data["email_verified_time"] = emailVerifiedTime;
//     data["joining_timestamp"] = joiningTimestamp;
//     data["account_status"] = accountStatus;
//     data["account_status_update_time"] = accountStatusUpdateTime;
//     data["referral_code"] = referralCode;
//     data["main_wallet_activated"] = mainWalletActivated;
//     data["main_wallet_amount"] = mainWalletAmount;
//     data["earning_wallet_activated"] = earningWalletActivated;
//     data["earning_wallet_amount"] = earningWalletAmount;
//     if (promotion != null) {
//       data["promotion"] = promotion?.map((e) => e.toJson()).toList();
//     }
//     if (extraGuide != null) data["extra_guide"] = extraGuide;
//     return data;
//   }
// }

// class Promotion {
//   String? id;
//   String? name;
//   String? description;

//   String? image;

//   Promotion({this.id, this.name, this.description, this.image});

//   Promotion.fromJson(Map<String, dynamic> json) {
//     name = json["name"];
//     description = json["description"];
//     id = json["_id"];
//     image = json["image"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};

//     data["name"] = name;
//     data["description"] = description;
//     data["id"] = id;
//     data["image"] = image;
//     return data;
//   }
// }

// class UserProfile {
//   UserProfile({
//     this.status,
//     this.message,
//     this.data,
//   });
//    int?? status;
//    String?? message;
//    Data?? data;

//   UserProfile.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = Data.fromJson(json['data']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['status'] = status;
//     _data['message'] = message;
//     _data['data'] = data!.toJson();
//     return _data;
//   }
// }

// class Data {
//   Data({
//     required this.name,
//     required this.profileImage,
//     required this.mainWalletBalance,
//     required this.currency,
//     required this.extraGuides,
//     required this.promotions,
//   });
//    String? name;
//    String? profileImage;
//    int? mainWalletBalance;
//    String? currency;
//    List?<dynamic> extraGuides;
//    List?<Promotions> promotions;

//   Data.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     profileImage = json['profile_image'];
//     mainWalletBalance = json['main_wallet_balance'];
//     currency = json['currency'];
//     extraGuides = List.castFrom<dynamic, dynamic>(json['extra_guides']);
//     promotions = List.from(json['promotions'])
//         .map((e) => Promotions.fromJson(e))
//         .toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['name'] = name;
//     _data['profile_image'] = profileImage;
//     _data['main_wallet_balance'] = mainWalletBalance;
//     _data['currency'] = currency;
//     _data['extra_guides'] = extraGuides;
//     _data['promotions'] = promotions.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class versionModel {
/*
{
  "status": 200,
  "message": "Success",
  "data": "1.0.1"
}
*/

  int? status;
  String? message;
  String? data;

  versionModel({
    this.status,
    this.message,
    this.data,
  });
  versionModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    data = json['data']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}

class UserProfile {
  UserProfile({
    this.status,
    this.message,
    this.data,
  });
  int? status;
  String? message;
  Data? data;

  UserProfile.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? joiningTimestamp;
  String? countryCode;
  String? phoneNumber;
  String? email;
  bool? phoneVerified;
  bool? selfie;
  bool? idPhoto;
  bool? emailVerified;
  bool? referredByState;
  String? emailVerifiedTime;
  String? referralCode;
  String? qrCode;
  String? accountStatus;
  String? accountStatusUpdateTime;
  String? profileImage;
  dynamic mainWalletBalance;
  String? currency;
  dynamic todaysReferralEarningWalletBalance;
  dynamic receiveMoneyWalletBalance;
  List<ExtraGuides>? extraGuides;
  List<Promotions>? promotions;

  Data({
    required this.name,
    required this.joiningTimestamp,
    required this.countryCode,
    required this.phoneNumber,
    required this.email,
    required this.phoneVerified,
    required this.idPhoto,
    required this.selfie,
    required this.emailVerified,
    required this.emailVerifiedTime,
    required this.referralCode,
    required this.qrCode,
    required this.accountStatus,
    required this.accountStatusUpdateTime,
    required this.profileImage,
    required this.mainWalletBalance,
    required this.currency,
    required this.todaysReferralEarningWalletBalance,
    required this.receiveMoneyWalletBalance,
    required this.extraGuides,
    required this.promotions,
    required this.referredByState,
  });

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    joiningTimestamp = json['joining_timestamp'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    phoneVerified = json['phone_verified'];
    selfie = json['selfie'];
    idPhoto = json['id_photo'];
    emailVerified = json['email_verified'];
    emailVerifiedTime = json['email_verified_time'];
    referralCode = json['referral_code'];
    qrCode = json['qr_code'];
    accountStatus = json['account_status'];
    accountStatusUpdateTime = json['account_status_update_time'];
    profileImage = json['profile_image'] ?? '';
    mainWalletBalance = json['main_wallet_balance'];
    currency = json['currency'];
    referredByState = json['referred_by_state'];
    todaysReferralEarningWalletBalance = json['todays_referral_earning_wallet_balance'];
    receiveMoneyWalletBalance = json['receive_money_wallet_balance'];
    // extraGuides = List.castFrom<dynamic, dynamic>(json['extra_guides']);
    // promotions = List.castFrom<dynamic, dynamic>(json['promotions']);
    // promotions = json["promotions"] == null
    //     ? null
    //     : (json["promotions"] as List)
    //         .map((e) => Promotions.fromJson(e))
    //         .toList();
    // extraGuides = json["extra_guides"] ?? [];
    extraGuides = List.from(json['extra_guides']).map((e) => ExtraGuides.fromJson(e)).toList();
    promotions = List.from(json['promotions']).map((e) => Promotions.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['joining_timestamp'] = joiningTimestamp;
    _data['country_code'] = countryCode;
    _data['phone_number'] = phoneNumber;
    _data['email'] = email;
    _data['phone_verified'] = phoneVerified;
    _data['email_verified'] = emailVerified;
    _data['email_verified_time'] = emailVerifiedTime;
    _data['referral_code'] = referralCode;
    _data['qr_code'] = qrCode;
    _data['account_status'] = accountStatus;
    _data['referred_by_state'] = referredByState;
    _data['account_status_update_time'] = accountStatusUpdateTime;
    _data['profile_image'] = profileImage;
    _data['main_wallet_balance'] = mainWalletBalance;
    _data['currency'] = currency;
    _data['todays_referral_earning_wallet_balance'] = todaysReferralEarningWalletBalance;
    _data['receive_money_wallet_balance'] = receiveMoneyWalletBalance;
    _data['extra_guides'] = extraGuides!.map((e) => e.toJson()).toList();
    _data['promotions'] = promotions!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ExtraGuides {
  ExtraGuides({
    required this.id,
    required this.heading,
    required this.description,
    required this.content,
    required this.image,
  });
  String? id;
  String? heading;
  String? description;
  String? content;
  String? image;

  ExtraGuides.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    heading = json['heading'];
    description = json['description'];
    content = json['content'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['heading'] = heading;
    _data['description'] = description;
    _data['content'] = content;
    _data['image'] = image;
    return _data;
  }
}

class Promotions {
  Promotions({
    // required this.id,
    required this.name,
    required this.timestamp,
    required this.description,
    required this.image,
  });
  //  String? id;
  String? name;
  String? timestamp;
  String? description;
  String? image;

  Promotions.fromJson(Map<String, dynamic> json) {
    // id = json['_id'];
    name = json['name'];
    timestamp = json['timestamp'];
    description = json['description'];

    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    // _data['_id'] = id;
    _data['name'] = name;
    _data['timestamp'] = timestamp;
    _data['description'] = description;

    _data['image'] = image;
    return _data;
  }
}
