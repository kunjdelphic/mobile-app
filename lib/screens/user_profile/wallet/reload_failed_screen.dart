import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../notification/server_maintainance_screen.dart';

class ReloadFailedScreen extends StatefulWidget {
  const ReloadFailedScreen({Key? key}) : super(key: key);

  @override
  _ReloadFailedScreenState createState() => _ReloadFailedScreenState();
}

class _ReloadFailedScreenState extends State<ReloadFailedScreen> {
  @override
  Widget build(BuildContext context) {
    return ServerMaintenanceScreen();
    Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Payment Status",
          style: kBlackLargeStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Center(
            child: Text(
              'Reload Failed',
              style: kRedSuperLargeStyle,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            'assets/images/wallet/wallet_reload_failed.png',
            width: Get.width * 0.6,
            height: Get.width * 0.6,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Center(
              child: Text(
                'If your amount is deducted, it will be transferred back soon.',
                textAlign: TextAlign.center,
                style: kBlackMediumStyle,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GradientButton(
            text: 'Close',
            width: true,
            widthSize: Get.width * 0.5,
            buttonState: ButtonState.idle,
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
