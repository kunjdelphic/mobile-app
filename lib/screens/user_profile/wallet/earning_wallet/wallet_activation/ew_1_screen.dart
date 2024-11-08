import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/user_profile/report_and_feedback/report_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/earning_wallet/wallet_activation/ew_2_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';

import 'package:progress_state_button/progress_button.dart';
import 'package:styled_text/styled_text.dart';

import 'ew_3_screen.dart';
import 'ew_4_screen.dart';

class EW1Screen extends StatefulWidget {
  const EW1Screen({Key? key}) : super(key: key);

  @override
  _EW1ScreenState createState() => _EW1ScreenState();
}

class _EW1ScreenState extends State<EW1Screen> {
  int stepCount = 0;
  bool isPhoneVerified = false,
      isIdSubmitted = false,
      isSelfieSubmitted = false;
  ButtonState continueBtnState = ButtonState.idle;
  UserProfileController userProfileController = Get.find();

  bool isResubmitted = false;

  @override
  void initState() {
    super.initState();

    checkIfEkycComplete();
  }

  checkIfEkycComplete() async {
    print(
        'ACCOUNT STATUS :: ${userProfileController.userProfile.value.data!.accountStatus}');
    print(
        'PHONE :: ${userProfileController.userProfile.value.data!.phoneVerified}');
    print('ID :: ${userProfileController.userProfile.value.data!.idPhoto}');
    print('SELFIE :: ${userProfileController.userProfile.value.data!.selfie}');

    switch (userProfileController.userProfile.value.data!.accountStatus) {
      case 'NOT_APPROVED':
        if (userProfileController.userProfile.value.data!.phoneVerified ??
            false) {
          isPhoneVerified = true;
          stepCount = 1;
        }

        if (userProfileController.userProfile.value.data!.idPhoto ?? false) {
          isIdSubmitted = true;
          stepCount = 2;
        }
        if (userProfileController.userProfile.value.data!.selfie ?? false) {
          isSelfieSubmitted = true;
          stepCount = 3;
        }
        break;
      case 'APPROVED':
        if (userProfileController.userProfile.value.data!.phoneVerified ??
            false) {
          isPhoneVerified = true;
          stepCount = 1;
        }

        if (userProfileController.userProfile.value.data!.idPhoto ?? false) {
          isIdSubmitted = true;
          stepCount = 2;
        }
        if (userProfileController.userProfile.value.data!.selfie ?? false) {
          isSelfieSubmitted = true;
          stepCount = 3;
        }
        break;
      case 'RESUBMIT':
        stepCount = 3;
        if (userProfileController.userProfile.value.data!.phoneVerified ??
            false) {
          isPhoneVerified = true;
          stepCount = 1;
        }

        if (userProfileController.userProfile.value.data!.idPhoto ?? false) {
          isIdSubmitted = true;
          stepCount = 2;
        }
        if (userProfileController.userProfile.value.data!.selfie ?? false) {
          isSelfieSubmitted = true;
          stepCount = 3;
        }
        break;
      case 'PENDING':
        if (userProfileController.userProfile.value.data!.phoneVerified ??
            false) {
          isPhoneVerified = true;
          stepCount = 1;
        }

        if (userProfileController.userProfile.value.data!.idPhoto ?? false) {
          isIdSubmitted = true;
          stepCount = 2;
        }
        if (userProfileController.userProfile.value.data!.selfie ?? false) {
          isSelfieSubmitted = true;
          stepCount = 3;
        }
        break;

      default:
    }
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
          "Account Verification",
          style: kBlackLargeStyle,
        ),
      ),
      body: GetX<UserProfileController>(
        init: UserProfileController(),
        builder: (_) {
          return _.userProfile.value.data!.accountStatus == 'RESUBMIT'
              ? isResubmitted
                  ? ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      children: [
                        stepCount == 0
                            ? Center(
                                child: Text(
                                  'Activate Wallet\nVerifying Your Account.',
                                  textAlign: TextAlign.center,
                                  style: kBlackDarkLargeStyle,
                                ),
                              )
                            : stepCount == 3
                                ? Center(
                                    child: Text(
                                      'Well done! Step $stepCount out of 3 Completed.',
                                      textAlign: TextAlign.center,
                                      style: kBlackDarkLargeStyle,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'Step $stepCount out of 3 Completed.',
                                      textAlign: TextAlign.center,
                                      style: kBlackDarkLargeStyle,
                                    ),
                                  ),
                        const SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          'assets/images/wallet/earning_wallet_ac_veri.png',
                          width: Get.width * 0.55,
                          height: Get.width * 0.55,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Congratulations!  We will notify you as soon\nas your details have been verified and your\nwallet activated.',
                            textAlign: TextAlign.center,
                            style: kBlackSmallLightMediumStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned(
                              top: 15,
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: Get.width * 0.6,
                                dashColor: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    children: [
                                      stepCount == 1 ||
                                              stepCount == 2 ||
                                              stepCount == 3
                                          ? !isPhoneVerified
                                              ? Image.asset(
                                                  'assets/images/cross.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                              : Image.asset(
                                                  'assets/images/tick.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                          : Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: kWhite,
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Center(
                                                child: Text(
                                                  '1',
                                                  style:
                                                      kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Center(
                                        child: Text(
                                          'Verify Phone\nNumber',
                                          textAlign: TextAlign.center,
                                          style: kBlackSmallMediumStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // DottedLine(
                                  //   direction: Axis.horizontal,
                                  //   lineLength: Get.width * 0.15,
                                  //   dashColor: Colors.black87,
                                  // ),
                                  Column(
                                    children: [
                                      stepCount == 2 || stepCount == 3
                                          ? !isIdSubmitted
                                              ? Image.asset(
                                                  'assets/images/cross.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                              : Image.asset(
                                                  'assets/images/tick.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                          : Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: kWhite,
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Center(
                                                child: Text(
                                                  '2',
                                                  style:
                                                      kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Center(
                                        child: Text(
                                          'Take ID Photo',
                                          textAlign: TextAlign.center,
                                          style: kBlackSmallMediumStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // DottedLine(
                                  //   direction: Axis.horizontal,
                                  //   lineLength: Get.width * 0.15,
                                  //   dashColor: Colors.black87,
                                  // ),
                                  Column(
                                    children: [
                                      stepCount == 3
                                          ? !isSelfieSubmitted
                                              ? Image.asset(
                                                  'assets/images/cross.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                              : Image.asset(
                                                  'assets/images/tick.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                          : Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: kWhite,
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Center(
                                                child: Text(
                                                  '3',
                                                  style:
                                                      kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Center(
                                        child: Text(
                                          'Take A Selfie',
                                          textAlign: TextAlign.center,
                                          style: kBlackSmallMediumStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        GradientButton(
                          text: 'Close',
                          width: false,
                          onTap: () async {
                            Get.back(result: true);
                          },
                          widthSize: Get.width,
                          buttonState: continueBtnState,
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      children: [
                        Center(
                          child: Text(
                            'Oops! Something went wrong.',
                            textAlign: TextAlign.center,
                            style: kBlackDarkLargeStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          'assets/images/wallet/earning_wallet_ac_veri_reject.png',
                          width: Get.width * 0.55,
                          height: Get.width * 0.55,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StyledText(
                          text:
                              'It seems like we could not verify some of your details. Please resubmit your details or contact us by <link>Send Report</link>.',
                          textAlign: TextAlign.center,
                          style: kBlackSmallLightMediumStyle,
                          tags: {
                            'link': StyledTextActionTag(
                              (_, attrs) => Get.to(() => const ReportScreen()),
                              style: kRedSmallMediumStyle,
                            ),
                          },
                        ),

                        // Center(
                        //   child: Text(
                        //     'It seems like we could not verify some of your details. Please resubmit your details or contact us by Send Report.',
                        //     textAlign: TextAlign.center,
                        //     style: kBlackSmallLightMediumStyle,
                        //   ),
                        // ),
                        const SizedBox(
                          height: 25,
                        ),
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned(
                              top: 15,
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: Get.width * 0.6,
                                dashColor: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    children: [
                                      stepCount == 1 ||
                                              stepCount == 2 ||
                                              stepCount == 3
                                          ? !isPhoneVerified
                                              ? Image.asset(
                                                  'assets/images/cross.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                              : Image.asset(
                                                  'assets/images/tick.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                          : Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: kWhite,
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Center(
                                                child: Text(
                                                  '1',
                                                  style:
                                                      kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Center(
                                        child: Text(
                                          'Verify Phone\nNumber',
                                          textAlign: TextAlign.center,
                                          style: kBlackSmallMediumStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // DottedLine(
                                  //   direction: Axis.horizontal,
                                  //   lineLength: Get.width * 0.15,
                                  //   dashColor: Colors.black87,
                                  // ),
                                  Column(
                                    children: [
                                      stepCount == 1 ||
                                              stepCount == 2 ||
                                              stepCount == 3
                                          ? !isIdSubmitted
                                              ? Image.asset(
                                                  'assets/images/cross.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                              : Image.asset(
                                                  'assets/images/tick.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                          : Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: kWhite,
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Center(
                                                child: Text(
                                                  '2',
                                                  style:
                                                      kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Center(
                                        child: Text(
                                          'Take ID Photo',
                                          textAlign: TextAlign.center,
                                          style: kBlackSmallMediumStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // DottedLine(
                                  //   direction: Axis.horizontal,
                                  //   lineLength: Get.width * 0.15,
                                  //   dashColor: Colors.black87,
                                  // ),
                                  Column(
                                    children: [
                                      stepCount == 1 ||
                                              stepCount == 2 ||
                                              stepCount == 3
                                          ? !isSelfieSubmitted
                                              ? Image.asset(
                                                  'assets/images/cross.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                              : Image.asset(
                                                  'assets/images/tick.png',
                                                  width: 32,
                                                  height: 32,
                                                )
                                          : Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: kWhite,
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Center(
                                                child: Text(
                                                  '3',
                                                  style:
                                                      kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Center(
                                        child: Text(
                                          'Take A Selfie',
                                          textAlign: TextAlign.center,
                                          style: kBlackSmallMediumStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        GradientButton(
                          text: 'Resubmit',
                          width: false,
                          onTap: () async {
                            if (!isPhoneVerified) {
                              var res = await Get.to(() => const EW2Screen());
                              if (res != null) {
                                if (res) {
                                  //verified
                                  setState(() {
                                    isPhoneVerified = true;
                                    if (isIdSubmitted && isSelfieSubmitted) {
                                      isResubmitted = true;
                                      stepCount = 3;
                                    } else {
                                      stepCount = 1;
                                    }
                                  });
                                } else {
                                  //not verified
                                  setState(() {
                                    isPhoneVerified = false;
                                  });
                                }
                              }
                            } else if (!isIdSubmitted) {
                              var res = await Get.to(() => const EW3Screen());
                              if (res != null) {
                                if (res) {
                                  setState(() {
                                    isIdSubmitted = true;
                                    if (isPhoneVerified && isSelfieSubmitted) {
                                      isResubmitted = true;
                                      stepCount = 3;
                                    } else {
                                      stepCount = 2;
                                    }
                                  });
                                } else {
                                  //not submitted
                                  setState(() {
                                    isIdSubmitted = false;
                                  });
                                }
                              }
                            } else if (!isSelfieSubmitted) {
                              var res = await Get.to(() => const EW4Screen());
                              if (res != null) {
                                if (res) {
                                  setState(() {
                                    isSelfieSubmitted = true;
                                    isResubmitted = true;
                                    stepCount = 3;
                                  });
                                } else {
                                  //not submitted
                                  setState(() {
                                    isSelfieSubmitted = false;
                                  });
                                }
                              }
                            }
                          },
                          widthSize: Get.width,
                          buttonState: continueBtnState,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        WhiteButton(
                          text: 'Later',
                          width: false,
                          widthSize: Get.width,
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ],
                    )
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    stepCount == 0
                        ? Center(
                            child: Text(
                              'Activate Wallet\nVerifying Your Account.',
                              textAlign: TextAlign.center,
                              style: kBlackDarkLargeStyle,
                            ),
                          )
                        : stepCount == 3
                            ? Center(
                                child: Text(
                                  'Well done! Step $stepCount out of 3 Completed.',
                                  textAlign: TextAlign.center,
                                  style: kBlackDarkLargeStyle,
                                ),
                              )
                            : Center(
                                child: Text(
                                  'Step $stepCount out of 3 Completed.',
                                  textAlign: TextAlign.center,
                                  style: kBlackDarkLargeStyle,
                                ),
                              ),
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      'assets/images/wallet/earning_wallet_ac_veri.png',
                      width: Get.width * 0.55,
                      height: Get.width * 0.55,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    stepCount == 3
                        ? Center(
                            child: Text(
                              'Congratulations!  We will notify you as soon\nas your details have been verified and your\nwallet activated.',
                              textAlign: TextAlign.center,
                              style: kBlackSmallLightMediumStyle,
                            ),
                          )
                        : Center(
                            child: Text(
                              'Help us confirm your identity.\nComplete the verification process below\nto start using your earning wallet.',
                              textAlign: TextAlign.center,
                              style: kBlackSmallLightMediumStyle,
                            ),
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: 15,
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: Get.width * 0.6,
                            dashColor: Colors.black87,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                children: [
                                  stepCount == 1 ||
                                          stepCount == 2 ||
                                          stepCount == 3
                                      ? !isPhoneVerified
                                          ? Image.asset(
                                              'assets/images/cross.png',
                                              width: 32,
                                              height: 32,
                                            )
                                          : Image.asset(
                                              'assets/images/tick.png',
                                              width: 32,
                                              height: 32,
                                            )
                                      : Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: kWhite,
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Center(
                                            child: Text(
                                              '1',
                                              style:
                                                  kBlackSmallLightMediumStyle,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Center(
                                    child: Text(
                                      'Verify Phone\nNumber',
                                      textAlign: TextAlign.center,
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ),
                                ],
                              ),
                              // DottedLine(
                              //   direction: Axis.horizontal,
                              //   lineLength: Get.width * 0.15,
                              //   dashColor: Colors.black87,
                              // ),
                              Column(
                                children: [
                                  stepCount == 2 || stepCount == 3
                                      ? !isIdSubmitted
                                          ? Image.asset(
                                              'assets/images/cross.png',
                                              width: 32,
                                              height: 32,
                                            )
                                          : Image.asset(
                                              'assets/images/tick.png',
                                              width: 32,
                                              height: 32,
                                            )
                                      : Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: kWhite,
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Center(
                                            child: Text(
                                              '2',
                                              style:
                                                  kBlackSmallLightMediumStyle,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Center(
                                    child: Text(
                                      'Take ID Photo',
                                      textAlign: TextAlign.center,
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ),
                                ],
                              ),
                              // DottedLine(
                              //   direction: Axis.horizontal,
                              //   lineLength: Get.width * 0.15,
                              //   dashColor: Colors.black87,
                              // ),
                              Column(
                                children: [
                                  stepCount == 3
                                      ? !isSelfieSubmitted
                                          ? Image.asset(
                                              'assets/images/cross.png',
                                              width: 32,
                                              height: 32,
                                            )
                                          : Image.asset(
                                              'assets/images/tick.png',
                                              width: 32,
                                              height: 32,
                                            )
                                      : Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: kWhite,
                                              border: Border.all(
                                                color: Colors.black26,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Center(
                                            child: Text(
                                              '3',
                                              style:
                                                  kBlackSmallLightMediumStyle,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Center(
                                    child: Text(
                                      'Take A Selfie',
                                      textAlign: TextAlign.center,
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GradientButton(
                      text: stepCount == 0
                          ? 'Start'
                          : stepCount == 3
                              ? 'Close'
                              : 'Continue',
                      width: false,
                      onTap: () async {
                        // var res = await Get.to(() => const EW4Screen());
                        // if (res != null) {
                        //   if (res) {
                        //     setState(() {
                        //       stepCount = 3;
                        //     });
                        //   }
                        // }
                        // return;
                        switch (stepCount) {
                          case 0:
                            var res = await Get.to(() => const EW2Screen());
                            if (res != null) {
                              if (res) {
                                //verified
                                setState(() {
                                  stepCount = 1;
                                  isPhoneVerified = true;
                                });
                              } else {
                                //not verified
                                setState(() {
                                  stepCount = 1;
                                  isPhoneVerified = false;
                                });
                              }
                            }

                            break;
                          case 1:
                            var res = await Get.to(() => const EW3Screen());
                            if (res != null) {
                              if (res) {
                                setState(() {
                                  stepCount = 2;
                                  isIdSubmitted = true;
                                });
                              } else {
                                //not submitted
                                setState(() {
                                  stepCount = 2;
                                  isIdSubmitted = false;
                                });
                              }
                            }
                            break;
                          case 2:
                            var res = await Get.to(() => const EW4Screen());
                            if (res != null) {
                              if (res) {
                                setState(() {
                                  stepCount = 3;
                                  isSelfieSubmitted = true;
                                });
                              } else {
                                //not submitted
                                setState(() {
                                  stepCount = 3;
                                  isSelfieSubmitted = false;
                                });
                              }
                            }
                            break;

                          case 3:
                            Get.back(result: true);
                            break;
                        }
                      },
                      widthSize: Get.width,
                      buttonState: continueBtnState,
                    )
                  ],
                );
        },
      ),
    );
  }
}
