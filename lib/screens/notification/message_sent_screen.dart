import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/notification_controller.dart';
import '../../style/colors.dart';
import '../../style/style.dart';
import '../../widgets/buttons/gradient_button.dart';
import 'notification_disable_screen.dart';

class MessageSentScreen extends StatefulWidget {
  const MessageSentScreen({super.key});

  @override
  State<MessageSentScreen> createState() => _MessageSentScreenState();
}

class _MessageSentScreenState extends State<MessageSentScreen> {
  final notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading:  BackButton(
          onPressed: (){
            Get.back();
            Get.back();
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/massagesent.png"),
          const SizedBox(height: 50),
          Text(
            " Message Sent !",
            textAlign: TextAlign.center,
            style: kBlackDarkSuperLargeStyle,
            // kBlackDarkSuperLargeStyle.copyWith(fontSize: 22,color: kBlack17),
          ),
          const SizedBox(height: 25),
          Text(
            "We’ll get back to you as soon as possible. Thank you for reaching out.",
            textAlign: TextAlign.center,
            style: kBlackLightMediumStyle,
            // kBlackLightExtraLargeStyle.copyWith(color: const Color(0xff434343), fontSize: 14),
          ),
          const SizedBox(height: 40),
          WhiteBluBtn(
            width: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
            onTap: () {
              Get.back();
              Get.back();
              Get.back();
              // notificationController.launchWhatsApp(callBack: () {
              //   // Get.to(MessageSentScreen());
              // });
              // Get.to(() => NotificationDisableScreen());
            },
            text: "Back",
            widthSize: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
          )
        ],
      ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.06),
    );
  }
}
