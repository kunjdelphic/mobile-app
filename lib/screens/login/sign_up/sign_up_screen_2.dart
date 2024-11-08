import 'package:flutter/material.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/login_controller.dart';
import 'package:parrotpos/screens/login/sign_up/sign_up_screen_21.dart';
import 'package:parrotpos/screens/main_home.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';

import 'package:get/get.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

import 'sign_up_screen_3.dart';

class SignUpScreen2 extends StatefulWidget {
  final Map map;
  const SignUpScreen2({Key? key, required this.map}) : super(key: key);

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final LoginController loginController = Get.put(LoginController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String phoneNo;
  ButtonState loginBtnState = ButtonState.idle;
  bool isConfirmed = false;

  signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        loginBtnState = ButtonState.loading;
      });

      print({
        "email": widget.map['email'],
        "password": widget.map['password'],
        "name": widget.map['name'],
        "phone_number": phoneNo,
        "country_iso": Config().countryIso,
        "country_code": Config().countryCode,
      });

      Get.off(() => SignUpScreen21(
            map: {
              "email": widget.map['email'],
              "password": widget.map['password'],
              "name": widget.map['name'],
              "phone_number": phoneNo,
              "country_iso": Config().countryIso,
              "country_code": Config().countryCode,
            },
          ));

      // Map? res = await loginController.signUp({
      //   "email": widget.map['email'],
      //   "password": widget.map['password'],
      //   "name": widget.map['name'],
      //   "phone_number": phoneNo,
      //   "country_iso": Config().countryIso,
      //   "country_code": Config().countryCode,
      // });
      // if (res!['status'] == 200) {
      //   //sign up complete

      //   Get.off(() => SignUpScreen21(
      //         map: {
      //           "email": widget.map['email'],
      //           "password": widget.map['password'],
      //           "name": widget.map['name'],
      //           "phone_number": phoneNo,
      //           "country_iso": Config().countryIso,
      //           "country_code": Config().countryCode,
      //         },
      //       ));
      // } else {
      //   //failed
      //   setState(() {
      //     loginBtnState = ButtonState.idle;
      //   });
      //   errorSnackbar(title: "Signup Failed", subtitle: res['message']);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Join ParrotPos",
          style: kBlackLargeStyle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: isConfirmed
            ? ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Center(
                    child: Text(
                      'Confirm your Number',
                      style: kBlackMediumStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!value.trim().startsWith('01')) {
                        return 'Phone number is invalid';
                      }
                      if (value.trim().length < 10 ||
                          value.trim().length > 11) {
                        return 'Phone number is invalid';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      phoneNo = val!.trim();
                    },
                    textAlign: TextAlign.center,
                    readOnly: true,
                    enableInteractiveSelection: true,
                    style: kBlackMediumStyle,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 14),
                      helperStyle: kRedSmallLightMediumStyle,
                      errorStyle: kRedSmallLightMediumStyle,
                      hintStyle: kRedSmallLightMediumStyle,
                      hintText: 'Eg: 0123456789',
                      labelStyle: kRedSmallLightMediumStyle,
                      fillColor: kWhite,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 0.3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: kTextboxBorderColor, width: 1.4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isConfirmed = false;
                      });
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
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'We will send a verification code\nto this phone number.',
                      textAlign: TextAlign.center,
                      style: kBlackSmallLightMediumStyle,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  GradientButton(
                    text: 'Next',
                    width: true,
                    onTap: () {
                      signup();
                    },
                    widthSize: size.width - 20,
                    buttonState: loginBtnState,
                  ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // Text(
                  //   'Don\'t have an account?',
                  //   textAlign: TextAlign.center,
                  //   style: kBlackMediumStyle,
                  // ),
                  // const Divider(thickness: 0.30),
                  // Image.asset(
                  //   'assets/images/logo/parrotpos_logo.png',
                  //   // width: size.width * 0.2,
                  //   height: 25,
                  // ),
                ],
              )
            : ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Center(
                    child: Text(
                      'Fill up your Phone Number',
                      style: kBlackMediumStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!value.trim().startsWith('01')) {
                        return 'Phone number is invalid';
                      }
                      if (value.trim().length < 10 ||
                          value.trim().length > 11) {
                        return 'Phone number is invalid';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      phoneNo = val!.trim();
                    },
                    textAlign: TextAlign.center,
                    enableInteractiveSelection: true,
                    style: kBlackMediumStyle,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 14),
                      helperStyle: kRedSmallLightMediumStyle,
                      errorStyle: kRedSmallLightMediumStyle,
                      hintStyle: kRedSmallLightMediumStyle,
                      hintText: 'Eg: 0123456789',
                      labelStyle: kRedSmallLightMediumStyle,
                      fillColor: kWhite,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 0.3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: kTextboxBorderColor, width: 1.4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'We will send a verification code\nto this phone number.',
                      textAlign: TextAlign.center,
                      style: kBlackSmallLightMediumStyle,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  GradientButton(
                    text: 'Next',
                    width: true,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        setState(() {
                          isConfirmed = true;
                        });
                      }
                    },
                    widthSize: size.width - 20,
                    buttonState: loginBtnState,
                  ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // Text(
                  //   'Don\'t have an account?',
                  //   textAlign: TextAlign.center,
                  //   style: kBlackMediumStyle,
                  // ),
                  // const Divider(thickness: 0.30),
                  // Image.asset(
                  //   'assets/images/logo/parrotpos_logo.png',
                  //   // width: size.width * 0.2,
                  //   height: 25,
                  // ),
                ],
              ),
      ),
    );
  }
}
