import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:parrotpos/screens/login/login_screen.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../controllers/internet_controller.dart';
import 'sign_up/sign_up_screen.dart';

class OldLoginScreen extends StatefulWidget {
  const OldLoginScreen({Key? key}) : super(key: key);

  @override
  _OldLoginScreenState createState() => _OldLoginScreenState();
}

class _OldLoginScreenState extends State<OldLoginScreen> {
  @override
  Widget build(BuildContext context) {
    final _c = Get.put(InternetController());
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          leading: const BackButton(),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Sign in or Sign up",
            style: kBlackLargeStyle,
          ),
        ),
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back_ios_new_rounded),
        //     onPressed: () {
        //       Get.back();
        //     },
        //   ),
        //   title: Text(
        //     'Sign in or Sign up',
        //     style: kBlackTitleStyle20,
        //   ),
        // ),
        body: Column(
          children: [
            SafeArea(
                child: Image.asset(
              'assets/images/logo/login_logo@2x.png',
              width: Get.width,
            )),
            const Spacer(),
            Text(
              'Don\'t have an account?',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 15,
            ),
            GradientButton(
              text: "Sign up",
              width: false,
              widthSize: 0,
              onTap: () => Get.to(() => const SignUpScreen()),
              buttonState: ButtonState.idle,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Already have an account?',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 15,
            ),
            WhiteButton(
              text: 'Login',
              width: false,
              widthSize: 0,
              onTap: () {
                Get.to(() => const LoginScreen());
              },
            ),
            const SizedBox(
              height: 30,
            ),
            // Platform.isIOS
            //     ?/
            InkWell(
              onTap: () {
                Get.back();
              },
              child: const Text(
                "Back",
                style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
              ),
            ),
            // : Container(),
            const Spacer(),
          ],
        ));
  }
}
