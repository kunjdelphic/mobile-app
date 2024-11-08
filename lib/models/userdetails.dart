// class UserData {
//   String token;
//   String phoneNumber;
//   String countryCode;
//   String name;
//   String email;
//   String profileImage;
//   String password;
//   String amountMainWallet;
//   String currencyMainWallet;
//   String referralCode;
//   String accountVerif;
//   bool phoneNumberVerif;
//   bool emaiflVerif;
//   bool stateMainWallet;
//   List promotions;
//   List extraGuide;
//   String reason;

//   UserData(
//       {this.token,
//       this.countryCode,
//       this.profileImage,
//       this.name,
//       this.email,
//       this.phoneNumber,
//       this.amountMainWallet,
//       this.currencyMainWallet,
//       this.referralCode,
//       this.password,
//       this.emaiflVerif,
//       this.phoneNumberVerif,
//       this.stateMainWallet,
//       this.accountVerif,
//       this.promotions,
//       this.extraGuide,
//       this.reason});

//   Map toMap(UserData user) {
//     var data = Map<String, dynamic>();
//     data['token'] = user.token;
//     data['countryCode'] = user.countryCode;
//     data['profileImage'] = user.profileImage;
//     data['name'] = user.name;
//     data['email'] = user.email;
//     data["phoneNumber"] = user.phoneNumber;
//     data["amountMainWallet"] = user.amountMainWallet;
//     data["currencyMainWallet"] = user.currencyMainWallet;
//     data["accountVerif"] = user.accountVerif;
//     data["referralCode"] = user.referralCode;
//     data["password"] = user.password;
//     data["emaiflVerif"] = user.emaiflVerif;
//     data["phoneNumberVerif"] = user.phoneNumberVerif;
//     data["stateMainWallet"] = user.stateMainWallet;
//     data["promotions"] = user.promotions;
//     data["extraGuide"] = user.extraGuide;
//     data["reason"] = user.reason;
//     return data;
//   }

//   // Named constructor
//   UserData.fromMap(Map<String, dynamic> mapData) {
//     this.token = mapData['token'];
//     this.countryCode = mapData['countryCode'];
//     this.profileImage = mapData['profileImage'];
//     this.name = mapData['name'];
//     this.email = mapData['email'];
//     this.phoneNumber = mapData['phoneNumber'];
//     this.amountMainWallet = mapData['amountMainWallet'];
//     this.currencyMainWallet = mapData['currencyMainWallet'];
//     this.accountVerif = mapData['accountVerif'];
//     this.referralCode = mapData['referralCode'];
//     this.password = mapData['password'];
//     this.emaiflVerif = mapData['emaiflVerif'];
//     this.phoneNumberVerif = mapData['phoneNumberVerif'];
//     this.stateMainWallet = mapData['stateMainWallet'];
//     this.promotions = mapData['promotions'];
//     this.extraGuide = mapData['extraGuide'];
//     this.reason = mapData['reason'];
//   }
// }
