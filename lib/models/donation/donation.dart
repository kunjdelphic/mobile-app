class Donation {
  int? status;
  String? message;
  Data? data;

  Donation({this.status, this.message, this.data});

  Donation.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
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

class Data {
  String? userTotalDonate;
  String? userTotalDonateCurrency;
  String? totalDonate;
  String? totalDonateCurrency;

  Data(
      {this.userTotalDonate,
      this.userTotalDonateCurrency,
      this.totalDonate,
      this.totalDonateCurrency});

  Data.fromJson(Map<String, dynamic> json) {
    userTotalDonate = json["user_total_donate"];
    userTotalDonateCurrency = json["user_total_donate_currency"];
    totalDonate = json["total_donate"];
    totalDonateCurrency = json["total_donate_currency"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["user_total_donate"] = userTotalDonate;
    data["user_total_donate_currency"] = userTotalDonateCurrency;
    data["total_donate"] = totalDonate;
    data["total_donate_currency"] = totalDonateCurrency;
    return data;
  }
}
