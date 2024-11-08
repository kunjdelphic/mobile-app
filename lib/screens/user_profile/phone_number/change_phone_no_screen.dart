import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/user_profile/wallet/earning_wallet/wallet_activation/phone_no_otp_report_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';

import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../widgets/buttons/white_button.dart';
import '../report_and_feedback/feedback_screen.dart';

class ChangePhoneNoScreen extends StatefulWidget {
  const ChangePhoneNoScreen({Key? key}) : super(key: key);

  @override
  _ChangePhoneNoScreenState createState() => _ChangePhoneNoScreenState();
}

class _ChangePhoneNoScreenState extends State<ChangePhoneNoScreen> {
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
  // final userProfileController = Get.put(UserProfileController());
  requestOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        loginBtnState = ButtonState.loading;
      });

      verifyPhoneNo();
    }
  }

  verifyPhoneNo() async {
    try {
      print('+*+*+*+*+*+*+*+ PHONE NO :: $phoneNo');

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+' + Config().countryCode + phoneNo,
          verificationCompleted: (PhoneAuthCredential credent0123456ial) async {},
          verificationFailed: (FirebaseAuthException e) {
            print('failed');
            print('Message: ${e.message}');
            print('Code: ${e.code}');

            setState(() {
              loginBtnState = ButtonState.idle;
              errorSnackbar(title: 'Failed', subtitle: 'Error sending the OTP!');
            });
          },
          codeSent: (String verficationID, int? resendToken) {
            print('+++++++ CODE SENT');
            print("111111111111111 ${verficationID}");
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
    print("this run");
    return await userProfileController.updateAccountVerStatus({
      'type': type,
      'phoneNo': phoneNo,
    });
  }

  matchOtp() async {
    // bool net = false;
    // net = await internetCheck();
    // if (net) {
    setState(() {
      loginBtnState = ButtonState.loading;
    });
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(verificationId: verificationCode, smsCode: otp!);
      UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(authCredential);
      print(authResult.user);
      print("=====================");
      if (authResult.user != null) {
        var x = await updateAccountVerificationStatus('PHONE_NUMBER');
        setState(() {
          loginBtnState = ButtonState.idle;
        });
        print("pkg $x");
        if (x == 'Failed') {
          errorSnackbar(title: 'Failed', subtitle: 'Phone Number is already registered');
        } else {
          taskCompletedDialog(
            title: 'Update Successful!',
            buttonTitle: 'Ok',
            image: 'assets/images/tick.png',
            context: context,
            onTap: () {
              Get.back();

              userProfileController.getUserDetails();

              Get.back(result: true);
            },
            // subtitle: 'Your phone number successfully updated',
          );
        }
      } else {
        setState(() {
          loginBtnState = ButtonState.idle;
          errorSnackbar(title: 'Failed', subtitle: 'Unable to verify the number!');
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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Colors.white,
        // centerTitle: true,
        title: Text(
          "Phone Number",
          style: kBlackLargeStyle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: isOtpSent
            ? ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                'Did not receive OTP in your email?',
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
                                var res = await Get.to(() => PhoneNoOtpReportScreen(
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/phone.png',
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Update Phone Number ?',
                        style: kBlackExtraLargeStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Your phone number will be used to Recover forgotten password,Send & receive money. Make sure you entered  the correct phone number.',
                          style: kBlackSmallLightMediumStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: TextFormField(
                          // cursorColor: kTextboxBorderColor,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Phone number is required';
                            }
                            if (!value.trim().startsWith('01')) {
                              return 'Phone number is invalid';
                            }
                            if (value.trim().length < 10 || value.trim().length > 11) {
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
                          // style: kBlackMediumStyle,
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                            helperStyle: kRedSmallLightMediumStyle,
                            errorStyle: kRedSmallLightMediumStyle,
                            hintStyle: kBlackSmallLightMediumStyle,
                            hintText: 'Enter Phone Number Here',
                            labelStyle: kRedSmallLightMediumStyle,
                            fillColor: kWhite,
                            filled: true,
                            // enabledBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(12.0),
                            //   borderSide: const BorderSide(
                            //       color: Colors.black38, width: 0.3),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(12.0),
                            //   borderSide: const BorderSide(
                            //       color: kTextboxBorderColor, width: 1.4),
                            // ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(12.0),
                            // ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            splashColor: Colors.blueAccent,
                            highlightColor: Colors.blue.withOpacity(0.3),
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 45,
                              width: 170,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(12), boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 4),
                                ),
                              ]),
                              child: const Text(
                                "Back",
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          GradientButton(
                              text: "Update",
                              width: true,
                              onTap: () async {
                                setState(() {});
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  setState(() {
                                    loginBtnState = ButtonState.loading;
                                  });
                                  var x = await updateAccountVerificationStatus('PHONE_NUMBER');
                                  if (x == 'Failed') {
                                    // errorSnackbar(
                                    //     title: 'Failed',
                                    //     subtitle:
                                    //         'Phone Number is already registered');
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                                          elevation: 5.0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Image.asset(
                                                    'assets/icons/change_phone_dl.png',
                                                    width: Get.width * 0.2,
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text('${phoneNo}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
                                                  const SizedBox(
                                                    height: 15.0,
                                                  ),
                                                  Text(
                                                    'This phone number was used by other user. if you are sure this is your number then contact support !',
                                                    style: kBlackSmallMediumStyle,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: WhiteButton(
                                                          text: 'Yes',
                                                          width: false,
                                                          widthSize: 0,
                                                          onTap: () {
                                                            Get.back();
                                                            Get.to(() => const FeedbackScreen());
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: GradientButton(
                                                          text: 'No',
                                                          btnColor: true,
                                                          width: false,
                                                          widthSize: 0,
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          buttonState: ButtonState.idle,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    if (x == "Failed") {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                            ),
                                            // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                                            elevation: 5.0,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Image.asset(
                                                      'assets/icons/change_phone_dl.png',
                                                      width: Get.width * 0.2,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text('${userProfileController.userProfile.value.data!.phoneNumber}',
                                                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
                                                    const SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Text(
                                                      'This phone number was used by other user. if you are sure this is your number then contact support !',
                                                      style: kBlackSmallMediumStyle,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: WhiteButton(
                                                            text: 'Yes',
                                                            width: false,
                                                            widthSize: 0,
                                                            onTap: () {
                                                              Get.back();
                                                              // Get.to(() =>
                                                              //     const ChangePhoneNoScreen());
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: GradientButton(
                                                            text: 'No',
                                                            btnColor: true,
                                                            width: false,
                                                            widthSize: 0,
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                            buttonState: ButtonState.idle,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      taskCompletedDialog(
                                        title: 'Update Successful!',
                                        buttonTitle: 'Ok',
                                        image: 'assets/images/tick.png',
                                        context: context,
                                        onTap: () {
                                          Get.back();

                                          userProfileController.getUserDetails();

                                          Get.back(result: true);
                                        },
                                        // subtitle: 'Your phone number successfully updated',
                                      );
                                    }
                                  }
                                }

                                // requestOtp();
                              },
                              widthSize: MediaQuery.of(context).size.width * 0.4,
                              buttonState: ButtonState.idle),
                          // GestureDetector(
                          //   onHorizontalDragEnd: (details) {},
                          //   onTap: () async {
                          //     setState(() {});
                          //     if (_formKey.currentState!.validate()) {
                          //       _formKey.currentState!.save();
                          //
                          //       setState(() {
                          //         loginBtnState = ButtonState.loading;
                          //       });
                          //       var x = await updateAccountVerificationStatus('PHONE_NUMBER');
                          //       if (x == 'Failed') {
                          //         // errorSnackbar(
                          //         //     title: 'Failed',
                          //         //     subtitle:
                          //         //         'Phone Number is already registered');
                          //         showDialog(
                          //           context: context,
                          //           builder: (context) {
                          //             return Dialog(
                          //               shape: const RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.all(
                          //                   Radius.circular(15.0),
                          //                 ),
                          //               ),
                          //               // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                          //               elevation: 5.0,
                          //               child: Padding(
                          //                 padding: const EdgeInsets.symmetric(horizontal: 15),
                          //                 child: SingleChildScrollView(
                          //                   child: Column(
                          //                     mainAxisSize: MainAxisSize.min,
                          //                     mainAxisAlignment: MainAxisAlignment.center,
                          //                     crossAxisAlignment: CrossAxisAlignment.center,
                          //                     children: <Widget>[
                          //                       const SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                       Image.asset(
                          //                         'assets/icons/change_phone_dl.png',
                          //                         width: Get.width * 0.2,
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                       Text('${phoneNo}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
                          //                       const SizedBox(
                          //                         height: 15.0,
                          //                       ),
                          //                       Text(
                          //                         'This phone number was used by other user. if you are sure this is your number then contact support !',
                          //                         style: kBlackSmallMediumStyle,
                          //                         textAlign: TextAlign.center,
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                       Row(
                          //                         children: [
                          //                           Expanded(
                          //                             child: WhiteButton(
                          //                               text: 'Yes',
                          //                               width: false,
                          //                               widthSize: 0,
                          //                               onTap: () {
                          //                                 Get.back();
                          //                                 Get.to(() => const FeedbackScreen());
                          //                               },
                          //                             ),
                          //                           ),
                          //                           const SizedBox(
                          //                             width: 10,
                          //                           ),
                          //                           Expanded(
                          //                             child: GradientButton(
                          //                               text: 'No',
                          //                               btnColor: true,
                          //                               width: false,
                          //                               widthSize: 0,
                          //                               onTap: () {
                          //                                 Get.back();
                          //                               },
                          //                               buttonState: ButtonState.idle,
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       } else {
                          //         if (x == "Failed") {
                          //           showDialog(
                          //             context: context,
                          //             builder: (context) {
                          //               return Dialog(
                          //                 shape: const RoundedRectangleBorder(
                          //                   borderRadius: BorderRadius.all(
                          //                     Radius.circular(15.0),
                          //                   ),
                          //                 ),
                          //                 // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                          //                 elevation: 5.0,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.symmetric(horizontal: 15),
                          //                   child: SingleChildScrollView(
                          //                     child: Column(
                          //                       mainAxisSize: MainAxisSize.min,
                          //                       mainAxisAlignment: MainAxisAlignment.center,
                          //                       crossAxisAlignment: CrossAxisAlignment.center,
                          //                       children: <Widget>[
                          //                         const SizedBox(
                          //                           height: 15,
                          //                         ),
                          //                         Image.asset(
                          //                           'assets/icons/change_phone_dl.png',
                          //                           width: Get.width * 0.2,
                          //                         ),
                          //                         const SizedBox(
                          //                           height: 15,
                          //                         ),
                          //                         Text('${userProfileController.userProfile.value.data!.phoneNumber}',
                          //                             style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
                          //                         const SizedBox(
                          //                           height: 15.0,
                          //                         ),
                          //                         Text(
                          //                           'This phone number was used by other user. if you are sure this is your number then contact support !',
                          //                           style: kBlackSmallMediumStyle,
                          //                           textAlign: TextAlign.center,
                          //                         ),
                          //                         const SizedBox(
                          //                           height: 15,
                          //                         ),
                          //                         Row(
                          //                           children: [
                          //                             Expanded(
                          //                               child: WhiteButton(
                          //                                 text: 'Yes',
                          //                                 width: false,
                          //                                 widthSize: 0,
                          //                                 onTap: () {
                          //                                   Get.back();
                          //                                   // Get.to(() =>
                          //                                   //     const ChangePhoneNoScreen());
                          //                                 },
                          //                               ),
                          //                             ),
                          //                             const SizedBox(
                          //                               width: 10,
                          //                             ),
                          //                             Expanded(
                          //                               child: GradientButton(
                          //                                 text: 'No',
                          //                                 btnColor: true,
                          //                                 width: false,
                          //                                 widthSize: 0,
                          //                                 onTap: () {
                          //                                   Get.back();
                          //                                 },
                          //                                 buttonState: ButtonState.idle,
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                         const SizedBox(
                          //                           height: 15,
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               );
                          //             },
                          //           );
                          //         } else {
                          //           taskCompletedDialog(
                          //             title: 'Update Successful!',
                          //             buttonTitle: 'Ok',
                          //             image: 'assets/images/tick.png',
                          //             context: context,
                          //             onTap: () {
                          //               Get.back();
                          //
                          //               userProfileController.getUserDetails();
                          //
                          //               Get.back(result: true);
                          //             },
                          //             // subtitle: 'Your phone number successfully updated',
                          //           );
                          //         }
                          //       }
                          //     }
                          //
                          //     // requestOtp();
                          //   },
                          //   child: Container(
                          //     height: 45,
                          //     width: 170,
                          //     alignment: Alignment.center,
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(12),
                          //         gradient: const LinearGradient(
                          //           colors: [
                          //             kBlueBtnColor1,
                          //             kBlueBtnColor2,
                          //           ],
                          //           begin: Alignment.topCenter,
                          //           end: Alignment.bottomCenter,
                          //         ),
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black.withOpacity(0.1),
                          //             spreadRadius: 2,
                          //             blurRadius: 5,
                          //             offset: const Offset(0, 4),
                          //           ),
                          //         ]),
                          //     child: const Text("Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          //   ),
                          // ),
                          ///
                          // GradientButton(
                          //   text: 'Request OTP',
                          //   width: true,
                          //   onTap: () {
                          //     requestOtp();
                          //   },
                          //   widthSize: Get.width,
                          //   buttonState: loginBtnState,
                          // ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}

// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       elevation: 0.5,
//       leading: const BackButton(),
//       backgroundColor: Colors.white,
//       centerTitle: true,
//       title: Text(
//         "Phone Number Verification",
//         style: kBlackLargeStyle,
//       ),
//     ),
//     body: Form(
//       key: _formKey,
//       child: isOtpSent
//           ? ListView(
//               keyboardDismissBehavior:
//                   ScrollViewKeyboardDismissBehavior.onDrag,
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               children: [
//                 Text(
//                   'Enter OTP Number',
//                   style: kBlackExtraLargeStyle,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   'An OTP has been sent to $phoneNo',
//                   style: kBlackSmallLightMediumStyle,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 OtpTextField(
//                   keyboardType: TextInputType.number,
//                   textStyle: kBlackLargeStyle,
//                   borderColor: kColorPrimary,
//                   focusedBorderColor: kColorPrimary,
//                   numberOfFields: 6,
//                   showFieldAsBox: true,
//                   borderRadius: BorderRadius.circular(12),
//                   onCodeChanged: (value) {
//                     if (value.length < 6) {
//                       setState(() {
//                         isOtpFilled = false;
//                       });
//                     }
//                   },
//                   onSubmit: (value) {
//                     print(value);
//                     otp = value;
//
//                     setState(() {
//                       isOtpFilled = true;
//                     });
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Center(
//                   child: Text(
//                     '$_timer seconds',
//                     style: kBlackLightExtraLargeStyle,
//                   ),
//                 ),
//                 Center(
//                   child: Text(
//                     '(Time remaining)',
//                     style: kBlackSmallLightMediumStyle,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Divider(thickness: 0.30),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 sentOtpCount == 2 && isResend
//                     ? Column(
//                         children: [
//                           Center(
//                             child: Text(
//                               'Still did not receive OTP?',
//                               style: kBlackSmallLightMediumStyle,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Center(
//                             child: Text(
//                               'Let us know by clicking "Send Report".',
//                               style: kBlackLightMediumStyle,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 25,
//                           ),
//                         ],
//                       )
//                     : Column(
//                         children: [
//                           Center(
//                             child: Text(
//                               'Did not receive OTP in your email?',
//                               style: kBlackSmallLightMediumStyle,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           isResend
//                               ? GradientButton(
//                                   text: 'Resend',
//                                   borderRadius: 20,
//                                   width: true,
//                                   onTap: () {
//                                     //resend otp
//                                     setState(() {
//                                       requestOtp();
//                                       isResend = false;
//                                     });
//                                   },
//                                   widthSize: Get.width,
//                                   buttonState: resendBtnState,
//                                 )
//                               : GradientButton(
//                                   text: 'Resend',
//                                   width: true,
//                                   borderRadius: 20,
//                                   btnColor: true,
//                                   color: Colors.black.withOpacity(0.08),
//                                   onTap: () {},
//                                   widthSize: Get.width,
//                                   buttonState: ButtonState.idle,
//                                 ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           const Divider(thickness: 0.30),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           const SizedBox(
//                             height: 25,
//                           ),
//                           isResend
//                               ? Column(
//                                   children: [
//                                     Center(
//                                       child: Text(
//                                         'Is this number correct?',
//                                         style: kBlackSmallLightMediumStyle,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                       width: Get.width,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color:
//                                                 Colors.black.withOpacity(0.2),
//                                             spreadRadius: 2,
//                                             blurRadius: 5,
//                                             offset: const Offset(0, 0),
//                                           ),
//                                         ],
//                                         borderRadius:
//                                             BorderRadius.circular(50),
//                                       ),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         mainAxisSize: MainAxisSize.max,
//                                         children: [
//                                           const Spacer(),
//                                           const SizedBox(
//                                             width: 45,
//                                           ),
//                                           Text(
//                                             phoneNo,
//                                             style: kBlackLightMediumStyle,
//                                           ),
//                                           const Spacer(),
//                                           GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 isOtpSent = false;
//                                                 isResend = false;
//                                               });
//                                             },
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 5, right: 3),
//                                               child: Image.asset(
//                                                 'assets/images/edit.png',
//                                                 width: 40,
//                                                 height: 40,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 25,
//                                     ),
//                                   ],
//                                 )
//                               : SizedBox(),
//                         ],
//                       ),
//                 isOtpFilled
//                     ? GradientButton(
//                         text: 'Complete',
//                         width: true,
//                         onTap: () {
//                           if (otp != null) {
//                             matchOtp();
//                           }
//                         },
//                         widthSize: Get.width,
//                         buttonState: loginBtnState,
//                       )
//                     : sentOtpCount == 2 && isResend
//                         ? GradientButton(
//                             text: 'Send Report',
//                             width: true,
//                             onTap: () async {
//                               //send report
//                               var res =
//                                   await Get.to(() => PhoneNoOtpReportScreen(
//                                         phoneNo: phoneNo,
//                                       ));
//                               if (res != null) {
//                                 if (res) {
//                                   //reported
//                                   Get.back(result: false);
//                                 }
//                               }
//                             },
//                             widthSize: Get.width,
//                             buttonState: loginBtnState,
//                           )
//                         : GradientButton(
//                             text: 'Next',
//                             width: true,
//                             onTap: () {},
//                             color: kBlackExtraLightColor,
//                             btnColor: true,
//                             widthSize: Get.width,
//                             buttonState: ButtonState.idle,
//                           ),
//               ],
//             )
//           : ListView(
//               keyboardDismissBehavior:
//                   ScrollViewKeyboardDismissBehavior.onDrag,
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               children: [
//                 Text(
//                   'Enter Your Phone Number',
//                   style: kBlackExtraLargeStyle,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   'An OTP will be sent to your phone number for verification purposes',
//                   style: kBlackSmallLightMediumStyle,
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 TextFormField(
//                   textAlignVertical: TextAlignVertical.center,
//                   validator: (value) {
//                     if (value!.trim().isEmpty) {
//                       return 'Phone number is required';
//                     }
//                     if (!value.trim().startsWith('01')) {
//                       return 'Phone number is invalid';
//                     }
//                     if (value.trim().length < 10 ||
//                         value.trim().length > 11) {
//                       return 'Phone number is invalid';
//                     }
//                     return null;
//                   },
//                   onSaved: (val) {
//                     phoneNo = val!.trim();
//                     // phoneNo = '${Config().countryCode}$phoneNo';
//                   },
//                   // textAlign: TextAlign.center,
//                   initialValue: phoneNo,
//                   enableInteractiveSelection: true,
//                   style: kBlackMediumStyle,
//                   textInputAction: TextInputAction.done,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 15, vertical: 14),
//                     helperStyle: kRedSmallLightMediumStyle,
//                     errorStyle: kRedSmallLightMediumStyle,
//                     hintStyle: kBlackSmallLightMediumStyle,
//                     hintText: 'Eg: 0123456789',
//                     labelStyle: kRedSmallLightMediumStyle,
//                     fillColor: kWhite,
//                     filled: true,
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       borderSide:
//                           const BorderSide(color: Colors.black38, width: 0.3),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       borderSide: const BorderSide(
//                           color: kTextboxBorderColor, width: 1.4),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 GradientButton(
//                   text: 'Request OTP',
//                   width: true,
//                   onTap: () {
//                     requestOtp();
//                   },
//                   widthSize: Get.width,
//                   buttonState: loginBtnState,
//                 ),
//               ],
//             ),
//     ),
//   );
// }
