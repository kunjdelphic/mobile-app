class MyLevelReferralUsers {
  MyLevelReferralUsers({
     this.status,
     this.message,
     this.data,
  });
    int? status;
    String? message;
    List<Data>? data;

  MyLevelReferralUsers.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.name,
    required this.email,
    required this.joiningTimestamp,
    required this.profileImage,
    required this.earning,
  });
   String? name;
   String? email;
   String? joiningTimestamp;
   String? profileImage;
   var earning;

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    joiningTimestamp = json['joining_timestamp'];
    profileImage = json['profile_image'];
    earning = json['earning'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['joining_timestamp'] = joiningTimestamp;
    _data['profile_image'] = profileImage;
    _data['earning'] = earning;
    return _data;
  }
}
