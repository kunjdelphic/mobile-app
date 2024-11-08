import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/notification_controller.dart';
import 'package:parrotpos/screens/notification/notification_enable_screen.dart';
import 'package:parrotpos/services/remote_service.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../style/colors.dart';
import '../../style/style.dart';
import 'notification_disable_screen.dart';

class ServerMaintenanceScreen extends StatefulWidget {
  final String? screenName;
  const ServerMaintenanceScreen({super.key, this.screenName});

  @override
  State<ServerMaintenanceScreen> createState() => _ServerMaintenanceScreenState();
}

class _ServerMaintenanceScreenState extends State<ServerMaintenanceScreen> with WidgetsBindingObserver {
  // RxBool isPermissionGranted = false.obs;
  // bool isPermissionNotGranted = false;
  final notificationController = Get.put(NotificationController());
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // RemoteService.timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   RemoteService.checkServerFrequently();
    // });

    // requestNotificationPermissions();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print(" Dispose+++++++++ +++ ++ ++ +${dispose}");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // notificationController.checkPermission();
    }
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (state == AppLifecycleState.resumed) {
  //     Permission.notification.request().then((statusNT) {
  //       if (statusNT.isGranted) {
  //         notificationController.serverManager();
  //         // serverManager();
  //       } else {
  //         Get.to(() => const NotificationDisableScreen());
  //       }
  //     });
  //   }
  // }

  // Future<void> _checkPermission() async {
  //   var status = await Permission.notification.status;
  //   if (status.isGranted) {
  //     setState(() {
  //       isPermissionGranted.value = true;
  //     });
  //     // _navigateToNextScreen();
  //     Get.to(() => NotificationEnableScreen(isGrantedPermission: true));
  //   } else if (status.isDenied) {
  //     setState(() {
  //       isPermissionNotGranted = true;
  //     });
  //     Get.to(() => NotificationDisableScreen());
  //   }
  // }
  //
  // Future<void> requestPermission() async {
  //   var status = await Permission.notification.request();
  //   if (status.isGranted) {
  //     setState(() {
  //       isPermissionGranted.value = true;
  //     });
  //     Get.to(() => NotificationEnableScreen(isGrantedPermission: true));
  //     // _navigateToNextScreen();
  //   } else if (status.isDenied) {
  //     openAppSettings();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("Name Screen ----- ${widget.screenName}");
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/notifyme.png"),
          SizedBox(height: 50),
          Text(
            "Hang on! \n we are under maintenance",
            textAlign: TextAlign.center,
            style: kBlackDarkSuperLargeStyle,
            // kBlackDarkSuperLargeStyle.copyWith(fontSize: 22, color: kBlack17),
          ),
          const SizedBox(height: 25),
          Text(
            "We are updating the server to enhance your experience. To receive an alert once the update is completed, click 'Notify Me'.",
            textAlign: TextAlign.center,
            style: kBlackLightMediumStyle,
            // kBlackLightMediumStyle.copyWith(color: Color(0xff434343),fontSize: 14),
          ),
          SizedBox(height: 40),
          CommonBorderBtn(
              width: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
              border: Border.all(color: kColorPrimary, width: 1.5),
              onTap: () async {
                notificationController.requestPermission(billName: widget.screenName);

                // await notificationController.serverManager();
                // Get.to(() => NotificationEnableScreen());
              },
              title: "Notify Me",
              style: kPrimaryExtraDarkSuperLargeStyle.copyWith(
                fontSize: 18,
              ))
        ],
      ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.06),
    );
  }
}
