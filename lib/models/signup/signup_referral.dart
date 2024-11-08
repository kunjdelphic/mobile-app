class SignupReferral {
  late String name;
  late String email;
  late String profileImage;
  late String message;

  SignupReferral({
    required this.email,
    required this.name,
    required this.profileImage,
    required this.message,
  });

  SignupReferral.fromMap(Map<String, dynamic> map) {
    email = map["email"];
    name = map["name"];
    message = map["message"] ?? '';
    profileImage = map["profile_image"];
  }
}
