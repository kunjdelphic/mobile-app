import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:parrotpos/controllers/notification_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:styled_text/tags/styled_text_tag_action.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../style/colors.dart';
import '../../style/style.dart';
import '../../widgets/buttons/gradient_button.dart';

class NotificationNotEnable extends StatefulWidget {
  const NotificationNotEnable({super.key});

  @override
  State<NotificationNotEnable> createState() => _NotificationNotEnableState();
}

class _NotificationNotEnableState extends State<NotificationNotEnable> {
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.grey)),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Notification",
          // "Contact Support",
          style: kBlackLargeStyle,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              "assets/images/notification_disable.png",
              height: 190,
              width: 210,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 70,
            ),
            Text(
              "Notifications are disabled!",
              style: kBlackDarkSuperLargeStyle,
            ),
            const SizedBox(
              height: 17,
            ),
            StyledText(
              text: 'You have <notification>1 new notifications.</notification> \n Enable now to view the details.',
              textAlign: TextAlign.center,
              style: kBlackLightMediumStyle,
              tags: {
                'notification': StyledTextActionTag(
                  (_, attrs) {},
                  style: kBlackLightMediumStyle1,
                ),
              },
            ),
            // Text(
            //   "You have 1 new notifications.\nEnable now to view the details.",
            //   style: kBlackLightMediumStyle,
            //   textAlign: TextAlign.center,
            // ),
            const Spacer(),
            CommonBorderBtn(
                width: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.08),
                border: Border.all(color: kColorPrimary, width: 1.5),
                onTap: () async {
                  notificationController.requestPermission();
                },
                title: "Enable Now",
                style: kPrimaryExtraDarkSuperLargeStyle.copyWith(
                  fontSize: 18,
                )),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
