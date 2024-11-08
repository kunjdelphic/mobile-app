import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parrotpos/controllers/login_controller.dart';
import 'package:parrotpos/screens/main_home.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';

import 'package:get/get.dart';
import 'package:parrotpos/widgets/dialogs/sheets.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class SignUpScreen4 extends StatefulWidget {
  const SignUpScreen4({Key? key}) : super(key: key);

  @override
  _SignUpScreen4State createState() => _SignUpScreen4State();
}

class _SignUpScreen4State extends State<SignUpScreen4> {
  final LoginController loginController = Get.put(LoginController());

  late String phoneNo;
  ButtonState loginBtnState = ButtonState.idle;
  bool isConfirmed = false;
  File? selectedImage;

  signup() async {
    print('uploading');

    if (selectedImage != null) {
      setState(() {
        loginBtnState = ButtonState.loading;
      });

      String? res = await loginController.uploadProfileImage({
        "image": selectedImage,
      });
      if (res!.isEmpty) {
        //sign up complete
        setState(() {
          loginBtnState = ButtonState.idle;
          isConfirmed = true;
        });
        // showTermsDialog();
      } else {
        //failed
        setState(() {
          loginBtnState = ButtonState.idle;
        });
        errorSnackbar(title: "Signup Failed", subtitle: res);
      }
    }
  }

  // showTermsDialog() async {
  //   var res = await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return const TermsDialog();
  //     },
  //   );
  //   if (res != null) {
  //     //success
  //     Get.offAll(() => const MainHome());
  //   } else {
  //     //cancelled

  //   }
  //   return;
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,

        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        // title: Text(
        //   "Join ParrotPos",
        //   style: kBlackLargeStyle,
        // ),
      ),
      body: isConfirmed
          ? ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                Center(
                  child: Text(
                    'Your profile created\nsuccessfully!',
                    textAlign: TextAlign.center,
                    style: kBlackLargeStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    width: size.width * 0.36,
                    height: size.width * 0.36,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            radius: size.width * 0.16,
                            child: selectedImage != null
                                ? Image.file(selectedImage!)
                                : Image.asset(
                                    'assets/images/referral/ic_profile.png',
                                  ),
                          ),
                        ),
                        Positioned(
                          width: size.width * 0.32,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: const CircleAvatar(
                              radius: 17,
                              backgroundColor: kColorPrimary,
                              child: Icon(
                                Icons.done,
                                color: kWhite,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                GradientButton(
                  text: 'Next',
                  width: true,
                  onTap: () {
                    //sign up

                    // showTermsDialog();
                    Get.offAll(() => const MainHome());
                  },
                  widthSize: size.width - 20,
                  buttonState: loginBtnState,
                )
              ],
            )
          : ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                Center(
                  child: Text(
                    'Add your picture',
                    style: kBlackLargeStyle,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    width: size.width * 0.36,
                    height: size.width * 0.36,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            radius: size.width * 0.16,
                            child: selectedImage != null
                                ? Image.file(selectedImage!)
                                : Image.asset(
                                    'assets/images/referral/ic_profile.png',
                                  ),
                          ),
                        ),
                        selectedImage != null
                            ? Positioned(
                                width: size.width * 0.32,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    var res = await addPictureSheet(
                                      context,
                                      false,
                                    );
                                    if (res != null) {
                                      selectedImage = res;
                                      setState(() {});
                                    }
                                  },
                                  child: const CircleAvatar(
                                    radius: 17,
                                    backgroundColor: kColorPrimary,
                                    child: Icon(
                                      Icons.edit,
                                      color: kWhite,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              )
                            : Positioned(
                                width: size.width * 0.32,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    var res = await addPictureSheet(
                                      context,
                                      false,
                                    );
                                    if (res != null) {
                                      selectedImage = res;
                                      setState(() {});
                                    }
                                  },
                                  child: const CircleAvatar(
                                    radius: 17,
                                    backgroundColor: kColorPrimary,
                                    child: Icon(
                                      Icons.add,
                                      color: kWhite,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                selectedImage != null
                    ? GradientButton(
                        text: 'Next',
                        width: true,
                        onTap: () {
                          signup();
                        },
                        widthSize: size.width - 20,
                        buttonState: loginBtnState,
                      )
                    : GradientButton(
                        text: 'Add Picture',
                        width: true,
                        onTap: () async {
                          var res = await addPictureSheet(
                            context,
                            false,
                          );
                          if (res != null) {
                            selectedImage = res;
                            setState(() {});
                          }
                        },
                        widthSize: size.width - 20,
                        buttonState: loginBtnState,
                      ),
                const SizedBox(
                  height: 20,
                ),
                WhiteButton(
                  text: 'Skip',
                  width: true,
                  widthSize: size.width,
                  onTap: () {
                    // showTermsDialog();
                    Get.offAll(() => const MainHome());
                  },
                ),
              ],
            ),
    );
  }
}
