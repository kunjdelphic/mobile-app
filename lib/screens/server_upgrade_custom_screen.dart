import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../style/style.dart';
import '../widgets/buttons/gradient_button.dart';
import 'notification/server_maintainance_screen.dart';

class CustomServerUpgradeScreen extends StatelessWidget {
  const CustomServerUpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ServerMaintenanceScreen(),
      // SafeArea(
      //   child: SizedBox(
      //     width: Get.width,
      //     child: Column(
      //       children: [
      //         Expanded(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               const SizedBox(
      //                 height: 15,
      //               ),
      //               Image.asset(
      //                 'assets/images/server_upgrade.png',
      //                 width: Get.width * 0.8,
      //               ),
      //               const SizedBox(
      //                 height: 25,
      //               ),
      //               Text(
      //                 'We are updating the server to make the\nexperience better for you.',
      //                 textAlign: TextAlign.center,
      //                 style: kBlackMediumStyle,
      //               ),
      //               Column(
      //                 children: [
      //                   Text(
      //                     'Please try again in',
      //                     style: kBlackMediumStyle,
      //                   ),
      //                   Text(
      //                     '30 mins',
      //                     style: kBlackDarkSuperLargeStyle,
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //         GradientButton(
      //           text: 'Close',
      //           width: false,
      //           onTap: () {
      //             Get.back();
      //           },
      //           widthSize: Get.width - 20,
      //           buttonState: ButtonState.idle,
      //         ),
      //         const SizedBox(
      //           height: 20,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
