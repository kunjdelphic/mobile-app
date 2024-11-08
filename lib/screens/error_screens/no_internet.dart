import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../style/style.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/buttons/white_button.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

var buttonstate = ButtonState.idle;

class _NoInternetState extends State<NoInternet> {
  @override
  void initState() {
    buttonstate = ButtonState.idle;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange,
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(),
                    Text(
                      'No Internet Connection...',
                      style: kRedDarkSuperLargeStyle,
                    ),
                    Image.asset(
                      'assets/images/no_internet.png',
                      width: Get.width * 0.8,
                    ),
                    Text(
                      'You are not connected to the internet\nMake sure you connect and try again.',
                      textAlign: TextAlign.center,
                      style: kBlackDarkLargeStyle,
                    ),
                    GradientButton(
                      text: 'Retry',
                      width: false,
                      onTap: () {
                        setState(() {
                          buttonstate = ButtonState.loading;
                        });

                        Timer(const Duration(seconds: 3), () {
                          setState(() {
                            buttonstate = ButtonState.fail;
                          });
                        });
                      },
                      widthSize: Get.width - 20,
                      buttonState: buttonstate,
                    ),
                    WhiteButton(
                      text: 'Close',
                      width: false,
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      widthSize: Get.width - 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              // GradientButton(
              //   text: 'Retry',
              //   width: false,
              //   onTap: () {
              //     // Get.back();
              //   },
              //   widthSize: Get.width - 20,
              //   buttonState: ButtonState.idle,
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // WhiteButton(
              //   text: 'Close',
              //   width: false,
              //   onTap: () {
              //     Get.back();
              //   },
              //   widthSize: Get.width - 20,
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
