import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:parrotpos/screens/error_screens/no_internet.dart';
import 'package:parrotpos/screens/main_home.dart';
import 'package:parrotpos/screens/splash_screen.dart';
import 'package:parrotpos/services/remote_service.dart';

class InternetController extends GetxController {
  RxBool internet = true.obs;
  @override
  void onInit() async {
    await checkIfInternetAvailable();
    if (internet.value) {
      await checkForServerDown();
    }
    super.onInit();
  }

  checkForServerDown() async {
    await RemoteService.checkServer();
  }

  Future checkIfInternetAvailable() async {
    var _connectivity = Connectivity();
    var firstresult = await _connectivity.checkConnectivity();
    if (firstresult.contains(ConnectivityResult.none)) {
      // if (firstresult == ConnectivityResult.none) {
      internet = false.obs;
      Get.to(const NoInternet());
    }
    var result = _connectivity.onConnectivityChanged;
    result.listen((event) {
      // print(event);
      // print(internet);
      // print("Get.currentRoute");
      // print(Get.currentRoute);
      if (internet == false.obs) {
        internet = true.obs;
        Get.back();
        if (Get.currentRoute == '/MainHome') {
          Get.to(() => const SplashScreen(),
              transition: Transition.upToDown,
              duration: const Duration(milliseconds: 500));
        }
      }

      if (event.contains(ConnectivityResult.none)) {
        internet = false.obs;
        Get.to(const NoInternet(),
            transition: Transition.upToDown,
            duration: const Duration(milliseconds: 500));
      }
    });
  }
}
