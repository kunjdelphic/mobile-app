import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/notification/message_sent_screen.dart';
import '../screens/notification/model_notification.dart';
import '../screens/notification/notification_disable_screen.dart';
import '../screens/notification/notification_enable_screen.dart';
import '../services/remote_service.dart';

class NotificationController extends GetxController {
  RxBool isPermissionGranted = false.obs;
  RxBool isPermissionNotGranted = false.obs;
  RxBool isRequestInProgress = false.obs;

  Future<void> setToken({String? billName}) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      print("FCM Token: $token");
      print("Bill Name : $billName");
      await FirebaseFirestore.instance.collection('NotificationData').doc(RemoteService.accessId).set({
        "fcm_token": token,
        'timeStamp': DateTime.now().toUtc(),
        'env': baseUrl.contains("dev") ? "dev" : "prod",
        'type': billName,
      });
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }

  Future<void> checkPermission({String? screen}) async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      // setState(() {
      isPermissionGranted.value = true;
      // });
      // _navigateToNextScreen();
      setToken(billName: screen);
      Get.to(() => const NotificationEnableScreen());
    } else {
      // setState(() {
      isPermissionNotGranted.value = true;
      // });
      Get.off(() => const NotificationDisableScreen());
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (isNotification == false) {
  //     AppSettings.openAppSettings(
  //       type: AppSettingsType.notification,
  //     ).then((value) {});
  //   } else {
  //     AppSettings.openAppSettings(
  //       type: AppSettingsType.notification,
  //     ).then((value) {});
  //   }
  //
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       Future.delayed(const Duration(milliseconds: 200)).then((value) async {
  //         isNotification = await Permission.notification.isGranted ? true : false;
  //         if (AppConstants.isGuest) {}
  //       });
  //
  //       // isNotification = Permission.notification.isGranted ? true : false;
  //
  //       break;
  //     case AppLifecycleState.inactive:
  //       break;
  //     case AppLifecycleState.paused:
  //       break;
  //     case AppLifecycleState.detached:
  //       break;
  //     default:
  //   }
  // }

  /// Romil Sir Function
  // Future<void> serverManager() async {
  //   var status = await Permission.notification.request();
  //   if (status.isGranted) {
  //     Get.to(() => const NotificationEnableScreen());
  //   } else {
  //     // openAppSettings().then((value) async {
  //     AppSettings.openAppSettings(
  //       type: AppSettingsType.notification,
  //       asAnotherTask: false,
  //     ).then((value) async {
  //       final statusNT = await Permission.notification.status;
  //       // await Permission.notification.request().then((statusNT) {
  //       if (statusNT.isGranted) {
  //         serverManager();
  //       } else {
  //         Get.off(() => const NotificationDisableScreen());
  //       }
  //     });
  //   }
  // }

  // Future<void> serverManager() async {
  //   var status = await Permission.notification.request();
  //   if (status.isGranted) {
  //     Get.off(() => NotificationEnableScreen());
  //   } else {
  //     openAppSettings().then((value) async {
  //       var statusNT = await Permission.notification.request();
  //       if (statusNT.isGranted) {
  //         serverManager();
  //       } else {
  //         Future.delayed(Duration(seconds: 3));
  //         Get.to(NotificationDisableScreen());
  //       }
  //     });
  //
  //     // openAppSettings().whenComplete(() async {
  //     //   if (await Permission.notification.isGranted) {
  //     //     serverManager();
  //     //   } else {
  //     //     Get.off(NotificationDisableScreen());
  //     //   }
  //     //
  //     //   // Permission.notification.onGrantedCallback(() {
  //     //   // });
  //     //   // Permission.notification.onDeniedCallback(() {
  //     //   //   // serverManager();
  //     //   // });
  //     //
  //     //   // if (statusNT.isGranted) {
  //     //   //   serverManager();
  //     //   // } else {
  //     //   //   Get.off(NotificationDisableScreen());
  //     //   // }
  //     // });
  //   }
  // }

  Future<void> requestPermission({String? billName}) async {
    // if (isRequestInProgress.value) return; // Prevent multiple requests
    // isRequestInProgress.value = true;
    var status = await Permission.notification.request();
    if (status.isGranted) {
      // setState(() {
      isPermissionGranted.value = true;
      await setToken(billName: billName);
      // });
      Get.off(() => NotificationEnableScreen(billType: billName));
      // _navigateToNextScreen();
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification).whenComplete(() {
        print("===== OYE OYE");
      });
      // openAppSettings();
    }
    // isRequestInProgress.value = false;
  }

  // final String phoneNumber = "+ 9825641184"; // "+ 601155506029"; // Replace with your phone number
  final String phoneNumber = "+ 601155506029"; // "+ 601155506029"; // Replace with your phone number
  final String message = "Hello ParrotPos, I am unable to make my wallet reload at the moment. Please assist me.  Thank you! "; // Replace with your message

  Future<void> launchWhatsApp({Function? callBack}) async {
    final url = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    if (await canLaunch(url)) {
      await launch(url).then((value) {
        if (callBack != null) {
          Future.delayed(const Duration(seconds: 2), () => callBack());
        }
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  // getNotification(context) async {
  //   final res = await RemoteService.getNotification();
  //   print("121212121212121 ${res}");
  // }
  final RxList<GetNotificationModelNotifications> unreadList = <GetNotificationModelNotifications>[].obs;
  final getNotificationModel = GetNotificationModel().obs;
  Future<GetNotificationModel> getNotification() async {
    var res = await RemoteService.getNotification();
    print("+++++++++++++ ${res}");
    getNotificationModel.value = GetNotificationModel.fromJson(res);
    return getNotificationModel.value;
  }

  final getNotificationRead = ReadNotification().obs;
  Future<ReadNotification> getReadNotification({required String id}) async {
    var res = await RemoteService.getNotificationRead(id: id);
    print("Read -----------  ${res}");
    getNotificationRead.value = ReadNotification.fromJson(res);
    return getNotificationRead.value;
  }

  Future<String> updateUserNotification({required String token}) async {
    var res = await RemoteService.updateNotification(token: token);
    print("Read -----------  ${res}");
    return res['message'];
  }

  Future<String> userNotificationDelete({required String id}) async {
    var res = await RemoteService.getNotificationDelete(id: id);
    print("Delete -----------  ${res}");
    return res['message'];
  }
}
