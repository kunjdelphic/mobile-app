import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parrotpos/style/style.dart';
import 'package:progress_state_button/progress_button.dart';

import '../widgets/buttons/gradient_button.dart';

class ServerUpgradeScreen extends StatelessWidget {
  const ServerUpgradeScreen({Key? key}) : super(key: key);

//  final image, title, sutitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Image.asset(
                      'assets/images/server_upgrade.png',
                      width: Get.width * 0.8,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'We are updating the server to make the\nexperience better for you.',
                      textAlign: TextAlign.center,
                      style: kBlackMediumStyle,
                    ),
                    Column(
                      children: [
                        Text(
                          'Please try again in',
                          style: kBlackMediumStyle,
                        ),
                        Text(
                          '30 mins',
                          style: kBlackDarkSuperLargeStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GradientButton(
                text: 'Close',
                width: false,
                onTap: () {
                  SystemNavigator.pop();
                },
                widthSize: Get.width - 20,
                buttonState: ButtonState.idle,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
