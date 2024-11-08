// import 'package:fireauth/auth_controller.dart';
// import 'package:fireauth/fireauth.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/models/signup/forgot_password.dart';
import 'package:parrotpos/models/signup/signup_referral.dart';
import 'package:parrotpos/services/remote_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../style/colors.dart';
import '../widgets/dialogs/snackbars.dart';

class LoginController extends GetxController {
  Future<String?> login(Map map) async {
    var res = await RemoteService.login(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  signInWithYahoo(context) async {
    try {
      UserCredential yahooUser = await FirebaseAuth.instance.signInWithProvider(YahooAuthProvider());
      if (yahooUser.user?.email != null) {
        print(yahooUser.user?.email);
        var map = {
          "country_iso": "MY",
          "email": yahooUser.user!.email.toString(),
          // "email": "test1@gmail.com",
          "third_party": "YAHOO",
          // "name": googleUser.displayName
        };
        FirebaseAuth.instance.signOut();
        print(map);
        // var checking =
        //     await RemoteService.checkAlreadyThirdPartyRegisted(map["email"]);
        // print("Checking : $checking");
        // if (checking["status"] == 200 ||
        //     checking["message"] == "Auth User is not Registered") {
        var res = await RemoteService.thirdPartyLogin(map);

        Get.back();

        return res['message'];

        // } else {
        //   Get.back();
        //   return "Issue in signin using yahoo";
        // }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<String?> signInWithGoogle() async {
  //     final GoogleSignInAccount? googleUser = Platform.isAndroid
  //         ? await GoogleSignIn().signIn()
  //         : await GoogleSignIn(
  //         clientId:
  //         "844852597269-50p2h3pp1qr9gce6a564oitjmfojjh99.apps.googleusercontent.com")
  //         .signIn();
  //
  //     var map = {
  //       "country_iso": "MY",
  //       "email": googleUser!.email,
  //       // "email": "test1@gmail.com",
  //       "third_party": "GOOGLE",
  //       // "name": googleUser.displayName
  //     };
  //     print("22222222222222 ${googleUser!.email}");
  //     // var checking =
  //     //     await RemoteService.checkAlreadyThirdPartyRegisted(map["email"]);
  //     Platform.isAndroid
  //         ? await GoogleSignIn().signOut()
  //         : await GoogleSignIn(
  //         clientId:
  //         "844852597269-50p2h3pp1qr9gce6a564oitjmfojjh99.apps.googleusercontent.com")
  //         .signOut();
  //     // print(checking);
  //     // if (checking["status"] == 200 ||
  //     //     checking["message"] == "Auth User is not Registered") {F
  //
  //     var res = await RemoteService.thirdPartyLogin(map);
  //      print("===========${res}");
  //     Get.back();
  //     return res["message"];
  //
  // }

  Future<String?> signInWithGoogle() async {
    try {
      // Show loading indicator
      Get.dialog(
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 60,
              width: 100,
              child: const SizedBox(
                height: 30,
                width: 30,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScalePulseOut,
                  colors: [kAccentColor],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Sign in with Google
      final GoogleSignInAccount? googleUser =
          Platform.isAndroid ? await GoogleSignIn().signIn() : await GoogleSignIn(clientId: "844852597269-50p2h3pp1qr9gce6a564oitjmfojjh99.apps.googleusercontent.com").signIn();

      if (googleUser == null) {
        Get.back(); // Close the loading indicator
        return "Sign in aborted by user";
      }

      var map = {
        "country_iso": "MY",
        "email": googleUser.email,
        "third_party": "GOOGLE",
        // "name": googleUser.displayName
      };

      print("22222222222222 ${googleUser.email}");

      Platform.isAndroid ? await GoogleSignIn().signOut() : await GoogleSignIn(clientId: "844852597269-50p2h3pp1qr9gce6a564oitjmfojjh99.apps.googleusercontent.com").signOut();

      var res = await RemoteService.thirdPartyLogin(map);

      Get.back(); // Close the loading indicator

      // Navigate to the next screen if login is successful
      // if (res["status"] == 200) {
      //   Get.to(() => NextScreen());
      // }

      return res["message"];
    } catch (error) {
      Get.back(); // Close the loading indicator in case of an error
      print("Sign in failed: $error");
      return "Sign in failed: $error";
    }
  }

  Future<String?> signInWithApple() async {
    try{
      Get.dialog(
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 60,
              width: 100,
              child: const SizedBox(
                height: 30,
                width: 30,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScalePulseOut,
                  colors: [kAccentColor],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
      // Trigger the authentication flow
      if (await TheAppleSignIn.isAvailable()) {
        String generateNonce([int length = 32]) {
          final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
          final random = Random.secure();
          return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
        }

        String sha256ofString(String input) {
          final bytes = utf8.encode(input);
          final digest = sha256.convert(bytes);
          return digest.toString();
        }

        // final credential = await SignInWithApple.getAppleIDCredential(
        //   scopes: [
        //     AppleIDAuthorizationScopes.email,
        //     AppleIDAuthorizationScopes.fullName,
        //   ],
        // );
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);

        // Request credential for the currently signed in Apple account.
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        // Create an `OAuthCredential` from the credential returned by Apple.
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );

        UserCredential credential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
        // print("Rge SDd" + credential.user!.email!);
        // errorSnackbar(title: "Login Success", subtitle: credential.user!.email!);
        final pref = await SharedPreferences.getInstance();
        // switch (result.status) {
        //   case AuthorizationStatus.authorized:
        // if (credential!.email != null && credential!.givenName != null) {
        //   // Store the email and full name in SharedPreferences
        //   pref?.setString("email_apple", credential!.email!);
        //   pref?.setString(
        //       "name_apple", credential!.givenName! + credential!.familyName!);
        // }
        // String? email = await pref?.getString("email_apple");
        // String? fullname = await pref?.getString("name_apple");

        // print(
        //     "The email and full name in SharedPreferences are:${email} ,${fullname} ");

        if (credential.user?.email != null) {
          var map = {
            "country_iso": "MY",
            "email": credential.user?.email,
            "third_party": "APPLE",
            "name": FirebaseAuth.instance.currentUser?.displayName ?? "",
          };

          await GetStorage().write('name', FirebaseAuth.instance.currentUser!.displayName);
          await FirebaseAuth.instance.signOut();
          // if (result.credential!.email!.isEmpty) {
          // Get.dialog(const Center(child: CircularProgressIndicator()));
          // }
          var res = await RemoteService.thirdPartyLogin(map);
          Get.back();
          return res["message"];
        }

        // Obtain the auth details from the request

        //All the required credentials
      }
      Get.back();
      return null;
    }catch (error) {
      Get.back(); // Close the loading indicator in case of an error
      print("Sign in failed: $error");
      return null;
    }

  }

  Future<Map?> signUp(Map map) async {
    var res = await RemoteService.signUp(map);

    print(res);

    if (res["status"] == 200) {
      return {
        'status': res['status'],
        'session_id': res['session_id'],
      };
    } else {
      return res;
    }
  }

  Future<String?> emailVerification(Map map) async {
    var res = await RemoteService.emailVerification(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<SignupReferral> getReferralDetails(Map map) async {
    var res = await RemoteService.getReferralDetails(map);
    if (res["status"] == 200) {
      return SignupReferral.fromMap(res["referral"]);
    } else {
      return SignupReferral(
        email: '',
        name: '',
        profileImage: '',
        message: res['message'],
      );
    }
  }

  Future<SignupReferral> signUpReferral(Map map) async {
    var res = await RemoteService.signUpReferral(map);
    if (res["status"] == 200) {
      return SignupReferral.fromMap(res["referral"]);
    } else {
      return SignupReferral(
        email: '',
        name: '',
        profileImage: '',
        message: res['message'],
      );
    }
  }

  Future<String?> uploadProfileImage(Map map) async {
    var res = await RemoteService.uploadProfileImage(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<ForgotPassword?> forgotPassword(Map map) async {
    var res = await RemoteService.forgotPassword(map);
    if (res["status"] == 200) {
      return ForgotPassword.fromMap(res);
    } else {
      return ForgotPassword(
        message: res['message'],
        status: res['status'],
        // otp: '',
        sessionId: '',
      );
    }
  }

  Future<String?> verifyForgotPassword(Map map) async {
    var res = await RemoteService.verifyForgotPassword(map);
    if (res["status"] == 200) {
      return '';
    } else {
      return res['message'];
    }
  }
}
