// class GetReferralListModel {
//   dynamic status;
//   String message;
//   Data data;

//   GetReferralListModel({this.status, this.message, this.data});

//   GetReferralListModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   TodaysReferralEarning todaysReferralEarning;
//   LevelWise levelWise;

//   Data({this.todaysReferralEarning, this.levelWise});

//   Data.fromJson(Map<String, dynamic> json) {
//     todaysReferralEarning = json['todaysReferralEarning'] != null
//         ? new TodaysReferralEarning.fromJson(json['todaysReferralEarning'])
//         : null;
//     levelWise = json['levelWise'] != null
//         ? new LevelWise.fromJson(json['levelWise'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.todaysReferralEarning != null) {
//       data['todaysReferralEarning'] = this.todaysReferralEarning.toJson();
//     }
//     if (this.levelWise != null) {
//       data['levelWise'] = this.levelWise.toJson();
//     }
//     return data;
//   }
// }

// class TodaysReferralEarning {
//   String trxnId;
//   String fromId;
//   String toId;
//   String trxnTimestamp;
//   dynamic trxnAmount;
//   String trxnCurrency;
//   String trxnReason;
//   String trxnStatus;
//   String type;
//   dynamic numberOfReferrals;
//   String trxnType;
//   dynamic earningWalletAmount;
//   dynamic mainWalletAmount;

//   TodaysReferralEarning(
//       {this.trxnId,
//       this.fromId,
//       this.toId,
//       this.trxnTimestamp,
//       this.trxnAmount,
//       this.trxnCurrency,
//       this.trxnReason,
//       this.trxnStatus,
//       this.type,
//       this.numberOfReferrals,
//       this.trxnType,
//       this.earningWalletAmount,
//       this.mainWalletAmount});

//   TodaysReferralEarning.fromJson(Map<String, dynamic> json) {
//     trxnId = json['trxnId'];
//     fromId = json['fromId'];
//     toId = json['toId'];
//     trxnTimestamp = json['trxnTimestamp'];
//     trxnAmount = json['trxnAmount'];
//     trxnCurrency = json['trxnCurrency'];
//     trxnReason = json['trxnReason'];
//     trxnStatus = json['trxnStatus'];
//     type = json['type'];
//     numberOfReferrals = json['numberOfReferrals'];
//     trxnType = json['trxnType'];
//     earningWalletAmount = json['earning_wallet_amount'];
//     mainWalletAmount = json['main_wallet_amount'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['trxnId'] = this.trxnId;
//     data['fromId'] = this.fromId;
//     data['toId'] = this.toId;
//     data['trxnTimestamp'] = this.trxnTimestamp;
//     data['trxnAmount'] = this.trxnAmount;
//     data['trxnCurrency'] = this.trxnCurrency;
//     data['trxnReason'] = this.trxnReason;
//     data['trxnStatus'] = this.trxnStatus;
//     data['type'] = this.type;
//     data['numberOfReferrals'] = this.numberOfReferrals;
//     data['trxnType'] = this.trxnType;
//     data['earning_wallet_amount'] = this.earningWalletAmount;
//     data['main_wallet_amount'] = this.mainWalletAmount;
//     return data;
//   }
// }

// class LevelWise {
//   One one;
//   One two;
//   One three;
//   One four;
//   One five;

//   LevelWise({this.one, this.two, this.three, this.four, this.five});

//   LevelWise.fromJson(Map<String, dynamic> json) {
//     one = json['1'] != null ? new One.fromJson(json['1']) : null;
//     two = json['2'] != null ? new One.fromJson(json['2']) : null;
//     three = json['3'] != null ? new One.fromJson(json['3']) : null;
//     four = json['4'] != null ? new One.fromJson(json['4']) : null;
//     five = json['5'] != null ? new One.fromJson(json['5']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.one != null) {
//       data['1'] = this.one.toJson();
//     }
//     if (this.two != null) {
//       data['2'] = this.two.toJson();
//     }
//     if (this.three != null) {
//       data['3'] = this.three.toJson();
//     }
//     if (this.four != null) {
//       data['4'] = this.four.toJson();
//     }
//     if (this.five != null) {
//       data['5'] = this.five.toJson();
//     }
//     return data;
//   }
// }

// class One {
//   dynamic total;
//   List<Trans> trans;

//   One({this.total, this.trans});

//   One.fromJson(Map<String, dynamic> json) {
//     total = json['total'];
//     if (json['trans'] != null) {
//       trans = new List<Trans>();
//       json['trans'].forEach((v) {
//         trans.add(new Trans.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['total'] = this.total;
//     if (this.trans != null) {
//       data['trans'] = this.trans.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Trans {
//   String trxnId;
//   String fromId;
//   String toId;
//   String trxnTimestamp;
//   dynamic trxnAmount;
//   String trxnCurrency;
//   String trxnReason;
//   String trxnStatus;
//   dynamic trxnTypeCashback;
//   String type;
//   String trxnType;
//   dynamic fromEarningWalletAmount;
//   dynamic fromMainWalletAmount;
//   dynamic toEarningWalletAmount;
//   dynamic toMainWalletAmount;
//   Others others;

//   Trans(
//       {this.trxnId,
//       this.fromId,
//       this.toId,
//       this.trxnTimestamp,
//       this.trxnAmount,
//       this.trxnCurrency,
//       this.trxnReason,
//       this.trxnStatus,
//       this.trxnTypeCashback,
//       this.type,
//       this.trxnType,
//       this.fromEarningWalletAmount,
//       this.fromMainWalletAmount,
//       this.toEarningWalletAmount,
//       this.toMainWalletAmount,
//       this.others});

//   Trans.fromJson(Map<String, dynamic> json) {
//     trxnId = json['trxnId'];
//     fromId = json['fromId'];
//     toId = json['toId'];
//     trxnTimestamp = json['trxnTimestamp'];
//     trxnAmount = json['trxnAmount'];
//     trxnCurrency = json['trxnCurrency'];
//     trxnReason = json['trxnReason'];
//     trxnStatus = json['trxnStatus'];
//     trxnTypeCashback = json['trxnTypeCashback'];
//     type = json['type'];
//     trxnType = json['trxnType'];
//     fromEarningWalletAmount = json['from_earning_wallet_amount'];
//     fromMainWalletAmount = json['from_main_wallet_amount'];
//     toEarningWalletAmount = json['to_earning_wallet_amount'];
//     toMainWalletAmount = json['to_main_wallet_amount'];
//     others =
//         json['others'] != null ? new Others.fromJson(json['others']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['trxnId'] = this.trxnId;
//     data['fromId'] = this.fromId;
//     data['toId'] = this.toId;
//     data['trxnTimestamp'] = this.trxnTimestamp;
//     data['trxnAmount'] = this.trxnAmount;
//     data['trxnCurrency'] = this.trxnCurrency;
//     data['trxnReason'] = this.trxnReason;
//     data['trxnStatus'] = this.trxnStatus;
//     data['trxnTypeCashback'] = this.trxnTypeCashback;
//     data['type'] = this.type;
//     data['trxnType'] = this.trxnType;
//     data['from_earning_wallet_amount'] = this.fromEarningWalletAmount;
//     data['from_main_wallet_amount'] = this.fromMainWalletAmount;
//     data['to_earning_wallet_amount'] = this.toEarningWalletAmount;
//     data['to_main_wallet_amount'] = this.toMainWalletAmount;
//     if (this.others != null) {
//       data['others'] = this.others.toJson();
//     }
//     return data;
//   }
// }

// class Others {
//   String senderName;
//   String senderCountryCode;
//   String senderPhoneNumber;
//   String type;
//   String account;
//   String product;
//   String productImg;
//   String productName;
//   String serialNumberFromOperator;
//   String expiry;
//   String refid;
//   String reloadId;
//   String senderProfileImage;

//   Others(
//       {this.senderName,
//       this.senderCountryCode,
//       this.senderPhoneNumber,
//       this.type,
//       this.account,
//       this.product,
//       this.productImg,
//       this.productName,
//       this.serialNumberFromOperator,
//       this.expiry,
//       this.refid,
//       this.senderProfileImage,
//       this.reloadId});

//   Others.fromJson(Map<String, dynamic> json) {
//     senderName = json['senderName'];
//     senderCountryCode = json['senderCountryCode'];
//     senderPhoneNumber = json['senderPhoneNumber'];
//     type = json['type'];
//     account = json['account'];
//     product = json['product'];
//     productImg = json['productImg'];
//     productName = json['productName'];
//     serialNumberFromOperator = json['serialNumberFromOperator'];
//     expiry = json['expiry'];
//     refid = json['refid'];
//     reloadId = json['reloadId'];
//     senderProfileImage = json['senderProfileImage'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['senderName'] = this.senderName;
//     data['senderCountryCode'] = this.senderCountryCode;
//     data['senderPhoneNumber'] = this.senderPhoneNumber;
//     data['type'] = this.type;
//     data['account'] = this.account;
//     data['product'] = this.product;
//     data['productImg'] = this.productImg;
//     data['productName'] = this.productName;
//     data['serialNumberFromOperator'] = this.serialNumberFromOperator;
//     data['expiry'] = this.expiry;
//     data['refid'] = this.refid;
//     data['reloadId'] = this.reloadId;
//         data['senderProfileImage'] = this.senderProfileImage;
//     return data;
//   }
// }
