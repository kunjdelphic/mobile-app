class SendMoneyRecentList {
  SendMoneyRecentList({
    this.status,
    this.message,
    this.data,
  });
  int? status;
  String? message;
  List<SendMoneyRecentListData>? data;

  SendMoneyRecentList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data'])
        .map((e) => SendMoneyRecentListData.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SendMoneyRecentListData {
  SendMoneyRecentListData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.currency,
    required this.timestamp,
    required this.amount,
    required this.order,
    required this.profileImage,
  });
  String? name;
  String? email;
  String? phoneNumber;
  String? countryCode;
  String? currency;
  String? timestamp;
  dynamic amount;
  dynamic order;
  String? profileImage;

  SendMoneyRecentListData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    countryCode = json['country_code'];
    currency = json['currency'];
    timestamp = json['timestamp'];
    amount = json['amount'];
    order = json['order'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['phone_number'] = phoneNumber;
    _data['country_code'] = countryCode;
    _data['currency'] = currency;
    _data['timestamp'] = timestamp;
    _data['amount'] = amount;
    _data['order'] = order;
    _data['profile_image'] = profileImage;
    return _data;
  }
}
