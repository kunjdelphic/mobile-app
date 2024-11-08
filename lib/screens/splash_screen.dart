import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parrotpos/controllers/internet_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/login/main_login_screen.dart';
import 'package:parrotpos/screens/main_home.dart';

import 'package:parrotpos/screens/onboarding_screen.dart';
import 'package:parrotpos/screens/server_upgrade_screen.dart';
import 'package:parrotpos/services/remote_service.dart';

import 'package:parrotpos/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late GetStorage getStorage;
  final userProfileController = Get.put(UserProfileController());

  @override
  void initState() {
    checkIfFirstLoad();
    super.initState();
  }

  // checkServer() async {
  //   print("server checking");
  //   var x = await RemoteService.checkServer();

  //   x != '503' ? checkIfFirstLoad() : Get.to(ServerUpgradeScreen());
  // }

  checkIfFirstLoad() async {
    final pref = await SharedPreferences.getInstance();
    bool? isFirst = pref.getBool('onboarding');
    await GetStorage().initStorage;

    if (isFirst ?? false) {
      Timer(const Duration(seconds: 4), () async {
        String? accessId = GetStorage().read('accessId');

        print('ACCESS ID :: $accessId');

        if (accessId != null) {
          // RemoteService.accessId = accessId;
          RemoteService.accessId = accessId;
          Get.offAll(() => const MainHome());
        } else {
          Get.offAll(() => const MainLoginScreen());
        }
      });
    } else {
      Timer(const Duration(seconds: 4), () {
        Get.offAll(() => const OnboardingScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _controller = Get.put(InternetController());
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFfffdff),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 25),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/logo/parrotpos_logo.png",
              repeat: ImageRepeat.noRepeat,
              height: 23,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: const Divider(
                color: Color(0xffD4D4D4),
                thickness: 0.30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Container(
                height: 32,
                // width: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      12.0,
                    ),
                  ),
                  border: Border.all(
                    color: Colors.blueAccent,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "V",
                      style: kBlackSmallLightMediumStyle,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${userProfileController.currentVersion}',
                      style: kBlackSmallLightMediumStyle,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/images/logo/logo.gif",
        ),
      ),
    );
  }
}
