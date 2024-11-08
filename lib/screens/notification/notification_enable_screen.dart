import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parrotpos/screens/notification/message_sent_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/notification_controller.dart';
import '../../style/colors.dart';
import '../../style/style.dart';
import '../../widgets/buttons/gradient_button.dart';
import 'notification_disable_screen.dart';

class NotificationEnableScreen extends StatefulWidget {
  final String? billType;
  const NotificationEnableScreen({
    super.key,
    this.billType,
  });

  @override
  State<NotificationEnableScreen> createState() => _NotificationEnableScreenState();
}

class _NotificationEnableScreenState extends State<NotificationEnableScreen> with WidgetsBindingObserver {
  final notificationController = Get.put(NotificationController());
  bool _hasNavigated = false;
  @override
  void initState() {
    super.initState();
    notificationController.setToken(billName: widget.billType);
    WidgetsBinding.instance.addObserver(this);
    // notificationController.serverManager();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print(" dispose -------------- ${dispose}");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // notificationController.checkPermission();
      // Get.to(() => MessageSentScreen());
      setState(() {});
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setState(() {
  //       Get.to(() => MessageSentScreen());
  //       // Get.back();
  //     });
  //     // Get.to(() => MessageSentScreen())?.then((_) {
  //     //   setState(() {
  //     //     isNavigating = false;
  //     //   });
  //     // });
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed && !_hasNavigated) {
  //     _hasNavigated = true;
  //     Get.to(() => const MessageSentScreen())?.then((_) {
  //       _hasNavigated = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // notificationController.serverManager();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25),
          Image.asset("assets/images/notification_enable.png"),
          const SizedBox(height: 50),
          Text(
            "Notifications enabled !", textAlign: TextAlign.center, style: kBlackDarkSuperLargeStyle,
            // kBlackDarkSuperLargeStyle.copyWith(fontSize: 22,color: kBlack17),
          ),
          const SizedBox(height: 25),
          Text(
            "You will be alerted once the update is completed. For immediate assistance, contact us via WhatsApp.",
            textAlign: TextAlign.center,
            style: kBlackLightMediumStyle,
            // kBlackLightExtraLargeStyle.copyWith(color: const Color(0xff434343),fontSize: 14),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WhiteBluBtn(
                width: 150,
                onTap: () {
                  Get.back();
                  Get.back();
                },
                text: "Back",
                widthSize: Get.width * 0.34,
              ),
              CommonBorderBtn(
                  border: Border.all(color: kColorPrimary),
                  onTap: () async {
                    notificationController.launchWhatsApp(callBack: () {
                      Get.to(() => MessageSentScreen());
                    });
                  },
                  title: "Contact Us",
                  style: kPrimaryExtraDarkSuperLargeStyle.copyWith(
                    fontSize: 18,
                  )),
            ],
          )
        ],
      ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.06),
    );
  }
}
