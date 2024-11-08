class PrivacyPolicy {
  PrivacyPolicy({
    this.status,
    this.message,
    this.content,
  });
  int? status;
  String? message;
  String? content;

  PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['content'] = content;
    return _data;
  }
}
