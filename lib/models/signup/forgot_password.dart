class ForgotPassword {
  late int status;
  late String message;
  // late String otp;
  late String sessionId;

  ForgotPassword({
    required this.message,
    required this.status,
    // required this.otp,
    required this.sessionId,
  });

  ForgotPassword.fromMap(Map<String, dynamic> map) {
    message = map["message"] ?? '';
    status = map["status"];
    sessionId = map["session_id"] ?? '';
    // otp = map["otp"] ?? '';
  }
}
