import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/user_profile/wallet/earning_wallet/wallet_activation/phone_no_otp_report_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/completed_dialog.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class EW2Screen extends StatefulWidget {
  const EW2Screen({Key? key}) : super(key: key);

  @override
  _EW2ScreenState createState() => _EW2ScreenState();
}

class _EW2ScreenState extends State<EW2Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneNo = '';
  ButtonState resendBtnState = ButtonState.idle;
  ButtonState loginBtnState = ButtonState.idle;
  bool isOtpSent = false;
  String? otp;
  bool isOtpFilled = false;
  Timer? timer;
  bool isResend = false;
  late int _timer;
  int sentOtpCount = 0;
  late String verificationCode;
  UserProfileController userProfileController = Get.find();

  @override
  void initState() {
    super.initState();

    phoneNo = userProfileController.userProfile.value.data!.phoneNumber ?? '';
  }

  requestOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        // startTimer();
        // isOtpSent = true;
        // sentOtpCount++;
        loginBtnState = ButtonState.loading;
      });

      verifyPhoneNo();
    }
  }

  verifyPhoneNo() async {
    try {
      print('PHONE NO :: $phoneNo');
      // setState(() {
      //   error = null;
      //   codeSend = true;
      // });

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+' + Config().countryCode + phoneNo,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            print('failed');
            print('Message: ${e.message}');
            print('Code: ${e.code}');

            setState(() {
              loginBtnState = ButtonState.idle;
              errorSnackbar(
                  title: 'Failed', subtitle: 'Error sending the OTP!');
            });
          },
          codeSent: (String verficationID, int? resendToken) {
            print('CODE SENT');
            print(verficationID);
            setState(() {
              startTimer();
              isOtpSent = true;
              sentOtpCount++;
              verificationCode = verficationID;

              loginBtnState = ButtonState.idle;
            });
          },
          codeAutoRetrievalTimeout: (String verificationID) {
            setState(() {
              verificationCode = verificationID;
            });
          },
          timeout: const Duration(seconds: 59));
    } catch (e) {
      print(e);
      setState(() {
        loginBtnState = ButtonState.idle;
        errorSnackbar(title: 'Failed', subtitle: 'Error sending the OTP!');
      });
    }
  }

  updateAccountVerificationStatus(String type) async {
    return await userProfileController.updateAccountVerStatus({
      'type': type,
      'phoneNo': phoneNo,
    });
    // if (res!.isEmpty) {
    //   //updated
    //   setState(() {
    //     continueBtnState = ButtonState.idle;
    //   });
    // } else {
    //   //failed
    //   setState(() {
    //     continueBtnState = ButtonState.idle;
    //   });

    //   errorSnackbar(
    //       title: "Failed", subtitle: 'Updating number was unsuccessful!');
    // }
  }

  matchOtp() async {
    // bool net = false;
    // net = await internetCheck();
    // if (net) {
    setState(() {
      loginBtnState = ButtonState.loading;
    });
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: otp!);
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      if (authResult.user != null) {
        print('');
        print('PHONE AUTH UID :: ' + authResult.user!.uid);
        print('PHONE AUTH CREDENTIALS :: ' + authCredential.toString());
        print('');
        var x = await updateAccountVerificationStatus('PHONE_NUMBER');
        setState(() {
          loginBtnState = ButtonState.idle;
        });
        if (x != 'Failed') {
          taskCompletedDialog(
            title: 'Verified!',
            buttonTitle: 'Next',
            image: 'assets/images/tick.png',
            context: context,
            onTap: () {
              Get.back();

              Get.back(result: true);
            },
            subtitle: 'Your phone number successfully verified',
          );
        } else {
          errorSnackbar(
              title: 'Failed', subtitle: 'Phone Number already registered');
        }

        userProfileController.getUserDetails();
      } else {
        setState(() {
          loginBtnState = ButtonState.idle;
          errorSnackbar(
              title: 'Failed', subtitle: 'Unable to verify the number!');
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loginBtnState = ButtonState.idle;
        errorSnackbar(title: 'Failed', subtitle: 'OTP is incorrect!');
      });
    }
  }

  void startTimer() {
    _timer = 60;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timer--;
      });
      if (_timer == 0) {
        timer.cancel();
        isResend = true;
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();

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
          "Phone Number Verification",
          style: kBlackLargeStyle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: isOtpSent
            ? ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Text(
                    'Enter OTP Number',
                    style: kBlackExtraLargeStyle,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'An OTP has been sent to $phoneNo',
                    style: kBlackSmallLightMediumStyle,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  OtpTextField(
                    keyboardType: TextInputType.number,
                    textStyle: kBlackLargeStyle,
                    borderColor: kColorPrimary,
                    focusedBorderColor: kColorPrimary,
                    numberOfFields: 6,
                    showFieldAsBox: true,
                    borderRadius: BorderRadius.circular(12),
                    onCodeChanged: (value) {
                      if (value.length < 6) {
                        setState(() {
                          isOtpFilled = false;
                        });
                      }
                    },
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
                  sentOtpCount == 2 && isResend
                      ? Column(
                          children: [
                            Center(
                              child: Text(
                                'Still did not receive OTP?',
                                style: kBlackSmallLightMediumStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                'Let us know by clicking "Send Report".',
                                style: kBlackLightMediumStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Center(
                              child: Text(
                                'Did not receive OTP in your phone?',
                                style: kBlackSmallLightMediumStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            isResend
                                ? GradientButton(
                                    text: 'Resend',
                                    borderRadius: 20,
                                    width: true,
                                    onTap: () {
                                      //resend otp
                                      setState(() {
                                        requestOtp();
                                        isResend = false;
                                      });
                                    },
                                    widthSize: Get.width,
                                    buttonState: resendBtnState,
                                  )
                                : GradientButton(
                                    text: 'Resend',
                                    width: true,
                                    borderRadius: 20,
                                    btnColor: true,
                                    color: Colors.black.withOpacity(0.08),
                                    onTap: () {},
                                    widthSize: Get.width,
                                    buttonState: ButtonState.idle,
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(thickness: 0.30),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            isResend
                                ? Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          'Is this number correct?',
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
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Spacer(),
                                            const SizedBox(
                                              width: 45,
                                            ),
                                            Text(
                                              phoneNo,
                                              style: kBlackLightMediumStyle,
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isOtpSent = false;
                                                  isResend = false;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, right: 3),
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
                                        height: 25,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                  isOtpFilled
                      ? GradientButton(
                          text: 'Complete',
                          width: true,
                          onTap: () {
                            if (otp != null) {
                              matchOtp();
                            }
                          },
                          widthSize: Get.width,
                          buttonState: loginBtnState,
                        )
                      : sentOtpCount == 2 && isResend
                          ? GradientButton(
                              text: 'Send Report',
                              width: true,
                              onTap: () async {
                                //send report
                                var res =
                                    await Get.to(() => PhoneNoOtpReportScreen(
                                          phoneNo: phoneNo,
                                        ));
                                if (res != null) {
                                  if (res) {
                                    //reported
                                    Get.back(result: false);
                                  }
                                }
                              },
                              widthSize: Get.width,
                              buttonState: loginBtnState,
                            )
                          : GradientButton(
                              text: 'Next',
                              width: true,
                              onTap: () {},
                              color: kBlackExtraLightColor,
                              btnColor: true,
                              widthSize: Get.width,
                              buttonState: ButtonState.idle,
                            ),
                ],
              )
            : ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Text(
                    'Enter Your Phone Number',
                    style: kBlackExtraLargeStyle,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'An OTP will be sent to your phone number for verification purposes',
                    style: kBlackSmallLightMediumStyle,
                  ),
                  const SizedBox(
                    height: 15,
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
                      // phoneNo = '${Config().countryCode}$phoneNo';
                    },
                    // textAlign: TextAlign.center,
                    initialValue: phoneNo,
                    enableInteractiveSelection: true,
                    style: kBlackMediumStyle,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 14),
                      helperStyle: kRedSmallLightMediumStyle,
                      errorStyle: kRedSmallLightMediumStyle,
                      hintStyle: kBlackSmallLightMediumStyle,
                      hintText: 'Eg: 123456789',
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
                  GradientButton(
                    text: 'Request OTP',
                    width: true,
                    onTap: () {
                      requestOtp();
                    },
                    widthSize: Get.width,
                    buttonState: loginBtnState,
                  ),
                ],
              ),
      ),
    );
  }
}
