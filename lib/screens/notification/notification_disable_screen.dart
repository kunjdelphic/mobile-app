import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/screens/notification/message_sent_screen.dart';

import '../../controllers/notification_controller.dart';
import '../../style/colors.dart';
import '../../style/style.dart';
import '../../widgets/buttons/gradient_button.dart';

class NotificationDisableScreen extends StatefulWidget {
  const NotificationDisableScreen({super.key});

  @override
  State<NotificationDisableScreen> createState() => _NotificationDisableScreenState();
}

class _NotificationDisableScreenState extends State<NotificationDisableScreen> with WidgetsBindingObserver {
  final notificationController = Get.put(NotificationController());

  bool isBackgroundSyncWorking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // notificationController.serverManager();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isBackgroundSyncWorking == true) {
        notificationController.checkPermission();
      }
      // Get.to(() => MessageSentScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/notification_disable.png"),
          const SizedBox(height: 50),
          Text(
            "Notifications are still \n disabled! ",
            textAlign: TextAlign.center,
            style: kBlackDarkSuperLargeStyle,
            // kBlackDarkSuperLargeStyle.copyWith(fontSize: 22,color: kBlack17),
          ),
          const SizedBox(height: 25),
          Text(
            "Please enable notifications in your settings to receive an alert once the update is completed. Alternatively, for immediate assistance, you can contact us via WhatsApp.",
            textAlign: TextAlign.center,
            style: kBlackLightMediumStyle,
            // kBlackLightMediumStyle.copyWith(color: const Color(0xff434343), fontSize: 14),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonBorderBtn(
                  border: Border.all(color: Color(0xff0E76BC)),
                  onTap: () {
                    isBackgroundSyncWorking = true;
                    notificationController.requestPermission();
                    // notificationController.serverManager();
                    // Get.to(() => NotificationEnableScreen());
                  },
                  title: "Notify Me",
                  style: kPrimaryExtraDarkSuperLargeStyle.copyWith(
                    fontSize: 18,
                    color: const Color(0xff0E76BC),
                  )),
              WhiteBluBtn(
                width: 150,
                onTap: () {
                  isBackgroundSyncWorking = false;
                  notificationController.launchWhatsApp(callBack: () {
                    Get.to(() => MessageSentScreen());
                    // Get.back();
                  });
                  // Get.to(() => MessageSentScreen());
                },
                text: "Contact Us",
                widthSize: Get.width * 0.34,
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.06),
    );
  }
}
