import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/login_controller.dart';
import 'package:parrotpos/screens/login/sign_up/sign_up_screen_3.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class SignUpScreen21 extends StatefulWidget {
  final Map map;
  const SignUpScreen21({Key? key, required this.map}) : super(key: key);

  @override
  _SignUpScreen21State createState() => _SignUpScreen21State();
}

class _SignUpScreen21State extends State<SignUpScreen21> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());

  late String email;
  ButtonState btnState = ButtonState.idle;
  ButtonState resendBtnState = ButtonState.idle;
  bool isOtpSent = false;
  bool isOtpEnter = false;
  bool isVerified = false;
  String? otp;
  bool isOtpFilled = false;
  bool isResend = false;
  late Timer timer;
  late int _timer;
  late String sessionId;
  int sentOtpCount = 0;

  @override
  void initState() {
    super.initState();

    email = widget.map['email'];
  }

  verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        // startTimer();
        // is = true;
        btnState = ButtonState.loading;
      });

      String? res = await loginController.emailVerification({
        "session_id": sessionId,
        "otp": otp,
      });
      if (res!.isEmpty) {
        //logged in
        setState(() {
          btnState = ButtonState.idle;
          resendBtnState = ButtonState.idle;
          isVerified = true;
        });
      } else {
        //failed
        setState(() {
          btnState = ButtonState.idle;
        });

        errorSnackbar(title: "Verification Failed", subtitle: res);
      }
    }
  }

  requestOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        btnState = ButtonState.loading;
      });
      print({
        "email": email,
        "password": widget.map['password'],
        "name": widget.map['name'],
        "phone_number": widget.map['phone_number'],
        "country_iso": Config().countryIso,
        "country_code": Config().countryCode,
      });

      Map? res = await loginController.signUp({
        "email": email,
        "password": widget.map['password'],
        "name": widget.map['name'],
        "phone_number": widget.map['phone_number'],
        "country_iso": Config().countryIso,
        "country_code": Config().countryCode,
      });
      print(res);

      if (res!['status'] == 200) {
        //sign up complete

        sessionId = res['session_id'];

        setState(() {
          // startTimer();
          isOtpSent = true;
          btnState = ButtonState.idle;
          sentOtpCount++;
        });
      } else {
        //failed
        setState(() {
          btnState = ButtonState.idle;
        });
        errorSnackbar(title: "Signup Failed", subtitle: res['message']);
      }
    }
  }

  resendOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        resendBtnState = ButtonState.loading;
      });

      Map? res = await loginController.signUp({
        "email": email,
        "password": widget.map['password'],
        "name": widget.map['name'],
        "phone_number": widget.map['phone_number'],
        "country_iso": Config().countryIso,
        "country_code": Config().countryCode,
      });
      print(res);

      if (res!['status'] == 200) {
        //sign up complete

        sessionId = res['session_id'];

        setState(() {
          sentOtpCount++;

          isResend = false;
          timer.cancel();

          startTimer();
          isOtpSent = true;
          resendBtnState = ButtonState.idle;
        });
      } else {
        //failed
        setState(() {
          resendBtnState = ButtonState.idle;
        });
        errorSnackbar(title: "Signup Failed", subtitle: res['message']);
      }
    }
  }

  void startTimer() {
    _timer = 60;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timer--;
        if (_timer == 0) {
          timer.cancel();
          if (sentOtpCount == 2) {
            taskCompletedDialog(
              title: 'Still didn\'t receive OTP? We will contact you soon.',
              buttonTitle: 'Ok',
              image: 'assets/icons/change_phone_dl.png',
              context: context,
            );
            // sentOtpCount = 0;
          } else {
            isResend = true;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Verify Email ID",
          style: kBlackLargeStyle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: isVerified
            ? ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Image.asset(
                    'assets/images/signup/email_verified.png',
                    width: Get.width * 0.5,
                    height: Get.width * 0.5,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Center(
                      child: CircleAvatar(
                    radius: 20,
                    backgroundColor: kColorPrimary,
                    child: Icon(
                      Icons.done,
                      color: kWhite,
                      size: 22,
                    ),
                  )),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Text(
                      'Your email has been verified.\nClick "Next" to login and proceed.',
                      style: kBlackMediumStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GradientButton(
                    text: 'Next',
                    width: true,
                    onTap: () {
                      Get.offAll(() => const SignUpScreen3());
                    },
                    widthSize: Get.width,
                    buttonState: ButtonState.idle,
                  ),
                ],
              )
            : isOtpSent
                ? isOtpEnter
                    ? ListView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        children: [
                          Center(
                            child: Text(
                              'Enter OTP sent to your email:',
                              style: kBlackMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              email,
                              style: kRedDarkMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          OtpTextField(
                            keyboardType: TextInputType.number,
                            textStyle: kBlackLargeStyle,
                            borderColor: kColorPrimary,
                            focusedBorderColor: kColorPrimary,
                            numberOfFields: 4,
                            showFieldAsBox: true,
                            borderRadius: BorderRadius.circular(12),
                            onSubmit: (value) {
                              print(value);
                              otp = value;

                              setState(() {
                                isOtpFilled = true;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              '$_timer seconds',
                              style: kBlackLightExtraLargeStyle,
                            ),
                          ),
                          Center(
                            child: Text(
                              '(Time remaining)',
                              style: kBlackSmallLightMediumStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(thickness: 0.30),
                          const SizedBox(
                            height: 10,
                          ),
                          //TODO: NEW METHOD
                          isResend
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        'Did not receive OTP in your email?',
                                        style: kBlackSmallLightMediumStyle,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GradientButton(
                                      text: 'Resend',
                                      borderRadius: 20,
                                      width: true,
                                      onTap: () {
                                        //resend otp
                                        setState(() {
                                          resendOtp();
                                        });
                                      },
                                      widthSize: Get.width,
                                      buttonState: resendBtnState,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(thickness: 0.30),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        'Is this a correct email id?',
                                        style: kBlackSmallLightMediumStyle,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Spacer(),
                                          const SizedBox(
                                            width: 45,
                                          ),
                                          Text(
                                            email,
                                            style: kBlackLightMediumStyle,
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isOtpSent = false;
                                                isResend = false;
                                                isOtpEnter = false;
                                                isOtpFilled = false;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 5, right: 3),
                                              child: Image.asset(
                                                'assets/images/edit.png',
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'Did not receive OTP in your email?',
                                        style: kBlackSmallLightMediumStyle,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GradientButton(
                                      text: 'Resend',
                                      width: true,
                                      borderRadius: 20,
                                      btnColor: true,
                                      color: Colors.black.withOpacity(0.08),
                                      onTap: () {},
                                      widthSize: Get.width,
                                      buttonState: ButtonState.idle,
                                    ),
                                    sentOtpCount == 2
                                        ? Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Divider(thickness: 0.30),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: Text(
                                                  'Is this a correct email id?',
                                                  style: kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: const Offset(0, 0),
                                                    ),
                                                  ],
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    const Spacer(),
                                                    const SizedBox(
                                                      width: 45,
                                                    ),
                                                    Text(
                                                      email,
                                                      style: kBlackLightMediumStyle,
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          isOtpSent = false;
                                                          isResend = false;
                                                          isOtpEnter = false;
                                                          isOtpFilled = false;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 5, right: 3),
                                                        child: Image.asset(
                                                          'assets/images/edit.png',
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(thickness: 0.30),

                          const SizedBox(
                            height: 25,
                          ),
                          isOtpFilled
                              ? GradientButton(
                                  text: 'Verify',
                                  width: true,
                                  onTap: () {
                                    if (otp != null) {
                                      verifyOtp();
                                    }
                                  },
                                  widthSize: Get.width,
                                  buttonState: btnState,
                                )
                              : GradientButton(
                                  text: 'Verify',
                                  width: true,
                                  btnColor: true,
                                  color: kBlackExtraLightColor,
                                  onTap: () {},
                                  widthSize: Get.width,
                                  buttonState: ButtonState.idle,
                                ),
                        ],
                      )
                    : ListView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        children: [
                          Image.asset(
                            'assets/images/signup/verify_email.png',
                            width: Get.width * 0.5,
                            height: Get.width * 0.5,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: Text(
                              'An OTP has been sent to',
                              style: kBlackMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Text(
                              email,
                              style: kRedDarkMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Text(
                              'Be sure to also check your spam inbox.',
                              style: kRedMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          GradientButton(
                            text: 'Enter OTP',
                            width: true,
                            onTap: () {
                              setState(() {
                                isOtpEnter = true;
                              });

                              startTimer();
                            },
                            widthSize: Get.width,
                            buttonState: btnState,
                          ),
                        ],
                      )
                : ListView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    children: [
                      // Text(
                      //   'Enter Your Phone Number',
                      //   style: kBlackExtraLargeStyle,
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      Center(
                        child: Text(
                          'An OTP will be sent to this email for verification purposes.\nPlease confirm your email ID.',
                          textAlign: TextAlign.center,
                          style: kBlackSmallMediumStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Email address is required';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          // if (!RegExp(
                          //         r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                          //     .hasMatch(value.removeAllWhitespace)) {
                          //   return 'Please enter a valid email address';
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          email = val!.trim();
                        },
                        initialValue: email,
                        enableInteractiveSelection: true,
                        style: kBlackMediumStyle,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                          helperStyle: kRedSmallLightMediumStyle,
                          errorStyle: kRedSmallLightMediumStyle,
                          hintStyle: kBlackSmallLightMediumStyle,
                          hintText: 'Email address',
                          labelStyle: kRedSmallLightMediumStyle,
                          fillColor: kWhite,
                          filled: true,
                          suffixIcon: const Icon(
                            Icons.edit,
                            size: 18,
                            color: kBlackLightColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.black38, width: 0.3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: kTextboxBorderColor, width: 1.4),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GradientButton(
                        text: 'Verify Email',
                        width: true,
                        onTap: () {
                          requestOtp();
                        },
                        widthSize: Get.width,
                        buttonState: btnState,
                      ),
                    ],
                  ),
      ),
    );
  }
}
