import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart' as prefix;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_amounts.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_categories.dart';
import 'package:parrotpos/models/donation/donation.dart';
import 'package:parrotpos/models/favorite/all_favorites.dart';
import 'package:parrotpos/models/favorite/all_recurring.dart';
import 'package:parrotpos/models/favorite/favorite_categories.dart';

import 'package:parrotpos/models/favorite/outstanding_bill.dart';
import 'package:parrotpos/models/favorite/recurring.dart';
import 'package:parrotpos/models/referral/my_level_referral_users.dart';
import 'package:parrotpos/models/referral/my_referral.dart';

import 'package:parrotpos/models/referral/todays_referral_earnings.dart';
import 'package:parrotpos/models/topup/recent_top_up.dart';
import 'package:parrotpos/models/topup/top_up_amounts.dart';
import 'package:parrotpos/models/topup/top_up_products.dart';
import 'package:parrotpos/models/user_profile/privacy_policy.dart';
import 'package:parrotpos/models/user_profile/terms_and_conditions.dart';
import 'package:parrotpos/models/user_profile/user_profile.dart';
import 'package:parrotpos/models/wallet/bank_list.dart';
import 'package:parrotpos/models/wallet/day_referral_earning.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/models/wallet/earning_wallet.dart';
import 'package:parrotpos/models/wallet/main_wallet_reload.dart';
import 'package:parrotpos/models/wallet/product_transaction_history.dart';
import 'package:parrotpos/models/wallet/send_money_recent_list.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/models/wallet/transaction_history_filter_products.dart';
import 'package:parrotpos/models/wallet/wallet_balance.dart';
import 'package:http_parser/http_parser.dart';
import 'package:parrotpos/screens/main_home.dart';
import 'package:parrotpos/screens/notification/server_maintainance_screen.dart';
import 'package:parrotpos/screens/server_upgrade_screen.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../controllers/user_profile_controller.dart';
import '../screens/notification/model_notification.dart';
import '../screens/server_upgrade_custom_screen.dart';

///Development URL
// String baseUrl = "https://gateway.dev.parrotpos.com.my/";
//
///Production URL
String baseUrl = "https://gateway.dev.parrotpos.com.my/";

// production = https://gateway.parrotpos.com.my/
// development = https://gateway.dev.parrotpos.com.my/
String noAuth = "no-auth/";
String auth = "auth/";
String accounts = "accounts/";
String mainWalletReload = "main-wallet-reload/";
String wallet = "wallet/";
String userReports = "user-reports/";

class RemoteService {
  static late String accessId;

  static late UserProfile userProfile;
  static GetStorage getStorage = GetStorage();
  static var client = http.Client();

  static Map<String, String> header = {
    "Content-type": "application/json; charset=utf-8"
  };
  static Map<String, String> authHeader = {
    "Content-type": "application/json; charset=utf-8",
    "access_id": accessId,
  };

  static initiatizeAuthHeader() async {
    authHeader = {
      "Content-type": "application/json; charset=utf-8",
      "access_id": accessId,
    };
  }

  static checkServer() async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + noAuth + "login"),
        headers: header,
        body: jsonEncode({}),
      );
      print("------ STATUS CODE ---- ${res.statusCode}");
      // print(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }
      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
    } catch (e) {
      //  print("error 502 $e");
      // prefix.Get.to(const ServerUpgradeScreen());
    }
  }

  static Timer? timer;
  static checkServerFrequently() async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + noAuth + "login"),
        headers: header,
        body: jsonEncode({}),
      );
      // print("------ STATUS CODE ${res.statusCode}");
      // print(res.body);
      if (timer != null && res.statusCode == 200) {
        timer?.cancel();
      }
      if (res.statusCode == 200) {
        prefix.Get.off(const MainHome());
      }
    } catch (e) {
      //  print("error 502 $e");
      // prefix.Get.to(const ServerUpgradeScreen());
    }
  }

  static Future login(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + noAuth + "login"),
        headers: header,
        body: jsonEncode(map),
      );
      // print(map);
      // print(header);
      // print(baseUrl + accounts + noAuth + 'login');

      var response = jsonDecode(res.body);

      if (response["status"] == 200) {
        print(response["access_id"]);
        accessId = response["access_id"];
        RemoteService.initiatizeAuthHeader();

        getStorage.write('accessId', accessId);
        print("Usr accessId 999999999999 $accessId");
      }

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 503) {
        prefix.Get.to(() => const CustomServerUpgradeScreen());
        return {
          "status": 503,
          "message": "Server Maintenance In Progress!",
        };
      }

      return response;
    } catch (e) {
      //  prefix.Get.to(() => const CustomServerUpgradeScreen());
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future checkAlreadyThirdPartyRegisted(email) async {
    Response res = await client.post(
      Uri.parse(baseUrl + accounts + "no-auth/verify-auth-third-party"),
      headers: header,
      body: jsonEncode({"email": email}),
    );
    var response = jsonDecode(res.body);

    return response;
  }

  static Future thirdPartyLogin(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + "no-auth/auth-third-party"),
        headers: header,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (response["status"] == 200) {
        print("The acces id is" + response["access_id"]);
        accessId = response["access_id"];
        RemoteService.initiatizeAuthHeader();

        getStorage.write('accessId', accessId);
        print("Usr accessId /*/*/*/*/*/*/* $accessId");
        print("Response Data-----------------  $response");
      }

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 503) {
        prefix.Get.to(() => const CustomServerUpgradeScreen());
        return {
          "status": 503,
          "message": "Server Maintenance In Progress!",
        };
      }

      return response;
    } catch (e) {
      // print(e.toString());
      //  prefix.Get.to(() => const CustomServerUpgradeScreen());
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future updateNamePhone(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + auth + 'update-user-details'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      //  prefix.Get.to(() => const CustomServerUpgradeScreen());
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future updateNamePhoneIOS(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + auth + 'update-name-contact'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      //  prefix.Get.to(() => const CustomServerUpgradeScreen());
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future signUp(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + noAuth + "signup"),
        headers: header,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      //  prefix.Get.to(() => const CustomServerUpgradeScreen());
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future deleteAccount() async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + auth + "delete-account"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "access_id": accessId,
        },
        body: jsonEncode({}),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future signUpReferral(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + auth + "apply-referral-code"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "access_id": accessId,
        },
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future getReferralDetails(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + auth + "referral-details"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "access_id": accessId,
        },
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future emailVerification(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + noAuth + "email-verification"),
        headers: header,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (response["status"] == 200) {
        accessId = response["access_id"];
        RemoteService.initiatizeAuthHeader();

        getStorage.write('accessId', accessId);
        print("Usr accessId 88888888  $accessId");
      }

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future uploadProfileImage(map) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl + accounts + auth + "upload-profile-image"),
      );

      request.files.add(http.MultipartFile(
        'profile_image',
        map['image'].readAsBytes().asStream(),
        map['image'].lengthSync(),
        filename: map['image'].path,
        contentType: MediaType('image', 'jpeg'),
      ));

      request.headers.addAll({
        "Content-type": "application/x-www-form-urlencoded",
        "access_id": accessId,
      });

      http.StreamedResponse res = await request.send();

      var responseData = await http.Response.fromStream(res);

      var response = jsonDecode(responseData.body);

      if (responseData.statusCode == 200) {
        return response;
      } else {
        if (res.statusCode == 502) {
          prefix.Get.offAll(const ServerMaintenanceScreen());
        }

        return {
          "status": 400,
          "message": "Failed to upload profile image!",
        };
      }

      // Response res = await client.post(
      //   Uri.parse(baseUrl + accounts + auth + "upload-profile-image"),
      //   headers: {
      //     "Content-type": "application/json; charset=utf-8",
      //     "access_id": accessId,
      //   },
      //   body: jsonEncode(map),
      // );

      // var response = jsonDecode(res.body);

      // return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future forgotPassword(map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + noAuth + "reset-password"),
        headers: header,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future matchVersion() async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + noAuth + "fetch-latest-app-version"),
        headers: authHeader,
      );
      print("Response STATUS CODE  ++++++ ${res.statusCode}");
      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      print("Response version ++++++ ${response}");

      return response;
    } catch (e) {}
  }

  static Future verifyForgotPassword(map) async {
    try {
      Response res = await client.post(
        Uri.parse(
            baseUrl + accounts + noAuth + "otp-verification-reset-password"),
        headers: header,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to verify",
      };
    }
  }

  static Future<UserProfile> getUserDetails() async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + "user-reports/home-screen/details"),
        headers: authHeader,
      );

      print("res code ====== ${res.statusCode}");
      var response = jsonDecode(res.body);
      if (response['status'] == 401 ||
          response['message'] == 'Session Expired') {
        return UserProfile(
          status: 401,
          message: 'Session Expired!',
        );
      }

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 503) {
        prefix.Get.to(() => const CustomServerUpgradeScreen());
        return UserProfile(
          status: 503,
          message: 'Server Maintenance In Progress!',
        );
      }

      userProfile = UserProfile.fromJson(response);

      return userProfile;
    } catch (e) {
      //  prefix.Get.to(() => const CustomServerUpgradeScreen());
      return UserProfile(
        status: 400,
        message: 'Failed to fetch user profile!',
      );
    }
  }

  static Future updateAccountVerStatus(map) async {
    try {
      switch (map['type']) {
        case 'PHONE_NUMBER':
          Response res = await client.post(
            Uri.parse(baseUrl + accounts + auth + "phone-number-verification"),
            headers: authHeader,
            body: jsonEncode({
              "phone_number": "${map['phoneNo']}",
              "country_code": Config().countryCode,
            }),
          );

          var response = jsonDecode(res.body);
          if (response["status"] != 200) {
            return {
              "status": 400,
              "message": "Failed",
            };
          }

          if (res.statusCode == 502) {
            prefix.Get.offAll(
                ServerMaintenanceScreen(screenName: "Send Money"));
          }

          return response;
        case 'ID_CARD':
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(baseUrl + accounts + auth + "upload-card-images"),
          );
          request.fields.addAll({
            'document_type': '${map['cardType']}',
            'card_name': '${map['name']}',
            'card_number': '${map['cardNo']}'
          });
          if (map['cardType'] == 'ID_CARD') {
            //two images
            request.files.add(http.MultipartFile(
              'images',
              map['frontImage'].readAsBytes().asStream(),
              map['frontImage'].lengthSync(),
              filename: map['frontImage'].path,
              contentType: MediaType('image', 'jpeg'),
            ));
            request.files.add(http.MultipartFile(
              'images',
              map['backImage'].readAsBytes().asStream(),
              map['backImage'].lengthSync(),
              filename: map['backImage'].path,
              contentType: MediaType('image', 'jpeg'),
            ));
          } else {
            //one image
            request.files.add(http.MultipartFile(
              'images',
              map['frontImage'].readAsBytes().asStream(),
              map['frontImage'].lengthSync(),
              filename: map['frontImage'].path,
              contentType: MediaType('image', 'jpeg'),
            ));
          }

          request.headers.addAll({
            "Content-type": "application/x-www-form-urlencoded",
            "access_id": accessId,
          });

          http.StreamedResponse res = await request.send();

          var responseData = await http.Response.fromStream(res);

          var response = jsonDecode(responseData.body);

          if (response['status'] != 200) {
            return {
              "status": 400,
              "message": "${response['message']}",
            };
          }

          if (res.statusCode == 502) {
            prefix.Get.offAll(
                ServerMaintenanceScreen(screenName: "Send Money"));
          }

          return response;
        case 'SELFIE':
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(baseUrl + accounts + auth + "upload-selfie"),
          );
          // request.fields.addAll({
          //   'selfie': 'ID_CARD',
          //   'card_name': '${map['name']}',
          //   'card_number': '${map['cardNo']}'
          // });

          request.files.add(http.MultipartFile(
            'selfie',
            map['frontImage'].readAsBytes().asStream(),
            map['frontImage'].lengthSync(),
            filename: map['frontImage'].path,
            contentType: MediaType('image', 'jpeg'),
          ));

          request.headers.addAll({
            "Content-type": "application/x-www-form-urlencoded",
            "access_id": accessId,
          });

          http.StreamedResponse res = await request.send();

          var responseData = await http.Response.fromStream(res);

          var response = jsonDecode(responseData.body);

          if (response["status"] != 200) {
            return {
              "status": 400,
              "message": "Failed",
            };
          }

          if (res.statusCode == 502) {
            prefix.Get.offAll(
                ServerMaintenanceScreen(screenName: "Send Money"));
          }

          return response;

        default:
      }
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed",
      };
    }
  }

  static Future<BankList> getAllBankList(Map map) async {
    try {
      BankList bankList;
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + mainWalletReload + "bank-list"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      if (response['status'] == 401 &&
          response['message'] == 'Session Expired') {
        return BankList(
          status: 401,
          message: 'Session Expired!',
          banks: [],
        );
      }

      bankList = BankList.fromJson(response);

      return bankList;
    } catch (e) {
      return BankList(
        status: 400,
        message: 'Failed to fetch bank list!',
      );
    }
  }

  static Future<ProductTransactionHistory> getProductTransactionHistory(
      Map map) async {
    try {
      ProductTransactionHistory productTransactionHistory;
      Response res = await client.post(
        Uri.parse(baseUrl + "favorite/transaction-filter"),
        headers: authHeader,
        body: jsonEncode(map),
      );
      // log(res.body.toString());

      var response = jsonDecode(res.body);
      log("+++++--------******* ${res.body}");
      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
          response['message'] == 'Session Expired') {
        return ProductTransactionHistory(
          status: 401,
          message: 'Session Expired!',
          description: '',
          transactions: [],
        );
      }

      productTransactionHistory = ProductTransactionHistory.fromJson(response);
      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      return productTransactionHistory;
    } catch (e) {
      return ProductTransactionHistory(
        status: 400,
        message: 'Failed to fetch bank list!',
      );
    }
  }

  static Future<DayReferralEarning> getDayReferralEarning(Map map) async {
    try {
      DayReferralEarning bankList;

      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "reports/day-referral-earning"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      if (response['status'] == 401 &&
          response['message'] == 'Session Expired') {
        return DayReferralEarning(
          status: 401,
          message: 'Session Expired!',
        );
      }

      bankList = DayReferralEarning.fromJson(response);

      return bankList;
    } catch (e) {
      return DayReferralEarning(
        status: 400,
        message: 'Failed to fetch referral earnings!',
      );
    }
  }

  static Future addBankToUserList(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(
            baseUrl + wallet + mainWalletReload + "add-to-user-bank-list"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response["status"] == 503) {
        prefix.Get.offAll(const CustomServerUpgradeScreen());
        return response;
      }
      return response;
    } catch (e) {
      // prefix.Get.to(() => const CustomServerUpgradeScreen());
      return {
        "status": 400,
        "message": "Failed to add bank to user list!",
      };
    }
  }

  static Future removeBankFromUserList(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(
            baseUrl + wallet + mainWalletReload + "remove-from-user-bank-list"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to remove bank from user list!",
      };
    }
  }

  static Future<MainWalletReload> getMainWalletReload(Map map) async {
    log('wallet update called...........');
    try {
      MainWalletReload mainWalletReloadData;
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + mainWalletReload + "user-bank-list"),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      print("response +++  ${response}");
      if (response['status'] == 401 &&
          response['message'] == 'Session Expired') {
        return MainWalletReload(
          status: 401,
          message: 'Session Expired!',
        );
      }

      mainWalletReloadData = MainWalletReload.fromJson(response);
      print("Data +++++++++++ ${response}");

      return mainWalletReloadData;
    } catch (e) {
      return MainWalletReload(
        status: 400,
        message: 'Failed to fetch wallet data!',
      );
    }
  }

  static Future<WalletBalance> getWalletBalance(Map map) async {
    try {
      WalletBalance mainWalletReloadData;
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "reports/wallet-balance"),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return WalletBalance(
          status: 401,
          message: 'Unable to fetch wallet balance!',
          data: null,
        );
      }

      mainWalletReloadData = WalletBalance.fromJson(response);

      return mainWalletReloadData;
    } catch (e) {
      return WalletBalance(
        status: 400,
        message: 'Failed to fetch wallet balance!',
      );
    }
  }

  static Future<TermsAndConditions> getTermsAndConditions(String type) async {
    try {
      TermsAndConditions termsAndConditions;
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "no-auth/fetch-terms-conditions"),
        headers: header,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      if (response['status'] == 401 || response['status'] == 404) {
        return TermsAndConditions(
          status: response['status'],
          message: 'Terms and conditions not found!',
          content: '',
        );
      }

      termsAndConditions = TermsAndConditions.fromJson(response);

      return termsAndConditions;
    } catch (e) {
      return TermsAndConditions(
        status: 400,
        message: 'Failed to fetch terms and conditions!',
        content: '',
      );
    }
  }

  static Future<ReferralTermsAndConditions> getReferralTermsAndConditions(
      String type) async {
    try {
      ReferralTermsAndConditions termsAndConditions;
      Response res = await client.post(
        Uri.parse(
            baseUrl + userReports + "no-auth/fetch-referral-terms-conditions"),
        headers: header,
      );

      var response = jsonDecode(res.body);
      print("Term And Condition +++++++++++++++ $response");

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      if (response['status'] == 401 || response['status'] == 404) {
        return ReferralTermsAndConditions(
          status: response['status'],
          message: 'Referral Terms and conditions not found!',
          content: '',
        );
      }

      termsAndConditions = ReferralTermsAndConditions.fromJson(response);

      return termsAndConditions;
    } catch (e) {
      return ReferralTermsAndConditions(
        status: 400,
        message: 'Failed to fetch referral terms and conditions!',
        content: '',
      );
    }
  }

  static Future<PrivacyPolicy> getPrivacyPolicy(String type) async {
    try {
      PrivacyPolicy privacypolicy;
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "no-auth/fetch-privacy-policy"),
        headers: header,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      if (response['status'] == 401 || response['status'] == 404) {
        return PrivacyPolicy(
          status: response['status'],
          message: 'Privacy Policy not found!',
          content: '',
        );
      }

      privacypolicy = PrivacyPolicy.fromJson(response);

      return privacypolicy;
    } catch (e) {
      return PrivacyPolicy(
        status: 400,
        message: 'Failed to fetch privacy policy!',
        content: '',
      );
    }
  }

  static Future addAmountToMainWallet(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + mainWalletReload),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      // if (res.statusCode == 502) {
      //   prefix.Get.offAll(ServerMaintenanceScreen(screenName: "Reload Wallet"));
      // }
      print("statusCode ++++ ${res.statusCode}");
      print("statusCode ----- ${res.statusCode}");
      print("res.body ++-+-+-+- ${jsonDecode(res.body)["status"]}");

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(ServerMaintenanceScreen(screenName: "Reload Wallet"));
      }
      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to reload main wallet!",
      };
    }
  }

  static Future sendUserReport(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + 'reports/send-report'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to send report!",
      };
    }
  }

  static Future requestDonation(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + 'reports/fund-request'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to send report!",
      };
    }
  }

  static Future sendUserFeedback(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + 'reports/contact-support'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to send feedback!",
      };
    }
  }

  static Future<SendMoneyRecentList> getSendMoneyRecentList(Map map) async {
    try {
      SendMoneyRecentList bankList;
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + "recent-list-send-money"),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      if (response['status'] == 401 &&
          response['message'] == 'Session Expired') {
        return SendMoneyRecentList(
          status: 401,
          message: 'Session Expired!',
          data: [],
        );
      }

      bankList = SendMoneyRecentList.fromJson(response);

      return bankList;
    } catch (e) {
      return SendMoneyRecentList(
        status: 400,
        message: 'Failed to fetch recent list!',
      );
    }
  }

  static Future<EarningHistory> getEarningHistory(Map map,
      {bool refreshing = false}) async {
    try {
      EarningHistory earningHistory;
      if (refreshing) {
        Response res2 = await client.post(
            Uri.parse(baseUrl + userReports + "reports/earning-history"),
            headers: authHeader,
            body: jsonEncode({'page_no': 0}));
        earningHistory = EarningHistory.fromJson(jsonDecode(res2.body));
        // log(res2.statusCode.toString());
        log('refreshing earning ........... ${earningHistory.data!.length}');

        return earningHistory;
      } else {
        Response res = await client.post(
            Uri.parse(baseUrl + userReports + "reports/earning-history"),
            headers: authHeader,
            body: jsonEncode(map));

        var response = jsonDecode(res.body);

        if (res.statusCode == 502) {
          prefix.Get.offAll(const ServerMaintenanceScreen());
        }

        if (response['status'] == 401 &&
                response['message'] == 'Session Expired' ||
            response['status'] == 503) {
          return EarningHistory(
            status: 401,
            message: 'Unable to fetch earning history!',
            data: null,
          );
        }

        earningHistory = EarningHistory.fromJson(response);

        for (var item in earningHistory.data!) {}
      }

      return earningHistory;
    } catch (e) {
      return EarningHistory(
        status: 400,
        message: 'Failed to fetch earning history!',
        data: null,
      );
    }
  }

  static Stream<EarningHistory>? getEarningHistorySocket() {
    try {
      // Socket socket = io(
      //     'https://gateway.dev.parrotpos.com.my/',
      //     OptionBuilder()
      //         .setTransports(
      //           ['websocket'],
      //         )
      //         .disableAutoConnect()
      //         .build());
      // socket.connect();
      // print('SOCKET CONNECTED:: ');

      // socket.onConnect(
      //   (data) {
      //     print('ON CONNECT');
      //     print(data);

      //     socket.emit('register', authHeader);
      //   },
      // );

      // print('SOCKET CALLED:: ');

      // socket.on(
      //   'earning_history',
      //   (data) => {
      //     print('SOCKET DATA:: '),
      //     print(data),
      //   },
      // );
    } catch (e) {
      // return EarningHistory(
      //   status: 400,
      //   message: 'Failed to fetch earning history!',
      //   data: null,
      // );
    }
    return null;
  }

  static Stream<TransactionHistory>? getTransactionHistorySocket() {
    try {
      IO.Socket socket = IO.io(
        'https://gateway.dev.parrotpos.com.my/',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build(),
      );
      socket.connect();
      socket.onConnect((_) {});
      socket.emit('register', {
        "access_id": accessId,
      });

      // socket.on('connect', (data) {
      //   print('ON CONNECT');
      //   print(data);
      //   print(socket.id);

      //   socket.emit('register', {
      //     "access_id": accessId,
      //   });
      // });

      // socket.onConnect(
      //   (data) {
      //     print('ON CONNECT');
      //     print(data);

      //     socket.emit('register', authHeader);
      //   },
      // );

      socket.on(
        'transaction_history',
        (data) => {
          print('SOCKET DATA:: '),
          print(data),
        },
      );
    } catch (e) {
      // return TransactionHistory(
      //   status: 400,
      //   message: 'Failed to fetch transaction history!',
      //   data: null,
      // );
    }
    return null;
  }

  static Future<EarningWallet> getEarningWallet(Map map) async {
    try {
      EarningWallet earningWallet;
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "reports/amount-description"),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return EarningWallet(
          status: 401,
          message: 'Unable to fetch earning wallet!',
          data: null,
        );
      }

      earningWallet = EarningWallet.fromJson(response);

      return earningWallet;
    } catch (e) {
      return EarningWallet(
        status: 400,
        message: 'Failed to fetch earning wallet!',
        data: null,
      );
    }
  }

  static Future<TransactionHistory> getTransactionHistory(Map map,
      {bool refreshing = false}) async {
    try {
      // WalletController con = prefix.Get.find();
      TransactionHistory transactionHistory;
      if (refreshing) {
        Response res2 = await client.post(
            Uri.parse(baseUrl + userReports + "reports/transaction-history"),
            headers: authHeader,
            body: jsonEncode({'page_no': 0}));
        transactionHistory = TransactionHistory.fromJson(jsonDecode(res2.body));

        log('refreshing ........... ${transactionHistory.data!.length}');
        // List<TransactionHistoryData> tobeShared = [
        //   transactionHistory.data!.first
        // ];
        // all.fir
        // transactionHistory = TransactionHistory(data: tobeShared);

        return transactionHistory;
      } else {
        Response res = await client.post(
            Uri.parse(baseUrl + userReports + "reports/transaction-history"),
            headers: authHeader,
            body: jsonEncode(map));

        // print(res.statusCode);
        var response = jsonDecode(res.body);
        // print(response);

        if (res.statusCode == 502) {
          prefix.Get.offAll(const ServerMaintenanceScreen());
        }

        if (response['status'] == 401 &&
                response['message'] == 'Session Expired' ||
            response['status'] == 503) {
          return TransactionHistory(
            status: 401,
            message: 'Unable to fetch transaction history!',
            data: null,
          );
        }

        transactionHistory = TransactionHistory.fromJson(response);

        return transactionHistory;
      }
    } catch (e) {
      return TransactionHistory(
        status: 400,
        message: 'Failed to fetch transaction history!',
        data: null,
      );
    }
  }

  static Future<TransactionHistoryFilterProducts>
      getTransactionHistoryFilterProducts(Map map) async {
    try {
      TransactionHistoryFilterProducts transactionHistoryFilterProducts;
      Response res = await client.post(
        Uri.parse(
            baseUrl + userReports + "reports/transaction-history-products"),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return TransactionHistoryFilterProducts(
          status: 401,
          message: 'Unable to fetch transaction history!',
          products: null,
        );
      }

      transactionHistoryFilterProducts =
          TransactionHistoryFilterProducts.fromJson(response);

      return transactionHistoryFilterProducts;
    } catch (e) {
      return TransactionHistoryFilterProducts(
        status: 400,
        message: 'Failed to fetch transaction history!',
        products: null,
      );
    }
  }

  static Future sendMoney(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + 'send-money'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response["status"] == 503) {
        prefix.Get.to(const ServerMaintenanceScreen());
        return response;
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to send money!",
      };
    }
  }

  static Future getMainWalletReloadNote() async {
    try {
      Response res = await client.get(
        Uri.parse(baseUrl + userReports + 'reports/reload-wallet-receipt-note'),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const ServerMaintenanceScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to fetch!",
      };
    }
  }

  static Future getNotification() async {
    try {
      print("authHeader 89898989898  ${authHeader}");
      Response res = await client.get(
        Uri.parse(baseUrl + accounts + 'auth/notifications'),
        // Uri.parse("https://gateway.dev.parrotpos.com.my/accounts/auth/notifications"),
        headers:
            // authHeader
            {
          "Content-type": "application/json; charset=utf-8",
          "access_id":
              "8ghgseoca07f4yu4nx2yizkc0mtsm7w7ftmqyiuoes65nmup8ldf2jwqu8hsq37eomg1cadyl3jgfcd439brk0l933d3j70ws39sklc97co32rssnb3t6fkqf4av6htic9zyiqqhbcg7don3eegd5a",
        },
      );

      var response = jsonDecode(res.body);

      log("Notification Data ++++++++ ${response}");

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const ServerMaintenanceScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to fetch!",
      };
    }
  }

  static Future getNotificationRead({required String id}) async {
    try {
      Response res = await client.get(
        Uri.parse(
            baseUrl + accounts + 'auth/read-notification?notificationId=${id}'),
        // Uri.parse("https://gateway.dev.parrotpos.com.my/accounts/auth/notifications"),
        headers:
            // authHeader
            {
          "Content-type": "application/json; charset=utf-8",
          "access_id":
              "8ghgseoca07f4yu4nx2yizkc0mtsm7w7ftmqyiuoes65nmup8ldf2jwqu8hsq37eomg1cadyl3jgfcd439brk0l933d3j70ws39sklc97co32rssnb3t6fkqf4av6htic9zyiqqhbcg7don3eegd5a",
        },
      );

      var response = jsonDecode(res.body);

      log("Notification Reade Data ++++++++ ${response}");

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const ServerMaintenanceScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to fetch!",
      };
    }
  }

  static Future updateNotification({required String token}) async {
    print("Tokens  +-+-+-+-+-+-+-+-+- ${token}");
    try {
      Response res = await client.post(
        Uri.parse(baseUrl +
            accounts +
            'auth/update-user-notification-token?token=${token}'),
        // Uri.parse("https://gateway.dev.parrotpos.com.my/accounts/auth/notifications"),
        headers:
            // authHeader
            {
          "Content-type": "application/json; charset=utf-8",
          "access_id":
              "8ghgseoca07f4yu4nx2yizkc0mtsm7w7ftmqyiuoes65nmup8ldf2jwqu8hsq37eomg1cadyl3jgfcd439brk0l933d3j70ws39sklc97co32rssnb3t6fkqf4av6htic9zyiqqhbcg7don3eegd5a",
        },
      );

      var response = jsonDecode(res.body);

      log("Notification Upate User Data ++++++++ ${response}");

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const ServerMaintenanceScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to fetch!",
      };
    }
  }

  static Future getNotificationDelete({required String id}) async {
    try {
      Response res = await client.get(
        Uri.parse(
            baseUrl + accounts + 'auth/delete_notification?notificationId='),
        // Uri.parse("https://gateway.dev.parrotpos.com.my/accounts/auth/notifications"),
        headers:
            // authHeader
            {
          "Content-type": "application/json; charset=utf-8",
          "access_id":
              "8ghgseoca07f4yu4nx2yizkc0mtsm7w7ftmqyiuoes65nmup8ldf2jwqu8hsq37eomg1cadyl3jgfcd439brk0l933d3j70ws39sklc97co32rssnb3t6fkqf4av6htic9zyiqqhbcg7don3eegd5a",
        },
      );

      var response = jsonDecode(res.body);

      log("Notification Delete ++++++++ ${response}");

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const ServerMaintenanceScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to fetch!",
      };
    }
  }

  static Future getFetchMainWalletReloadInfo() async {
    try {
      Response res = await client.get(
        Uri.parse(
            baseUrl + userReports + 'reports/fetch-main-wallet-reload-info'),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);
      log("MAIN WALLET RELOAD INFO :------- ${response}");

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to fetch!",
      };
    }
  }

  static Future removeRecentFromSendMoney(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + 'remove-recent-send-money'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to remove recent from send money!",
      };
    }
  }

  static Future transferToMainWallet(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + 'transfer-earning-to-main-wallet'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(
            ServerMaintenanceScreen(screenName: "Earning To Main Transfer"));
      }

      if (response["status"] == 503) {
        prefix.Get.offAll(
            ServerMaintenanceScreen(screenName: "Earning To Main Transfer"));
        return response;
      }
      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to transfer to main wallet!",
      };
    }
  }

  static Future<MyReferral> getMyReferral(Map map) async {
    try {
      MyReferral mainWalletReloadData;
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + auth + "view-my-referral"),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      if (response['status'] == 401 &&
          response['message'] == 'Session Expired') {
        return MyReferral(
          status: 401,
          message: 'Session Expired!',
        );
      }

      mainWalletReloadData = MyReferral.fromJson(response);

      return mainWalletReloadData;
    } catch (e) {
      return MyReferral(
        status: 400,
        message: 'Failed to fetch my referrals!',
      );
    }
  }

  static Future<TodaysReferralEarnings> getTodaysReferralEarnings(
      Map map) async {
    try {
      TodaysReferralEarnings todaysReferralEarnings;
      Response res = await client.post(
        Uri.parse(
            baseUrl + userReports + "reports/todays-referral-earning-list"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      if (response['status'] == 401 &&
          response['message'] == 'Session Expired') {
        return TodaysReferralEarnings(
          status: 401,
          message: 'Session Expired!',
        );
      }

      todaysReferralEarnings = TodaysReferralEarnings.fromJson(response);

      return todaysReferralEarnings;
    } catch (e) {
      return TodaysReferralEarnings(
        status: 400,
        message: 'Failed to fetch todays referral earnings!',
      );
    }
  }

  static Future<MyLevelReferralUsers> getMyLevelReferralUsers(Map map) async {
    try {
      MyLevelReferralUsers myLevelReferralUsers;
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + auth + "referral-level-users"),
        headers: authHeader,
        body: jsonEncode(map),
      );
      print(map);
      print(header);
      print(authHeader);
      print(baseUrl + accounts + auth + 'referral-level-users');
      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }
      print(response);
      if (response['status'] == 401 &&
          response['message'] == 'Session Expired') {
        return MyLevelReferralUsers(
          status: 401,
          message: 'Session Expired!',
        );
      }

      myLevelReferralUsers = MyLevelReferralUsers.fromJson(response);

      return myLevelReferralUsers;
    } catch (e) {
      return MyLevelReferralUsers(
        status: 400,
        message: 'Failed to fetch users!',
      );
    }
  }

  static Future<TopUpProducts> getTopUpProducts(Map map) async {
    try {
      TopUpProducts topUpProducts;
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "topup-screen/topup-products"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return TopUpProducts(
          status: 401,
          message: 'Unable to fetch topup products!',
          products: null,
        );
      }

      topUpProducts = TopUpProducts.fromJson(response);

      return topUpProducts;
    } catch (e) {
      return TopUpProducts(
        status: 400,
        message: 'Failed to fetch topup products!',
      );
    }
  }

  static Future<RecentTopUp> getRecentTopUp(Map map) async {
    try {
      RecentTopUp recentTopUp;
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "reports/recent-topup"),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);
      // print(response);
      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return RecentTopUp(
          status: 401,
          message: 'Unable to fetch recent topup!',
          data: null,
        );
      }

      recentTopUp = RecentTopUp.fromJson(response);

      return recentTopUp;
    } catch (e) {
      return RecentTopUp(
        status: 400,
        message: 'Failed to fetch recent topup!',
      );
    }
  }

  static Future<TopUpAmounts> getTopUpAmounts(Map map) async {
    try {
      TopUpAmounts topUpAmounts;
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "topup-screen/topup-amounts"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return TopUpAmounts(
          status: 401,
          message: 'Unable to fetch topup amounts!',
          amounts: null,
          info: null,
        );
      }

      topUpAmounts = TopUpAmounts.fromJson(response);

      return topUpAmounts;
    } catch (e) {
      return TopUpAmounts(
        status: 400,
        message: 'Failed to fetch topup amounts!',
      );
    }
  }

  static Future<OutstandingBill> getOutstandingBill(Map map) async {
    try {
      OutstandingBill outstandingBill;
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + "outstanding-bill"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return OutstandingBill(
            status: 401,
            message: 'Unable to fetch outstanding bill!',
            bill: null);
      }

      outstandingBill = OutstandingBill.fromJson(response);

      return outstandingBill;
    } catch (e) {
      return OutstandingBill(
        status: 400,
        message: 'Failed to fetch outstanding bill!',
      );
    }
  }

  static Future removeRecentTopUp(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + 'reports/remove-recent-topup'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to remove from recent topup!",
      };
    }
  }

  static Future initiateTopUp(Map map) async {
    WalletController walletController = prefix.Get.find();
    UserProfileController profileController = prefix.Get.find();
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + 'initiate-topup'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);
      print(response);

      if (res.statusCode == 502) {
        prefix.Get.offAll(ServerMaintenanceScreen(screenName: "TopUp"));
      }

      if (response["status"] == 503) {
        prefix.Get.to(ServerMaintenanceScreen(screenName: "TopUp"));
        return response;
      }

      log(response.toString());

      walletController.getTransactionHistory(
        {},
        refreshing: true,
      );

      walletController.getEarningHistory(
        refreshing: true,
      );

      log('calling earning......');
      // walletController.getEarningHistory(refreshing: true);
      // Response res2 = await client.post(
      //     Uri.parse(baseUrl + userReports + "reports/earning-history"),
      //     headers: authHeader,
      //     body: jsonEncode({'page_no': 0}));
      //     walletController.earningHistory.update((val) {
      //       if(val!.data !=null){
      //         val.data!.insert(0, EarningHistory.fromJson(jsonDecode(res2.body)).data!.first);

      //       }else{
      //         val.data = EarningHistory.fromJson(jsonDecode(res2.body)).data!;
      //       }
      //     });
      // walletController.getEarningWallet({});

      profileController.getUserDetails();

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to topup!",
      };
    }
  }

  static Future<Map<String, dynamic>> addNewFavorite(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + 'favorite/add'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      log(response.toString());

      return response;
    } catch (e) {
      log(e.toString());
      return {
        "status": 400,
        "message": "Failed to add new favorite!",
      };
    }
  }

  static Future editFavorite(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + 'favorite/update'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to update favorite!",
      };
    }
  }

  static Future removeFavorite(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + 'favorite/remove-favorite-product'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to remove favorite!",
      };
    }
  }

  static Future updateFavoriteOrder(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + 'favorite/update-order-favorites'),
        headers: authHeader,
        body: json.encode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to update order!",
      };
    }
  }

  static Future addNewRecurring(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + 'favorite/add-recurring'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to add new recurring!",
      };
    }
  }

  static Future editRecurring(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + 'favorite/update-recurring'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to update recurring!",
      };
    }
  }

  static Future removeRecurring(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + 'favorite/remove-recurring'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to remove recurring!",
      };
    }
  }

  static Future updateRecurringOrder(Map map) async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + 'favorite/update-order-favorites'),
        headers: authHeader,
        body: json.encode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to update order!",
      };
    }
  }

  static Future initiateBillPayment(Map map) async {
    WalletController walletController = prefix.Get.find();
    UserProfileController profileController = prefix.Get.find();
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + wallet + 'initiate-bill-payment'),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);
      print(response);

      if (res.statusCode == 502) {
        prefix.Get.offAll(
            const ServerMaintenanceScreen(screenName: "Bill Payment"));
      }

      if (response["status"] == 503) {
        prefix.Get.to(
            const ServerMaintenanceScreen(screenName: "Bill Payment"));
        return response;
      }

      log(response.toString());

      walletController.getTransactionHistory(
        {},
        refreshing: true,
      );
      // TransactionHistory transactionHistory;
      // Response res2 = await client.post(
      //     Uri.parse(baseUrl + userReports + "reports/transaction-history"),
      //     headers: authHeader,
      //     body: jsonEncode({'page_no': 0}));
      // transactionHistory = TransactionHistory.fromJson(jsonDecode(res2.body));
      // log(res2.statusCode.toString());
      // if (walletController.transactionHistory.value.data != null) {
      //   log('already');
      //   walletController.transactionHistory.value.data!
      //       .insert(0, transactionHistory.data!.first);
      // } else {
      //   log('first');
      //   walletController.transactionHistory.value.data =
      //       transactionHistory.data;
      // }
      walletController.getEarningHistory(
        refreshing: true,
      );

      // profileController.getUserDetails();

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed bill payment!",
      };
    }
  }

  static Future<BillPaymentCategories> getBillPaymentCategories(Map map) async {
    try {
      BillPaymentCategories billPaymentCategories;
      Response res = await client.post(
        Uri.parse(baseUrl +
            userReports +
            "bill-payment-screen/bill-payment-categories"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      log("----- RESPONSE ROMIL ++++ ${response}");

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return BillPaymentCategories(
          status: 401,
          message: 'Unable to fetch categories!',
          categories: null,
        );
      }

      billPaymentCategories = BillPaymentCategories.fromJson(response);

      return billPaymentCategories;
    } catch (e) {
      return BillPaymentCategories(
        status: 400,
        message: 'Failed to fetch categories!',
      );
    }
  }

  // static Future<BillPaymentCategoriesProducts> getBillPaymentProducts(Map map) async {
  //   try {
  //     BillPaymentCategoriesProducts billPaymentProducts;
  //     Response res = await client.post(
  //       Uri.parse(baseUrl +
  //           userReports +
  //           "bill-payment-screen/bill-payment-products"),
  //       headers: authHeader,
  //       body: jsonEncode(map),
  //     );

  //     print(res.statusCode);
  //     var response = jsonDecode(res.body);
  //     print(response);

  //     if (response['status'] == 401 &&
  //             response['message'] == 'Session Expired' ||
  //         response['status'] == 503) {
  //       return BillPaymentCategoriesProducts(
  //         status: 401,
  //         message: 'Unable to fetch products!',
  //         products: null,
  //       );
  //     }

  //     billPaymentProducts = BillPaymentCategoriesProducts.fromJson(response);

  //     return billPaymentProducts;
  //   } catch (e) {
  //     print(e);
  //     return BillPaymentCategoriesProducts(
  //       status: 400,
  //       message: 'Failed to fetch products!',
  //     );
  //   }
  // }

  static Future<BillPaymentAmounts> getBillPaymentAmounts(Map map) async {
    try {
      BillPaymentAmounts billPaymentAmounts;
      Response res = await client.post(
        Uri.parse(
            baseUrl + userReports + "bill-payment-screen/bill-payment-amounts"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return BillPaymentAmounts(
          status: 401,
          message: 'Unable to fetch bill payment amounts!',
          amounts: null,
          info: null,
        );
      }

      billPaymentAmounts = BillPaymentAmounts.fromJson(response);

      return billPaymentAmounts;
    } catch (e) {
      return BillPaymentAmounts(
        status: 400,
        message: 'Failed to fetch bill payment amounts!',
      );
    }
  }

  static Future<AllFavorites> getAllFavorites(Map map,
      {bool refreshing = false}) async {
    try {
      AllFavorites allFavorites;

      if (refreshing) {
        log('refreshing........$refreshing');
        Response res = await client.post(
          Uri.parse(baseUrl + "favorite/get-favorite-products-user"),
          headers: authHeader,
          body: jsonEncode({'page_no': 0}),
        );

        allFavorites = AllFavorites.fromJson(jsonDecode(res.body));

        log('refreshing ........... ${allFavorites.data!.length}');
        // List<TransactionHistoryData> tobeShared = [
        //   transactionHistory.data!.first
        // ];
        // all.fir
        // transactionHistory = TransactionHistory(data: tobeShared);

        return allFavorites;
      } else {
        Response res = await client.post(
          Uri.parse(baseUrl + "favorite/get-favorite-products-user"),
          headers: authHeader,
          body: jsonEncode(map),
        );
        print(authHeader);

        var response = jsonDecode(res.body);
        log("URL  : ${Uri.parse(baseUrl + "favorite/get-favorite-products-user")}");
        log("DATA PASSING : ${jsonEncode(map)}");
        log("METHOD : POST");
        log("RESPONSE STATUS CODE : ${res.statusCode}");
        log("RESPONSE BODY : ${res.body}");

        if (res.statusCode == 502) {
          prefix.Get.offAll(const ServerMaintenanceScreen());
        }

        print(response.toString());
        if (response['status'] == 401 &&
                response['message'] == 'Session Expired' ||
            response['status'] == 503) {
          return AllFavorites(
            status: 401,
            message: 'Unable to fetch favorites!',
            data: null,
          );
        }

        allFavorites = AllFavorites.fromJson(response);
        print("Length ========== ${allFavorites.data!.length}");
        allFavorites.data!.forEach((element) {
          print(
              "+-+-+-+-+-+-+- A B C ${element.lastTransactionId} == ${element.lastTransactionStatus}");
        });
        // allFavorites.data!.sort((a, b) => a.order!.compareTo(b.order!));
        return allFavorites;
      }
    } catch (e) {
      return AllFavorites(
        status: 400,
        message: 'Failed to fetch favorites!',
      );
    }
  }

  refresFavourite(int pageNo) async {
    Response res = await client.post(
      Uri.parse(baseUrl + "favorite/get-favorite-products-user"),
      headers: authHeader,
      body: jsonEncode({'page_no': pageNo}),
    );
    var response = jsonDecode(res.body);
    AllFavorites allFavorites = AllFavorites.fromJson(response);
    return allFavorites;
  }

  static Future<AllRecurring> getAllRecurring(Map map) async {
    try {
      AllRecurring allRecurring;
      Response res = await client.post(
        Uri.parse(baseUrl + "favorite/get-recurring"),
        headers: authHeader,
        // body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return AllRecurring(
          status: 401,
          message: 'Unable to fetch recurring!',
          recurring: null,
        );
      }

      allRecurring = AllRecurring.fromJson(response);

      allRecurring.recurring!.sort((a, b) => a.order!.compareTo(b.order!));

      return allRecurring;
    } catch (e) {
      return AllRecurring(
        status: 400,
        message: 'Failed to fetch recurring!',
      );
    }
  }

  static Future<Recurring> getRecurring(Map map) async {
    try {
      Recurring allFavorites;
      Recurring recurring;
      Response res = await client.post(
        Uri.parse(baseUrl + "favorite/get-favorite-products-user"),
        headers: authHeader,
        // body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return Recurring(
          status: 401,
          message: 'Unable to fetch recurring!',
          data: null,
        );
      }

      allFavorites = Recurring.fromJson(response);

      recurring = Recurring(
          data: [], message: allFavorites.message, status: allFavorites.status);
      for (var item in allFavorites.data!) {
        if (!item.recurring!) {
          recurring.data!.add(item);
        }
      }
      recurring.data!.sort((a, b) => a.order!.compareTo(b.order!));

      return recurring;
    } catch (e) {
      return Recurring(
        status: 400,
        message: 'Failed to fetch recurring!',
      );
    }
  }

  static Future<FavoriteCategories> getFavoriteCategories(Map map) async {
    try {
      FavoriteCategories favoriteCategories;
      Response res = await client.post(
        Uri.parse(baseUrl + "favorite/favorite-categories"),
        headers: authHeader,
        body: jsonEncode(map),
      );

      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (response['status'] == 401 &&
              response['message'] == 'Session Expired' ||
          response['status'] == 503) {
        return FavoriteCategories(
          status: 401,
          message: 'Unable to fetch categories!',
          categories: null,
        );
      }

      favoriteCategories = FavoriteCategories.fromJson(response);

      return favoriteCategories;
    } catch (e) {
      return FavoriteCategories(
        status: 400,
        message: 'Failed to fetch categories!',
      );
    }
  }

  // static Future<FavoriteProducts> getFavoriteProducts(Map map) async {
  //   try {
  //     FavoriteProducts favoriteProducts;
  //     Response res = await client.post(
  //       Uri.parse(baseUrl + "favorite/favorite-products-of-category"),
  //       headers: authHeader,
  //       body: jsonEncode(map),
  //     );

  //     print(res.statusCode);
  //     var response = jsonDecode(res.body);
  //     print(response);

  //     if (response['status'] == 401 &&
  //             response['message'] == 'Session Expired' ||
  //         response['status'] == 503) {
  //       return FavoriteProducts(
  //         status: 401,
  //         message: 'Unable to fetch products!',
  //         products: null,
  //       );
  //     }

  //     favoriteProducts = FavoriteProducts.fromJson(response);

  //     return favoriteProducts;
  //   } catch (e) {
  //     print(e);
  //     return FavoriteProducts(
  //       status: 400,
  //       message: 'Failed to fetch products!',
  //     );
  //   }
  // }

  static Future<Donation> getDonation() async {
    try {
      Donation donation;
      Response res = await client.post(
        Uri.parse(baseUrl + userReports + "reports/donation"),
        headers: authHeader,
      );

      var response = jsonDecode(res.body);
      print("Res Code *-*-*-*-*-*--* ${res.statusCode}");

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      if (response['status'] == 401 ||
          response['message'] == 'Session Expired') {
        return Donation(
          status: 401,
          message: 'Session Expired!',
        );
      }

      donation = Donation.fromJson(response);

      return donation;
    } catch (e) {
      return Donation(
        status: 400,
        message: 'Failed to fetch donation!',
      );
    }
  }

  static Future shareReferral() async {
    try {
      Response res = await client.post(
        Uri.parse(baseUrl + accounts + auth + "share-my-referral-code"),
        headers: authHeader,
      );
      var response = jsonDecode(res.body);

      if (res.statusCode == 502) {
        prefix.Get.offAll(const ServerMaintenanceScreen());
      }

      if (res.statusCode == 503 || jsonDecode(res.body)["status"] == 503) {
        prefix.Get.to(const CustomServerUpgradeScreen());
      }

      return response;
    } catch (e) {
      return {
        "status": 400,
        "message": "Failed to transfer to main wallet!",
      };
    }
  }
}
